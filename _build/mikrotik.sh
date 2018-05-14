echo "Building Mikrotik Basic Shell . . ."
cp ./_build/tmp/basic/hosts ./_build/tmp/basic/1.txt
sed -e '/^:/d' ./_build/tmp/basic/1.txt > ./_build/tmp/basic/2.txt
sed -i 's|0.0.0.0 |ip dns static add address=$1 name=|g' ./_build/tmp/basic/2.txt
cat ./_build/tmp/basic/2.txt > ./_build/tmp/basic/mikrotik.sh
echo "Cleaning tmp . . ."
rm ./_build/tmp/basic/1.txt
rm ./_build/tmp/basic/2.txt

echo "Building Mikrotik Full Shell . . ."
cp ./_build/tmp/full/hosts ./_build/tmp/full/1.txt
sed -e '/^:/d' ./_build/tmp/full/1.txt > ./_build/tmp/full/2.txt
sed -i 's|0.0.0.0 |ip dns static add address=$1 name=|g' ./_build/tmp/full/2.txt
cat ./_build/tmp/full/2.txt > ./_build/tmp/full/mikrotik.sh
echo "Cleaning tmp . . ."
rm ./_build/tmp/full/1.txt
rm ./_build/tmp/full/2.txt
