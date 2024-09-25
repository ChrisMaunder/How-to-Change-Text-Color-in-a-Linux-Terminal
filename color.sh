#!/bin/bash
#
# Example of outputting coloured text


# Sub Routines :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# Returns a color code for the given foreground/background colors
# This code is echoed to the terminal before outputing text in
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

    if [ "$foreground" == "" ]; then foreground="Default"; fi
    if [ "$background" == "" ]; then background="$color_background"; fi

    if [ "$foreground" == "Contrast" ]; then
	    foreground=$(ContrastForeground ${background})
	fi
	
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



useColor="true"
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

clear

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

WriteLine
WriteLine "Default contrasting color on predefined background"
WriteLine

WriteLine "Primary colored background" "Contrast" $color_primary
WriteLine "Mute colored background"    "Contrast" $color_mute
WriteLine "Info colored background"    "Contrast" $color_info
WriteLine "Success colored background" "Contrast" $color_success
WriteLine "Warning colored background" "Contrast" $color_warn
WriteLine "Error colored background"   "Contrast" $color_error

WriteLine
WriteLine "Each color on the default background"
WriteLine


WriteLine "Default foreground"     "Default"
WriteLine "Black foreground"       "Black"
WriteLine "DarkRed foreground"     "DarkRed"
WriteLine "DarkGreen foreground"   "DarkGreen"
WriteLine "DarkYellow foreground"  "DarkYellow"
WriteLine "DarkBlue foreground"    "DarkBlue"
WriteLine "DarkMagenta foreground" "DarkMagenta"
WriteLine "DarkCyan foreground"    "DarkCyan"
WriteLine "Gray foreground"        "Gray"
WriteLine "DarkGray foreground"    "DarkGray"
WriteLine "Red foreground"         "Red"
WriteLine "Green foreground"       "Green"
WriteLine "Yellow foreground"      "Yellow"
WriteLine "Blue foreground"        "Blue"
WriteLine "Magenta foreground"     "Magenta"
WriteLine "Cyan foreground"        "Cyan"
WriteLine "White foreground"       "White"

WriteLine
WriteLine "Default contrasting color on each background"
WriteLine


WriteLine "Default background"     $(ContrastForeground "Default")     "Default"
WriteLine "Black background"       $(ContrastForeground "Black")       "Black"
WriteLine "DarkRed background"     $(ContrastForeground "DarkRed")     "DarkRed"
WriteLine "DarkGreen background"   $(ContrastForeground "DarkGreen")   "DarkGreen"
WriteLine "DarkYellow background"  $(ContrastForeground "DarkYellow")  "DarkYellow"
WriteLine "DarkBlue background"    $(ContrastForeground "DarkBlue")    "DarkBlue"
WriteLine "DarkMagenta background" $(ContrastForeground "DarkMagenta") "DarkMagenta"
WriteLine "DarkCyan background"    $(ContrastForeground "DarkCyan")    "DarkCyan"
WriteLine "Gray background"        $(ContrastForeground "Gray")        "Gray"
WriteLine "DarkGray background"    $(ContrastForeground "DarkGray")    "DarkGray"
WriteLine "Red background"         $(ContrastForeground "Red")         "Red"
WriteLine "Green background"       $(ContrastForeground "Green")       "Green"
WriteLine "Yellow background"      $(ContrastForeground "Yellow")      "Yellow"
WriteLine "Blue background"        $(ContrastForeground "Blue")        "Blue"
WriteLine "Magenta background"     $(ContrastForeground "Magenta")     "Magenta"
WriteLine "Cyan background"        $(ContrastForeground "Cyan")        "Cyan"
WriteLine "White background"       $(ContrastForeground "White")       "White"

WriteLine
WriteLine

WriteLine "Setting up the CodeProject.SenseAI Development Environment              " "$color_info"
WriteLine "                                                                        " "Default" $color_mute
WriteLine "========================================================================" "Black"   $color_mute
WriteLine "                                                                        " "Black"   $color_mute
WriteLine "                 CodeProject SenseAI Installer                          " $color_primary $color_mute
WriteLine "                                                                        " "Black"   $color_mute
WriteLine "========================================================================" "Black"   $color_mute
WriteLine "                                                                        " "Default" $color_mute

