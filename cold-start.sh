#!/usr/bin/env bash
set -euo pipefail

PGUSER=vimkim
PGDB=vimkimdb
SERVICE=postgresql-16    # adjust if your service name differs (e.g., postgresql-16)

FILES=(
  "id_plain.sql"
  "id_ext.sql"
  "detoast_plain.sql"   # the convert_to(...) version
  "detoast_ext.sql"     # the convert_to(...) version
)

for f in "${FILES[@]}"; do
  echo "==> Cold run: $f"
  # 1) restart server to clear shared_buffers
  sudo systemctl restart "$SERVICE"
  # give it a moment to come up
  sleep 1

  # 2) clear OS page cache
  sudo sync
  echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

  # 3) run in a fresh connection
  psql -U "$PGUSER" "$PGDB" -f "$f"
done

echo "cold run random plain"
sudo systemctl restart "$SERVICE"
sleep 1
sudo sync
echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
psql -U "$PGUSER" "$PGDB" -v sample_n=10000 -f ./random_detoast_plain.sql

echo "cold run random ext"
sudo systemctl restart "$SERVICE"
sleep 1
sudo sync
echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
psql -U "$PGUSER" "$PGDB" -v sample_n=10000 -f ./random_detoast_ext.sql
