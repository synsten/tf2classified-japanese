#!/usr/bin/env bash

set -e

SourceDir="${1:?Usage: $0 <SourceDir>}"
OutputDir="converted_${SourceDir}"

mkdir -p "$OutputDir"

find "$SourceDir" -type f -print0 | while IFS= read -r -d '' File; do
	if [ "$(xxd -p -l 3 "$File")" != "efbbbf" ]; then
		echo "::error file=$File::$File is not UTF-8-BOM"
		exit 1
	fi

	Out="$OutputDir/${File#"$SourceDir"/}"
	mkdir -p "$(dirname "$Out")"

	iconv -f UTF-8 -t UTF-16LE "$File" -o "$Out"
done