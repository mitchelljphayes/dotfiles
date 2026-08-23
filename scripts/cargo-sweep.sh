#!/usr/bin/env bash
#
# cargo-sweep.sh — daily cleanup of Rust per-project target/ dirs.
#
# Run via launchd (com.mjp.cargo-sweep.plist) at 03:00 daily. Two-stage policy:
#   1. Time-based: remove artifacts untouched for 7+ days across the Developer tree.
#   2. Size-based: cap each discovered target/ dir at 10GiB (per-dir, not
#      aggregate — cargo-sweep --maxsize shrinks each target dir independently).
#
# Safety:
#   - No-op (exit 0) when cargo-sweep is missing so launchd doesn't log failures.
#   - Skips (exit 0) if a `cargo` or `rustc` build is currently running.
#   - Scopes strictly to /Users/mjp/Developer; never touches other paths.
#   - Logs with timestamps to stdout (launchd redirects to ~/Library/Logs/).
#
# cargo-sweep 0.8.0 syntax (confirmed via `cargo-sweep sweep --help`):
#   cargo-sweep sweep [--recursive] [--time <days> | --maxsize <size>]
#                     [--dry-run] [--hidden] [PATH]...
# Note: the subcommand is `sweep` (0.8.0 changed from top-level to subcommand).
#
# Pinned version: 0.8.0 (unmaintained; do not auto-upgrade).
#   Reinstall pinned: cargo install --locked --version 0.8.0 cargo-sweep
#
set -euo pipefail

# ─── Configuration ────────────────────────────────────────────────────────────
DEVELOPER_ROOT="/Users/mjp/Developer"
TIME_DAYS="7"
MAX_SIZE="10GiB"

# ─── Logging ─────────────────────────────────────────────────────────────────
# Defined before any caller (notably the argument parser) so an invalid arg
# logs the intended message and exits 2 rather than invoking macOS /usr/bin/log.
log() { printf '[%s] %s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$*"; }

# ─── Arguments ───────────────────────────────────────────────────────────────
# --dry-run: pass --dry-run through to every cargo-sweep invocation (preview;
#            no deletion). Use to validate policy before loading the agent.
DRY_RUN=()
for arg in "$@"; do
    case "$arg" in
        --dry-run|-d) DRY_RUN=("--dry-run") ;;
        *) log "unknown argument: $arg"; exit 2 ;;
    esac
done

# ─── Guards ──────────────────────────────────────────────────────────────────

# Graceful no-op if cargo-sweep is not installed (could be `cargo uninstall`-ed).
if ! command -v cargo-sweep >/dev/null 2>&1; then
    log "cargo-sweep not found on PATH; skipping run (exit 0)"
    exit 0
fi

# Refuse to run while a build is active — sweeping a target dir being written
# is unsafe. `pgrep -x` matches the exact process name.
if pgrep -x cargo >/dev/null 2>&1 || pgrep -x rustc >/dev/null 2>&1; then
    log "active cargo/rustc build detected; skipping run (exit 0)"
    exit 0
fi

# Scope check: never run if the Developer root is missing (e.g. wrong machine).
if [[ ! -d "$DEVELOPER_ROOT" ]]; then
    log "$DEVELOPER_ROOT does not exist; skipping run (exit 0)"
    exit 0
fi

# ─── Stage 1: time-based recursive sweep ─────────────────────────────────────
# Removes artifacts whose mtime is older than TIME_DAYS across every Rust
# project under the Developer tree. Hidden dirs (.git, .Claude/worktrees, ...)
# are skipped by cargo-sweep's default (no --hidden).
log "stage 1: recursive time sweep (--time ${TIME_DAYS}d) under $DEVELOPER_ROOT${DRY_RUN:+ (dry-run)}"

# Capture output for logging only (stage 2 does its own filesystem discovery).
STAGE1_OUTPUT="$(cargo-sweep sweep --recursive --time "$TIME_DAYS" "${DRY_RUN[@]}" "$DEVELOPER_ROOT" 2>&1)" || {
    log "stage 1 FAILED (cargo-sweep exit $?):"
    printf '%s\n' "$STAGE1_OUTPUT" | sed 's/^/    /'
    exit 1
}
printf '%s\n' "$STAGE1_OUTPUT" | sed 's/^/    /'

# ─── Stage 2: per-target-dir size cap ────────────────────────────────────────
# Discover cargo project target/ dirs via DIRECT FILESYSTEM DISCOVERY — not
# by parsing cargo-sweep human-readable output (fragile: format changes or
# error lines emitted into the output would silently break discovery, causing
# the size cap to fail open).
#
# Method: find every Cargo.toml under the Developer root, pruning target
# subtrees (so we don't descend into build artifacts) and hidden dirs
# (consistent with stage 1's cargo-sweep default). find without -L does NOT
# follow symlinks, so symlinked external trees are not traversed. For each
# manifest, the default target dir is <project>/target; cargo-sweep --maxsize
# is invoked from the project dir (which has Cargo.toml). Workspace members
# that use the workspace root's target have no local target/ and are skipped;
# the workspace root's Cargo.toml is discovered independently. Dedup via
# sort -z -u ensures each default per-project/workspace target/ is handled once.
#
# cargo-sweep --maxsize shrinks a single target dir to MAX_SIZE by evicting the
# oldest artifacts. Applied per discovered project individually (not
# --recursive --maxsize, which the plan flags as a budgeting anti-pattern).
# Null-delimited throughout for correct handling of spaces in paths.
log "stage 2: per-dir size cap (--maxsize ${MAX_SIZE}) via filesystem discovery"

fail=0
capped=0
while IFS= read -r -d '' target_dir; do
    capped=1
    project_dir="$(dirname "$target_dir")"
    log "  capping: $project_dir (target: $target_dir)"
    if ! cargo-sweep sweep --maxsize "$MAX_SIZE" "${DRY_RUN[@]}" "$project_dir" 2>&1 | sed 's/^/    /'; then
        log "  WARN: maxsize sweep failed for $project_dir (continuing)"
        fail=1
    fi
done < <(
    find "$DEVELOPER_ROOT" \
        \( -type d -name target -o -type d -name '.*' \) -prune \
        -o -type f -name Cargo.toml -print0 2>/dev/null \
    | while IFS= read -r -d '' manifest; do
        project_dir="$(dirname "$manifest")"
        target_dir="$project_dir/target"
        if [[ -d "$target_dir" ]]; then
            printf '%s\0' "$target_dir"
        fi
    done \
    | sort -z -u
)

if [[ "$capped" -eq 0 ]]; then
    log "stage 2: no target dirs discovered; nothing to cap"
fi

if [[ "$fail" -ne 0 ]]; then
    log "done (with warnings)"
else
    log "done"
fi
exit "$fail"