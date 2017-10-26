mkdir ./_build/tmp/basic -p
mkdir ./_build/tmp/full -p

echo "Building standard hosts . . ."
find ./_data/basic -type f -name "*.txt" | xargs cat > ./_build/tmp/basic/1.txt
sed -e '/^#/d' ./_build/tmp/basic/1.txt > ./_build/tmp/basic/2.txt
sort ./_build/tmp/basic/2.txt -u > ./_build/tmp/basic/3.txt
cat ./_build/head.txt ./_build/tmp/basic/3.txt > ./_build/tmp/basic/hosts
echo "Cleaning tmp . . ."
rm ./_build/tmp/basic/1.txt
rm ./_build/tmp/basic/2.txt
rm ./_build/tmp/basic/3.txt

echo "Building full hosts . . ."
find ./_data -type f -name "*.txt" | xargs cat > ./_build/tmp/full/1.txt
sed -e '/^#/d' ./_build/tmp/full/1.txt > ./_build/tmp/full/2.txt
sort ./_build/tmp/full/2.txt -u > ./_build/tmp/full/3.txt
cat ./_build/head.txt ./_build/tmp/full/3.txt > ./_build/tmp/full/hosts
echo "Cleaning tmp . . ."
rm ./_build/tmp/full/1.txt
rm ./_build/tmp/full/2.txt
rm ./_build/tmp/full/3.txt
