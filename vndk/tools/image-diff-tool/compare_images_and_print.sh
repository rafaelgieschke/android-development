#!/bin/bash

set -e

PROGNAME="$0"

function usage {
  cat <<EOF
Usage:
    ${PROGNAME} [OPTION] ... "[Args for compare_images]"

Options:
    -h, --help
        Show this message and exit.
    -c, --check
        Exit with a non-zero status if there is any unexpected diffs.
EOF
}

while [[ "$1" =~ ^- ]] && [[ "$1" != "--" ]]; do
  case "$1" in
    -h | --help)
      usage
      exit 0
      ;;
    -c | --check)
      CHECK_DIFF_RESULT=1
      ;;
    *)
      break
      ;;
  esac
  shift
done
if [ "$1" == "--" ]; then
  shift
fi

readonly CHECK_DIFF_RESULT

. build/envsetup.sh
lunch aosp_arm64-next-userdebug
build/soong/soong_ui.bash --make-mode compare_images
COMMON_ALLOWLIST=development/vndk/tools/image-diff-tool/allowlist.txt
out/host/linux-x86/bin/compare_images $1 -u -w "${COMMON_ALLOWLIST}"

if [ -v DIST_DIR ]; then
  cp common.csv diff.csv allowlisted_diff.csv "${DIST_DIR}"
fi

echo >&2
echo >&2 " - Different parts (that are allowlisted)"
cat >&2 allowlisted_diff.csv
echo >&2
echo >&2 " - Different parts (that are not allowlisted)"
cat >&2 diff.csv

if [ "$(wc -l diff.csv | cut -d' ' -f1)" -gt "1" ]; then
  cat >&2 <<EOF

[ERROR] Unexpected diffing files.
There are diffing files that are not ignored by allowlist.
The allowlist may need to be updated.
EOF
  if [ -n "${CHECK_DIFF_RESULT}" ]; then
    exit 1
  fi
fi
