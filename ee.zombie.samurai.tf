/loaded ee.zombie.samurai.tf

;; Blade boosts

/eff_def -i"ss" -n"Silver Sheen" -l2 \
 -m"down" -c"samurai,boost,private" \
 -u"Your blade glimmers with a silver sheen." \
 -d"The silver glimmer vanishes from your blade."

/eff_status_add ss [<effect_count>?SS:ss]

/def -mglob -t'*You lack the mental reserves to sustain your silver sheen enchantment.*' ss_off = /eff_down ss

;Your blade glimmers with a silver sheen.
;The silver glimmer vanishes from your blade.
;You lack the mental reserves to sustain your silver sheen enchantment.

/eff_def -i"re" -n"Razor Edge" -l2 \
 -m"down" -c"samurai,boost,private" \
 -u"The air about your blade hums against its razor-sharp edge." \
 -d"The edge of your blade grows a bit duller."

/eff_status_add re [<effect_count>?RE:re]

;The air about your blade hums against its razor-sharp edge.
;The edge of your blade grows a bit duller.

/eff_def -i"ls" -n"Lightsword" -l2 \
 -m"down" -c"samurai,boost,private" \
 -u"The blade shimmers with a cold blue light." \
 -d"The cold, blue glow surrounding your blade vanishes."

/eff_status_add ls [<effect_count>?LS:ls]

;The blade shimmers with a cold blue light.
;The cold, blue glow surrounding your blade vanishes.


;;Align prefs

;;Tenrai blade
;/eff_def -i"tb" -n"Tenrai blade" -t -l2 -w10 \
; -m"down" -c"samurai,boost,private" \
; -u"the spiritual forces of good." \
; -d"The benign spiritual forces of the Tenrai Blade twindle away."

;Jigoku blade
;/eff_def -i"jb" -n"Jigoku blade" -t -l2 -w10 \
; -m"down" -c"samurai,boost,private" \
; -u"the spiritual forces of evil." \
; -d"The dark spiritual forces of the Jigoku Blade twindle away."

;Blade align
;/eff_def -i"ba" -n"Blade Align" -l2 \
; -m"down" -c"samurai,boost,private" \
; -u"the spiritual forces of (good|evil)." \
; -d"The (benign|dark) spiritual forces of the (Tenrai|Jigoku) Blade dwindle away."

;Blade align
/eff_def -i"ba" -n"Blade Align" -l2 -m"down" -c"samurai,boost,private" -u"the spiritual forces of (good|evil)." -d"The (benign|dark) spiritual forces of the (Tenrai|Jigoku) Blade dwindle away."

/eff_status_add ba [<effect_count>?BA:ba]


;;Blade prefs
/eff_def -i"sspref" -n"Blade pref" -l3 \
 -m"down" -c"samurai,boost,private" \
 -u"Your sword begins to glow with" \
 -d"Your (.*)blade spell wears off."

/eff_status_add sspref [<effect_count>?BP:bp]

/def -mglob -t'*You lack the mental reserves to sustain your blade\'s damage preference.*' bladepref_off = /eff_down sspref



;/eff_def -i"fireblade" -n"Fire blade" -t -l3 \
; -m"down" -c"samurai,boost,private" \
; -u"Your sword begins to glow with the faintest glow of elemental fire." \
; -d"Your fireblade spell wears off."

;/eff_def -i"acidblade" -n"Acid blade" -t -l3 \
; -m"down" -c"samurai,boost,private" \
; -u"Your sword begins to glow with the faintest glow of elemental fire." \
; -d"Your acidblade spell wears off."

;/eff_status_add ssacidpref [<effect_count>?<effect_drops>:OFF]

;;Neutralize blade
/def -mregexp -t"Your spirit touches the blade, cleansing it of elemental powers." neut_blade = /eff_down sspref

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Samurai mastery effects ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;sspirit
/eff_def -i"sspirit" -n"Inner spirit" -t -l2 -w10 \
 -m"down" -c"samurai,mastery,private" \
 -u"You open your eyes with newfound confidence." \
 -d"The teachings of your ancestors fade from your mind as the aches and"

/eff_status_add sspirit [<effect_count>?SPRT:sprt]

;;spirit down
;The teachings of your ancestors fade from your mind as the aches and
;harsher realities of life catch up with you once more.
;;spirit up
;You turn your mind inwards, and seek out the essence of your Warrior Spirit.
;You open your eyes with newfound confidence.

/eff_def -i"sken" -n"Kenjutsu" -l2 \
 -m"down" -c"samurai,mastery,private" \
 -u"You take a deep breath, and the world around you seems to come to a halt." \
 -d"(.*) anticipates your movement and your attempt at Tebukuro kenjutsu fails!" \
 -r"Your body seems to have recovered from the previous Tebukuro-kenjutsu."

/eff_status_add sken [<effect_count>?SKEN:[<effect_ready>?sken:wait]]

/def -mregexp -t'You are already focused on Tebukuro-kenjutsu!' = /eff_up sken
;Fedaykin anticipates your movement and your attempt at Tebukuro kenjutsu fails!

;;ken up
;You turn inwards and focus on Tebukuro kenjutsu.  
;;ken down
;Ghost anticipates your movement and your attempt at Tebukuro kenjutsu fails!
;;ken ready
;Your body seems to have recovered from the previous Tebukuro-kenjutsu.

;You turn inwards and focus on Tebukuro kenjutsu.
;You take a deep breath, and the world around you seems to come to a halt.
;You become aware of the movement and trajectory of each object around you,
;both living and lifeless. The flow of Tebukuro kenjutsu takes over your
;body and you begin to move on instinct.

/eff_def -i"smwalk" -n"Magical walking" -t -l2 -w10 \
 -m"down" -c"samurai,mastery,private" \
 -u"You start walking magically." \
 -d"Your magical walking wears off."

/eff_status_add smwalk [<effect_count>?WALK:walk]
 
;;smwalk up
;You start walking magically.
;;smwalk down
;Your magical walking wears off.
;;smwalk hits
;Your magically hastened movement allows you to strike additional blows.


