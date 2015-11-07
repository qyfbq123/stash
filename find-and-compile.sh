#! /bin/bash

find . -maxdepth 5 -mindepth 1 -type f -name "*.coffee" -exec coffee -c {} \;
find . -maxdepth 5 -mindepth 1 -type f -name "*.jade" -exec jade {} \;
