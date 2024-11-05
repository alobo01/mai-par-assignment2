# First time:

docker run -h julia-container1 --name julia -p 8887:8887 -v //c/Users/Usuario/OneDrive/Documentos/PAR/PAR2/julia:/home/jovyan -e JUPYTER_PORT=8887 --cpus=2 --memory-reservation=1024m --memory=16384m -d jupyter/julia-notebook

# From second on:

docker start julia

# To get the token:

docker logs julia 2>&1 | select-string -pattern "http://.*\?token" | Select-Object -Last 2 | Select-Object -First 2