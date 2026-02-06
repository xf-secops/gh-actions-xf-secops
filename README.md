# gh-actions-upstream

Org-specific wrapper workflows for the upstream GitHub org. These workflows are
**thin wrappers** that call shared reusable workflows from `gh-actions-shared`.

## Triggers
- `workflow_dispatch` for `orchestrator`, `discover`, `summary`, `repository`, `fork`, and `polling`
Fork drift polling is triggered by the Worker cron (no polling repos).

## Requirements
- `BWS_ACCESS_TOKEN` and `BWS_PROJECT_ID` repo secrets
- `BWS_VERSION` and `BWS_SHA256` repo variables

All workflow logic resides in the shared repo.
