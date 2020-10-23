;;Effects which are common throughout the mud, no matter
;;what character is played.  Note that prots should be
;;stored in ee.zombie.prots.tf
/loaded ee.zombie.common.tf

;;/eff_def -i"" -n"" -t \
;; -m"down" -c"Common" \
;; -u"" \
;; -d""

/eff_def -i"poison" -n"Poison" \
 -m"up" -c"Common" \
 -u"(.*) poisoned you!" \
 -d"(.*) neutralizes the poison in your veins."

;;mist haze

;;curse

;;infravision
/eff_def -i"infra" -n"Infravision" \
 -m"down" -c"Common" \
 -u"You feel like you can see in the dark." \
 -d"Your vision is a bit less red."
