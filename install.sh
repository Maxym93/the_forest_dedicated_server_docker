#!/bin/bash -e

USER_NAME=$(whoami)                                     # To get the username 

STEAM_PORT="8766"                                       # Steam Port to be opened and used on host OS
GAME_PORT="27015"                                       # Game Port to be opened and used on host OS
QUERY_PORT="27016"                                      # Query Port to be opened and used on host OS

##############   PLEASE EDIT ONLY HERE   #################################
##############           START           #################################
FOREST_NAME="The Forest PRIVATE SERVER"                 # Server display name
FOREST_PLAYERS="8"                                      # Maximum number of players
FOREST_VAC="off"                                        # Enable or Disable Valve AntiCheat (Better to not use it) (Default: off)
FOREST_SERVER_PASS="SERVER_PASS"                        # Password to enter the server (leave blank "" to enter without password)
FOREST_ADMIN_PASS="ADMIN_PASS"                          # Administrator password to manage players on server (leave blank "" to disable Admin on Server)
FOREST_GAME_TOKEN="STEAM_TOKEN"                         # PUT your Steam TOKEN here
SAVE_INTERVAL="30"                                      # Interval of World Saves in minutes (Default 30)
DIFFICULTY="Normal"                                     # Difficulty ( Peaceful | Normal | Hard )(Default: Normal)
INIT_TYPE="Continue"                                    # New or continue a game ( New | Continue ) (Default: Continue)
SAVE_SLOT="1"                                           # Slot to save the game ( 1 | 2 | 3 | 4 | 5 )
FOREST_LOGS="off"                                       # More output of server logs (Default: off)
ADMIN_EMAIL="E-MAIL@gmail.com"                          # Admin contact E-Mail
VEGAN_MODE="off"                                        # Set on if you want to disable enemies ( on | off ) (Default: off)
VEGATARIAN_MODE="off"                                   # Set on if you want to enable enemies only at night ( on | off ) (Default: off)
FOREST_RESET_HOLES="off"                                # Reset all existing floor holes when loading a save ( on | off ) (Default: off)
FOREST_TREE_REGROW="on"                                 # Enable Tree regrowth when sleeping ( on | off ) (Default: on)
FOREST_CREATIVE_ENEMIES="off"                           # Allow enemies in creative games ( on | off ) (Default: off)
FOREST_ALLOW_CHEATS="off"                               # To allow use cheats on Server (Default: off)
TEAM_DAMEGE="off"                                       # Realistic Player Damage ( on | off ) (Default: off)
##############           START           #################################
##############   PLEASE EDIT ONLY HERE   #################################

CONTAINER_NAME="the_forest"                             # The name of Docker Container
STEAMCMD_DIR="/srv/steamcmd"                            # SteamCMD Directory
THE_FOREST_DIR="/srv/the_forest"                        # The Forest Dedicated Server Directory
BACKUPS_DIR="/home/$USER_NAME/backups/the_forest"       # BackUPs Directory

# Create BackUP DIR
if [ ! -d $BACKUPS_DIR ]
then
    echo "--------------------------------------------------"
    echo "-------------     STEP 1 / 10       --------------"
    echo "--------------------------------------------------"
    echo "- Creating $BACKUPS_DIR dir  -"
    echo "--------------------------------------------------"
    mkdir -p $BACKUPS_DIR > /dev/null 2>&1
else
    echo "--------------------------------------------------"
    echo "-------------     STEP 1 / 10       --------------"
    echo "--------------------------------------------------"
    echo "-    $BACKUPS_DIR dir already exists    -"
    echo "--------------------------------------------------"
fi

# Create SteamCMD DIR
if [ ! -d $STEAMCMD_DIR ]
then
    echo "--------------------------------------------------"
    echo "-------------     STEP 2 / 10       --------------"
    echo "--------------------------------------------------"
    echo "--     Creating SteamCMD dir $STEAMCMD_DIR     ---"
    echo "--------------------------------------------------"
    sudo mkdir -p $STEAMCMD_DIR > /dev/null 2>&1
else
    echo "--------------------------------------------------"
    echo "-------------     STEP 2 / 10       --------------"
    echo "--------------------------------------------------"
    echo "----     $STEAMCMD_DIR dir already exists     ----"
    echo "--------------------------------------------------"
fi

