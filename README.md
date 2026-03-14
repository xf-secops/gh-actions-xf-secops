# gh-actions-xf-secops

Org-specific wrapper workflows for the `xf-secops` GitHub org. These workflows are
**thin wrappers** that call shared reusable workflows from `gh-actions-shared`.

## Triggers
- `workflow_dispatch` for `orchestrator`, `discover`, `summary`, `repository`, `fork`, `polling`, and `sync`
Fork drift polling and tracked-branch sync dispatches are triggered by the Worker (no polling repos).

## Requirements
- `BWS_ACCESS_TOKEN` and `BWS_PROJECT_ID` repo secrets
- `BWS_VERSION` and `BWS_SHA256` repo variables

All workflow logic resides in the shared repo.
