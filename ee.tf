/_echo * Loading Effect Engine v1.8 [ 23 Oct 2020 ]
/_echo * Created by Musashi
/_echo * Refer to file "_readme effect_engine.txt" for help.
;;maybe /eff_help *?
/loaded ee.tf

/set EffectEngineVersion=1.7

;;TODO list
;;[ ] /eff_help
;;[ ] Define patterns for up/down/ready/warning/force down messages.
;;[ ] Change up/down macros to use up/down message formats! :P
;;[X] Define pattern for long report messages.
;;[ ] Evidential effect-setting (**Hard!).
;;[X] Run known macro on up/down/ready to allow user to do stuff.
;;[X] Pass params to known macros (above) based on pattern.
;;    * Note that the parameter positions may be changed by the common prefix (eg: (> |^))
;;[ ] Allow timeout limits (for dropping out of reports) to be set per effect.
;;[X] Icons on everything.
;;[ ] Fix problems with restarting tf while effects are up/down. (Is this possible?!)
;;[ ] Add persistence of current effect state to file (for reloading on link drop etc).
;;[/] Eliminate all warnings.
;;[X] List all effects (allow pattern match on id or specific criteria).
;;[X] Add 'WAIT' status for effects with 'ready' message.
;;[X] Ensure eff_com is always used, rather than just echo.
;;[X] Add colours/attributes to up/down/ready messages.
;;[ ] Add colours/attributes to warning messages (on echo only).
;;[ ] Add colours for levels, which override colours for messages.
;;[ ] Kill warning processes if effect falls befure warning comes.
;;[X] Using a different output channel on a report-by-report basis.  Ie: /eff_rep -o"echo" 
;;    or /eff_rep -o"party say", or even /eff_rep -o<prot_channel> which would take the value
;;    of the supplied string and prepend it to the report output (rather than use eff_com).
;;[ ] Don't reset counters on reload of eff_defs.
;;[ ] Reset macros to reset counters.
;;[ ] Reload file macro with/without resetting counters.
;;[ ] Check for existing definition before redefining (use num of old as id for new).
;;[ ] Attributes on per-effect basis.  Ie: highlight trigging line with user-defined attributes.
;;[X] eff_messages_default: default values for 'messages' (up,down,ready).
;;[X] Defaults/settings in separate file.
;;[X] Default trig priority.
;;[X] Custom priority with -p flag on eff_def.
;;[X] eff_dropall: drops all current effects
;;[ ] eff_refresh: reloads all eff_def files.
;;[ ] eff_clear: clear all effects 
;;[ ] eff_clear_all: all effects and their counters
;;[X] ers and erl: eff report short and eff report long aliases.
;;[ ] Variable durations for effects to use average time. (**Hard!)
;;[ ] eff_rep_default: Sets the default arguments passed to eff_rep.
;;[X] Timing of all stacked effects.
;;[X] -f flag to force effects to drop after a period of time.
;;[ ] Sanity checks for flag combinations (-f requires -e etc)
;;[ ] Check that passing parameters goes through to force downs/etc
;;[ ] Defaults for a heap of things
;;[X] Add status bar handling.
;;[X] Move icon handling to eff_com
;;[X] Added -z option to eff_def for defining world

;;Load global effect engine settings from a separate file.
;;You really shouldn't ever need to edit anything other than
;;the values in the settings file.  Everything in this file
;;is code and shouldn't be touched unless you really, really
;;know what you are doing.
/load -q ee.settings.tf

;;When reloading this file, purge all previous definitions
/purge eff_*
/purge effect_*

;;Load some functions from a common resource file
/require -q common.tf

;;Have to reload this, as the purges above will have removed them
/load -q ee.aliases.tf

