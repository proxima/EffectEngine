/loaded common.tf

;;This is used in various places to return the value of a variable
;;whose name is supplied.  Unfortunately, the syntax is horrible.
;;Eg:
;;/set var_name=foo
;;/set var_foo=2
;;
;;then $(/getval %%var_%{var_name}) will return 2
;;/def getval = /eval /echo %{1}

/def -i getval = /result %{*}


;;Debug Print

/def -i dp=/if ({debug}) /eval /echo # [Debug] %{*}%;/endif

