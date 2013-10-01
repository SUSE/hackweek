This is needed to get pictures to show up:

for i in *.jpg; do convert -define jpeg:size=200x200 $i -thumbnail '300x200>' -background white -gravity center -extent 300x200 .thumbnails/$i; done
