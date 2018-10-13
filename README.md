## Install Instructions

#### Dependencies:
* [ShipScriptLoader](https://github.com/dirtyredz/ShipScriptLoader)
..* Follow steps 1 & 2

1. Make sure ShipScriptLoader is installed
2. Copy files to Avorion install directory
3. Open Avorion/mods/ShipScriptLoader/config/ShipScriptLoader.lua in your favorite text editor (notepad, sublime-text etc..)
4. Add the following lines of code before the line `return Config`
..* `Config.Add("mods/TF_TargetView/scripts/entity/tf_targetview.lua")`
