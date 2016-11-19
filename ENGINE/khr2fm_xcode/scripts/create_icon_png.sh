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
DIR_output="icons"

# Files
icon="$DIR_project/ASSETS/GFX/icon.png"

# Data
ios_sizes=(
	# iPhone
	"57x57" # App pre-iOS7
	"114x114"
	"120x120" # App post-iOS7
	"180x180"
	"80x80" # Spotlight
	"120x120"
	"29x29"	# Settings
	"58x58"
	"87x87"
	"40x40" # Notifications
	"60x60"

	# iPad
	"72x72" # App pre-iOS7
	"144x144"
	"76x76" # App post-iOS7
	"152x152"
	"167x167"
	"50x50" # Spotlight pre-iOS7
	"100x100"
	"20x20" # Spotlight post-iOS7
	"40x40"
	"80x80"
	"29x29" # Settings
	"58x58"

	# AppStore
	"1024x1024"
)
ios_names=(
	# iPhone
	"Icon@1x~iphone-OS5" # App pre-iOS7
	"Icon@2x~iphone-OS5"
	"Icon@2x~iphone-OS7" # App post-iOS7
	"Icon@3x~iphone-OS7"
	"Icon@2x~iphone-OS7-spotlight" # Spotlight
	"Icon@3x~iphone-OS7-spotlight"
	"Icon@1x~iphone-OS5-settings" # Settings
	"Icon@2x~iphone-OS7-settings"
	"Icon@3x~iphone-OS7-settings"
	"Icon@2x~iphone-OS7-notifs" # Notifications
	"Icon@3x~iphone-OS7-notifs"

	# iPad
	"Icon@1x~ipad-OS5" # App pre-iOS7
	"Icon@2x~ipad-OS5"
	"Icon@1x~ipad-OS7" # App post-iOS7
	"Icon@2x~ipad-OS7"
	"Icon@2x~ipadpro-OS7"
	"Icon@1x~ipad-OS5-spotlight" # Spotlight pre-iOS7
	"Icon@2x~ipad-OS5-spotlight"
	"Icon@1x~ipad-OS7-spotlight" # Spotlight post-iOS7
	"Icon@2x~ipad-OS7-spotlight"
	"Icon@3x~ipad-OS7-spotlight"
	"Icon@2x~ipad-OS7-settings" # Settings
	"Icon@3x~ipad-OS7-settings"

	# AppStore
	"Icon~AppStore"
)

#printf "${#ios_sizes[@]} == ${#ios_names[@]}"; exit

# Make sure bootsplash exists
if [ ! -f "$icon" ]; then
	printf "Couldn't find icon!\n"
	exit -1
fi

# Start converting
for (( i=0; i < ${#ios_sizes[@]}; i++ )) do
	convert "$icon" -resize "${ios_sizes[i]}" "$DIR_output/${ios_names[i]}".png
done
