#!/bin/bash
ACTIVE=$(who | grep "pts" | wc -l)
echo $ACTIVE
