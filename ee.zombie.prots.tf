;;Contains definitions for all prots.  Note that these are in a file which is loaded no matter
;;what class the character is, because you may have prots cast on you by anyone.
;;Effects which are specific to a class (eg Aegis, Smwalk) should go in a separate file which
;;is only loaded when the character has that class.

/loaded ee.zombie.prots.tf

;;/eff_def -i"" -s -m"" -n"" -u"" -d""

;;Barkskin
;;Your skin turns green and fissures, thickening into a layer of tough bark.
;;Your barkskin wears off.

;;Barkskin
/eff_def -i"bs" -n"Barkskin" -t -s -m"down" -l2 \
 -m"down,ready" -c"ranger,prot,public" \
 -u"Your skin turns green and fissures, thickening into a layer of tough bark." \
 -d"Your barkskin wears off."

/eff_status_add bs <effect_count>


;;Stoneskin

;;Granite plates form over your skin.
;;Your stoneskin crumbles and drops off.

/eff_def -i"sskin" -n"Stoneskin" -t -s -m"down" -l2 \
 -m"down,ready" -c"ranger,prot,public" \
 -u"Granite plates form over your skin." \
 -d"Your stoneskin crumbles and drops off."


;;Shield of Protection
;;You form a barrier of repulsive magic around yourself.
;;You form a barrier of repulsive magic around Carpet.
;;You are surrounded by a green glow.
;;Your protection spell wears off.

/eff_def -i"sop" -n"Shield of Protection" -s -t -m"down" -l2 \
 -m"down" -c"prot,public" \
 -u"(You form a barrier of repulsive magic around yourself.|You are surrounded by a green glow.)" \
 -d"Your protection spell wears off."

/eff_status_add sop <effect_count>

;;Preparation of harmony
;;NB: This message always comes from preparation, even if it fails
;;You feel like you might be ready for harmony.
;;This is the message the caster gets if preparation didn't work
;;The target has not been prepared for harmony successfully.
;;You feel less prepared for harmony.

/eff_def -i"poh" -n"Preparation of Harmony" -m"up,down" -u"You feel like you might be ready for harmony." -d"You feel less prepared for harmony."

;;Blur
;;(%w) enchants the air around you, blurring your figure.
;;Mindart enchants the air around you, blurring your figure.
;;Your blur wears off

/eff_def -i"blur" -n"Blur" \
 -m"down" -c"prot,public" \
 -u"(.*) enchants the air around you, blurring your figure." \
 -d"Your blur wears off"

;;Brain unpain
;;Your brain feels bigger.
;;Your brain feels smaller.

/eff_def -i"bup" -n"Brain unpain" -m"down" -l2 \
 -m"down" -c"boost,public" \
 -u"Your brain feels bigger." \
 -d"Your brain feels smaller."

;;Force shield
;;Galad surrounds you with a telekinetic shield of force.
;;The force shield dissipates.

/eff_def -i"fs" -n"Force shield" -m"down" -l2 \
 -m"down" -c"prot,public" \
 -u"(.*) surrounds you with a telekinetic shield of force.|You surround yourself with a telekinetic shield of force." \
 -d"The force shield dissipates."

/eff_status_add fs [<effect_count>?UP:--]

;;Regeneration
/eff_def -i"regen" -n"Regeneration" -m"down" -l2 \
 -m"down" -c"healer,boost,public" \
 -u"You feel your metabolism speed up." \
 -d"Your metabolism slows back down."

/eff_status_add regen [<effect_count>?UP:--]


;;You feel your metabolism speed up.

;;Water walking
;;You feel lighter.
;;Musashi looks a bit different.
;;You feel heavy.

;;Harmony armour
;;You feel in complete harmony.
;;You no longer feel harmonious.

/eff_def -i"ha" -n"Harmony armour" -m"down" -l2 \
 -m"down" -c"healer,boost,public" \
 -u"You feel in complete harmony." \
 -d"You no longer feel harmonious."

;;Harmonious barrier
;;You feel enveloped in harmony.

;;True unpain
/eff_def -i"tup" -n"True unpain" -m"down" -l2 \
 -m"down" -c"healer,boost,public" \
 -u"You feel like you could carry the world." \
 -d"You feel like crap."

;;Minor unpain
/eff_def -i"mup" -n"Minor Unpain" -m"down" -l2 \
 -c"prot,boost,public" \
 -u"You feel more sturdy." \
 -d"You feel a little like crap."

;;Iron will
/eff_def -i"iw" -n"Iron Will" -t -w12 -m"down" -l2 \
 -c"prot,boost,public" \
 -u"(.*) stares deep into your eyes, bolstering your concentration greatly.|You turn your mind inwards, enchanting yourself with an aura of rigid" \
 -d"Your Iron Will wears off."

/eff_status_add iw [<effect_count>?UP:--]

;;Energy hauberk
/eff_def -i"eh" -n"Energy Hauberk" -m"down" -l2 \
 -c"prot,boost,public" \
 -u"With a flash a shining hauberk of pure energy encases you." \
 -d"The energy surrounding your body dwindles away."


/eff_def -i"disp" -n"Displacement" -m"down" -l2 \
 -c"prot,boost,public" \
 -u"(.*) displaces your image." \
 -d"Your displacement wears off."

/eff_def -i"botm" -n"Barrier of the mind" -m"down" -l2 \
 -c"prot,boost,public" \
 -u"You feel as if a protective barrier surrounds your fragile mind." \
 -d"You feel a slight tingle somewhere deep inside your mind."


;Deprecated in favour of amorphic armour now
;/eff_def -i"vap" -n"Vaporic Armour" -t -s -l2 \
; -m"down" -c"samurai,prot,public" \
; -u"You cast a protective spell on Musashi.|casts a protective spell on you." \
; -d"Your vaporic armour spell wears off"

/eff_def -i"arm" -n"Amorphic Armour" -t -s -l2 \
 -m"down" -c"samurai,prot,public" \
 -u"You cast a protective spell on Musashi.|casts a protective spell on you." \
 -d"Your Amorphic Armour spell wears off."


;;Stun resistance
/eff_def -i"sr" -n"Stun resistance" -t -m"down" -l2 \
 -m"down" -c"healer,prot,public" \
 -u"Musashi wobbles around a bit." \
 -d"Your stun resistance wears off."

/eff_status_add sr [<effect_count>?UP:--]


/eff_def -i"md" -n"Mind development" -m"down" -l2 \
 -m"down" -c"psi,buss,public" \
 -u"You feel smart." \
 -d"You feel stupid."

