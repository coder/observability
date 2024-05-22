# Postgres Runbooks

## PostgresNotificationQueueFillingUp

Postgres offers asynchronous notification via the `LISTEN` and `NOTIFY`
commands. Coder depends heavily on this async notification mechanism for routine
functionality.

This may be due to a session executing `LISTEN()` and entering a long
transaction. To verify:

- Check active sessions with `SELECT * FROM pg_stat_activity;`,
- Check the database log for the PID of the session that is preventing cleanup,
- Kill the query: `SELECT pg_terminate_backend(<pid>);`

For more information, see the PostgreSQL documentation available here:

- [PostgreSQL documentation on `LISTEN`](https://www.postgresql.org/docs/current/sql-listen.html)
- [PostgreSQL documentation on `NOTIFY`](https://www.postgresql.org/docs/current/sql-notify.html)

## PostgresDown

Postgres is not currently running, which means the Coder control plane will not be able to read or write any state.
Workspaces may continue to work normally but it is recommended to get Postgres back up as quickly as possible.

## PostgresConnectionsRunningLow

PostgreSQL has a `max_connections` setting that determines the maximum number of
concurrent connections. Once this connection limit is reached, no new
connections will be possible.

To increase the maximum number of concurrent connections, update the `max_connections`
configuration option for your PostgreSQL instance. See the PostgreSQL
documentation for more details.

**Note:** You may also need to adjust `shared_buffers` after increasing
`max_connections`. Additionally, you may also need to adjust the kernel
configuration value `kernel.shmmax` in `/etc/sysctl.conf` /
`/etc/sysctl.conf.d`.

For more information, see:

- [PostgreSQL Documentation: Server Configuration](https://www.postgresql.org/docs/16/runtime-config-file-locations.html)
- [Tuning your PostgreSQL Server](https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server)
