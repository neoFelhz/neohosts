mkdir ./_build/tmp/basic -p
mkdir ./_build/tmp/full -p

find ./_data/basic -type f -name "*.txt" | xargs cat > ./_build/tmp/basic/all.txt
sort ./_build/tmp/baisc/all.txt -u > ./_build/tmp/basic/standby.txt
cat ./_build/head.txt ./_build/tmp/basic/standby.txt > ./_build/tmp/basic/hosts
rm ./_build/tmp/basic/all.txt
rm ./_build/tmp/basic/standby.txt

find ./_data -type f -name "*.txt" | xargs cat > ./_build/tmp/full/all.txt
sort ./_build/tmp/full/all.txt -u > ./_build/tmp/full/standby.txt
cat ./_build/head.txt ./_build/tmp/full/standby.txt > ./_build/tmp/full/hosts
rm ./_build/tmp/full/all.txt
rm ./_build/tmp/full/standby.txt
