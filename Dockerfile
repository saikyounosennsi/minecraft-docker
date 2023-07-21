FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]
RUN set -x && \
		apt update && \
		apt upgrade -y && \
		apt install -y wget openjdk-18-jre
WORKDIR /opt/minecraft
RUN set -x && \
		wget -O server.jar -o /dev/null 'https://download.getbukkit.org/spigot/spigot-1.20.1.jar' && \
		echo eula=true > eula.txt && \
		echo stop | java -Xms1024M -Xmx1024M -jar server.jar
RUN wget -O plugins/geysermc.jar -o /dev/null 'https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot' && \
		wget -O plugins/floodgate.jar -o /dev/null 'https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot' && \
		echo stop | java -Xms1024M -Xmx1024M -jar server.jar && \
		cat plugins/Geyser-Spigot/config.yml | sed -e "s/auth-type: online/auth-type: floodgate/g" | tee plugins/Geyser-Spigot/config.yml && \
		cat server.properties | sed -e "s/enforce-secure-profile=true/enforce-secure-profile=false/g" | tee server.properties
#ops setting 
#RUN echo -e '[\n	{\n		"uuid": "<op権限を与えたいユーザーのUUIDを入力>",\n		"name": "<管理者権限を与えたいユーザーの名前を入力>",\n		"level": 4,\n		"bypassesPlayerLimit": true\n	}\n]' | tee ops.json

EXPOSE 25565/tcp
EXPOSE 19132/udp
CMD ["java","-Xms1024M","-Xmx1024M","-jar","server.jar"]

