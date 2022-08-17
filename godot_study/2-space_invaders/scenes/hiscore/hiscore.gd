extends VBoxContainer

const PRE_ITEM: PackedScene = preload("res://scenes/hiscore/score_item.tscn")
const COLORS = [
	"FF0000",
	"FF7700",
	"FFB900",
	"FDFF00",
	"C7FF00",
	"49FF00",
	"00FF5D",
	"00FFF3",
	"008DFF",
	"0700FF",
]

func mount_hiscores_table(hiscores: Array):
	for c in get_children():
		if c.name != "timer_add_el_to_list":
			c.queue_free()

	var idx = 1
	var header = PRE_ITEM.instance()
	header.pos = "RANK"
	header.player_name = "NAME"
	header.score = "SCORE"
	add_child(header)

	for hs in hiscores:
		var item = PRE_ITEM.instance()
		item.pos = str(idx) + get_suffix(idx)
		item.player_name = hs.name
		item.score = hs.score
		item.color = COLORS[idx - 1]

		$timer_add_el_to_list.start()
		add_child(item)
		yield($timer_add_el_to_list, "timeout")
		idx += 1

func get_suffix(item_position: int) -> String:
	if item_position == 1:
		return 'ST'
	if item_position == 2:
		return 'ND'
	if item_position == 3:
		return 'RD'

	return "TH"
