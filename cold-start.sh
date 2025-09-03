#!/usr/bin/env bash
set -euo pipefail

PGUSER=vimkim        # <- change if needed
PGDB=vimkimdb        # <- change if needed

FILES=(
  "id_plain.sql"
  "id_ext.sql"
  "detoast_plain.sql"
  "detoast_ext.sql"
)

# Optional: for a *true* cold start also clear Postgres shared_buffers once
# sudo systemctl restart postgresql

for f in "${FILES[@]}"; do
  echo "==> Running $f with OS cold cache"
  # OS cache cold (affects whole machine; do NOT use on prod)
  sudo sync
  echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

  psql -U "$PGUSER" "$PGDB" -f "$f"
done
