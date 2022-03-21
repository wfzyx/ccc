#!/usr/bin/bash

rm -rf ../out
antlr4 ccc.g4 -o ../out
javac ../out/ccc*.java
