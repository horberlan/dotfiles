#!/usr/bin/env zsh

MIME=$(mimetype --all --brief "$1")

case "$MIME" in
# .pdf
*application/pdf*)
    pdftotext "$1" -
    ;;
# .7z
*application/x-7z-compressed*)
    7z l "$1"
    ;;
# .tar .tar.Z
*application/x-tar*)
    tar -tvf "$1"
    ;;
# .tar.*
*application/x-compressed-tar* | *application/x-*-compressed-tar*)
    tar -tvf "$1"
    ;;
# .rar
*application/vnd.rar*)
    unrar l "$1"
    ;;
# .zip
*application/zip*)
    unzip -l "$1"
    ;;
# any plain text file that doesn't have a specific handler
*text/plain*)
    # return false to always repaint, in case terminal size changes
    bat --force-colorization --paging=never --style=changes,numbers \
        --terminal-width $(($2 - 3)) "$1" && false
    ;;
*)
    echo "unknown format"
    ;;
esac

file="$1"
shift
case "$file" in
# Handle different file extensions
*.tar*)
    tar tf "$file"
    ;;
*.zip)
    unzip -l "$file"
    ;;
*.rar)
    unrar l "$file"
    ;;
*.7z)
    7z l "$file"
    ;;
*.avi | *.mp4 | *.mkv)
    thumbnail="$LF_TEMPDIR/thumbnail.png"
    ffmpeg -y -i "$file" -vframes 1 "$thumbnail"
    preview "$thumbnail" "$@"
    ;;
*.pdf)
    thumbnail="$LF_TEMPDIR/thumbnail.png"
    gs -o "$thumbnail" -sDEVICE=pngalpha -dLastPage=1 "$file" >/dev/null
    preview "$thumbnail" "$@"
    ;;
*.jpg | *.jpeg | *.png | *.bmp)
    preview "$file" "$@"
    ;;
*.svg)
    thumbnail="$LF_TEMPDIR/thumbnail.png"
    convert "$file" "$thumbnail"
    preview "$thumbnail" "$@"
    ;;
    
*)
    cat "$file"
    ;;
esac
