# npm install -g @slidev/cli
DIRS=$(ls -d */)
for DIR in $DIRS; do
  DIRNAME=$(echo $DIR | sed 's:/*$::')
  if find "$DIRNAME/src/package.json"; then
    cd "$DIRNAME/src"
    yarn install
    echo "Building $DIRNAME"
    yarn build
    cd ../..
  fi
done
