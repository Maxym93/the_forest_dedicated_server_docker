FROM ubuntu:18.04

ENV THE_FOREST_DIR="/the_forest" \
    FOREST_NAME="The Forest PRIVATE SERVER" \
    FOREST_PLAYERS="8" \
    FOREST_SERVER_PASS="" \
    FOREST_ADMIN_PASS="" \
    FOREST_GAME_TOKEN="" \
    SAVE_INTERVAL="30" \
    DIFFICULTY="Normal" \
    INIT_TYPE="Continue" \
    SAVE_SLOT="1" \
    ADMIN_EMAIL="E-MAIL@gmail.com" \
    VEGAN_MODE="off" \
    VEGATARIAN_MODE="off" \
    FOREST_RESET_HOLES="off" \
    FOREST_TREE_REGROW="on" \
    FOREST_CREATIVE_ENEMIES="off" \
    TEAM_DAMEGE="off"

EXPOSE 8766/tcp 8766/udp 27015/tcp 27015/udp 27016/tcp 27016/udp

VOLUME ["/the_forest"]

COPY ./start_server.sh /

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests wget wine-stable lib32gcc1 net-tools winbind xvfb && \
	mkdir -p $THE_FOREST_DIR && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    chmod +x /start_server.sh

CMD ["./start_server.sh"]