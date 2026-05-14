# Diwa Schema (Public)

This library contains the public, shared Ecto schemas and migrations for the Diwa ecosystem. It is intended for OSS publication.

## Scope

Following the architectural split (Phase 1.5, May 2026), this repository houses only non-patent-candidate infrastructure:

*   **Enterprise**: Organizations, API Keys, Usage Records, Secrets.
*   **Team**: Plans, Tasks, Ingest Jobs, HITL Escalations, Shortcut Aliases.
*   **Infrastructure**: Tier definitions, generic Repo wrappers, utility types.

## Patent-Candidate Modules

Schemas related to BAWI sagas, Context graphs, Memory versions, Handoff messages, and Performance baselines have been moved to the private **`diwa_schema_pro`** repository per ENC-002 strategic posture.

## Usage

This library is included as a dependency in `diwa-agent` and `diwa-cloud`.

```elixir
{:diwa_schema, "~> 0.1.0"} # or path: "../diwa_schema"
```

## Migrations

Public migrations are centralized in `priv/repo/migrations`. The production migrator in `diwa-cloud` is configured to scan both this directory and the `diwa_schema_pro` migration directory.
