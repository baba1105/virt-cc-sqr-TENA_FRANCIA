# Image de base : Nginx
FROM nginx:latest

# Copie nos fichiers HTML et CSS dans le conteneur
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/

# Expose le port 80 pour le serveur web
EXPOSE 80

# Pour build le conteneur : docker build . -t mon-frontend
# Pour lancer le conteneur : docker run -p 8080:80 mon-frontend