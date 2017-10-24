find ./_data -type f -name "*.txt" -print0 | xargs --null cat > all.txt
sort all.txt -u > hosts
rm all.txt
