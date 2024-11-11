#!/bin/bash

. ~/.cache/wal/colors.sh # import colors from pywal

THEME_NAME="Pywal"


DIR=$(dirname "${BASH_SOURCE[0]}")
THEME_DIR="$DIR/$THEME_NAME"

# pywalfox algorithm color lightener
foxyfy() {
    python3 - "$@" <<'___HEREDOC'
from sys import argv


def hex_to_rgb(color):
    """Convert a hex color to rgb."""
    return tuple(bytes.fromhex(color.strip("#")))


def rgb_to_hex(color):
    """Convert an rgb color to hex."""
    return "#%02x%02x%02x" % (*color,)


def work(color, f):
    pwf = float(f)
    c = hex_to_rgb(color)
    b = []
    b.append(min((max(0, int(c[0] + (c[0] * pwf)))), 255))
    b.append(min((max(0, int(c[1] + (c[1] * pwf)))), 255))
    b.append(min((max(0, int(c[2] + (c[2] * pwf)))), 255))
    return rgb_to_hex(b)


print(work(argv[1],argv[2]))
___HEREDOC
}

# pywalfox constants

# light
pwf_0=1.25
# extra light
pwf_1=1.85
# extra extra light
pwf_2=2.15
# extra extra extra light
pwf_3=2.75

# Converts hex colors into rgb joined with comma
# #fff -> 255, 255, 255
hexToRgb() {
    # Remove '#' character from hex color #fff -> fff
    plain=${1#*#}
    printf "%d, %d, %d" 0x${plain:0:2} 0x${plain:2:2} 0x${plain:4:2}
}

prepare() {
    if [ -d $THEME_DIR ]; then
        rm -rf $THEME_DIR
    fi
    
    mkdir $THEME_DIR
    mkdir "$THEME_DIR/images"
    
    # Copy wallpaper so it can be used in theme  
    background_image="images/theme_ntp_background_norepeat.png"
    cp "$wallpaper" "$THEME_DIR/$background_image"

}


background=$(hexToRgb $background)
foreground=$(hexToRgb $foreground)
accent=$(hexToRgb $color11)
secondary=$(hexToRgb $color8)


frame=$background
frame_inactive=$background
frame_incognito=$background
frame_incognito_inactive=$background
bookmark_text=$foreground
tab_background_text=$foreground
tab_background_text_inactive=$foreground
tab_background_text_incognito=$foreground
tab_background_text_incognito_inactive=$foreground
tab_text=$foreground
toolbar=$accent
toolbar_button_icon=$foreground
toolbar_text=$foreground
ntp_text=$foreground
ntp_link=$accent
ntp_background=$foreground
ntp_section=$secondary
omnibox_text=$foreground
omnibox_background=$background
button_background=$foreground
control_button_background=$background


generate() {
    # Theme template
    cat > "$THEME_DIR/manifest.json" << EOF
    {
      "manifest_version": 3,
      "version": "1.0",
      "name": "$THEME_NAME Theme",
      "theme": {
        "images": {
          "theme_ntp_background" : "$background_image"
        },
        "colors": {
          "frame": [$frame],
          "frame_inactive": [$frame_inactive],
          "frame_incognito": [$frame_incognito],
          "frame_incognito_inactive": [$frame_incognito_inactive],
          "bookmark_text": [$bookmark_text],
          "tab_background_text": [$tab_background_text],
          "tab_background_text_inactive": [$tab_background_text_inactive],
          "tab_background_text_incognito": [$tab_background_text_incognito],
          "tab_background_text_incognito_inactive": [$tab_background_text_incognito_inactive],
          "tab_text": [$tab_text],
          "toolbar": [$toolbar],
          "toolbar_button_icon": [$toolbar_button_icon],
          "toolbar_text": [$toolbar_text],
          "ntp_text": [$ntp_text],
          "ntp_link": [$ntp_link],
          "ntp_background": [$ntp_background],
          "ntp_section": [$ntp_section],
          "omnibox_text": [$omnibox_text],
          "omnibox_background": [$omnibox_background],
          "button_background": [$button_background],
          "control_button_background": [$control_button_background]
        },
        "properties": {
          "ntp_background_alignment": "bottom"
        }
      }
    }
EOF
}

prepare
generate
echo "Pywal Chrome theme generated at $THEME_DIR"
