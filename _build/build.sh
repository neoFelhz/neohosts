find ../_data -type f -name "*.txt" -print0 | xargs --null cat > all.txt
sort all.txt -u > hosts
mv hosts ../_public
rm all.txt
