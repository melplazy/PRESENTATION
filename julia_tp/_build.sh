#!/bin/sh

pdflatex julia_tp.tex; 
bibtex julia_tp;
pdflatex julia_tp.tex; 
pdflatex julia_tp.tex; 

rm *.log *.aux *.out *.nav *.toc *.snm *.vrb *.blg *.bbl

