#!/usr/bin/env bash
# cleanup.sh — run from the ROOT of your tabasum-ph.github.io repo.
#
# This MOVES unused files into _unused_archive/ instead of deleting them,
# so you can review (and back up your personal photos!) before removing.
#
# After running and verifying the site still works:
#   1. Back up _unused_archive/ somewhere private (it contains personal photos).
#   2. Delete it:  rm -rf _unused_archive
#   3. Commit and push.
#
# NOTE: This shrinks the DEPLOYED site, not your git clone size.
# Old files live on in git history. To truly shrink the repo, either
# rewrite history (git filter-repo) or start a fresh repo from the
# cleaned files.

set -euo pipefail
ARCH="_unused_archive"
mkdir -p "$ARCH"

mv_safe() { [ -e "$1" ] && mkdir -p "$ARCH/$(dirname "$1")" && mv "$1" "$ARCH/$1" && echo "archived: $1" || true; }

# ---- Leftovers from the unused HTML5 UP "Dimension" template ----
mv_safe assets
mv_safe README.txt
mv_safe LICENSE.txt          # license of the unused Dimension template
mv_safe pic01.jpg
mv_safe pic02.jpg
mv_safe pic03.jpg
mv_safe overlay.png
mv_safe next.png
mv_safe prev.png

# ---- Unreferenced media (gallery was removed; video is not embedded) ----
mv_safe ninth_big_item.jpg
mv_safe ninth_item.jpg
mv_safe "IMG_20230215_182905 (1).jpg"   # personal photo, publicly downloadable
mv_safe gfp-astro-timelapse.mp4          # duplicate of video/ copy
mv_safe video
mv_safe images                           # 19MB, nothing references it

# ---- Unused CSS (only the 5 files linked in index.html are kept) ----
mv_safe css/bootstrap.css
mv_safe css/bootstrap.css.map
mv_safe css/bootstrap-theme.css
mv_safe css/bootstrap-theme.css.map
mv_safe "css/templatemo-main(modified).css"
mv_safe css/templatemo-style.css
mv_safe css/slick.css

# ---- Unused JS (only the 6 scripts loaded in index.html are kept) ----
mv_safe js/bootstrap.min.js
mv_safe js/jquery-3.5.1.min.js
mv_safe js/slick.js
mv_safe js/templatemo-script.js
mv_safe js/vendor/bootstrap.js
mv_safe js/vendor/npm.js

# ---- img/: keep ONLY what the site uses, archive the rest (~150MB of
#      personal camera photos that are currently public on the internet) ----
KEEP="Me24.jpg first_bg.jpg second_bg.jpg third_bg.jpg fourth_bg.jpg fifth_bg.jpg close.png loading.gif next.png prev.png"
mkdir -p "$ARCH/img"
for f in img/*; do
    base="$(basename "$f")"
    keep=false
    for k in $KEEP; do [ "$base" = "$k" ] && keep=true && break; done
    $keep || { mv "$f" "$ARCH/img/$base" && echo "archived: $f"; }
done

echo
echo "Done. Review $ARCH/, back up personal photos, then delete it."
echo "Kept PDFs untouched (some are unlinked but may be shared by URL):"
echo "  CPS-Talk-notes.pdf, MyPoster.pdf, TabasumRahnuma(GWOSC)2022-05-28.pdf"
