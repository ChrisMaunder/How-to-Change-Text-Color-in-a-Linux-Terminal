# How to Change Text Color in a Linux Terminal

A quick overview and a simple bash script to make your script output a little more lively

- [Download source code - 2.7 KB](https://raw.githubusercontent.com/ChrisMaunder/How-to-Change-Text-Color-in-a-Linux-Terminal/master/docs/assets/color.zip)

## Introduction

The default text output to a terminal is monochromatic and doesn't provide a simple method to provide context. For instance, you may want an error to appear in red, success in green, or important info to be output in bold.

Adding color to your terminal output is straightforward and involves outputting the correct control characters before your text.

## Terminal Colors

To output colored text, you need to `printf `or` echo -e` (the `-e` to ensure control characters are interpreted) the control characters for the required color, then output your text, and then (to be tidy) reset the output back to defaults. The following table lists the codes:




| Color | Foreground | Background |
| --- | --- | --- |
| Default | \033[39m | \033[49m |
| Black | \033[30m | \033[40m |
| Dark red | \033[31m | \033[41m |
| Dark green | \033[32m | \033[42m |
| Dark yellow (Orange-ish) | \033[33m | \033[43m |
| Dark blue | \033[34m | \033[44m |
| Dark magenta | \033[35m | \033[45m |
| Dark cyan | \033[36m | \033[46m |
| Light gray | \033[37m | \033[47m |
| Dark gray | \033[90m | \033[100m |
| Red | \033[91m | \033[101m |
| Green | \033[92m | \033[101m |
| Orange | \033[93m | \033[103m |
| Blue | \033[94m | \033[104m |
| Magenta | \033[95m | \033[105m |
| Cyan | \033[96m | \033[106m |
| White | \033[97m | \033[107m |

and the reset code is **\033[0m**

The format of the string for foreground color is:

```cpp
"\033[" + "<0 or 1, meaning normal or bold>;" + "<color code> + "m"
```

and for background:

```cpp
"\033[" + "<color code>" + "m"
```

These codes can be output together in order to change fore- and back-ground colors simultaneously.

## Using the Code

A simple example of red text:

```cpp
printf "\033[91mThis is red text\033[0m"
```

An example of red text on a white background:

```cpp
printf "\033[91m\033[107mThis is red text on a white background\033[0m"
```

This is a little cumbersome so I've created some simple subroutines that provide the means to output text in a more civilised manner.

## Helper Functions

The following helper functions allow you to do stuff like:

```cpp
WriteLine "This is red text" "Red"
WriteLine "This is red text on a white background" "Red" "White"
```

Much easier.

```cpp
useColor="true" # Set to false if you find your environment just doesn't handle colors well

# Returns a color code for the given foreground/background colors
# This code is echoed to the terminal before outputting text in
# order to generate a colored output.
#
# string foreground color name. Optional if no background provided.
#        Defaults to "Default" which uses the system default
# string background color name.  Optional. Defaults to $color_background
#        which is set based on the current terminal background
# returns a string
function Color () {

    local foreground=$1
    local background=$2

    if [ "$foreground" == "" ];  then foreground="Default"; fi
    if [ "$background" == "" ]; then background="$color_background"; fi

    local colorString='\033['

    # Foreground Colours
    case "$foreground" in
        "Default")      colorString='\033[0;39m';;
        "Black" )       colorString='\033[0;30m';;
        "DarkRed" )     colorString='\033[0;31m';;
        "DarkGreen" )   colorString='\033[0;32m';;
        "DarkYellow" )  colorString='\033[0;33m';;
        "DarkBlue" )    colorString='\033[0;34m';;
        "DarkMagenta" ) colorString='\033[0;35m';;
        "DarkCyan" )    colorString='\033[0;36m';;
        "Gray" )        colorString='\033[0;37m';;
        "DarkGray" )    colorString='\033[1;90m';;
        "Red" )         colorString='\033[1;91m';;
        "Green" )       colorString='\033[1;92m';;
        "Yellow" )      colorString='\033[1;93m';;
        "Blue" )        colorString='\033[1;94m';;
        "Magenta" )     colorString='\033[1;95m';;
        "Cyan" )        colorString='\033[1;96m';;
        "White" )       colorString='\033[1;97m';;
        *)              colorString='\033[0;39m';;
    esac

    # Background Colours
    case "$background" in
        "Default" )     colorString="${colorString}\033[49m";;
        "Black" )       colorString="${colorString}\033[40m";;
        "DarkRed" )     colorString="${colorString}\033[41m";;
        "DarkGreen" )   colorString="${colorString}\033[42m";;
        "DarkYellow" )  colorString="${colorString}\033[43m";;
        "DarkBlue" )    colorString="${colorString}\033[44m";;
        "DarkMagenta" ) colorString="${colorString}\033[45m";;
        "DarkCyan" )    colorString="${colorString}\033[46m";;
        "Gray" )        colorString="${colorString}\033[47m";;
        "DarkGray" )    colorString="${colorString}\033[100m";;
        "Red" )         colorString="${colorString}\033[101m";;
        "Green" )       colorString="${colorString}\033[102m";;
        "Yellow" )      colorString="${colorString}\033[103m";;
        "Blue" )        colorString="${colorString}\033[104m";;
        "Magenta" )     colorString="${colorString}\033[105m";;
        "Cyan" )        colorString="${colorString}\033[106m";;
        "White" )       colorString="${colorString}\033[107m";;
        *)              colorString="${colorString}\033[49m";;
    esac

    echo "${colorString}"
}

# Outputs a line, including linefeed, to the terminal using the given foreground / background
# colors 
#
# string The text to output. Optional if no foreground provided. Default is just a line feed.
# string Foreground color name. Optional if no background provided. Defaults to "Default" which
#        uses the system default
# string Background color name.  Optional. Defaults to $color_background which is set based on the
#        current terminal background
function WriteLine () {

    local resetColor='\033[0m'

    local str=$1
    local forecolor=$2
    local backcolor=$3

    if [ "$str" == "" ]; then
        printf "\n"
        return;
    fi

    # Note the use of the format placeholder %s. This allows us to pass "--" as strings without error
    if [ "$useColor" == "true" ]; then
        local colorString=$(Color ${forecolor} ${backcolor})
        printf "${colorString}%s${resetColor}\n" "${str}"
    else
        printf "%s\n" "${str}"
    fi
}

# Outputs a line without a linefeed to the terminal using the given foreground / background colors 
#
# string The text to output. Optional if no foreground provided. Default is just a line feed.
# string Foreground color name. Optional if no background provided. Defaults to "Default" which
#        uses the system default
# string Background color name.  Optional. Defaults to $color_background which is set based on the
#        current terminal background
function Write () {
    local resetColor="\033[0m"

    local forecolor=$1
    local backcolor=$2
    local str=$3

    if [ "$str" == "" ];  then
        return;
    fi

    # Note the use of the format placeholder %s. This allows us to pass "--" as strings without error
    if [ "$useColor" == "true" ]; then
        local colorString=$(Color ${forecolor} ${backcolor})
        printf "${colorString}%s${resetColor}" "${str}"
    else
        printf "%s" "$str"
    fi
}
```

![](https://raw.githubusercontent.com/ChrisMaunder/How-to-Change-Text-Color-in-a-Linux-Terminal/master/docs/assets/color-text0.PNG)

## Handling Dark Mode and Light Mode

In many Linux and Unix distros the terminal is black background, white text. On macOS, the default is white background with black text. There are [ways and means](https://github.com/rocky/shell-term-background/blob/master/term-background.bash) to test and guess what's happening but ultimately you'll need to test on your system and decide what works for you.

What I do is assume that if we're on a mac, then we can test directly, otherwise we assume white on black. I then also try to stick to default colors, and where I want a bit of color, I'll stick to some predefined colors I know will work well anywhere.

```cpp
# Gets the terminal background color. It's a very naive guess 
# returns an RGB triplet, values from 0 - 64K
function getBackground () {

    if [[ $OSTYPE == 'darwin'* ]]; then
        osascript -e \
        'tell application "Terminal"
            get background color of selected tab of window 1
        end tell'
    else

        # See https://github.com/rocky/shell-term-background/blob/master/term-background.bash
        # for a comprehensive way to test for background colour. For now we're just going to
        # assume that non-macOS terminals have a black background.

        echo "0,0,0" # we're making assumptions here
    fi
}

# Determines whether or not the current terminal is in dark mode (dark background, light text)
# returns "true" if running in dark mode; false otherwise
function isDarkMode () {

    local bgColor=$(getBackground)
    
    IFS=','; colors=($bgColor); IFS=' ';

    # Is the background more or less dark?
    if [ ${colors[0]} -lt 20000 ] && [ ${colors[1]} -lt 20000 ] && [ ${colors[2]} -lt 20000 ]; then
        echo "true"
    else
        echo "false"
    fi
}
```

Once we have a rough idea of what we're dealing with, I'll do:

```cpp
darkmode=$(isDarkMode)

# Setup some predefined colours. Note that we can't reliably determine the background 
# color of the terminal so we avoid specifically setting black or white for the foreground
# or background. You can always just use "White" and "Black" if you specifically want
# this combo, but test thoroughly
if [ "$darkmode" == "true" ]; then
    color_primary="Blue"
    color_mute="Gray"
    color_info="Yellow"
    color_success="Green"
    color_warn="DarkYellow"
    color_error="Red"
else
    color_primary="DarkBlue"
    color_mute="Gray"
    color_info="Magenta"
    color_success="DarkGreen"
    color_warn="DarkYellow"
    color_error="Red"
fi
```

and to use these:

```cpp
WriteLine "Predefined colors on default background"
WriteLine

WriteLine "Default colored text" "Default"
WriteLine "Primary colored text" $color_primary
WriteLine "Mute colored text"    $color_mute
WriteLine "Info colored text"    $color_info
WriteLine "Success colored text" $color_success
WriteLine "Warning colored text" $color_warn
WriteLine "Error colored text"   $color_error

WriteLine
WriteLine "Default color on predefined background"
WriteLine

WriteLine "Default colored background" "Default"
WriteLine "Primary colored background" "Default" $color_primary
WriteLine "Mute colored background"    "Default" $color_mute
WriteLine "Info colored background"    "Default" $color_info
WriteLine "Success colored background" "Default" $color_success
WriteLine "Warning colored background" "Default" $color_warn
WriteLine "Error colored background"   "Default" $color_error 
```

On a classic Linux terminal:

![](https://raw.githubusercontent.com/ChrisMaunder/How-to-Change-Text-Color-in-a-Linux-Terminal/master/docs/assets/color-text1.PNG)

On a macOS terminal:

![](https://raw.githubusercontent.com/ChrisMaunder/How-to-Change-Text-Color-in-a-Linux-Terminal/master/docs/assets/color-text4.PNG)

Things are a bit murky so let's add one more function that will provide a contrasting foreground on whatever background we choose.

```cpp
# Returns the name of a color that will providing a contrasting foreground
# color for the given background color. This function assumes $darkmode has
# been set globally.
#
# string background color name. 
# returns a string representing a contrasting foreground colour name
function ContrastForeground () {

    local color=$1
    if [ "$color" == "" ]; then color="Default"; fi

    if [ "$darkmode" == "true" ]; then
        case "$color" in
            "Default" )     echo "White";;
            "Black" )       echo "White";;
            "DarkRed" )     echo "White";;
            "DarkGreen" )   echo "White";;
            "DarkYellow" )  echo "White";;
            "DarkBlue" )    echo "White";;
            "DarkMagenta" ) echo "White";;
            "DarkCyan" )    echo "White";;
            "Gray" )        echo "Black";;
            "DarkGray" )    echo "White";;
            "Red" )         echo "White";;
            "Green" )       echo "White";;
            "Yellow" )      echo "Black";;
            "Blue" )        echo "White";;
            "Magenta" )     echo "White";;
            "Cyan" )        echo "Black";;
            "White" )       echo "Black";;
            *)              echo "White";;
        esac
    else
        case "$color" in
            "Default" )     echo "Black";;
            "Black" )       echo "White";;
            "DarkRed" )     echo "White";;
            "DarkGreen" )   echo "White";;
            "DarkYellow" )  echo "White";;
            "DarkBlue" )    echo "White";;
            "DarkMagenta" ) echo "White";;
            "DarkCyan" )    echo "White";;
            "Gray" )        echo "Black";;
            "DarkGray" )    echo "White";;
            "Red" )         echo "White";;
            "Green" )       echo "Black";;
            "Yellow" )      echo "Black";;
            "Blue" )        echo "White";;
            "Magenta" )     echo "White";;
            "Cyan" )        echo "Black";;
            "White" )       echo "Black";;
            *)              echo "White";;
        esac
    fi
    
    echo "${colorString}"
}
```

Then, in the `Color `subroutine, we can do:

```cpp
function Color () {

    local foreground=$1
    local background=$2

    if [ "$foreground" == "" ]; then foreground="Default"; fi
    if [ "$background" == "" ]; then background="$color_background"; fi

    if [ "$foreground" == "Contrast" ]; then
        foreground=$(ContrastForeground ${background})
    fi
    
    ...
```

and to make our text with background color a little more legible, we do:

```cpp
WriteLine
WriteLine "Default contrasting color on predefined background"
WriteLine

WriteLine "Primary colored background" "Contrast" $color_primary
WriteLine "Mute colored background"    "Contrast" $color_mute
WriteLine "Info colored background"    "Contrast" $color_info
WriteLine "Success colored background" "Contrast" $color_success
WriteLine "Warning colored background" "Contrast" $color_warn
WriteLine "Error colored background"   "Contrast" $color_error 
```

The results on a Linux terminal:

![](https://raw.githubusercontent.com/ChrisMaunder/How-to-Change-Text-Color-in-a-Linux-Terminal/master/docs/assets/default-contrast-linux.PNG)

...and on a macOS terminal:

![](https://raw.githubusercontent.com/ChrisMaunder/How-to-Change-Text-Color-in-a-Linux-Terminal/master/docs/assets/default-contrast-macos.png)
