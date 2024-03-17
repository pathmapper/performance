#### GeoServer starten
`docker run --mount type=bind,src=/home/geoserver,target=/opt/geoserver_data -it -p8080:8080 --env INSTALL_EXTENSIONS=true --env COMMUNITY_EXTENSIONS="ogcapi-features" docker.osgeo.org/geoserver:2.24.x`
