#!/bin/bash


sleep 5


cd /home/monster/Documents/Monsters-Are-Attacking-the-City

git pull origin main

/home/monster/Documents/Godot/Godot_v4.4.1.arm64 --import --path /home/monster/Documents/Monsters-Are-Attacking-the-City/monsters-attacking/
/home/monster/Documents/Godot/Godot_v4.4.1.arm64 --path /home/monster/Documents/Monsters-Are-Attacking-the-City/monsters-attacking/
