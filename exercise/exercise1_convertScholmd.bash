#!/bin/bash

PATH=~/local/bin:/opt/SLIM/ScholarlyMarkdown/bin:/usr/texbin:/usr/local/bin:/opt/local/bin:/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin
scholdoc --css='https://slimgroup.slim.gatech.edu/ScholMD/core/slimweb-scholmd-core-v0.1-latest.css' --mathjax='https://slimgroup.slim.gatech.edu/MathJax/MathJax.js?config=TeX-AMS_HTML-full' --to=html --default-image-extension=png --citeproc "exercise1.md" "/opt/SLIM/ScholarlyMarkdown/configs/default_csl.yaml" -o "exercise1.html" 2>&1
