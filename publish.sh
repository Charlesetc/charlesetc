jekyll build
cp -r _site .site
git co master
rm -r *
mv .site/* ./
rmdir .site
git a
git commit -m "update to master from development"
