#!/usr/bin/env bash
# publish.sh <slug> <fil>...
# Lägger filerna i <idag>/<slug>/ på orphan-branchen pr-media, tar bort alla
# datummappar äldre än KEEP_DAYS, och force-pushar en enda commit. Skriver ut
# markdown-rader på stdout, allt annat går till stderr.
set -euo pipefail
slug=$1; shift
(( $# > 0 )) || { echo "usage: publish.sh <slug> <fil>..." >&2; exit 1; }

REMOTE=${PR_MEDIA_REMOTE:-https://github.com/flexapplicationsvisma/hrm}
BRANCH=${PR_MEDIA_BRANCH:-pr-media}
KEEP_DAYS=${PR_MEDIA_KEEP_DAYS:-7}
nwo=$(sed -E 's#.*github\.com[:/]##; s#\.git$##' <<<"$REMOTE")
: "${GH_TOKEN:=$(gh auth token --user HectorVisma)}"; export GH_TOKEN

files=(); for f in "$@"; do files+=("$(realpath "$f")"); done
today=$(date +%F); cutoff=$(date -d "-$KEEP_DAYS days" +%F)
work=$HOME/.cache/pr-media/${nwo//\//_}

rm -rf "$work"; mkdir -p "$work"; cd "$work"
git init -q -b publish
git remote add origin "$REMOTE"
if git fetch -q --depth 1 origin "$BRANCH" 2>/dev/null; then
  git checkout -q FETCH_HEAD -- .
else
  echo "no $BRANCH branch yet, creating it" >&2
fi

for d in ????-??-??; do
  [[ -d $d && $d < $cutoff ]] || continue
  rm -rf "$d"; echo "pruned $d" >&2
done

dest=$today/$slug
rm -rf "$dest"; mkdir -p "$dest"
cp "${files[@]}" "$dest"/
git add -A
git commit -q -m "pr-media $today $slug"
git push -q -f origin HEAD:"$BRANCH"
echo "pushed $dest to $nwo@$BRANCH" >&2

for f in "${files[@]}"; do
  n=$(basename "$f")
  echo "![${n%.*}](https://github.com/$nwo/blob/$BRANCH/$dest/$n?raw=true)"
done
