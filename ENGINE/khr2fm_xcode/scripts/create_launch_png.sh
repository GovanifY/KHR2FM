#!/bin/sh

# Look for ImageMagick
which convert > /dev/null
if [ $? -ne 0 ]; then
	printf "ImageMagick not found. Please, install it first.\n"
	exit -1
fi

# Locate ourselves to this script's directory
cd "$(dirname "$0")"

######################
### IMPORTANT DATA ###
######################

# Directories
DIR_xcode=".."
DIR_project="../../.."
DIR_output="bootsplash"

# Files
bootsplash="$DIR_project/ASSETS/GFX/bootsplash.png"

# Data
ios_sizes=(
	# Portrait
	"320x480" # iPhone
	"640x960"
	"640x1136"
	"750x1334"
	"1242x2208"
	"768x1004" # iPad
	"768x1024"
	"1536x2008"
	"1536x2048"

	# Landscape
	"480x320" # iPhone
	"960x640"
	"1136x640"
	"1334x750"
	"2208x1242"
	"1024x748" # iPad
	"1024x768"
	"2048x1496"
	"2048x1536"
)
ios_names=(
	# Portrait
	"Default-Portrait@1x~iphone3" # iPhone
	"Default-Portrait@2x~iphone4"
	"Default-Portrait@2x~iphone5"
	"Default-Portrait@2x~iphone6"
	"Default-Portrait@3x~iphone+"
	"Default-Portrait@0.8x~ipad" # iPad
	"Default-Portrait@1x~ipad"
	"Default-Portrait@1.8x~ipad"
	"Default-Portrait@2x~ipad"

	# Landscape
	"Default-Landscape@1x~iphone3" # iPhone
	"Default-Landscape@2x~iphone4"
	"Default-Landscape@2x~iphone5"
	"Default-Landscape@2x~iphone6"
	"Default-Landscape@3x~iphone+"
	"Default-Landscape@0.8x~ipad" # iPad
	"Default-Landscape@1x~ipad"
	"Default-Landscape@1.8x~ipad"
	"Default-Landscape@2x~ipad"
)

# Make sure bootsplash exists
if [ ! -f "$bootsplash" ]; then
	printf "Couldn't find bootsplash!\n"
	exit -1
fi

# Start converting
for (( i=0; i < ${#ios_sizes[@]}; i++ )) do
	convert "$bootsplash" -resize "${ios_sizes[i]}" -background none -gravity center -extent "${ios_sizes[i]}" "$DIR_output/${ios_names[i]}".png
done
