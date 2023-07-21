FROM ubuntu:22.04
RUN set -x && \
		apt update && \
		apt upgrade -y && \
		apt install -y wget openjdk-18-jre
WORKDIR /opt/minecraft
RUN set -x && \
		wget -O server.jar -o /dev/null 'https://download.getbukkit.org/spigot/spigot-1.20.1.jar' && \
		echo eula=true > eula.txt && \
		echo stop | java -Xms1024M -Xmx1024M -jar server.jar && \
		wget -O plugins/geysermc.jar -o /dev/null 'https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot' & \
		wget -O plugins/floodgate.jar -o /dev/null 'https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot' & \
		wait && \
		if [[ ! -e plugins/geysermc.jar && ! -e plugins/floodgate.jar ]]; then echo '========Download fail========' >&2 ; exit 1 ; fi && \
		echo stop | java -Xms1024M -Xmx1024M -jar server.jar && \
		cat plugins/Geyser-Spigot/config.yml | sed -e "s/auth-type: online/auth-type: floodgate/g" | tee plugins/Geyser-Spigot/config.yml
VOLUME ["/opt/minecraft/world","/opt/minecraft/world_nether","/opt/minecraft/world_the_end"]
EXPOSE 25565/tcp
EXPOSE 19132/udp
CMD ["java","-Xms1024M","-Xmx1024","-jar","server.jar"]

