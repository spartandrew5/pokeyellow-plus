IsStarterPikachuAliveInOurParty::
	ld hl, wPartySpecies
	ld de, wPartyMon1OTID
	ld bc, wPartyMonOT
	push hl
.loop
	pop hl
	ld a, [hli]
	push hl
	inc a
	jr z, .noPlayerPikachu
	cp STARTER_PIKACHU + 1
	jr nz, .curMonNotPlayerPikachu
	ld h, d
	ld l, e
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .curMonNotPlayerPikachu
	inc hl
	ld a, [wPlayerID+1]
	cp [hl]
	jr nz, .curMonNotPlayerPikachu

	push de
	push bc
	ld hl, wPlayerName
	ld d, NAME_LENGTH_JP
.nameCompareLoop
	dec d
	jr z, .sameOT
	ld a, [bc]
	inc bc
	cp [hl]
	inc hl
	jr z, .nameCompareLoop
	pop bc
	pop de

.curMonNotPlayerPikachu
	ld hl, wPartyMon2 - wPartyMon1
	add hl, de
	ld d, h
	ld e, l
	ld hl, NAME_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	jr .loop

.sameOT
	pop bc
	pop de
	ld h, d
	ld l, e
	ld bc, wPartyMon1HP - wPartyMon1OTID
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .noPlayerPikachu ; fainted Starter Pikachu
	pop hl
	scf
	ret

.noPlayerPikachu
	pop hl
	and a
	ret

IsThisBoxMonStarterPikachu::
	ld hl, wBoxMon1
	ld bc, wBoxMon2 - wBoxMon1
	ld de, wBoxMonOT
	jr IsThisMonStarterPikachu

IsThisPartyMonStarterPikachu::
	ld hl, wPartyMon1
	ld bc, wPartyMon2 - wPartyMon1
	ld de, wPartyMonOT
IsThisMonStarterPikachu:
	ld a, [wWhichPokemon]
	call AddNTimes
	ld a, [hl]
	cp STARTER_PIKACHU
	jr z, .checkOT
	cp RAICHU ; also accept Raichu as partner
	jr nz, .notPlayerPikachu
.checkOT
	ld bc, wPartyMon1OTID - wPartyMon1
	add hl, bc
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .notPlayerPikachu
	inc hl
	ld a, [wPlayerID+1]
	cp [hl]
	jr nz, .notPlayerPikachu
	ld h, d
	ld l, e
	ld a, [wWhichPokemon]
	ld bc, NAME_LENGTH
	call AddNTimes
	ld de, wPlayerName
	ld b, NAME_LENGTH_JP
.loop
	dec b
	jr z, .isPlayerPikachu
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr z, .loop
.notPlayerPikachu
	and a
	ret

.isPlayerPikachu
	scf
	ret

UpdatePikachuMoodAfterBattle::
; because d is always $82 at this function, it serves to
; ensure Pikachu's mood is at least 130 after battle
	push de
	call IsStarterPikachuAliveInOurParty
	pop de
	ret nc
	ld a, d
	cp 128
	ld a, [wPikachuMood]
	jr c, .d_less_than_128 ; we never jump
	cp d
	jr c, .load_d_into_mood
	ret

.d_less_than_128
	cp d
	ret c
.load_d_into_mood
	ld a, d
	ld [wPikachuMood], a
	ret

CheckPikachuStatusCondition::
; set carry flag if Starter Pikachu has a status condition
; also return d = 0 if fainted, but no function uses it
	xor a
	ld [wWhichPokemon], a
	ld hl, wPartyCount
.loop
	inc hl
	ld a, [hl]
	cp $ff
	jr z, .noAilment
	push hl
	call IsThisPartyMonStarterPikachu
	pop hl
	jr nc, .next
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hli]
	or [hl]
	ld d, a
	inc hl
	inc hl
	ld a, [hl] ; status
	and a
	jr nz, .hasAilment
	jr .noAilment

