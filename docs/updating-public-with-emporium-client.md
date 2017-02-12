# Updating public with emporium-client

``` bash
cd emporium-client
npm run build
rsync -auv --delete ./build/ ../emporium/public/
```
