find ./_data -type f -name "*.txt" | xargs cat > ./_build/tmp/all.txt
sort ./_build/tmp/all.txt -u > ./_build/tmp/hosts-standard.txt
cat ./_build/head.txt ./_build/tmp/hosts-standard.txt > ./_build/tmp/hosts
rm ./_build/tmp/all.txt
rm ./_build/tmp/hosts-standard.txt