.next
	ld a, [wWhichPokemon]
	inc a
	ld [wWhichPokemon], a
	jr .loop

.hasAilment
	scf
	ret

.noAilment
	and a
	ret

IsSurfingStarterPikachuInParty::
	ld hl, wPartySpecies
	ld de, wPartyMon1Moves
	ld bc, wPartyMonOT
	push hl
.loop
	pop hl
	ld a, [hli]
	push hl
	inc a
	jr z, .noSurfingPlayerPikachu
	cp STARTER_PIKACHU + 1
	jr nz, .curMonNotSurfingPlayerPikachu
	ld h, d
	ld l, e
	push hl
	push bc
	ld b, NUM_MOVES
.moveSearchLoop
	ld a, [hli]
	cp SURF
	jr z, .foundSurfingPikachu
	dec b
	jr nz, .moveSearchLoop
	pop bc
	pop hl
	jr .curMonNotSurfingPlayerPikachu

.foundSurfingPikachu
	pop bc
	pop hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .curMonNotSurfingPlayerPikachu
	inc hl
	ld a, [wPlayerID+1]
	cp [hl]
	jr nz, .curMonNotSurfingPlayerPikachu
	push de
	push bc
	ld hl, wPlayerName
	ld d, NAME_LENGTH_JP
.nameCompareLoop
	dec d
	jr z, .foundSurfingPlayerPikachu
	ld a, [bc]
	inc bc
	cp [hl]
	inc hl
	jr z, .nameCompareLoop
	pop bc
	pop de
.curMonNotSurfingPlayerPikachu
	ld hl, wPartyMon2 - wPartyMon1
	add hl, de
	ld d, h
	ld e, l
	ld hl, NAME_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	jr .loop

.foundSurfingPlayerPikachu
	pop bc
	pop de
	pop hl
	scf
	ret

.noSurfingPlayerPikachu
	pop hl
	and a
	ret


LoadFollowerSpriteBasedOnParty::
; Load follower sprite based on first party Pokemon
; Uses a lookup table to map Pokemon ID -> Sprite ID
	ld hl, wPartySpecies
	ld a, [hl]
	cp $FF
	ret z ; no party
	
	; Look up the sprite ID for this Pokemon
	ld b, a ; b = Pokemon ID we're looking for
	ld hl, PokemonToSpriteTable
.lookupLoop
	ld a, [hli] ; a = table entry Pokemon ID
	cp $FF ; end of table?
	jr z, .useDefaultSprite
	cp b ; does this entry match our Pokemon?
	jr z, .foundMatch
	inc hl ; skip the sprite ID byte
	jr .lookupLoop
	
.foundMatch
	ld a, [hl] ; load the sprite ID from table
	ld [wSpriteSet], a
	ret
	
.useDefaultSprite
	ld a, SPRITE_BASE_MON
	ld [wSpriteSet], a
	ret

