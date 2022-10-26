extends Node

#Basic Stuff Set Up, Please Modify These Variables, Cheers!
#(Please an int with a float if you want to more precise values)


#Player Stuff
const PLAYER_START_HEALTH: int = 10
const PLAYER_START_LEVEL: int = 0

const PLAYER_ACCELERATION: int = 45
const PLAYER_DECELERATION: float = 0.4
const PLAYER_MAX_SPEED: int = 115

const PLAYER_INVINSIBILITY_TIMER: int = 1

const PLAYER_RELOAD_TIME: int = 1
const SHAKE_AMOUNT: int = 2

const SOULS_TO_LEVEL_UP: int = 100
const SOULS_INCREASE: int = 30

const TIME_BETWEEN_ENEMY_SPAWN: int = 5

#Weapon Stuff
const PISTOL_THICC_BOY_LINE: int = 10
const PISTOL_SHADOW_LIFETIME: int = 120
const SHOTGUN_SHADOW_LIFETIME: int = 120
const SMG_SHADOW_LIFETIME: int = 120

const SHOTGUN_LOCKED_UNTIL: int = 1
const SMG_LOCKED_UNTIL: int = 2
const EXPLOSION_LOCKED_UNTIL: int = 3

const EXPLOSION_COOLDOWN: int = 10

const PISTOL_DAMAGE: float = 1.0
const SMG_DAMAGE: float = .01
const GRENADE_DAMAGE: float = 1.0
const SHOTGUN_RANGE: float = 100.0
const SMG_SPEED: int = 5000

#Enemy Health Stuff
const BASIC_ENEMY_HEALTH: int = 4
const ADVANCED_ENEMY_HEALTH: int = 6

const ADVANCED_ENEMY_PROJECTILE_SPEED: int = 300

#Enemy Speed Stuff
const BASIC_ENEMY_SPEED: int = 50
const ADVANCED_ENEMY_SPEED: int = 100
