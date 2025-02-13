; see constants/player_constants.asm

DefaultNamesPlayer:
	db "NEW NAME"
FOR n, 1, NUM_PLAYER_NAMES + 1
	next #PLAYERNAME{d:n}
ENDR
	db "@"

DefaultNamesGreen:
	db "NEW NAME"
FOR n, 1, NUM_PLAYER_NAMES + 1
	next #GREENNAME{d:n}
ENDR
	db "@"

DefaultNamesYellow:
	db "NEW NAME"
FOR n, 1, NUM_PLAYER_NAMES + 1
	next #YELLOWNAME{d:n}
ENDR
	db "@"

DefaultNamesRival:
	db "NEW NAME"
FOR n, 1, NUM_PLAYER_NAMES + 1
	next #RIVALNAME{d:n}
ENDR
	db "@"
