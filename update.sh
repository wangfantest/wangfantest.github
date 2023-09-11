git checkout --orphan newBranch
rm -f -r docs
hugo -b "https://wangfantest.github.io" -d docs
git add -A
git commit -am "commit message"
git branch -D master
git branch -m master
git push -f origin master