;;Prints an error message for the effect engine.
;;Arguments are: name of calling method, message
/def eff_err = \
  /let debug=0%;\
  /dp dp var count: %{#}%;\
  /let s=# %{1}%;\
  /shift%;\
  /let s=%{s}: %{*}%;\
  /_echo %{s}%;\
  /return 0

;;This keeps a count of the number of effects defined by the engine
/set eff_count=0

;;Returns a value indicating whether a message should be shown for
;;an effect for a particular event (up/down/ready)
/def eff_show_message = \
	/if (strstr($(/getval effect_%{1}_messages),{2})!=-1) /return 1%;/else /return 0%;/endif

/def eff_def = \
	/let debug=0%;\
	/if (!getopts("a:c:d:e:fi:l#m:n:op:#qr:stu:w#z")) /return 0%;\
		/endif%;\
	/if (strstr({opt_i}, " ") != -1) \
		/return $[eff_err({0}, strcat("Can't create '", {opt_i}, " - id may not contain spaces."))]%;\
		/endif%;\
	/if ((strlen({opt_i}) * strlen({opt_n}) * strlen({opt_u})) == 0) \
		/return $[eff_err({0}, strcat("Can't create '", {opt_i}, "' - id, name and up message must all be defined."))]%;\
		/endif%;\
	/if ({opt_w}) /let opt_t=1%;\
		/endif%;\
	/dp Defining: %{opt_i}%;\
	/set eff_reset_state=1%;\
	/if (eff_reset_state) \
		/set effect_%{opt_i}_count=0%;\
		/set effect_%{opt_i}_time=0%;\
		/set effect_%{opt_i}_duration=%{opt_e-0}%;\
		/set effect_%{opt_i}_start=0%;\
	/endif%;\
	/set effect_%{opt_i}_id=%{opt_i}%;\
	/set effect_%{opt_i}_name=%{opt_n}%;\
	/set effect_%{opt_i}_stackable=%{opt_s-0}%;\
	/set effect_%{opt_i}_timed=%{opt_t-0}%;\
	/set effect_%{opt_i}_warn=%{opt_w-0}%;\
	/set effect_%{opt_i}_num=%{eff_count}%;\
	/set effect_%{opt_i}_categories=%{opt_c}%;\
	/set effect_%{opt_i}_level=%{opt_l-1}%;\
	/set effect_%{opt_i}_attributes=%{opt_a}%;\
	/set effect_%{opt_i}_messages=%{opt_m-$[{eff_messages_default}]}%;\
	/set effect_%{opt_i}_force_down=%{opt_f-0}%;\
	/set effect_%{eff_count}=%{opt_i}%;\
	/set eff_count=$[eff_count+1]%;\
	/def effect_%{opt_i}_up_trig=%;\
	/def effect_%{opt_i}_down_trig=%;\
	/def effect_%{opt_i}_ready_trig=%;\
	/if (!{opt_p}) /let opt_p=%{eff_priority}%;\
	/endif%;\
	/if (!{opt_z}) /let opt_z=%;\
	/endif%;\
	/def -p%{opt_p} -w%{opt_z} -F -a%{eff_attr_up} -mregexp -t`%{eff_prefix}%{opt_u}` effect_%{opt_i}_up = \
		/eff_up %{opt_i}%%;\
		/test effect_%{opt_i}_up_trig("%%{P1}", "%%{P2}", "%%{P3}", "%%{P4}", "%%{P5}", "%%{P6}", "%%{P7}", "%%{P8}","%%{P9}")%;\
	/if (!{opt_f}) \
		/def -p%{opt_p} -F -a%{eff_attr_down} -mregexp -t`%{eff_prefix}%{opt_d}` effect_%{opt_i}_down = \
			/eff_down %{opt_i}%%;\
			/test effect_%{opt_i}_down_trig("%%{P1}", "%%{P2}", "%%{P3}", "%%{P4}", "%%{P5}", "%%{P6}", "%%{P7}", "%%{P8}","%%{P9}")%%;\
			/set effect_%{opt_i}_ready=0%;\
	/endif%;\
	/set effect_%{opt_i}_ready=1%;\
	/if ({opt_r}!~"") \
		/set effect_%{opt_i}_has_ready=1%;\
		/def -p%{opt_p} -F -a%{eff_attr_ready} -mregexp -t`%{eff_prefix}%{opt_r}` effect_%{opt_i}_ready = \
			/eff_ready %{opt_i}%%;\
			/test effect_%{opt_i}_ready_trig("%%{P1}", "%%{P2}", "%%{P3}", "%%{P4}", "%%{P5}", "%%{P6}", "%%{P7}", "%%{P8}","%%{P9}")%%;\
			/set effect_%{opt_i}_ready=1%;\
	/endif%;\
	/if (!{opt_q}) \
		/dp Defined: %{opt_i} as %{opt_n}%;\
	/endif

;;Executes when an effect goes up.  This will start timers, increment count
;;vars and optionally send a message to indicate the effect went up.

/def eff_up = \
	/let debug=0%;\
	/let stackable=$(/getval effect_%{1}_stackable)%;\
	/let count=$(/getval effect_%{1}_count)%;\
	/let count=$[{count} + 1]%;\
	/dp Going up: %{1}%;\
	/if ({stackable}) \
		/set effect_%{1}_count=$[{count}]%;\
		/dp %{1} count: %{count}%;\
	/else \
		/set effect_%{1}_count=1%;\
	/endif%;\
	/if ({count} > 1) \
		/set effect_%{1}_start_%{count}=$[time()]%;\
	/else \
		/set effect_%{1}_start=$[time()]%;\
	/endif%;\
;;	/if ($(/getval effect_%{1}_timed) & ($(/getval effect_%{1}_timing_stack) == -1 | $(/getval effect_%{1}_timing_stack)=~"")) \
;;		/set effect_%{1}_start=$[time()]%;\
;;		/set effect_%{1}_timing_stack=%{count}%;\
;;	/endif%;\
	/let duration=$(/getval effect_%{1}_duration)%;\
	/let warn=$(/getval effect_%{1}_warn)%;\
	/if ({warn} & {duration}) \
;;		/let name=$(/getval effect_%{1}_name)%;\
		/let rep_time=$[{duration} - {warn}]%;\
        /if ({rep_time} < 1) /let rep_time=1%;/endif%;\
;;TODO: Get process id so we can kill the warning if effect falls before the warning is due
		/repeat -%{rep_time} 1 /eff_warning %{1}%;\
	/endif%;\
	/if (eff_show_message({1}, "up")) \
		/let msg=$(/eval /_echo %%effect_%{1}_name up.)%;\
		/dp %{msg}%;\
		/if ({stackable}) /let count_msg=$[strcat(" Count: ", {count}, ".")]%;\
			/endif%;\
		/if ($(/getval effect_%{1}_timed) & {duration}!=0) /let duration_msg=$[strcat(" Expected duration: ", $(/getval effect_%{1}_duration),"s.")]%;\
			/endif%;\
		/eff_com -i"up" $[strcat({msg}, {count_msg}, {duration_msg})]%;\
	/endif%;\
	/dp $(/getval effect_%{1}_force_down)%;\
	/if ($(/getval effect_%{1}_force_down)) \
		/repeat -%{duration} 1 /eff_force_down %{1}%;\
	/endif

;;Called by a timer set when the effect goes up.  If the effect
;;has not dropped by the time the timer expects it to, this will
;;force the effect to appear like it went down.  This means that
;;the -f (force down) flag should NEVER be used with effects which
;;will actually give a down message, since this will screw up
;;the counts.

;;TODO: message format for forcing.

/def eff_force_down = \
  /let name=$(/getval effect_%{1}_name)%;\
  /eff_com -i"warning" $[strcat("Forcing ", {name}, " down!")]%;\
  /eff_down %{1}

;;Executes when an effect goes down.  This will end timers, set durations, 
;;decrement count vars and optionally send a message to indicate the effect
;;down.

/def eff_down = \
  /let msg=$(/eval /_echo %%effect_%{1}_name down.)%;\
  /let count=$[$(/getval effect_%{1}_count) - 1]%;\
  /if ({count} < 0) /let count=0%;\
  /endif%;\
  /set effect_%{1}_count=$[{count}]%;\
  /if ($(/getval effect_%{1}_stackable)) \
    /let count_str=$[strcat(" Count: ", {count},".")]%;\
  /endif%;\
  /if ($(/getval effect_%{1}_timed)) \
    /let prev_duration=$(/getval effect_%{1}_duration)%;\
    /let duration=$[trunc(time() - $(/getval effect_%{1}_start))]%;\
    /if ({duration} > {eff_duration_sanity_limit}) \
      /let duration=$[{prev_duration}]%;\
    /endif%;\
    /set effect_%{1}_duration=$[{duration}]%;\
    /let duration_str=$[strcat(" Duration: ", {duration},"s.")]%;\
    /let i=2%;\
    /if ({count} > 0) \
      /set effect_%{1}_start=$(/getval effect_%{1}_start_2)%;\
    /endif%;\
    /while ({i} < ({count} + 2)) \
      /let j=$[i+1]%;\
      /set effect_%{1}_start_%{i}=$(/getval effect_%{1}_start_%{j})%;\
      /let i=$[i+1]%;\
    /done%;\
  /endif%;\
;;  /kill $(getval effect_%{1}_warn_proc)%;\
  /set effect_%{1}_activity=$[time()]%;\
  /if ($(/getval effect_%{1}_ready)!~"") \
    /set effect_%{1}_ready=0%;\
  /endif%;\
  /if (eff_show_message({1}, "down")) \
    /eff_com -i"down" $[strcat({msg}, {count_str}, {duration_str})]%;\
  /endif

/def eff_ready = /let msg=$(/eval /_echo %%effect_%{1}_name is ready to go!)%;\
  /eff_com -i"ready" $[strcat({msg}, {count_str}, {duration_str})]%;\
  /set effect_%{1}_ready=1

/def eff_warning = /let msg=$(/eval /_echo Warning!! %%effect_%{1}_name will fall in)%;\
	/let secs=$(/eval /_echo %%effect_%{1}_warn seconds!!)%;\
	/eff_com -i"warning" $[strcat({msg}, " ", {secs})]

;/def eff_warning = /let msg=$(/eval /echo -aBCYellow Warning!! %%effect_%{1}_name will fall in)%;/let secs=$(/eval /echo -aBCYellow %%effect_%{1}_warn seconds!!)%;/eff_com -i"warning" $[strcat({msg}, " ", {secs})]

;;Prepends the appropriate icon to a given message
/def eff_icon = \
  /return "$[strrep(strcat($(/getval eff_icon_%{1}), " "), {eff_icons})]"

;;Sends a message to the current effect engine communications channel.
;;This is echo by default, but may be set to anything.
;;Icons are automatically added to the front of
;;May be called with -s to suppress icon
/def eff_com = \
  /if (!getopts("i:", "")) /return 0%;\
    /endif%;\
  /if ({opt_i}!~"" & {eff_icons} & strlen({*})) \
    /let s=$[strcat(eff_icon({opt_i}), "", {*})]%;\
  /endif%;\
  /if ({eff_com} =~ "echo" | {eff_com} =~ "") \
    /_echo %{s}%;\
  /else \
    /send %{eff_com} %{s}%;\
  /endif

;;The effect message parser.  This calls the variable
;;replacement method, the condition evaluation method
;;and finally the special character replacement method
;;to parse effect engine strings to produce nice output.
;;It will turn things like: 
;;[<effect_sop_count>?<effect_sop_name> up!:<effect_sop_name> down!]
;;into "Shield of protection up!" or "Shield of protection down!"
;;depending on the value of the variables sop_count and sop.
;;If a second argument is supplied - the id of an effect - all
;;generic tags (<effect_count>) are replaced with id-specific
;;tags (<effect_aog_count>).  Note this means that mixtures of
;;specific and generic tags won't work as <effect_sop_count>
;;would be replaced with <effect_aog_sop_count>.

;;Arguments: 
;; Message to parse and return.
;; (Optional) id of effect.

/def eff_msg = \
  /let msg=%{1}%;\
  /if ({#} > 1) \
    /let msg=$[replace("<effect_", strcat("<effect_", {2}), {msg})]%;\
  /endif%;\
  /let msg=$[eff_replace_vars({msg})]%;\
  /let msg=$[eff_evaluate_conditions({msg})]%;\
  /let msg=$[eff_replace_chars({msg})]%;\
  /result "%{msg}"

;;Replaces any text tagged with < and > with the value
;;of the variable having a name identical to the text
;;so bracketed.  Eg, <tag> will be replaced with the
;;value of the variable "tag".
;;Note that this DOES allow for nested variables - ie
;;if the value of "tag" is "<tag2>", then "<tag>" will
;;be replaced with the value of "tag" ("<tag2>"), then
;;that will be replaced with the value of "tag2".
;;To prevent this sort of nested evaluation (for example
;;if you want to put a literal "<" in the value of one
;;of your variables, place a ":" as the first character
;;in the tag.  Eg: If "mytag" has the value "<hi>" then
;;using "<:mytag>" will insert "<hi>", rather than the
;;value of the variable "hi".

/def eff_replace_vars = \
  /let debug=0%;\
  /let msg=%{*}%;\
  /let var_start=$[strstr({msg}, "<")]%;\
  /let parse_start=0%;\
  /while ({var_start} != -1 & {var_start} >= {parse_start}) \
    /dp var_start: %{var_start}%;\
    /let msg_rem=$[substr({msg}, {var_start} + 1)]%;\
    /if (strstr({msg_rem}, ">") == -1) \
      /return $[eff_err({0}, strcat("Unclosed tag, started at '", substr({msg}, {var_start}, 10), "...'."))]%;\
    /endif%;\
    /if (strstr({msg_rem}, " ") != -1 & strstr({msg_rem}, " ") < strstr({msg_rem}, ">") & strstr({msg_rem}, " " > {var_start})) \
      /return $[eff_err({0}, strcat("Space found in tag, started at '", substr({msg}, {var_start}, 10), "...'."))]%;\
    /endif%;\
    /let var_name=$[substr({msg}, {var_start} + 1, {parse_start} + strstr(substr({msg}, {parse_start}), ">") - {var_start} - 1)]%;\
    /dp var_name: %{var_name}%;\
    /if (substr({var_name}, 0, 1) =~ ":") \
      /let set_parse_start=1%;\
      /let var_name=$[replace(":","",{var_name})]%;\
    /endif%;\
    /dp var_name: %{var_name}%;\
    /if (strstr({eff_special_tags}, {var_name}) != -1) \
      /let var_value=$[strcat("<", {var_name}, ">")]%;\
      /let set_parse_start=1%;\
    /else \
      /let var_value=$[getval({var_name})]%;\
    /endif%;\
    /dp var_value: %{var_value}%;\
    /if ({set_parse_start}) \
      /let parse_start=$[{var_start} + strlen({var_value})]%;\
      /let var_name=$[strcat(":",{var_name})]%;\
      /dp parse_start: %{parse_start}%;\
      /let set_parse_start=0%;\
    /endif%;\
    /let msg=$[replace(strcat("<", {var_name}, ">"), {var_value}, {msg})]%;\
    /dp replaced %{var_name}: %{msg}%;\
    /let var_start=$[{parse_start} + strstr(substr({msg}, {parse_start}), "<")]%;\
  /done%;\
  /result "%{msg}"

/def eff_set_time = \
    /let this_start=$(/getval effect_%{1}_start)%;\
    /set effect_%{1}_time=$[trunc(time() - {this_start})]%;\
    /let duration=$(/getval effect_%{1}_duration)%;\
    /if ({duration}) \
      /set effect_%{1}_drops=$[{duration} - (time() - {this_start})]%;\
    /endif
  

;;Checks a string to see if it can be evaluated by
;;evaluate_conditions().  Basically checks that the
;;bracket and other special character counts are
;;valid.

/def eff_check_conditions = \
  /_echo implement this!

;;Evaluates conditional statements in form:
;;[<if_part>?<true_part>:<false_part>]
;;If 'if_part' evaluates to 1, true_part is
;;returned, otherwise false_part is returned.
;;The string may contain multiple conditional
;;statements and they may be nested within
;;each other.

/def eff_evaluate_conditions = \
  /let debug=0%;\
  /let msg=%{*}%;\
  /let if_start=$[strstr({msg}, "[")]%;\
  /while ({if_start}!=-1) \
    /dp START WHILE: %{msg}%;\
    /let msg_rem=$[substr({msg}, {if_start} + 1)]%;\
    /let position=$[{if_start} + 1]%;\
    /dp msg_rem: %{msg_rem}%;\
    /if (strstr({msg_rem}, "[") != -1 & strstr({msg_rem}, "[") < strstr({msg_rem}, "?")) \
      /dp NESTING IN IF, PASSING: %{msg_rem}%;\
      /let msg=$[strcat(substr({msg}, 0, {position}), eff_evaluate_conditions({msg_rem}))]%;\
      /dp OUT OF NESTING IN IF, GOT: %{msg}%;\
    /elseif (strstr({msg_rem}, "?") == -1) \
      /return $[eff_err({0}, strcat("No '?' found in '", {msg_rem}, "'."))]%;\
    /elseif (strstr({msg_rem}, ":") == -1) \
      /return $[eff_err({0}, strcat("No ':' found in '", {msg_rem}, "'."))]%;\
    /elseif (strstr({msg_rem}, "]") == -1) \
      /return $[eff_err({0}, strcat("No ']' found in '", {msg_rem}, "'."))]%;\
    /elseif (strstr({msg_rem}, ":") < strstr({msg_rem}, "?")) \
      /return $[eff_err({0}, strcat("Found ':' before '?' in '", {msg_rem}, "'."))]%;\
    /else \
      /let if_part=$[substr({msg_rem}, 0, strstr({msg_rem}, "?"))]%;\
      /let position=$[{position} + strlen({if_part}) + 1]%;\
      /dp if_part: %{if_part}%;\
      /let msg_rem=$[substr({msg_rem}, strlen({if_part}) + 1)]%;\
      /if (strstr({msg_rem}, "[") != -1 & strstr({msg_rem}, "[") < strstr({msg_rem}, ":")) \
        /dp NESTING IN TRUEPART, PASSING: %{msg_rem}%;\
        /let msg=$[strcat(substr({msg}, 0, {position}), eff_evaluate_conditions({msg_rem}))]%;\
        /dp OUT OF NESTING IN TRUEPART, GOT: %{msg}%;\
      /elseif (strstr({msg_rem}, ":") == -1) \
        /return $[eff_err({0}, strcat("No ':' found in '", {msg_rem}, "'."))]%;\
      /elseif (strstr({msg_rem}, "]") == -1) \
        /return $[eff_err({0}, strcat("No ']' found in '", {msg_rem}, "'."))]%;\
      /else \
        /let true_part=$[substr({msg_rem}, 0, strstr({msg_rem}, ":"))]%;\
        /let position=$[{position} + strlen({true_part}) + 1]%;\
        /dp true_part: %{true_part}%;\
        /let msg_rem=$[substr({msg_rem}, strlen({true_part}) + 1)]%;\
        /if (strstr({msg_rem}, "[") != -1 & strstr({msg_rem}, "[") < strstr({msg_rem}, "]")) \
          /dp NESTING IN FALSEPART, PASSING: %{msg_rem}%;\
          /let msg=$[strcat(substr({msg}, 0, {position}), eff_evaluate_conditions({msg_rem}))]%;\
          /dp OUT OF NESTING IN TRUEPART, GOT: %{msg}%;\
        /elseif (strstr({msg_rem}, "]") == -1) \
          /return $[eff_err({0}, strcat("No ']' found in '", {msg_rem}, "'."))]%;\
        /else \
          /let false_part=$[substr({msg_rem}, 0, strstr({msg_rem}, "]"))]%;\
          /dp false_part: %{false_part}%;\
          /let msg_rem=$[substr({msg_rem}, strlen({false_part}) + 1)]%;\
          /if ({if_part} <= 0) \
            /let msg=$[replace(strcat("[", {if_part}, "?", {true_part}, ":", {false_part}, "]"), {false_part}, {msg})]%;\
          /else \
            /let msg=$[replace(strcat("[", {if_part}, "?", {true_part}, ":", {false_part}, "]"), {true_part}, {msg})]%;\
          /endif%;\
        /endif%;\
      /endif%;\
    /endif%;\
    /let if_start=$[strstr({msg}, "[")]%;\
    /dp END OF WHILE: %{msg}%;\
    /dp if_start: %{if_start}%;\
  /done%;\
  /dp OUT OF WHILE: %{msg}%;\
  /result "%{msg}"

;;Replaces bracketed values which equate to special
;;characters used by replace_vars (<,>) and by 
;;evaluate_conditions ([,],?,:).  This should be
;;called after both those methods are called for
;;obvious reasons.

;;These values are ignored by replace_vars.  You
;;should never need to change these.
/set eff_special_tags=:lt:gt:lsb:rsb:c:q

/def eff_replace_chars = \
  /let msg=%{*}%;\
  /let msg=$[replace("<lt>", "<", {msg})]%;\
  /let msg=$[replace("<gt>", ">", {msg})]%;\
  /let msg=$[replace("<lsb>", "[", {msg})]%;\
  /let msg=$[replace("<rsb>", "]", {msg})]%;\
  /let msg=$[replace("<c>", ":", {msg})]%;\
  /let msg=$[replace("<q>", "?", {msg})]%;\
  /let msg=$[replace("<crlf>", strcat(char(13), char(10)), {msg})]%;\
  /result "%{msg}"

;;Reports
;;Generally offer matching to the options when defining
;;Report all effects within a particular category
;;Report all effects with count > 0
;;Report all effects with a particular severity level
;;Eg:
;;/eff_rep -l4 : All effects with severity level 4
;;/eff_rep -u  : All effects which are up (count > 0).
;;/eff_rep -d  : All effects which are down (count = 0).
;;/eff_rep -c"Fighter" : All effects in 'Fighter' category.
;; -b  : Brief format
;; -v  : Verbose format
;; -i"sop" : Effect with id "sop"
;; -a  : Include all effects, even those beyond the timeout

/def eff_rep = \
  /let debug=0%;\
  /if (!getopts("ac:di:l#n:o:stuv", "")) /return 0%;\
    /endif%;\
  /let i=0%;\
  /let s=%;\
  /if ({opt_v}) \
    /let msg_format=long%;\
  /else \
    /let msg_format=short%;\
  /endif%;\
  /if ({opt_o}!~"") \
    /dp Using %{opt_o} for output.%;\
    /let current_com=$[{eff_com}]%;\
    /set eff_com=$[{opt_o}]%;\
  /endif%;\
  /while ({i} < {eff_count}) \
    /let this_id=$(/getval effect_%{i})%;\
    /dp id: %{this_id}%;\
    /let include=1%;\
    /if ({include} & strlen({opt_i}) & ({opt_i} !~ {this_id})) \
      /dp excluded on id%;\
      /let include=0%;\
    /endif%;\
    /let this_name=$(/getval effect_%{this_id}_name)%;\
    /dp this_name: %{this_name}%;\
    /if ({include} & strlen({opt_n}) & ({opt_n} !~ {this_name})) \
      /dp excluded on name%;\
      /let include=0%;\
    /endif%;\
    /let this_count=$(/getval effect_%{this_id}_count)%;\
    /if ({include} & {opt_u} & ({this_count} < 1)) \
      /dp excluded on up%;\
      /let include=0%;\
    /endif%;\
    /if ({include} & {opt_d} & ({this_count} > 0)) \
      /dp excluded on down%;\
      /let include=0%;\
    /endif%;\
    /eff_set_time %{this_id}%;\
    /let this_activity=$(/getval effect_%{this_id}_activity)%;\
    /if ({include} & {eff_timeout} & !{opt_a} & {this_count} < 1 & ((time() - {this_activity}) > {eff_timeout})) \
      /dp excluded on activity: $[time() - {this_activity}]%;\
      /let include=0%;\
    /endif%;\
    /let this_categories=$(/getval effect_%{this_id}_categories)%;\
    /dp this_categories: %{this_categories}%;\
    /if ({include} & strlen({opt_c}) & (substr({opt_c},0,1)!~"!") & (strstr({this_categories}, {opt_c}) == -1)) \
      /dp excluded on category: %{opt_c}%;\
      /let include=0%;\
    /endif%;\
    /if ({include} & strlen({opt_c}) & (substr({opt_c},0,1)=~"!") & (strstr({this_categories}, substr({opt_c},1)) != -1)) \
      /dp excluded on NOT category: %{opt_c}%;\
      /let include=0%;\
    /endif%;\
    /let this_level=$(/getval effect_%{this_id}_level)%;\
    /dp this_level: %{this_level}%;\
    /if ({include} & strlen({opt_l}) & ({opt_l}) != {this_level})) \
      /dp excluded on level: %{opt_l}%;\
      /let include=0%;\
    /endif%;\
    /if ({include}) \
      /let this_msg=$[replace("<effect_", strcat("<effect_", {this_id}, "_"), $(/getval eff_msg_%{msg_format}))]%;\
      /dp $[eff_msg({this_msg})]%;\
      /let s=$[strcat({s}, " ", eff_msg({this_msg}))]%;\
    /endif%;\
    /let i=$[{i}+1]%;\
    /if ({msg_format}=~"long") \
      /if (strlen({s})) \
        /eff_com -i"report" %{s}%;\
      /endif%;\
      /let this_msg=%;\
      /let s=%;\
    /endif%;\
  /done%;\
  /if ({msg_format}=~"short") \
    /if (strlen({s})) \
      /eff_com -i"report" %{s}%;\
    /else \
        /eff_com "No effects."%;\
    /endif%;\
  /endif%;\
  /if ({opt_o}!~"") \
    /set eff_com=$[{current_com}]%;\
  /endif%;\

;;This drops all effects by running through all defined
;;effects and calling /eff_down per effect count
/def eff_dropall = \
  /let debug=0%;\
  /let i=0%;\
  /while ({i} < {eff_count}) \
    /let this_id=$(/getval effect_%{i})%;\
    /dp id: %{this_id}%;\
    /let this_name=$(/getval effect_%{this_id}_name)%;\
    /dp this_name: %{this_name}%;\
    /let this_count=$(/getval effect_%{this_id}_count)%;\
    /if ({this_count} > 0) \
      /dp Would reset: %{this_name}%;\
      /dp /repeat %{this_count} /eff_down %{this_name}%;\
      /repeat %{this_count} /eff_down %{this_id}%;\
    /endif%;\
    /let i=$[{i}+1]%;\
  /done%;\
  /echo * Dropped all effects.


;;This comes later, maybe?  Have to define a trig which
;;just highlights the message produced for the warning.
/set eff_attr_warning=BCMagenta

/def eff_list = \
  /let debug=0%;\
  /let args=%{*}%;\
  /if (!getopts("ac:di:l#n:o:stuv", "")) /return 0%;\
    /endif%;\
  /let i=0%;\
  /let count=0%;\
  /_echo $[strrep("=", 50)]%;\
  /_echo # You have %{eff_count} effects defined.%;\
  /if (!{opt_v}) \
    /_echo $[strrep("-", 50)]%;\
  /endif%;\
  /while ({i} < {eff_count}) \
;;a:c:d:i:l#m:n:o#qr:stu:w# 
    /let include=$(/eff_matches_criteria -a %{args} %{i})%;\
    /dp include: %{include}%;\
    /if ({include}) \
      /let id=$(/getval effect_%{i})%;\
      /let count=$[{count} + 1]%;\
      /if ({opt_v}) \
        /eff_info %{id}%;\
      /else \
        /eval /echo $(/getval effect_%{id}_name) (id: %{id})%;\
      /endif%;\
    /endif%;\
    /let i=$[{i}+1]%;\
  /done%;\
  /_echo $[strrep("=", 50)]%;\
  /echo # %{count} effect(s) matched your criteria.%;\
  /echo # Use eff_info <id> to see more about an effect.

/def eff_info = \
  /let id=%{*}%;\
  /_echo $[strrep("-", 50)]%;\
  /_echo id: %{id}%;\
  /_echo name: $(/getval effect_%{id}_name)%;\
  /_echo stackable: $(/getval effect_%{id}_stackable)%;\
  /_echo timed: $(/getval effect_%{id}_timed)%;\
  /_echo warning: $(/getval effect_%{id}_warn)%;\
  /_echo categories: $(/getval effect_%{id}_categories)%;\
  /_echo level: $(/getval effect_%{id}_level)%;\
  /_echo messages: $(/getval effect_%{id}_messages)

;;Determines whether a given effect definition
;;matches the criteria supplied.
;;Criteria are: a:c:d:i:l#m:n:o#qr:stu:w#
;;The final argument should be the number of the
;;effect to test.
/def eff_matches_criteria = \
  /let debug=0%;\
  /dp %{*}%;\
  /if (!getopts("ac:di:l#n:o:stuv", "")) /return 0%;\
    /endif%;\
  /let i=%{*}%;\
  /let this_id=$(/getval effect_%{i})%;\
  /dp id: %{this_id}%;\
  /let include=1%;\
  /dp opt_i: %{opt_i}%;\
  /if ({include} & strlen({opt_i}) & ({opt_i} !~ {this_id})) \
    /dp excluded on id%;\
    /let include=0%;\
  /endif%;\
  /let this_name=$(/getval effect_%{this_id}_name)%;\
  /dp this_name: %{this_name}%;\
  /if ({include} & strlen({opt_n}) & ({opt_n} !~ {this_name})) \
    /dp excluded on name%;\
    /let include=0%;\
  /endif%;\
  /let this_count=$(/getval effect_%{this_id}_count)%;\
  /if ({include} & {opt_u} & ({this_count} < 1)) \
    /dp excluded on up%;\
    /let include=0%;\
  /endif%;\
  /if ({include} & {opt_d} & ({this_count} > 0)) \
    /dp excluded on down%;\
    /let include=0%;\
  /endif%;\
  /eff_set_time %{this_id}%;\
  /let this_activity=$(/getval effect_%{this_id}_activity)%;\
  /if ({include} & {eff_timeout} & !{opt_a} & {this_count} < 1 & ((time() - {this_activity}) > {eff_timeout})) \
    /dp excluded on activity: $[time() - {this_activity}]%;\
    /let include=0%;\
  /endif%;\
  /let this_categories=$(/getval effect_%{this_id}_categories)%;\
  /dp this_categories: %{this_categories}%;\
  /if ({include} & strlen({opt_c}) & (substr({opt_c},0,1)!~"!") & (strstr({this_categories}, {opt_c}) == -1)) \
    /dp excluded on category: %{opt_c}%;\
    /let include=0%;\
  /endif%;\
  /if ({include} & strlen({opt_c}) & (substr({opt_c},0,1)=~"!") & (strstr({this_categories}, substr({opt_c},1)) != -1)) \
    /dp excluded on NOT category: %{opt_c}%;\
    /let include=0%;\
  /endif%;\
  /let this_level=$(/getval effect_%{this_id}_level)%;\
  /dp this_level: %{this_level}%;\
  /if ({include} & strlen({opt_l}) & ({opt_l}) != {this_level})) \
    /dp excluded on level: %{opt_l}%;\
    /let include=0%;\
  /endif%;\
  /result %{include}


;;Effect Engine status bar handling

;;Numbers of seconds to wait between refreshes
/set eff_status_update_period=4

;;Commented this out, since it causes a new timer to spawn
;;every time this code file is loaded
;;/if ({eff_timer_on}~="") /set eff_timer_on=0

;;Creates a new variable named "effect_<id>_status" using the id
;;passed in, then sets the value of that variable every
;;time the effect engine status bar variables are updated
;;(as defined by eff_status_update_period).
;;
;;Eg: /eff_status_add aog "[<effect_count>?<effect_drops>s:DOWN]"
;; would create a variable called effect_aog_status
;; and update it's value to be something like
;; " 24s" or "DOWN" every time the status bar values
;; are refreshed.
;;You will need to add the status variable created
;;to the status bar yourself with something like:
;;  /set status_fields=@more:8:Br :1 @world :1 "AOG:" effect_aog_update:3

/def eff_status_add = \
  /let new_pattern=$[replace("<effect_", strcat("<effect_", {1}, "_"), {2})]%;\
  /set effect_%{1}_status_pattern=%{new_pattern}%;\
  /set effect_%{1}_status=$[eff_msg({new_pattern})]%;\
  /eff_start_timer
;;  /set eff_status_list=$[strcat(eff_status_list, {1}, ":")]

;;Removes an effect from the status bar update list
/def eff_status_remove = \
  /set eff_status_list=$[replace(strcat({1}, ":"), "", {eff_status_list})]%;\

;;Updates all the variables on the status bar which come from the
;;effect engine.
/def eff_status_update = \
  /let debug=0%;\
  /let eff_update_list=$(/listvar -sg effect_*_status)%;\
  /while (strlen({eff_update_list})) \
    /if (strstr({eff_update_list}, " ")==-1) \
      /let this_effect=%{eff_update_list}%;\
      /dp Should be last item in list%;\
    /else \
      /let this_effect=$[substr({eff_update_list}, 0, strstr({eff_update_list}, " "))]%;\
    /endif%;\
    /let this_effect=$[substr({this_effect}, strlen("effect_"))]%;\
    /let this_pattern=$(/getval effect_%{this_effect}_pattern)%;\
    /dp this_effect: %{this_effect}%;\
    /dp this_pattern: %{this_pattern}%;\
    /eff_set_time $[substr({this_effect}, 0, strlen({this_effect}) - strlen("_status"))]%;\
    /let tmp_status=$[eff_msg({this_pattern})]%;\
    /if (tmp_status!~$(/getval effect_%{this_effect})) \
      /set effect_%{this_effect}=%{tmp_status}%;\
    /endif%;\
    /let eff_update_list=$[substr({eff_update_list}, strlen("effect_") + strlen({this_effect}) + 1)]%;\
  /done%;\

/set eff_timer_started=0

/def eff_start_timer = \
  /if (!{eff_timer_started}) \
    /set eff_timer_started=1%;\
    /eff_status_timer%;\
  /endif

;;TODO: Update this to stop doing ticks if no effects need updating (how do we tell that?!?)
/def eff_status_timer = \
  /if (!{eff_timer_on}) \
    /set eff_timer_on=1%;\
    /eff_status_update%;\
    /repeat -%{eff_status_update_period} 1 /set eff_timer_on=0%%;/eff_status_timer%;\
  /endif%;\

;;Arghh tells you 'it would be cool to use colors too, 
;;i.e. when warning fires, status bar turns yellow, when down, turns red orso'
;;Arghh tells you 'hmm... in this ver, if a var text is set to a color, it uses 
;;that color in the bar'

;;Loading for testing - these sorts of load commands should be in your world file.
;;Eg:
;; /load ee.tf
;; /load ee.zombie.common.tf
;; /load ee.zombie.prots.tf
;; /load ee.zombie.paladin.tf

;;/load ee.zombie.common.tf
;;/load ee.zombie.paladin.tf
;;/load ee.zombie.prots.tf
