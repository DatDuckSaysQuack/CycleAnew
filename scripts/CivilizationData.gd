extends RefCounted
class_name CivilizationData

static func get_stages() -> Array:
	return [
		{"id":1,"name":"Dawn Settlement","desc":"Primitive hearths and first paths.","tint":Color(0.84,0.76,0.6),"houses":1,"event":"Ash Rain","alt":false},
		{"id":2,"name":"River Stones","desc":"Stone memory and river rites.","tint":Color(0.76,0.79,0.66),"houses":2,"event":"River Reversal","alt":false},
		{"id":3,"name":"Bronze Chorus","desc":"Ancient chorus of alloy and fire.","tint":Color(0.86,0.72,0.42),"houses":3,"event":"Copper Sandstorm","alt":false},
		{"id":4,"name":"Hellas Path","desc":"Marble argument under bright skies.","tint":Color(0.84,0.84,0.9),"houses":3,"event":"Statue Weeping","alt":false},
		{"id":5,"name":"Eternal Roads","desc":"Legions and roads cross the world.","tint":Color(0.75,0.66,0.57),"houses":4,"event":"Roadquake","alt":false},
		{"id":6,"name":"Crowned Fields","desc":"Kingdoms and grain beneath banners.","tint":Color(0.62,0.74,0.56),"houses":4,"event":"Black Harvest","alt":false},
		{"id":7,"name":"Smoke and Iron","desc":"Engines wake and conflict hardens.","tint":Color(0.56,0.56,0.58),"houses":5,"event":"Iron Hail","alt":false},
		{"id":8,"name":"Neon Memory","desc":"Electric myths and remembered cycles.","tint":Color(0.47,0.65,0.88),"houses":5,"event":"Flood Wall","alt":true},
		{"id":9,"name":"Orbital Dream","desc":"Sky rings and machine prayers.","tint":Color(0.66,0.65,0.87),"houses":6,"event":"Orbital Fall","alt":true},
		{"id":10,"name":"Final Garden","desc":"Mythic future of altered forms.","tint":Color(0.72,0.87,0.73),"houses":6,"event":"Last Bloom","alt":true}
	]

static func get_branches() -> Array:
	return ["Main Cycle","Rome Endures","Hellas Ascendant","Companion Age","Twin Species Accord"]
