#!/bin/sh
# Erzeugt die Screenshots für die README in doc/. Gebaut wird in einem
# temporären Verzeichnis, damit ein laufendes latexmk -pvc nicht stört.
set -eu
repo="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cp "$repo"/tex/*.sty "$repo"/templates/*.tex "$repo"/doc/*.tex "$tmp"/
cd "$tmp"
for f in schreibuebung-alphabet schreibvorlage-leer-gross schreibvorlage-leer-klein beispiel; do
  pdflatex -interaction=nonstopmode "$f.tex" >/dev/null
done

page() {  # PDF, Seite, Auflösung, Ausgabe
  pdftoppm -png -r "$3" -f "$2" -l "$2" -singlefile "$1" "$4"
  magick "$4.png" -bordercolor '#999' -border 1 "$4.png"
}

# Ganze Seiten nebeneinander
page schreibuebung-alphabet.pdf 1 50 alphabet
page schreibvorlage-leer-gross.pdf 1 50 gross
page schreibvorlage-leer-klein.pdf 1 50 klein
magick alphabet.png gross.png klein.png -background white -splice 20x0 \
  +append -chop 20x0 +repage -strip "$repo/doc/seiten.png"

# Alle Seiten des Beispiels nebeneinander
for n in 1 2 3; do
  page beispiel.pdf "$n" 50 "beispiel-$n"
done
magick beispiel-1.png beispiel-2.png beispiel-3.png -background white \
  -splice 20x0 +append -chop 20x0 +repage -strip "$repo/doc/beispiel.png"

# Ausschnitt mit den ersten Zeilen des Alphabets
pdftoppm -png -r 150 -f 1 -l 1 -singlefile -x 100 -y 70 -W 1060 -H 360 \
  schreibuebung-alphabet.pdf detail
magick detail.png -bordercolor '#999' -border 1 -strip "$repo/doc/detail.png"
