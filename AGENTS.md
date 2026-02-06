# AGENTS.md (repo guidance)

## Repository purpose
Org-specific GitHub Actions wrapper workflows that call shared reusable workflows in the shared org.

## Non-negotiables
- No workflow logic here beyond thin wrappers.
- No secrets committed; use BWS via repo secrets.
- Use `workflow_dispatch` only (no `repository_dispatch`).
- Polling is triggered by the Worker cron via `polling.yml` (no polling repos).
- `uses:` references to shared workflows must use release tags (for example, `v0.0.1`).
- Wrapper workflows must pass event context inputs (`event-context`, `event-name`, `expected-event-action`).
- Summary workflow must pass BWS secrets for event validation.
- Workflow-level permissions must be `{}`; set minimal permissions per job.

## Permissions
- Default `contents: read`. Only elevate if absolutely required.

## Tag rollout flow (wrappers)
1) Wait for `gh-actions-shared` to publish a new release tag (e.g., `v0.0.2`).
2) Update wrapper `uses:` to `@v0.0.2` and set `shared-ref: v0.0.2`.
3) During rollout, keep the previous tag available in shared `allowed_refs` for fast rollback.
4) To rollback, revert wrappers to the previous tag.

### Helper script (preferred)
```bash
./bump-tags.sh --v0.0.2
```
