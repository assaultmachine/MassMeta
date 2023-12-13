/datum/brain_trauma/mild/dumbness/on_life(seconds_per_tick, times_fired)
	owner.adjust_derpspeech_up_to(5 SECONDS * seconds_per_tick, 50 SECONDS)
	if(SPT_PROB(1.5, seconds_per_tick))
		owner.emote("drool")
	else if(owner.stat == CONSCIOUS && SPT_PROB(1.5, seconds_per_tick))
		owner.say(pick_list_replacements(BRAIN_DAMAGE_FILE_RU, "brain_damage"), forced = "brain damage", filterproof = TRUE)
