/loaded ee.zombie.spellblade.tf


/def -aBCYellow -t"Your skill in * has increased." sbmasteryincrease

;; Radiant aegis ;;;;;;;;;;;

;You utter the magic words 'praesidium modirma'
;A barely perceptible shroud of energy manifests to envelop you.
;You are already protected by a radiant aegis!

/eff_def -i"ra" -n"Radiant Aegis" -l2 -t -w10 \
 -m"down" -c"spellblade,private" \
 -u"A barely perceptible shroud of energy manifests to envelop you." \
 -d"You dispel the spell 'Radiant aegis'."

/eff_status_add ra [<effect_count>?UP:--]


;; Spellblade's ardor ;;;;;;;;

;You utter the magic words 'invocia validus'
;You reinforce your mind with magic, feeling instantly more focused.

/eff_def -i"sa" -n"Spellblade's Ardor" -l2 -t -w10 \
 -m"down" -c"spellblade,private" \
 -u"You reinforce your mind with magic, feeling instantly more focused." \
 -d"You dispel the spell 'Spellblade's ardor'."

/eff_status_add sa [<effect_count>?UP:--]


;A fiery burst of energy surges forth from your Katsujin-ken to devastate Lizard
;    priest!
;A fiery burst of energy surges forth from your Katsujin-ken to devastate Guard!

;You get STUNNED from the force of the attack.
;...BUT your reinforced mind breaks the stun.

;; PSI 20 levels

;; Regeneration

/eff_def -i"regen" -n"Regeneration" -l2 \
 -m"down" -c"psi,private" \
 -u"You feel your metabolism speed up." \
 -d"Your metabolism slows back down."

;You are done with the chant.
;You utter the magic words 'pu deepsi'
;You feel your metabolism speed up.

;Your metabolism slows back down.

;; Force shield

/eff_def -i"fs" -n"Force Shield" -l2 \
 -m"down" -c"psi,private" \
 -u"You surround yourself with a telekinetic shield of force." \
 -d"The force shield dissipates."

/eff_status_add fs [<effect_count>?UP:--]


;You are done with the chant.
;You lean back while bobbing your head and chant 'pimp pimp PIMP'
;You surround yourself with a telekinetic shield of force.



;Lacking the mana you lose control of the magic of 'augmented strikes' and it fizzles out.
;Lacking the mana you lose control of the magic of 'spellblade's ardor' and it fizzles out.
