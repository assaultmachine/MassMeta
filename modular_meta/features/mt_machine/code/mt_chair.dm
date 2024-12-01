/obj/structure/chair/mind_transferer_chair
	name = "Mind Transferer Chair"
	desc = "Chair for mind swapping"
	icon = 'modular_meta/features/mt_machine/icons/mt_machine.dmi'
	icon_state = "mt_chair"
	item_chair = /obj/item/chair/mind_transferer_chair
	var/machine_ref = null

/obj/structure/chair/mind_transferer_chair/Initialize(mapload)
	. = ..()

/obj/structure/chair/mind_transferer_chair/multitool_act(mob/living/user, obj/item/multitool/multi_tool)
	multi_tool.set_buffer(src)
	balloon_alert(user, "Сохранено")
	to_chat(user, span_notice("You save the data in [multi_tool] buffer. It can now be saved to mind transfer machine."))
	return ITEM_INTERACT_SUCCESS

/obj/structure/chair/mind_transferer_chair/post_buckle_mob(mob/living/M)
	. = ..()


/obj/item/chair/mind_transferer_chair
	name = "Mind Transferer Chair"
	icon_state = "stool"
	inhand_icon_state = "stool"
	origin_type = /obj/structure/chair/mind_transferer_chair
	break_chance = 0
