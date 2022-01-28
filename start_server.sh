#!/bin/bash

IP_ADDR=$(ifconfig | grep -oE -m 1 "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)

echo -e "serverIP $IP_ADDR
serverSteamPort 8766
serverGamePort 27015
serverQueryPort 27016
serverName $FOREST_NAME
serverPlayers $FOREST_PLAYERS
enableVAC off
serverPassword $FOREST_SERVER_PASS
serverPasswordAdmin $FOREST_ADMIN_PASS
serverSteamAccount $FOREST_GAME_TOKEN
serverAutoSaveInterval $SAVE_INTERVAL
difficulty $DIFFICULTY
initType $INIT_TYPE
slot $SAVE_SLOT
showLogs off
serverContact $ADMIN_EMAIL
veganMode $VEGAN_MODE
vegetarianMode $VEGATARIAN_MODE
resetHolesMode $FOREST_RESET_HOLES
treeRegrowMode $FOREST_TREE_REGROW
allowBuildingDestruction $FOREST_BUILDING_DESTR
allowEnemiesCreativeMode $FOREST_CREATIVE_ENEMIES
allowCheats off
realisticPlayerDamage $TEAM_DAMEGE
saveFolderPath 
targetFpsIdle 5
targetFpsActive 0" > $THE_FOREST_DIR/server.cfg

xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine $THE_FOREST_DIR/TheForestDedicatedServer.exe -batchmode -dedicated -nographics -nosteamclient -savefolderpath "$THE_FOREST_DIR/saves/" -configfilepath "$THE_FOREST_DIR/server.cfg"