#!/bin/bash
set -e
for d in ./apps/*; do cd $d; echo $(basename $d); echo; mix test; echo; cd ../..; done
