# Baut alle Vorlagen und das Beispiel vom Hauptordner des Repositorys aus:
#   latexmk               mit pdfLaTeX
#   latexmk -c            entfernt die Hilfsdateien wieder
# latexmk wechselt in das Verzeichnis jedes Dokuments; die latexmkrc dort
# werden nicht gelesen, daher wird der Suchpfad hier einmal für alle gesetzt.

use Cwd;
ensure_path('TEXINPUTS', getcwd() . '/tex/');
$pdf_mode = 1;
$do_cd = 1;

@default_files = (
  'doc/beispiel.tex',
  'templates/schreibuebung-alphabet.tex',
  'templates/schreibvorlage-leer-gross.tex',
  'templates/schreibvorlage-leer-klein.tex',
);
