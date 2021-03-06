FROM ubuntu:precise
MAINTAINER Jake Skeates <mail@jake.tf>

RUN apt-get -y update && apt-get -y upgrade && apt-get -y install lib32gcc1 lib32z1 lib32ncurses5 lib32bz2-1.0 lib32asound2 wget && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV USER tf2

RUN useradd -rm $USER

USER $USER
ENV SERVER /home/$USER/hlserver
RUN mkdir $SERVER
RUN wget -O - http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $SERVER -xvz
ADD ./tf2_ds.txt $SERVER/tf2_ds.txt
ADD ./update.sh $SERVER/update.sh
ADD ./tf.sh $SERVER/tf.sh
RUN $SERVER/update.sh

EXPOSE 27015/udp

WORKDIR /home/$USER/hlserver
ENTRYPOINT ["./tf.sh"]
CMD ["+sv_pure", "1", "+mapcycle", "mapcycle_quickplay_payload.txt", "+map", "pl_badwater", "+maxplayers", "24"]
