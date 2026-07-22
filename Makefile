GODOT_PATH := godot


all: linux

linux:
	mkdir -p build/linux; $(GODOT_PATH) --headless --export-release Linux "build/linux/SV Mod Loader Example Game.x86_64"
