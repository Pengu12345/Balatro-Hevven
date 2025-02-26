SMODS.Atlas({
    key = "jokers", 
    path = "jokers.png", 
    px = 71,
    py = 95
})

-- Widget (uncommon)
SMODS.Joker({
    key = "widget",
    loc_txt = {
        name = 'Widget',
        text = {
            "Retriggers {C:attention}5th {}played",
            "card of hand {C:attention}#1#{} times"
        }
    },
    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                    }
                }
    end,
    cost = 4,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 0
    },
	config = { extra = { retriggers = 2 }},

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[5] then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 4.10+(0.5*G.SETTINGS.GAMESPEED),
                blocking = false,
                blockable = false,
                func = function() 
                    play_sound("rh_widget_piano", 2.0, 0.5)
                    play_sound("rh_widget_piano", 1.0, 0.5)
                    play_sound("rh_widget_launch", 1.0, 0.5)
                    return true 
                end 
            }))  
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = card
            }
        end
    end
})

-- Space Gramps (common)
SMODS.Joker({
    key = "space_gramp",
    loc_txt = {
        name = 'Space Gramp',
        text = {
            "This Joker gains {C:mult}+#1#{} Mult",
            "if played hand contains",
            "a {C:attention}Black #2#",
            "{C:inactive}(Currently {C:red}+#3#{C:inactive} Mult)",
        },
    },
    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.mult_mod,
                        localize('Flush', 'poker_hands'),
                        card.ability.extra.mult
                    }
                }
    end,
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 1
    },
	config = { extra = { mult = 0, mult_mod = 4 }},

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before then
            if next(context.poker_hands['Flush']) and not context.blueprint then
                sendDebugMessage("card suits: "..context.scoring_hand[1].base.suit.." "..context.scoring_hand[2].base.suit, "rh_j_gramps")
                if  (context.scoring_hand[1].base.suit == "Spades" or context.scoring_hand[1].base.suit == "Clubs") and
                    (context.scoring_hand[2].base.suit == "Spades" or context.scoring_hand[2].base.suit == "Clubs") then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT
                    }
                end
            end
        end
        if 
            context.cardarea == G.jokers
            and not context.before
            and not context.after
        then
            if card.ability.extra.mult > 0 then
                return {
                    message = localize({ type = "variable", key = "a_mult", vars = {
                        card.ability.extra.mult,
                    }}),
                    mult_mod = card.ability.extra.mult,
                    colour = G.C.MULT
                }
            end
        end
    end
})

-- Cosmic Girl (common)
SMODS.Joker({
    key = "cosmic_girl",
    loc_txt = {
        name = 'Cosmic Girl',
        text = {
            "This Joker gains {C:mult}+#1#{} Mult",
            "if played hand contains",
            "a {C:attention}Red #2#",
            "{C:inactive}(Currently {C:red}+#3#{C:inactive} Mult)",
        },
    },
    loc_vars = function(self, info_queue, card)
                return {
                    vars = {
                        card.ability.extra.mult_mod,
                        localize('Flush', 'poker_hands'),
                        card.ability.extra.mult
                    }
                }
    end,
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 1,
        y = 1
    },
	config = { extra = { mult = 0, mult_mod = 4 }},

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before then
            if next(context.poker_hands['Flush']) and not context.blueprint then
                if  context.scoring_hand[1].base.suit == "Hearts" or context.scoring_hand[1].base.suit == "Diamonds" and
                    context.scoring_hand[2].base.suit == "Hearts"  or context.scoring_hand[2].base.suit == "Diamonds"  then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT
                    }
                end
            end
        end
        if 
            context.cardarea == G.jokers
            and not context.before
            and not context.after
        then
            if card.ability.extra.mult > 0 then
                return {
                    message = localize({ type = "variable", key = "a_mult", vars = {
                        card.ability.extra.mult,
                    }}),
                    mult_mod = card.ability.extra.mult,
                    colour = G.C.MULT
                }
            end
        end
    end
})

