# 🧪 Nomad Fabricator — Nx Labs Template

A modular monorepo template for building rapid web experiments with **Astro/Svelte**, **Cloudflare Workers**, and **TailwindCSS**—powered by [Nx](https://nx.dev/).

This template helps you spin up new “labs” (experiments, landing pages, micro-SaaS, and APIs) with zero config friction. Just click **“Use this template”** on GitHub or run the setup script for a fresh stack!

---

## 🚀 Features

- **Nx Monorepo:** Shared code, unified builds, and clean dependency management.
- **Astro + Svelte Admin Dashboard:** Modern, reactive UI out of the box.
- **Cloudflare Worker Labs:** Pre-wired for scalable serverless endpoints.
- **TailwindCSS:** Instant utility-first styling (with hot reload).
- **Preconfigured Structure:** Opinionated, but flexible—easy to add/remove labs.
- **Dev UX:** Run any lab or dashboard with a single command.

---

## 🛠️ Getting Started

**Option 1: Use as a GitHub Template (Recommended)**

1. Click **“Use this template”** on GitHub.
2. Clone your new repo:
    ```bash
    git clone https://github.com/YOUR_USERNAME/nomad-fabricator.git my-lab
    cd my-lab
    ```
3. Install dependencies:
    ```bash
    pnpm install
    ```
4. Start the admin dashboard:
    ```bash
    pnpm nx run dashboard:dev
    # → http://localhost:4321
    ```
5. Start any Cloudflare Worker (lab):
    ```bash
    pnpm nx run Exp1:dev
    # Swap Exp1 for any worker name (see /apps/workers)
    ```

**Option 2: Use the Bash Setup Script**

If you want to spin up a *brand new* repo from scratch with your own tweaks, run:

Note there is currently a bug that will exit the script early and will not init tailwind
On TODO list.

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/nomad-fabricator/main/scripts/nx_labs.sh | bash