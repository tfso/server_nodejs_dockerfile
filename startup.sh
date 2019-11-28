#!/bin/bash
if [[ ! -v ArtifactUrl ]]; then
    echo "ArtifactUrl not set. Doing nothing while waiting for something."
    node -e "setTimeout(()=>{},1000 * 60 * 60 * 20)"
else
    echo "build version: $BuildVersion"
    echo "host: $host"
    echo "HOST: $HOST"
    node -e "console.log('node version:', process.version)"
    echo "Downloading artifact"

    w3m -dump_source -header "Authorization: Bearer $AppveyorToken" -header "Content-type: application/json" $ArtifactUrl > artifact.zip
    7za x -y artifact.zip >> 7za.log

    if [ -f "install.sh" ]; then
        echo "executing install.sh"
        chmod +x ./install.sh
        ./install.sh
    fi

    if [ -d "node_modules" ];
    then
        echo npm install was executed at build time
    else
        npm install --production
    fi

    exec npm-start # npm-start (bash script) supports correct SIGTTERM + correct tmpdir in nodejs    
    
fi
