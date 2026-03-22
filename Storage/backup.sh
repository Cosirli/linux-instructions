#!/bin/bash
set -eo pipefail

# --- Configuration & Defaults ---
COMP_LEVEL=3
SPLIT_SIZE=""
ENCRYPT=false
PREFIX="backup"
ATTRS_BACKUP=false
TAR_EXCLUDES=()

usage() {
    echo "Usage: $0 -s <src> -d <dest> [options]"
    echo "Options:"
    echo "  -s PATH    Source directory"
    echo "  -d PATH    Destination directory"
    echo "  -n STR     Prefix (default: backup)"
    echo "  -c INT     Zstd level (1-22, default: 3)"
    echo "  -b SIZE    Split size (e.g. 5G)"
    echo "  -x PATTERN Exclude pattern (can use multiple times)"
    echo "  -f FILE    Exclude from file"
    echo "  -e         Enable AES256 encryption"
    echo "  -a         Backup chattr attributes"
    exit 1
}

while getopts "s:d:n:c:b:x:f:ea" opt; do
    case "$opt" in
        s) SOURCE=$(readlink -f "$OPTARG") ;;
        d) DEST=$(readlink -f "$OPTARG") ;;
        n) PREFIX="$OPTARG" ;;
        c) COMP_LEVEL="$OPTARG" ;;
        b) SPLIT_SIZE="$OPTARG" ;;
        x) TAR_EXCLUDES+=("--exclude=$OPTARG") ;;
        f) TAR_EXCLUDES+=("--exclude-from=$OPTARG") ;;
        e) ENCRYPT=true ;;
        a) ATTRS_BACKUP=true ;;
        *) usage ;;
    esac
done

[[ -z "$SOURCE" || -z "$DEST" ]] && usage
[[ $EUID -ne 0 ]] && { echo "Error: Must run as root"; exit 1; }

LOG_PREFIX="${PREFIX}_$(date +%Y%m%d)"
FINAL_EXT=".tar.zst"
[[ "$ENCRYPT" == true ]] && FINAL_EXT="$FINAL_EXT.gpg"
mkdir -p "$DEST"

# --- 1. Attribute Backup (The Robust Way) ---
# Using find -exec lsattr -d avoids the "dir/:" header lines completely
if [[ "$ATTRS_BACKUP" == true ]]; then
    echo "Recording file attributes..."
    find "$SOURCE" -xdev -exec lsattr -d {} + >  \
        "$DEST/${PREFIX}.attrs" 2>/dev/null || true
fi

# --- 2. Build the Command Arrays ---
# Tar command
TAR_CMD=(tar -cpSf - --numeric-owner --acls --xattrs --xattrs-include='*')
TAR_CMD+=(--one-file-system --delay-directory-restore --atime-preserve=system)
TAR_CMD+=("${TAR_EXCLUDES[@]}")
TAR_CMD+=(-C "$SOURCE" .)

# Compression
ZSTD_CMD=(zstd -"$COMP_LEVEL" --threads=0)

# Encryption
GPG_CMD=(cat)
[[ "$ENCRYPT" == true ]] && \
GPG_CMD=(gpg --symmetric --cipher-algo AES256 --pinentry-mode loopback)

# Split
if [[ -n "$SPLIT_SIZE" ]]; then
    OUTPUT_CMD=(split -b "$SPLIT_SIZE" -d -a 3 - "$DEST/$PREFIX$FINAL_EXT.part")
else
    OUTPUT_CMD=(cat)
    DEST_FILE="$DEST/$PREFIX$FINAL_EXT"
fi

# --- 3. Execution Pipeline ---
echo "Calculating source size..."
SRC_SIZE=$(du -sb "$SOURCE" "${TAR_EXCLUDES[@]}" | awk '{print $1}')

echo "Starting Backup..."

"${TAR_CMD[@]}" | \
    pv -s "$SRC_SIZE" -N "Archiving" | \
    "${ZSTD_CMD[@]}" | \
    "${GPG_CMD[@]}" | \
    ( [[ -n "$DEST_FILE" ]] && cat > "$DEST_FILE" || "${OUTPUT_CMD[@]}" )

# --- 4. Checksums ---
( cd "$DEST" && sha256sum "$PREFIX$FINAL_EXT"* > "${PREFIX}.sha256" )
echo "Success. Artifacts in $DEST"