/loaded ee.zombie.paladin.tf

;;/eff_def -i"" -t -n"" \
;; -m"down" -c"Paladin" \
;; -u"" \
;; -d""

;;TODO: Allow undefining based on category
;;/eff_undef -c'Paladin'

;;Test
/eff_def -i"test" -n"Test Effect" -l5 -t -w5 -e100 -f -s \
 -c"paladin,private" \
 -u"You say 'tu (.*)'" \
 -d"You say 'td'" \
 -r"You say 'tr'" 

;;Test
/eff_def -i"test2" -n"Test Effect 2" -l5 -t -w5 -e100 -f -s \
 -c"paladin,private" \
 -u"You say 'tu2'" \
 -d"You say 'td2'" \
 -r"You say 'tr2'" 

;/def effect_test_up_trig=/echo ARGS TO TEST: %{#}: %{*} 2: %{2}

/eff_status_add test [<effect_count>?<effect_drops>s:DOWN]
/eff_status_add test2 <effect_count>

;;Aegis
/eff_def -i"aegis" -n"Aegis" -t -l2 \
 -m"down,ready" -c"paladin,private" \
 -u"You raise your (.*) protectively before you!" \
 -d"You are too tired to maintain your Aegis!" \
 -r"You are recovered enough to raise your Aegis!"

/eff_status_add aegis [<effect_count>?UP:[<effect_ready>?RD:WT]]

;;Blade blessing
;;"You raise the (.*) over your head and solemnly chant 'nuljia srief'"

/eff_def -i"bb" -n"Blade Blessing" -t -l3 -e1800 \
 -m"down" -c"paladin,private" \
 -u"You raise the (.*) over your head and" \
 -d"((.*) is no longer blessed.|Your (.*) expires in a shower of sparks!)"

/eff_status_add bb [<effect_count>?<effect_drops>:OFF]

;;Armour of God
/eff_def -i"aog" -n"Armour of God" -t -l5 -w10 -e517 \
 -m"down" -c"paladin,prots,public" \
 -u"A shining suit of glowing silver mail surrounds you." \
 -d"The Armour of God surrounding you fades away."

/eff_status_add aog [<effect_count>?<effect_drops>:OFF]

;;Enlightenment
/eff_def -i"enl" -n"Enlightenment" -t -l2 -e900 \
 -m"down" -c"paladin,public" \
 -u"You feel wiser." \
 -d"You feel less wise."

/eff_status_add enl [<effect_count>?<effect_drops>:OFF]

;;Inner power
/eff_def -i"ip" -n"Inner Power" -t -l2 -e420 \
 -m"down" -c"paladin,public" \
 -u"You feel inner strength increasing." \
 -d"You feel your inner power decreasing."

/eff_status_add ip [<effect_count>?<effect_drops>:OFF]

;;
;;/eff_def -i"" -t -n"" \
;; -m"down" -c"Paladin" \
;; -u"" \
;; -d""

