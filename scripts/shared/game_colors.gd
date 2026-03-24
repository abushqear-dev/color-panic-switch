# This makes the script globally accessible by the name GameColors.
# That means other scripts can use GameColors.COLORS without manually loading the file.
class_name GameColors
extends RefCounted

# A shared list of allowed colors in the game.
# We keep this in one place so both the catcher and falling items use the same colors.
const COLORS: Array[Color] = [
	Color.RED,
	Color.GREEN,
	Color.BLUE
]
