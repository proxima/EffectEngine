/loaded ee.zombie.mom.tf

;;Combat trance

;You are prepared to do the skill.
;Your movements are now more focused and your mind is calm.
;You feel that it is easier to swing your weapons and
;know how to take advantage of your enemies weaknesses.

;/hilite Your concentration starts to crack and its hard to keep your calm mind.

/def -mregexp -t'(^|> )Your concentration starts to crack and its hard to keep your calm mind.' ctwarn = /eff_com -i"down" Combat trance dropping...

;You lose your concentration and fight with less precision.

/eff_def -i"ct" -n"Combat Trance" -l2 -t \
 -m"down" -c"mom,private" \
 -u"Your movements are now more focused and your mind is calm." \
 -d"You lose your concentration and fight with less precision."

/eff_status_add ct [<effect_count>?UP:--]
