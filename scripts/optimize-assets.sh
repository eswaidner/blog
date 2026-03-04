#!/bin/bash

INPUT_DIR="${1:-.}"

shopt -s globstar nullglob

convert_files=("$INPUT_DIR"/**/*.{jpg,jpeg,png} "$INPUT_DIR"/*.{jpg,jpeg,png})
webp_files=("$INPUT_DIR"/**/*.webp "$INPUT_DIR"/*.webp)

if [ ${#convert_files[@]} -eq 0 ] && [ ${#webp_files[@]} -eq 0 ]; then
  echo "No images found in $INPUT_DIR"
  exit 0
fi

if [ ${#convert_files[@]} -gt 0 ]; then
  mogrify \
    -format webp \
    -units PixelsPerInch \
    -resample 72 \
    -quality 85 \
    "${convert_files[@]}"

  # rm "${convert_files[@]}"
  echo "Converted ${#convert_files[@]} image(s)."
fi

if [ ${#webp_files[@]} -gt 0 ]; then
  mogrify \
    -units PixelsPerInch \
    -resample 72 \
    -quality 85 \
    "${webp_files[@]}"

  echo "Optimized ${#webp_files[@]} WebP image(s)."
fi
