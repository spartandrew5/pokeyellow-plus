RespawnOverworldPikachu:
	; Check if player has any Pokemon
	ld a, [wPartyCount]
	and a
	ret z ; no party
	ld a, $3
	ld [wPikachuSpawnState], a
	ret
