#!/bin/bash

# Nomad Fabricator — Jumpstart Script (v2025-07)
# A reusable Nx monorepo setup for labs, Cloudflare Workers, and an Astro/Svelte dashboard

set -e

# --------
# SETTINGS
# --------
PROJ="lab-fabricator"  # Change this for each new lab
DASHBOARD_PORT=4321
WORKERS=("Exp1" "Exp2" "Exp3" "Exp4" "Exp5")
AUTHOR="YourName"      # Optional: auto-fill in package.json

# -----------
# INIT REPO
# -----------
npx create-nx-workspace@latest $PROJ
cd $PROJ

# Add pnpm workspace
echo -e "packages:\n  - 'apps/**'\n  - 'libs/**'\n" > pnpm-workspace.yaml

# Init git (optional)
git init
git add .
git commit -m "Nx workspace: initial scaffold"

# -----------
# DEPENDENCIES
# -----------
pnpm add -D nx wrangler astro@latest @astrojs/svelte svelte tailwindcss postcss autoprefixer -w
pnpm install

# -----
# TREE
# -----
mkdir -p apps/dashboard/src/components
mkdir -p libs
mkdir -p apps/workers

# -----------
# DASHBOARD APP (Astro + Svelte + Tailwind)
# -----------
mkdir -p apps/dashboard/src/pages
cat > apps/dashboard/src/pages/index.astro <<'ASTRO'
---
import ThemeToggle from '../components/ThemeToggle.svelte';
import StatsToggle from '../components/StatsToggle.svelte';
let mode = 'overview';
---
<h1 class="text-3xl font-bold text-center mt-10">
  Nomad Fabricator
</h1>
<div class="flex justify-center gap-6 mt-8">
  <ThemeToggle client:load />
  <StatsToggle client:load mode={mode} />
</div>
ASTRO

cat > apps/dashboard/src/components/ThemeToggle.svelte <<'SVELTE'
<script>
  let dark=false;
  const toggle=()=>{
    dark=!dark;
    document.documentElement.classList.toggle('dark',dark);
  };
</script>
<button on:click={toggle} class="p-2 rounded bg-gray-200 dark:bg-slate-700">
  {dark?'🌙':'☀️'}
</button>
SVELTE

cat > apps/dashboard/src/components/StatsToggle.svelte <<'SVELTE'
<script>
  export let mode;
</script>
<div class="flex gap-2">
  <button class:selected={mode==='overview'} on:click={()=>mode='overview'}>Overview</button>
  <button class:selected={mode==='data'} on:click={()=>mode='data'}>Data</button>
</div>
<style>
  .selected{font-weight:600;text-decoration:underline}
</style>
SVELTE

cat > apps/dashboard/project.json <<'JSON'
{
  "name": "dashboard",
  "$schema": "../../node_modules/nx/schemas/project-schema.json",
  "sourceRoot": "apps/dashboard/src",
  "projectType": "application",
  "targets": {
    "dev": {
      "executor": "nx:run-commands",
      "options": { "command": "astro dev", "cwd": "apps/dashboard" }
    },
    "build": {
      "executor": "nx:run-commands",
      "options": { "command": "astro build", "cwd": "apps/dashboard" },
      "outputs": ["{workspaceRoot}/apps/dashboard/dist"]
    },
    "preview": {
      "executor": "nx:run-commands",
      "options": { "command": "astro preview --port 4321", "cwd": "apps/dashboard" }
    }
  }
}
JSON

cat > apps/dashboard/astro.config.mjs <<'ASTRO'
import { defineConfig } from 'astro/config';
import svelte from '@astrojs/svelte';

export default defineConfig({
  integrations: [svelte()],
});
ASTRO

# -----------
# WORKERS (Cloudflare)
# -----------
for NAME in "${WORKERS[@]}"; do
  mkdir -p apps/workers/$NAME/src
  # Wrangler toml
  cat > apps/workers/$NAME/wrangler.toml <<TOML
name = "$NAME"
main = "src/index.ts"
compatibility_date = "$(date +%Y-%m-%d)"
# [[kv_namespaces]]
# binding = "CACHE"
# id = "<uuid>"
TOML
  touch apps/workers/$NAME/src/index.ts
  cat > apps/workers/$NAME/project.json <<JSON
{
  "name": "$NAME",
  "\$schema": "../../../node_modules/nx/schemas/project-schema.json",
  "sourceRoot": "apps/workers/$NAME/src",
  "projectType": "application",
  "targets": {
    "dev": {
      "executor": "nx:run-commands",
      "options": { "command": "wrangler dev", "cwd": "apps/workers/$NAME" }
    },
    "deploy": {
      "executor": "nx:run-commands",
      "options": { "command": "wrangler deploy", "cwd": "apps/workers/$NAME" }
    }
  }
}
JSON
done


# TODO Some bug here with the script (tailwind isn't being symlinked into the binary)
# Tailwind config (for dashboard)
cd apps/dashboard

# Ensure there's a package.json first
if [ ! -f package.json ]; then
  pnpm init
fi

pnpm add -D tailwindcss postcss autoprefixer
pnpm exec tailwindcss init -p

cat > tailwind.config.js <<'TAILWIND'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{astro,js,ts,svelte}"],
  theme: { extend: {} },
  plugins: [],
}
TAILWIND

cd ../../..

# -----------
# ROOT README.md
# -----------
cat > README.md <<'README'
# Nomad Fabricator

A modular Nx monorepo for building rapid web experiments with Astro/Svelte, Cloudflare Workers, and TailwindCSS.

## Getting Started

```bash
pnpm install
pnpm nx run dashboard:dev    # Launch admin dashboard (Astro, http://localhost:4321)
pnpm nx run Exp1:dev         # Launch first worker (replace with any worker name)

---

## **How to use this template**

# 1. Save this script as `setup.sh`.
# 2. Make executable: `chmod +x setup.sh`.
# 3. Run: `./setup.sh`.
# 4. When it’s done, open your editor, run `pnpm install`, and GO!

# ---

# ### 🟢 *Further improvements*:
# - Add support for optional initial content in each worker.
# - Prompt for project name/author interactively.
# - Colorize or log steps for style.

# ---

# Let me know if you want the **README.md** or **usage docs** even more detailed! Or want an “add new worker” script!