-- Munchy Monk
SMODS.Joker({
    key = "munchy_monk",
    loc_txt = {
        name = 'Munchy Monk',
        text = {
            "This Joker gains {C:blue}+#1#{} Chips per",
            "{C:purple}Flow{} card used this run,  {C:red}+#2#{} Mult ",
            "per {C:purple}Tarot{} card used this run, and",
            "{X:mult,C:white} X#3# {} Mult every time a Planet card is used",
            "{C:inactive}(Currently {C:blue}+#4#{} Chips, {C:red}+#5#{} Mult, {X:mult,C:white} X#6# {C:inactive} Mult)",
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.add_chips,
                card.ability.extra.add_mult,
                card.ability.extra.add_x_mult,
                (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.flow or 0)*card.ability.extra.add_chips,
                (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)*card.ability.extra.add_mult,
                card.ability.extra.x_mult,
            }
        }
    end,
    cost = 4,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 2
    },
    soul_pos = {
        x = 1,
        y = 2
    },
	config = { extra = {
        add_chips = 50,
        add_mult = 1,
        add_x_mult = 0.1,
        chips = 0,
        mult = 0,
        x_mult = 1.0,
        used_planets = 0,
        used_tarots = 0,
        used_flows = 0,
        monk_level = 0
    }},
    calculate = function(self, card, context)
        if
			context.using_consumeable
			and not context.consumeable.beginning_end
		then
			if context.consumeable.ability.set == "Planet" then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.add_x_mult
                card.ability.extra.used_planets = card.ability.extra.used_planets +1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if (card.ability.extra.monk_level < card.ability.extra.used_planets) and
                            (card.ability.extra.monk_level < card.ability.extra.used_tarots) and
                            (card.ability.extra.monk_level < card.ability.extra.used_flows)
                        then
                            card.ability.extra.monk_level = card.ability.extra.monk_level + 1
                            card.children.floating_sprite:set_sprite_pos({
                                x = card.ability.extra.monk_level + 1,
                                y = 2
                            })
                        end
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}}})
                        return true
                    end}))
            end
			if context.consumeable.ability.set == "Tarot" then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.add_mult
                card.ability.extra.used_tarots = card.ability.extra.used_tarots +1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if (card.ability.extra.monk_level < card.ability.extra.used_planets) and
                            (card.ability.extra.monk_level < card.ability.extra.used_tarots) and
                            (card.ability.extra.monk_level < card.ability.extra.used_flows)
                        then
                            card.ability.extra.monk_level = card.ability.extra.monk_level + 1
                            card.children.floating_sprite:set_sprite_pos({
                                x = card.ability.extra.monk_level + 1,
                                y = 2
                            })
                        end
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.MULT})
                        return true
                    end}))
            end
			if context.consumeable.ability.set == "Flow" then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.add_chips
                card.ability.extra.used_flows = card.ability.extra.used_flows +1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if (card.ability.extra.monk_level < card.ability.extra.used_planets) and
                            (card.ability.extra.monk_level < card.ability.extra.used_tarots) and
                            (card.ability.extra.monk_level < card.ability.extra.used_flows)
                        then
                            card.ability.extra.monk_level = card.ability.extra.monk_level + 1
                            card.children.floating_sprite:set_sprite_pos({
                                x = card.ability.extra.monk_level + 1,
                                y = 2
                            })
                        end
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.CHIPS})
                        return true
                    end}))
            end
            sendDebugMessage("Monk level: "..card.ability.extra.monk_level, "rh_j_munchy_monk")
            sendDebugMessage("Used Planet cards: "..card.ability.extra.used_planets, "rh_j_munchy_monk")
            sendDebugMessage("Used Tarot cards: "..card.ability.extra.used_tarots, "rh_j_munchy_monk")
            sendDebugMessage("Used Flow cards: "..card.ability.extra.used_flows, "rh_j_munchy_monk")
            
            return
        end
        if 
            context.cardarea == G.jokers
            and not context.before
            and not context.after
        then
            return {
                message = localize({ type = "variable", key = "a_mmoonk", vars = {
                    card.ability.extra.chips,
                    card.ability.extra.mult,
                    card.ability.extra.x_mult 
                }}),
				Xmult_mod = card.ability.extra.x_mult,
				chip_mod = card.ability.extra.mult,
				mult_mod = card.ability.extra.x_mult,
            }
        end
    end
})