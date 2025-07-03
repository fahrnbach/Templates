#!/bin/bash

# add-worker.sh — Add a new Cloudflare Worker to Nx monorepo

# Prompt for worker name
read -p "Worker name (e.g. Exp6 or tefl-tech): " NAME
NAME=${NAME// /-}  # sanitize spaces to dashes

# Confirm directory does not already exist
DIR="apps/workers/$NAME"
if [ -d "$DIR" ]; then
  echo "❌ $DIR already exists. Aborting."
  exit 1
fi

# Scaffold folders and files
mkdir -p "$DIR/src"

# Wrangler toml
cat > "$DIR/wrangler.toml" <<TOML
name = "$NAME"
main = "src/index.ts"
compatibility_date = "$(date +%Y-%m-%d)"
# [[kv_namespaces]]
# binding = "CACHE"
# id = "<uuid>"
TOML

# Main worker file
cat > "$DIR/src/index.ts" <<'TS'
// Cloudflare Worker: $NAME
export default {
  async fetch(request, env, ctx) {
    return new Response("Hello from $NAME!", { status: 200 });
  }
}
TS

# project.json for Nx
cat > "$DIR/project.json" <<JSON
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

echo "✅ Worker $NAME created at $DIR"
echo ""
echo "To start local dev:"
echo "  pnpm nx run $NAME:dev"
echo "To deploy:"
echo "  pnpm nx run $NAME:deploy"

# Alternative to using:
# pnpm dlx wrangler init workerNameHere