/loaded ee.aliases.tf

;;These aliases are kept in a separate file to the main
;;effect engine, because they do not beed to be reloaded
;;at any stage.  This avoids the 'redefined ...' spam
;;from them when you reload the effect engine.

/def er = /eff_rep %*
/def err = /eff_rep
/def ers = /eff_rep
/def erl = /eff_rep -v

