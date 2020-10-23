/loaded ee.zombie.myrmi.tf

;;; Wall of steel ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;You are prepared to do the skill.
;You lift up your shield.

/eff_def -i"wos" -n"Wall of Steel" -l1 -t -w12 \
 -m"down" -c"myrmi,private" \
 -u"You lift up your shield." \
 -d"Your hand starts to ache, forcing you to lower your shield."

/eff_status_add wos [<effect_count>?UP:--]
;[<effect_count>?<effect_drops>:OFF]

/def -mregexp -t'Without a shield you can no longer uphold your wall of steel.' wos_shield_removed = /eff_down wos



;;;; Myrmi stat messages - reported in zombie.stats.tf ;;;;;;;;;;;;;;;;;;;;;

/def -mglob -t'puts on a stupid face as if he had completely forgotten what' catch_other_break



;Additional effect from wos with higher fig mastery?
;The concussive blow impairs Zombie's focus.


/set pbs=0
/def -mglob -t'The hard training lessons boost the effectiveness of your attack.' catch_pb = /set pbs=$[pbs+1]

/set wos=0
/def -mglob -t'Entering close combat while crouched in a defensive stance behind your wall of' catch_wos = /set wos=$[wos+1]

/set db_coord=0
/def -mglob -t'The blow hampers *s coordination.' catch_db_coord = /set db_coord=$[db_coord+1]

/set db_fero=0
/def -mglob -t'The blow saps *s ferocity.' catch_db_fero = /set db_fero=$[db_fero+1]

/set db_stun=0
/def -mglob -aB -t'*eyes roll around in * head as * consciousness leaves *.' catch_db_stun = /set db_stun=$[db_stun+1]

;Demon's eyes roll around in his head as his consciousness leaves him.

/set db_break=0
/def -mglob -aB -t'*The blow breaks *s concentration.*' catch_db_break = /set db_break=$[db_break+1]

/set wos_prots=0
/def -mglob -t'*You manage to block the hit by hiding behind your shield.*' catch_wos_prot = /set wos_prots=$[wos_prots+1]

/set dbs=0

;5
;You quickly seize the moment by swinging your Katsujin-ken through Priest's open
;defence. Your sword strikes against Priest's left temple accompanied by the
;sound of cracking bone. The power behind your swing is so fierce that it
;cuts its way with ease through the temple to Priest's eye which literally
;explodes to a white goo as your sharp blade touches it. Priest howls in pain,
;doubling up next to the gooey remnants of its eye while holding its badly
;bleeding head in its hands.

/set db5=0
/def -mglob -t'*doubling up next to the gooey remnants of * eye while holding * badly*' catch_db5 = /set db5=$[db5+1]%;/set dbs=$[dbs+1]

;4
;You kick Priest in the knee, knocking it out of balance. You quickly
;capitalize the opportunity by thrusting your Katsujin-ken through Priest's open
;defence. Your sword strikes Priest in the belly, just below the bellybutton,
;sliding deep into its flesh. You push your sword upwards, widening the wound
;and lacerating Priest's bowels. As the mushy intestines of Priest slowly drip
;down on your hand along the side of your sword your eyes meet with the glazed
;eyes of your opponent. A sense of sick satisfaction fills you as you watch your
;enemy wrestle with excruciating pain as a consequence of your vicious attack!

/set db4=0
/def -mglob -t'*enemy wrestle with excruciating pain as a consequence of your vicious attack!*' catch_db4 = /set db4=$[db4+1]%;/set dbs=$[dbs+1]

;3
;You stretch out your hand, lifting your Katsujin-ken on your eye level, pointing
;its tip at Priest. You begin to spin your sword above your head with accelerating
;speed, turning for a moment into a proverbial whirlwind of steel and muscle. Stepping
;closer to Priest you slash it with all of your strength. Your blade hits
;Priest in the junction of neck and chest, cutting open a large blood vessel.
;Priest tries to scream, but gets quickly squelched by its own blood, which
;reduces its voice to sound like strange gurgling.

/set db3=0
/def -mglob -t'*reduces its voice to sound like strange gurgling.*' catch_db3 = /set db3=$[db3+1]%;/set dbs=$[dbs+1]]%;/set dbs=$[dbs+1]

;2
;You hit Priest in the head with your shield, opening room for your sword
;move. You lift your sword up, bringing it down against Priest's stomach, slashing
;open a large wound on its left side. Priest tries to nurse its wound by placing
;its hand on it, but it can't help but to watch how its bowels slowly slither out
;from the wound to greet the daylight.

/set db2=0
/def -mglob -t'*from the wound to greet the daylight.*' catch_db2 = /set db2=$[db2+1]%;/set dbs=$[dbs+1]

;1
;You kick Priest in the kneecap trying to open room for your strike, Priest,
;however won't even budge. You still decide to press on by shoving your Katsujin-ken
;in its groin. To your amazement your attack passes its defence, landing
;in precisely where you wanted it to land. You grant Priest a free circumcision
;as your sword lacerates its genitals in a gory way.

/set db1=0
/def -mglob -t'*in its groin. To your amazement your attack passes its defence, landing*' catch_db1 = /set db1=$[db1+1]%;/set dbs=$[dbs+1]

