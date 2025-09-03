bench-all-range:
    pgbench -d toastbench -n -c 8 -T 60 -f bench_select_all_range.sql
