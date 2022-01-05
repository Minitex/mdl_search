#!/usr/bin/env bash

cp -R node_modules/universalviewer/dist public/uv
rm public/uv/*.zip
cp config/uv-config.json.example public/uv/config.json
