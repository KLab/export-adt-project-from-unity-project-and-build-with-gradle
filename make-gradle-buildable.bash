#!/usr/bin/env bash -ex

# TODO error check

prod_name=$(ls -1 build-adt)

rsync -avr -delete gradle/ "build-adt/$prod_name/"

echo SUCCESS
