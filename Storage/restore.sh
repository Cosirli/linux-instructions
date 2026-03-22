#!/bin/bash
set -eo pipefail

usage() {
    echo "Usage: $0 -s <backup_dir> -d <target_dir> -n <full_prefix_from_checksum_file>"
    exit 1
}

while getopts "s:d:n:" opt; do
    case "$opt" in
        s) SRC_DIR=$(readlink -f "$OPTARG") ;;
        d) DEST_DIR=$(readlink -f "$OPTARG") ;;
        n) PREFIX="$OPTARG" ;;
        *) usage ;;
    esac
done

[[ -z "$SRC_DIR" || -z "$DEST_DIR" || -z "$PREFIX" ]] && usage
[[ $EUID -ne 0 ]] && { echo "Error: Must run as root"; exit 1; }

mkdir -p "$DEST_DIR"

# 1. Integrity Check
echo "Verifying integrity..."
( cd "$SRC_DIR" && sha256sum -c "${PREFIX}.sha256" )

# 2. Setup Pipeline
FILES=($(ls "$SRC_DIR"/"$PREFIX".tar.zst* | sort))
[[ ${#FILES[@]} -eq 0 ]] && { echo "No backup files found"; exit 1; }

DECRYPT_CMD=(cat)
if [[ "${FILES[0]}" == *.gpg* ]]; then
    echo "Encrypted backup detected."
    DECRYPT_CMD=(gpg --decrypt --batch --pinentry-mode loopback)
fi

# 3. Restore Data
TOTAL_SIZE=$(du -cb "${FILES[@]}" | tail -n1 | awk '{print $1}')

cat "${FILES[@]}" | \
    pv -s "$TOTAL_SIZE" -N "Streaming" | \
    "${DECRYPT_CMD[@]}" | \
    zstd -d --threads=0 | \
    tar -xpSf - --numeric-owner --acls --xattrs --xattrs-include='*' -C "$DEST_DIR"

# 4. Restore Attributes (The Robust Way)
ATTR_FILE="$SRC_DIR/${PREFIX}.attrs"
if [[ -f "$ATTR_FILE" ]]; then
    echo "Applying chattr attributes..."
    while read -r line; do
        # Extract attributes and path
        # lsattr output: "----i--------- ./path/to/file"
        attrs=$(echo "$line" | awk '{print $1}' | tr -d '-')
        # Skip if no special attributes are set (like only 'e' for extents)
        [[ -z "${attrs//e/}" ]] && continue
        
        # Get path (stripping the leading source path prefix from the backup)
        # This assumes the backup was made with -C source .
        rel_path=$(echo "$line" | cut -c 21-)
        
        # Apply attributes
        chattr +"$attrs" "$DEST_DIR/$rel_path" 2>/dev/null || true
    done < "$ATTR_FILE"
fi

echo "Restore complete."