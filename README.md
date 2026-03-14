# gh-actions-xf-secops

Org-specific wrapper workflows for the xf-secops GitHub org. These workflows are
**thin wrappers** that call shared reusable workflows from gh-actions-shared.

## Triggers
- workflow_dispatch for orchestrator, discover, summary, repository, fork, and polling
- workflow_dispatch and hourly schedule for sync
Worker dispatches repository/fork/polling events; sync.yml reconciles all repos in the org on a schedule or manual run.

## Requirements
- BWS_PROJECT_ID and BWS_ACCESS_TOKEN repo secrets
- BWS_VERSION and BWS_SHA256 repo variables

All workflow logic resides in the shared repo.
