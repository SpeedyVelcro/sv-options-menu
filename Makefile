GODOT_PATH := godot
MOD_DIRECTORY := ${HOME}/.local/share/godot/app_userdata/SV Mod Loader/mods



all: linux

linux:
	mkdir -p build/linux; $(GODOT_PATH) --headless --export-release Linux "build/linux/SV Mod Loader Example Game.x86_64"
