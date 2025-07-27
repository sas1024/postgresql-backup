# PostgreSQL backup creating/rotating script

[![Docker Hub Pulls](https://img.shields.io/docker/pulls/sas1024/postgresql-backup.svg)](https://hub.docker.com/r/sas1024/postgresql-backup)

Backups dumps into `sql/<project>` directory.

Example of secret file for postgres data variables:

```
declare -A pg_servers
pg_servers=(
  [someservice1-postgres]="PGHOST=10.10.10.17 PGPORT=29597 PGDATABASE=someservice1_db PGUSER=user1_postgres PGPASSWORD=pw1_postgres"
  [someservice2-postgres]="PGHOST=10.10.10.23 PGPORT=29693 PGDATABASE=someservice2_db PGUSER=user2_postgres PGPASSWORD=pw2_postgres"
)
```

Allowed environment variables:
- `PGHOST`, `PGPORT`, `PGDATABASE` ,`PGUSER`, `PGPASSWORD` and other Postgresql environment variables https://www.postgresql.org/docs/17/libpq-envars.html
- `KEEP` - Amount of snapshots to keep. Default: `1`

This image can be useful for running in orchestrators like HashiCorp Nomad, Kubernetes and others.
