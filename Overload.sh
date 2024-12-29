#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

# Variables
WINEDIR=/$controlfolder/runtimes/wine64/bin
GAMEDIR=/$directory/ports/overload

# CD and set permissions
cd $GAMEDIR
> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1
$ESUDO chmod +x -R $GAMEDIR/*

# Display loading splash
[ "$CFW_NAME" == "muOS" ] && $ESUDO $GAMEDIR/splash "splash.png" 1
$ESUDO $GAMEDIR/splash "splash.png" 30000 & 

# Exports
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
export WINEPREFIX=/storage/.wine64
export WINEDEBUG=-all

# Config Setup
mkdir -p $GAMEDIR/config
bind_directories "$WINEPREFIX/drive_c/users/root/AppData/LocalLow/Revival/Overload" "$GAMEDIR/config"

# Run the game
$GPTOKEYB "Overload.exe" -c "./overload.gptk" &
$WINEDIR/box64 $WINEDIR/wine64 "./data/Overload.exe"

# Kill processes
pm_finish