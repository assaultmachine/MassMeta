/obj/machinery/mind_transferer
	name = "Mind Transferer Machine"
	desc = "Dark age technologies"
	icon = 'modular_meta/features/mt_machine/icons/mt_machine.dmi'
	icon_state = "mt_machine"
	density = 1
	var/list/linked_chairs = new/list()
	var/in_process = FALSE

/obj/machinery/mind_transferer/Initialize(mapload)
	. = ..()

/obj/machinery/mind_transferer/multitool_act(mob/living/user, obj/item/multitool/multi_tool)

	if(linked_chairs.len > 1)
		to_chat(user, span_notice("Ошибка: вы не можете подключить больше двух кресел!"))
		return
	if(!istype(multi_tool.buffer, /obj/structure/chair/mind_transferer_chair))
		return
	if(get_dist(src, multi_tool.buffer) > 1)
		to_chat(user, span_notice("Ошибка: слишком далеко!"))
		return

	//multi_tool.buffer.machine_ref = src
	linked_chairs.Add(multi_tool.buffer)
	to_chat(user, span_notice("Кресло подключено."))

/obj/machinery/mind_transferer/proc/mind_swap(mob/user)
	var/error = check_targets()
	if(error)
		to_chat(user, span_notice(error))

	in_process = TRUE
	icon_state = "mt_machine_anim"
	sleep(5 SECONDS)
	icon_state = "mt_machine"

	var/mob/living/swap_target_1 = linked_chairs[1].buckled_mobs[1]
	var/mob/living/swap_target_2 = linked_chairs[2].buckled_mobs[1]

	if(!swap_target_2.mind)
		swap_target_2.mind_initialize()
	if(!swap_target_1.mind)
		swap_target_1.mind_initialize()

	/*
	if(!(swap_target_1.mind && swap_target_2.mind))
		to_chat(user, span_notice("Цели должны быть разумны"))
		return
	if(swap_target_1.health < swap_target_1.crit_threshold || swap_target_2.healt < swap_target_2.crit_threshold)
		to_chat(user, span_notice("Цели не должны находиться в критическом состоянии"))
		return
	*/

	var/datum/mind/target_1_mind = swap_target_1.mind
	var/datum/mind/target_2_mind = swap_target_2.mind

	var/key_1 = swap_target_1.key
	var/key_2 = swap_target_2.key

	target_1_mind.transfer_to(swap_target_2)
	target_2_mind.transfer_to(swap_target_1)

	if(key_1 && key_2)
		swap_target_1.key = key_2
		swap_target_2.key = key_1

	in_process = FALSE

/obj/machinery/mind_transferer/interact(mob/user)
	. = ..()
	if(in_process)
		to_chat(user, span_notice("Ошибка: устройство в работе!"))
		return
	mind_swap(user)

/obj/machinery/mind_transferer/attackby(obj/item/weapon, mob/user, params)
	if(istype(weapon, /obj/item/multitool))
		return
	. = ..()

/obj/machinery/mind_transferer/proc/check_chairs_distance()
	if(get_dist(src, linked_chairs[1]) != 1 || get_dist(src, linked_chairs[2]) != 1)
		return FALSE
	return TRUE

/obj/machinery/mind_transferer/proc/check_targets()
	if(linked_chairs.len != 2)
		return "Ошибка: недостаточно кресел!"
	if(linked_chairs[1].buckled_mobs.len != 1 || linked_chairs[2].buckled_mobs.len != 1)
		return "Ошибка: не все кресла заняты!"
	if(!istype(linked_chairs[1].buckled_mobs[1], /mob/living/carbon/) || !istype(linked_chairs[2].buckled_mobs[1], /mob/living/carbon/))
		return "Ошибка: устройство совместимо только с гуманоидами!"
	if (!check_chairs_distance())
		return "Ошибка: кресла слишком далеко!"
	return null
