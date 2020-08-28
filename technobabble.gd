extends Node

var ACTIONS = [
	"Refocuses",
	"Amplifies",
	"Synchronizes",
	"Redirects",
	"Recalibrates",
	"Modulates",
	"Oscillates",
	"Intensifies",
	"Nullifies",
	"Boosts",
	"Reverses",
	"Reconfigures",
	"Actuates",
	"Focuses",
	"Inverts",
	"Reroutes",
	"Modifies",
	"Restricts",
	"Resets",
	"Extends"
]

var DESCRIPTOR = [
	"Microscopic",
	"Macroscopic",
	"Linear",
	"Non-linear",
	"Isometric",
	"Multivariant",
	"Nano",
	"Phased",
	"Master",
	"Auxiliary",
	"Primary",
	"Secondary",
	"Tertiary",
	"Back-up",
	"Polynodal",
	"Multiphasic",
	"Emergency",
	"Tri-fold",
	"Balanced",
	"Oscillating"
]

var SOURCE = [
	"Quantum",
	"Positronic",
	"Thermionic",
	"Osmotic",
	"Neutrino",
	"Spatial",
	"Resonating",
	"Thermal",
	"Photon",
	"Ionic",
	"Plasma",
	"Nucleonic",
	"Verteron",
	"Gravimetric",
	"Nadion",
	"Subspace",
	"Baryon",
	"Tetryon",
	"Polaron",
	"Tachyon"
]

var EFFECT = [
	"Flux",
	"Reaction",
	"Field",
	"Particle",
	"Gradient",
	"Induction",
	"Conversion",
	"Polarizing",
	"Displacement",
	"Feed",
	"Imagining",
	"Reciprocating",
	"Frequency",
	"Pulse",
	"Phased",
	"Harmonic",
	"Interference",
	"Distortion",
	"Dampening",
	"Invariance"
]

var DEVICE = [
	"Inhibitor",
	"Equalizer",
	"Damper",
	"Chamber",
	"Catalyst",
	"Coil",
	"Unit",
	"Grid",
	"Regulator",
	"Sustainer",
	"Relay",
	"Discriminator",
	"Array",
	"Coupling",
	"Controller",
	"Actuator",
	"Harmonic",
	"Generator",
	"Manifold",
	"Stabilizer"
]

func generate_technobabble():
	return str(
		ACTIONS[randi()%ACTIONS.size()].to_lower() + " the " +
		DESCRIPTOR[randi()%DESCRIPTOR.size()].to_lower() + " " +
		SOURCE[randi()%SOURCE.size()].to_lower() + " " +
		EFFECT[randi()%EFFECT.size()].to_lower() + " " +
		DEVICE[randi()%DEVICE.size()].to_lower()
	)
func _ready():
	randomize()
	print(generate_technobabble())
