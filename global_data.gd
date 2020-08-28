extends Node

#
# handles all the global vars and setters/getters
#

var line_points = []
var next_line_point = null

enum RATION_LEVELS {
	LOW = 1,
	NORMAL = 2,
	HIGH = 3
}

enum SHIP_STATES {
	SHIP_STOPPED,
	SHIP_MOVING,
	SHIP_EXPLORING,
	SHIP_EVENT,
	SHIP_HUNTING
}

var STATION_COLORS = {
	"Tactical" : Color("#a71313"),
	"Engineering": Color("#E1C335"),
	"Science": Color("#112959")
}

var DISEASES = {
	"space_dysentery" : {
		"name":"Space Dysentery",
		"heals_required" : 3, # how many sickbay uses to heal
		"deadliness" : 0.3, # chance per hour to die
		"recovery_rate" : 0.25 # chance per hour to recover
	},
	"gorch" : {
		"name":"Gorch",
		"heals_required" : 1,
		"deadliness" : 0.05,
		"recovery_rate" : 0.3
	},
	"quazulu": {
		"name":"Quazulu VIII Virus",
		"heals_required" : 6,
		"deadliness" : 0.25,
		"recovery_rate" : 0.15
	},
	"auroral" : {
		"name":"Auroral Plague",
		"heals_required":4,
		"deadliness": 0.3,
		"recovery_rate": 0.1
	},
	"cellular" : {
		"name":"Cellular Ennui",
		"heals_required":4,
		"deadliness":0.3,
		"recovery_rate":0.3
	},
	"polywater" : {
		"name":"Polywater Intoxication",
		"heals_required":2,
		"deadliness":0,
		"recovery_rate":0.15
	},
	"borg_nanites" : {
		"name":"Borg Nanites",
		"heals_required":10,
		"deadliness":0.45,
		"recovery_rate":0
	}
}

# CREW VARS
var CAPTAIN = {} # TODO: Figure this out
var CREW = []

# TIME VARS
var TIME = 0 setget set_time
var DAYS_PASSED = 0
var TIME_OF_DAY = 1
var TIME_PER_DAY = 24

# PATH VARS
var PATH_OFFSET = 0
var PATH_LENGTH = 0

# SHIP VARS

# Ship state determines what the game is doing at all times
var SHIP_STATE = SHIP_STATES.SHIP_STOPPED

# Fuel(Energy): used for almost everything
# Torpedos: used to escape some events
# Shields: prevents damage to the hull
# Rations: affects crew disease rates
# Destination: How far to travel to win
# Engine eff.: Less efficiency means more fuel
# Engine wear: How much efficiency is lost per tick
# Warp speed: The speed setting the player has selected
# Speed: How much per tick the ship moves

var FUEL = 100000 setget set_fuel
var TORPEDOS = 6
var MAX_SHIELDS = 100
var SHIELDS = MAX_SHIELDS setget set_shields

var RATIONS = RATION_LEVELS.NORMAL
var DESTINATION = 10000
var DISTANCE_TRAVELLED = 0 setget set_distance

var ENGINE_EFFICIENCY = 1 setget set_efficiency
var WARP_SPEED = 1 setget set_warp
var ENGINE_WEAR = pow(WARP_SPEED,2)*0.005
var FUEL_USE = calc_fuel_use()
var SPEED = calc_speed()

# EXPLORATION VARS
var EXPLORATION_COOLDOWN = 0 setget set_ex_cooldown
var EXPLORATION_BASE_CHANCE = 15
var EXPLORATION_BONUS_CHANCE = 0
var EXPLORATION_TICKS = 10

# SECTOR VARS
var SECTOR_LENGTH = 0.33334 # 1/3rd of the path unit_offset
var CURRENT_SECTOR = 0
var SECTORS = [0, SECTOR_LENGTH, SECTOR_LENGTH*2]
var END_OF_GAME_OFFSET = 1
var SECTOR_NAMES = ["Taurus Reach", "Neutral Zone", "Fluidic Space"]
var SECTOR_NAME = SECTOR_NAMES[0]

# EVENT VARS
var MAJOR_EVENT_CHANCE = 5
var MINOR_EVENT_CHANCE = 3


#
# all the setters and getters
#
func set_fuel(val):
	FUEL = max(floor(val), 0)
	calc_ship_resources()

func set_distance(val):
	DISTANCE_TRAVELLED = min(floor(val), DESTINATION)
	set_sector()

func set_efficiency(val):
	ENGINE_EFFICIENCY = max(val, 0.01)

func set_warp(val):
	WARP_SPEED = int(val)
	calc_ship_resources()

func calc_ship_resources():
	FUEL_USE = calc_fuel_use()
	SPEED = calc_speed()

func calc_fuel_use():
	if SHIP_STATE != SHIP_STATES.SHIP_MOVING:
		return 0
	return int(round(
		(WARP_SPEED) * (RATIONS * CREW.size()) / ENGINE_EFFICIENCY )
	)

func calc_speed():
	if SHIP_STATE != SHIP_STATES.SHIP_MOVING:
		return 0
	return (
		(WARP_SPEED) * 
		(5+CREW.size()) * 
		(ENGINE_EFFICIENCY)
	)

func set_shields(val):
	# keep shields between 0-100
	SHIELDS = clamp(val, 0, MAX_SHIELDS)

func set_ex_cooldown(val):
	# dont let the cooldown go below 0
	EXPLORATION_COOLDOWN = max(val, 0)

func set_time(val):
	# after 24 hours passes set a new day
	TIME = val
	TIME_OF_DAY += 1
	if TIME_OF_DAY >= TIME_PER_DAY:
		DAYS_PASSED += 1
		TIME_OF_DAY = 1
	
func set_sector():
	var po = stepify(PATH_OFFSET, 0.01)
	if po < SECTORS[1]:
		CURRENT_SECTOR = 0
	if po >= SECTORS[1] and po < SECTORS[2]:
		CURRENT_SECTOR = 1
	if po >= SECTORS[2]:
		CURRENT_SECTOR = 2
	SECTOR_NAME = SECTOR_NAMES[CURRENT_SECTOR]