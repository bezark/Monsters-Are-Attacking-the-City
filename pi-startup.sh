#!/bin/bash
sleep 5
cd /home/monster/Documents/Monsters-Are-Attacking-the-City

# Force repository to match remote exactly (but don't fail if no internet)
git fetch origin || true
git reset --hard origin/main || true
git clean -fd || true

# These will always run regardless of git success/failure
/home/monster/Documents/Godot/Godot_v4.4.1.arm64 --import --path /home/monster/Documents/Monsters-Are-Attacking-the-City/monsters-attacking/
/home/monster/Documents/Godot/Godot_v4.4.1.arm64 --path /home/monster/Documents/Monsters-Are-Attacking-the-City/monsters-attacking/