# Create The Forest DIR
if [ ! -d $THE_FOREST_DIR ]
then
    echo "--------------------------------------------------"
    echo "-------------     STEP 3 / 10       --------------"
    echo "--------------------------------------------------"
    echo "-     Creating The Forest dir $THE_FOREST_DIR    -"
    echo "--------------------------------------------------"
    sudo mkdir -p $THE_FOREST_DIR > /dev/null 2>&1
else
    echo "--------------------------------------------------"
    echo "-------------     STEP 3 / 10       --------------"
    echo "--------------------------------------------------"
    echo "--     $THE_FOREST_DIR dir already exists      ---"
    echo "--------------------------------------------------"
fi

# Copy SAVES
if ([ -f ./saves/guid ] && [ ! -f $THE_FOREST_DIR/saves/Multiplayer/Slot$SAVE_SLOT/guid ])
then
    echo "--------------------------------------------------"
    echo "-------------     STEP 4 / 10       --------------"
    echo "---------------------------------------------------"
    echo "-------------     Copying Saves     ---------------"
    echo "---------------------------------------------------"
    sudo mkdir -p $THE_FOREST_DIR/saves/Multiplayer/Slot$SAVE_SLOT/ > /dev/null 2>&1
    sudo cp ./saves/* $THE_FOREST_DIR/saves/Multiplayer/Slot$SAVE_SLOT/ > /dev/null 2>&1
else
    echo "--------------------------------------------------"
    echo "-------------     STEP 4 / 10       --------------"
    echo "--------------------------------------------------"
    echo "-------     There are no SAVES to copy     -------"
    echo "--------------------------------------------------"
fi

# Open ports in UFW
if [ $(sudo ufw status | grep -o inactive) = "inactive" ]
then
    echo "--------------------------------------------------"
    echo "-------------     STEP 5 / 10       --------------"
    echo "--------------------------------------------------"
    echo "------------     UFW is disabled     -------------"
    echo "------------     NO ACTION needed     ------------"
    echo "--------------------------------------------------"
else
    echo "--------------------------------------------------"
    echo "-------------     STEP 5 / 10       --------------"
    echo "--------------------------------------------------"
    echo "------------     Adding UFW rules     ------------"
    echo "--------------------------------------------------"
    sudo ufw allow $STEAM_PORT
    sudo ufw allow $GAME_PORT
    sudo ufw allow $QUERY_PORT
fi

# Install SteamCMD
if [ ! -f $STEAMCMD_DIR/steamcmd.sh ]
then
    echo "--------------------------------------------------"
    echo "-------------     STEP 6 / 10       --------------"
    echo "--------------------------------------------------"
    echo "----------     Unpacking SteamCMD     ------------"
    echo "--------------------------------------------------"
    sudo wget -qO- http://media.steampowered.com/installer/steamcmd_linux.tar.gz | sudo tar -v -C $STEAMCMD_DIR -zx > /dev/null 2>&1
else
    echo "--------------------------------------------------"
    echo "-------------     STEP 6 / 10       --------------"
    echo "--------------------------------------------------"
    echo "-----     SteamCMD is already installed     ------"
    echo "--------------------------------------------------"
fi

# Download The Forest Server
if [ ! -f $THE_FOREST_DIR/TheForestDedicatedServer.exe ]
then
    echo "--------------------------------------------------"
    echo "-------------     STEP 7 / 10       --------------"
    echo "--------------------------------------------------"
    echo "-----     Installing The Forest Server     -------"
    echo "--------------------------------------------------"
    sudo apt-get update > /dev/null 2>&1 && sudo apt-get install -y lib32gcc1
    bash -c "sudo $STEAMCMD_DIR/steamcmd.sh +@sSteamCmdForcePlatformType windows +@ShutdownOnFailedCommand 0 +@NoPromptForPassword 1 +force_install_dir $THE_FOREST_DIR +login anonymous +app_update 556450 validate +quit"
else
    echo "--------------------------------------------------"
    echo "-------------     STEP 7 / 10       --------------"
    echo "--------------------------------------------------"
    echo "--     The Forest Server already installed     ---"
    echo "--------------------------------------------------"
fi

# Create docker image (tag the_forest:latest)
if [[ $(docker images -a | grep -o $CONTAINER_NAME | head -1) != "$CONTAINER_NAME" ]]
then
    echo "--------------------------------------------------"
    echo "-------------     STEP 8 / 10       --------------"
    echo "--------------------------------------------------"
    echo "-------     Creating $CONTAINER_NAME image     --------"
    echo "--------------------------------------------------"
    docker build -t $CONTAINER_NAME .
else
    echo "--------------------------------------------------"
    echo "-------------     STEP 8 / 10       --------------"
    echo "--------------------------------------------------"
    echo "--------     $CONTAINER_NAME already exists     -------"
    echo "--------------------------------------------------"
fi

# Create crontab to create backup and restart server
if [[ $(crontab -l | grep -o $CONTAINER_NAME | head -1) != "$CONTAINER_NAME" ]]
then
    echo "--------------------------------------------------"
    echo "-------------     STEP 9 / 10       --------------"
    echo "--------------------------------------------------"
    echo "----------     Creating CRONTAB JOB     ----------"
    echo "--------------------------------------------------"
    crontab -l > mycron
    echo "0 5 * * * sudo zip -r $BACKUPS_DIR/\$(date +\%Y_\%m_\%d__\%H_\%M_\%S).zip $THE_FOREST_DIR/saves/ && docker stop $CONTAINER_NAME && sleep 60 && docker start $CONTAINER_NAME && sudo chown -R $USER_NAME:$USER_NAME $BACKUPS_DIR/" >> mycron
    crontab mycron
    rm mycron
    sudo service cron reload > /dev/null 2>&1
else
    echo "--------------------------------------------------"
    echo "-------------     STEP 9 / 10       --------------"
    echo "--------------------------------------------------"
    echo "--------     $CONTAINER_NAME already exists     -------"
    echo "--------------------------------------------------"
fi


# Start The Forest Server in Docker
if [[ $(docker ps -a | grep -o $CONTAINER_NAME | head -1) != "$CONTAINER_NAME" ]]
then
    echo "--------------------------------------------------"
    echo "-------------     STEP 10 / 10       -------------"
    echo "--------------------------------------------------"
    echo "-----     Starting $CONTAINER_NAME container     ------"
    echo "--------------------------------------------------"
    docker run -d --restart=always \
        -v $THE_FOREST_DIR:/the_forest \
        -e FOREST_NAME="$FOREST_NAME" \
        -e FOREST_PLAYERS="$FOREST_PLAYERS" \
        -e FOREST_VAC="$FOREST_VAC" \
        -e FOREST_SERVER_PASS="$FOREST_SERVER_PASS" \
        -e FOREST_ADMIN_PASS="$FOREST_ADMIN_PASS" \
        -e FOREST_GAME_TOKEN="$FOREST_GAME_TOKEN" \
        -e SAVE_INTERVAL="$SAVE_INTERVAL" \
        -e DIFFICULTY="$DIFFICULTY" \
        -e INIT_TYPE="$INIT_TYPE" \
        -e SAVE_SLOT="$SAVE_SLOT" \
        -e FOREST_LOGS="$FOREST_LOGS" \
        -e ADMIN_EMAIL="$ADMIN_EMAIL" \
        -e VEGAN_MODE="$VEGAN_MODE" \
        -e VEGATARIAN_MODE="$VEGATARIAN_MODE" \
        -e FOREST_RESET_HOLES="$FOREST_RESET_HOLES" \
        -e FOREST_TREE_REGROW="$FOREST_TREE_REGROW" \
        -e FOREST_CREATIVE_ENEMIES="$FOREST_CREATIVE_ENEMIES" \
        -e FOREST_ALLOW_CHEATS="$FOREST_ALLOW_CHEATS" \
        -e TEAM_DAMEGE="$TEAM_DAME" \
        -p $STEAM_PORT:8766/tcp -p $STEAM_PORT:8766/udp \
        -p $GAME_PORT:27015/tcp -p $GAME_PORT:27015/udp \
        -p $QUERY_PORT:27016/tcp -p $QUERY_PORT:27016/udp \
    --name $CONTAINER_NAME $CONTAINER_NAME:latest
else
    echo "--------------------------------------------------"
    echo "------------     STEP 10 / 10       --------------"
    echo "--------------------------------------------------"
    echo "--   Container $CONTAINER_NAME is already running    --"
    echo "--------------------------------------------------"
fi