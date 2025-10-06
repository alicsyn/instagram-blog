#!/bin/bash
cd /home/u811056906/projects/instagram-blog
/home/u811056906/bin/hugo --minify --cleanDestinationDir
echo "Build completed. Check public/ directory."
ls -la public/ | head -20

