# Pokémon Yellow Plus

This is a fork of the [Pokémon Yellow disassembly](https://github.com/pret/pokeyellow) at [PRET](https://github.com/pret).

This fork adds new features while maintaining compatibility with the base game. It doesn't modify core save data structures unnecessarily.

## Branches

There are several branches, each with different features:

**qol-features** branch:
* 3-option character selection (Red, Green, Yellow player sprites)
* Running shoes with updated sprites
* Updated surf sprites
* Reuse Repel
* Infinite text speed option
* Up/Down selection on Pokemon Summary Screen
* Item descriptions and sort in bag
* Can't deposit HMs
* Trade Pokemon evolve at Lv. 44
* Can evolve starter Pikachu 


**following-pokemon** branch:
* All Pokemon now follow behind player, not just Pikachu
* Updated NPC Overworld Pokemon sprites, replacing generic
* Expanded ROM size to fit all Pokemon following sprites
* Vanilla Yellow otherwise

**master** branch:
* Combination of above branches

<img src="https://i.imgur.com/TPF9qx1.gif" width="50%" />


## Planned Features
* Difficulty selection.
* Add ability to get all 151 mons and maybe a custom Mew event.
* EXP bar.
* Interaction with non-Pikachu mons. 

## Known Bugs
* Some NPC Overworld Pokemon do not face movement/player interaction direction. Not sure why but will try to fix in future updates.
* If you evolve Pikachu into Raichu, interaciting with Raichu will still display Pikachu interaction sprites.
* Debug build on following-pokemon branch fails to build due to space issues.

## Credits
* Lots of features and code based on [Pokémon Static Yellow](https://github.com/CreamElDudJafar/StaticYellow) - Another great Yellow hack. 
* MegamanOmega and [Pokémon Crystal Clear](https://shockslayer.com/crystal-clear/) - Following Pokemon sprites.
* [Pokémon EvoYellow](https://github.com/longlostsoul/EvoYellow) - Original inspiration and another fun Yellow hack.
* Additional Sprite Credit: FrenchOrange

Tried to make sure I also gave credit in commits when possible, but if I missed anyone, please feel free to reach out!



## Building

It builds the following ROMs:

- Pokemon Yellow (UE) [C][!].gbc  `sha1: cc7d03262ebfaf2f06772c1a480c7d9d5f4a38e1`
- YELLMONS.GB (debug build) `sha1: d44e96eddfbdad633cbe4e6e64915e9e198974b0`

To set up the repository, see [**INSTALL.md**](INSTALL.md).

## See also

- [**Wiki**][wiki] (includes [tutorials][tutorials])
- [**Symbols**][symbols]
- [**Tools**][tools]

You can find us on [Discord (pret, #pokered)](https://discord.gg/d5dubZ3).

For other pret projects, see [pret.github.io](https://pret.github.io/).

[wiki]: https://github.com/pret/pokeyellow/wiki
[tutorials]: https://github.com/pret/pokeyellow/wiki/Tutorials
[symbols]: https://github.com/pret/pokeyellow/tree/symbols
[tools]: https://github.com/pret/gb-asm-tools
