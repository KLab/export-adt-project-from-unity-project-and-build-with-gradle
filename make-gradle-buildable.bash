#!/usr/bin/env bash -ex

# TODO error check

prod_name=$(ls -1 build-adt)

ln -sFv "$(pwd)/gradle/"* "build-adt/$prod_name"

echo SUCCESS