PokemonToSpriteTable:
; Table mapping Pokemon ID to Sprite ID
; Format: db POKEMON_ID, SPRITE_ID
; Terminated with $FF
	db PIKACHU, SPRITE_PIKACHU
	db RAICHU, SPRITE_RAICHU
	db BULBASAUR, SPRITE_BULBASAUR
	db IVYSAUR, SPRITE_IVYSAUR
	db VENUSAUR, SPRITE_VENUSAUR
	db CHARMANDER, SPRITE_CHARMANDER
	db CHARMELEON, SPRITE_CHARMELEON
	db CHARIZARD, SPRITE_CHARIZARD
	db SQUIRTLE, SPRITE_SQUIRTLE
	db WARTORTLE, SPRITE_WARTORTLE
	db BLASTOISE, SPRITE_BLASTOISE
	db PIDGEY, SPRITE_PIDGEY
	db PIDGEOTTO, SPRITE_PIDGEOTTO
	db PIDGEOT, SPRITE_PIDGEOT
	db CATERPIE, SPRITE_CATERPIE
	db METAPOD, SPRITE_METAPOD
	db BUTTERFREE, SPRITE_BUTTERFREE
	db WEEDLE, SPRITE_WEEDLE
	db KAKUNA, SPRITE_KAKUNA
	db BEEDRILL, SPRITE_BEEDRILL
	db RATTATA, SPRITE_RATTATA
	db RATICATE, SPRITE_RATICATE
	db SPEAROW, SPRITE_SPEAROW
	db FEAROW, SPRITE_FEAROW
	db EKANS, SPRITE_EKANS
	db ARBOK, SPRITE_ARBOK
	db SANDSHREW, SPRITE_SANDSHREW
	db SANDSLASH, SPRITE_SANDSLASH
	db NIDORAN_F, SPRITE_NIDORAN_F
	db NIDORINA, SPRITE_NIDORINA
	db NIDOQUEEN, SPRITE_NIDOQUEEN
	db NIDORAN_M, SPRITE_NIDORAN_M
	db NIDORINO, SPRITE_NIDORINO
	db NIDOKING, SPRITE_NIDOKING
	db CLEFAIRY, SPRITE_CLEFAIRY
	db CLEFABLE, SPRITE_CLEFABLE
	db VULPIX, SPRITE_VULPIX
	db NINETALES, SPRITE_NINETALES
	db JIGGLYPUFF, SPRITE_JIGGLYPUFF
	db WIGGLYTUFF, SPRITE_WIGGLYTUFF
	db ZUBAT, SPRITE_ZUBAT
	db GOLBAT, SPRITE_GOLBAT
	db ODDISH, SPRITE_ODDISH
	db GLOOM, SPRITE_GLOOM
	db VILEPLUME, SPRITE_VILEPLUME
	db PARAS, SPRITE_PARAS
	db PARASECT, SPRITE_PARASECT
	db VENONAT, SPRITE_VENONAT
	db VENOMOTH, SPRITE_VENOMOTH
	db DIGLETT, SPRITE_DIGLETT
	db DUGTRIO, SPRITE_DUGTRIO
	db MEOWTH, SPRITE_MEOWTH
	db PERSIAN, SPRITE_PERSIAN
	db PSYDUCK, SPRITE_PSYDUCK
	db GOLDUCK, SPRITE_GOLDUCK
	db MANKEY, SPRITE_MANKEY
	db PRIMEAPE, SPRITE_PRIMEAPE
	db GROWLITHE, SPRITE_GROWLITHE
	db ARCANINE, SPRITE_ARCANINE
	db POLIWAG, SPRITE_POLIWAG
	db POLIWHIRL, SPRITE_POLIWHIRL
	db POLIWRATH, SPRITE_POLIWRATH
	db ABRA, SPRITE_ABRA
	db KADABRA, SPRITE_KADABRA
	db ALAKAZAM, SPRITE_ALAKAZAM
	db MACHOP, SPRITE_MACHOP
	db MACHOKE, SPRITE_MACHOKE
	db MACHAMP, SPRITE_MACHAMP
	db BELLSPROUT, SPRITE_BELLSPROUT
	db WEEPINBELL, SPRITE_WEEPINBELL
	db VICTREEBEL, SPRITE_VICTREEBEL
	db TENTACOOL, SPRITE_TENTACOOL
	db TENTACRUEL, SPRITE_TENTACRUEL
	db GEODUDE, SPRITE_GEODUDE
	db GRAVELER, SPRITE_GRAVELER
	db GOLEM, SPRITE_GOLEM
	db PONYTA, SPRITE_PONYTA
	db RAPIDASH, SPRITE_RAPIDASH
	db SLOWPOKE, SPRITE_SLOWPOKE
	db SLOWBRO, SPRITE_SLOWBRO
	db MAGNEMITE, SPRITE_MAGNEMITE
	db MAGNETON, SPRITE_MAGNETON
	db FARFETCHD, SPRITE_FARFETCHD
	db DODUO, SPRITE_DODUO
	db DODRIO, SPRITE_DODRIO
	db SEEL, SPRITE_SEEL
	db DEWGONG, SPRITE_DEWGONG
	db GRIMER, SPRITE_GRIMER
	db MUK, SPRITE_MUK
	db SHELLDER, SPRITE_SHELLDER
	db CLOYSTER, SPRITE_CLOYSTER
	db GASTLY, SPRITE_GASTLY
	db HAUNTER, SPRITE_HAUNTER
	db GENGAR, SPRITE_GENGAR
	db ONIX, SPRITE_ONIX
	db DROWZEE, SPRITE_DROWZEE
	db HYPNO, SPRITE_HYPNO
	db KRABBY, SPRITE_KRABBY
	db KINGLER, SPRITE_KINGLER
	db VOLTORB, SPRITE_VOLTORB
	db ELECTRODE, SPRITE_ELECTRODE
	db EXEGGCUTE, SPRITE_EXEGGCUTE
	db EXEGGUTOR, SPRITE_EXEGGUTOR
	db CUBONE, SPRITE_CUBONE
	db MAROWAK, SPRITE_MAROWAK
	db HITMONLEE, SPRITE_HITMONLEE
	db HITMONCHAN, SPRITE_HITMONCHAN
	db LICKITUNG, SPRITE_LICKITUNG
	db KOFFING, SPRITE_KOFFING
	db WEEZING, SPRITE_WEEZING
	db RHYHORN, SPRITE_RHYHORN
	db RHYDON, SPRITE_RHYDON
	db CHANSEY, SPRITE_CHANSEY
	db TANGELA, SPRITE_TANGELA
	db KANGASKHAN, SPRITE_KANGASKHAN
	db HORSEA, SPRITE_HORSEA
	db SEADRA, SPRITE_SEADRA
	db GOLDEEN, SPRITE_GOLDEEN
	db SEAKING, SPRITE_SEAKING
	db STARYU, SPRITE_STARYU
	db STARMIE, SPRITE_STARMIE
	db MR_MIME, SPRITE_MR_MIME
	db SCYTHER, SPRITE_SCYTHER
	db JYNX, SPRITE_JYNX
	db ELECTABUZZ, SPRITE_ELECTABUZZ
	db MAGMAR, SPRITE_MAGMAR
	db PINSIR, SPRITE_PINSIR
	db TAUROS, SPRITE_TAUROS
	db MAGIKARP, SPRITE_MAGIKARP
	db GYARADOS, SPRITE_GYARADOS
	db LAPRAS, SPRITE_LAPRAS
	db DITTO, SPRITE_DITTO
	db EEVEE, SPRITE_EEVEE
	db VAPOREON, SPRITE_VAPOREON
	db JOLTEON, SPRITE_JOLTEON
	db FLAREON, SPRITE_FLAREON
	db PORYGON, SPRITE_PORYGON
	db OMANYTE, SPRITE_OMANYTE
	db OMASTAR, SPRITE_OMASTAR
	db KABUTO, SPRITE_KABUTO
	db KABUTOPS, SPRITE_KABUTOPS
	db AERODACTYL, SPRITE_AERODACTYL
	db SNORLAX, SPRITE_SNORLAX
	db ARTICUNO, SPRITE_ARTICUNO
	db ZAPDOS, SPRITE_ZAPDOS
	db MOLTRES, SPRITE_MOLTRES
	db DRATINI, SPRITE_DRATINI
	db DRAGONAIR, SPRITE_DRAGONAIR
	db DRAGONITE, SPRITE_DRAGONITE
	db MEWTWO, SPRITE_MEWTWO
	db MEW, SPRITE_MEW
	db $FF ; end of table