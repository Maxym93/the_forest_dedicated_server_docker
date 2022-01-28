The Forest Dedicated Server (docker) installation script. (Tested on Ubuntu 18.04 LTS)

!!! Before executing this script (./install.sh) you need to do few steps. !!!

1. Install Docker Engine on your host OS (Ubuntu 18.04 LTS). - https://docs.docker.com/engine/install/ubuntu/
2. Create a new game server TOKEN here - https://steamcommunity.com/dev/managegameservers ( AppID: 242760 )
3. Clone this repo - git clone https://github.com/Maxym93/the_forest_dedicated_server_docker.git
4. Copy your Saves Files into ./saves/ dir if such exist. (Files: __RESUME__, guid, info) - (If you don't have Saves - no worries, script will skip this step) 
5. Execute command - chmod +x install.sh
6. Edit VARIABLES in install.sh as you need. FOREST_NAME="", FOREST_PLAYERS="", FOREST_GAME_TOKEN="", etc...
7. Run script WITHOUT sudo. (./install.sh)

P.S. Some of commands in script need "sudo" access. So you'll need to enter your password.