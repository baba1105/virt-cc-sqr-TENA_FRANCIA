FROM debian:latest

# Installation de bash, htop, vim et net-tools
RUN apt-get update && apt-get install bash htop vim net-tools -y 

# Creation d'une variable d'environnement 
ENV OWNER=Baptiste 

# Permet de garder le conteneur en vie pour pouvoir se connecter dessus
CMD ["sleep", "3600"]

#Pour build le conteneur : docker build . -t toolbox
#Pour lancer le conteneur : sudo docker run --name toolbox-ctn toolbox
#Pour se connecter au conteneur : docker exec -it toolbox-ctn /bin/bash