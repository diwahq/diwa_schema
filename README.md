# Diwa Schema

This library contains the shared Ecto schemas and migrations for the Diwa ecosystem (`diwa-agent` and `diwa-cloud`).

## Structure

It is organized into Tiers as per the specifications:

*   `Core`: Essential schemas (Context, Memory, etc.) used by all editions.
*   `Team`: Collaboration schemas (Sessions, Tasks, etc.).
*   `Enterprise`: Advanced features (Organizations, Billing, etc.).

## Usage

This library is included as a local path dependency in `diwa-agent` and `diwa-cloud`.

```elixir
{:diwa_schema, path: "../diwa_schema"}
```

## Migrations

All migrations are centralized here in `priv/repo/migrations`.
Both `diwa-agent` and `diwa-cloud` are configured to look for migrations in this directory.
