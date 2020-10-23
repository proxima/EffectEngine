;;This defines a common prefix which is inserted before every
;;trigger.  It allows us to ignore spoof messages which don't
;;appear either directly after a prompt (ending with >) or on
;;a new line.

/set eff_prefix=(> |^)

;;This defines how long an effect will stay in the reports without
;;it being re-set.  Basically allows effectts which aren't being
;;used to fall out of the report list without the user clearing them.
;;This is set to half an hour by default

/set eff_timeout=1800

;;This defines a limit for duration of effects.  Basically it's here
;;to exclude stupid durations being set against effects when they
;;are caused by bugs or missing up/down messages.  Durations greater
;;that this will be ignored.

/set eff_duration_sanity_limit=100000

;;This defines the default priority of all triggers defined by the
;;effect engine.  You can override this setting with the -p flag
;;of eff_def.

/set eff_priority=100

;;Effect communication channel
;;If unset, or set to 'echo', will echo effect messages to the screen
;;using tf's 'echo' command.  If set to anything else, will prepend
;;all outgoing messages with the value of %eff_com

/set eff_com=echo

;;Effect messages default.
;;This defines which messages will be shown for all effects
;;which do not define this themselves with the -m flag.
/set eff_messages_default="down,ready"

;;Message icons
;;These are prepended to appropriate messages.
;;Setting eff_icons to 0 turns these off.
/set eff_icons=1
/set eff_icon_up=[+]
/set eff_icon_down=[-]
/set eff_icon_warning=[!]
/set eff_icon_report=[#]
/set eff_icon_ready=[^]

;;Attributes given to lines matching up/down/ready messages.
/set eff_attr_up=BCGreen
/set eff_attr_down=BCRed
/set eff_attr_ready=BCBlue

;;This comes later, maybe?  Have to define a trig which
;;just highlights the message produced for the warning.
/set eff_attr_warning=BCMagenta

;;Message formats
;;These are special message formats which are used to report
;;on the status of the events in the engine.  Variables are
;;replaced, conditional statements are evualuated and finally
;;special character tags are replaced.

;;Short report format

/set eff_msg_short=\
        <effect_id>[<effect_stackable>\
                ?<lsb><effect_count><rsb>\
                :\
        ]\
        [<effect_timed>\
                ?[<effect_count>\
                        ?<lsb><effect_time>/<effect_duration><rsb>\
                        :<lsb>[<effect_has_ready>?[<effect_ready>?DOWN:WAIT]:DOWN]/<effect_duration><rsb>\
                ]\
                :[<effect_count>\
                        ?[<effect_stackable>\
                                ?\
                                :<lsb>UP<rsb>\
                        ]\
                        :[<effect_stackable>\
                                ?\
                                :<lsb>[<effect_has_ready>?[<effect_ready>?DOWN:WAIT]:DOWN]<rsb>\
                        ]\
                ]\
        ]\

;;Long report format

/set eff_msg_long=\
        <effect_name>[<effect_timed>\
                ?[<effect_count>\
                        ? is up. It will fall in <effect_drops>s.\
                        : is DOWN. Duration was <effect_duration>s.\
                ]\
                :[<effect_count>\
                        ?[<effect_stackable>\
                                ?\
                                : is up.\
                        ]\
                        :[<effect_stackable>\
                                ?\
                                : is DOWN.\
                        ]\
                ]\
        ]\
        [<effect_stackable>\
                ? Count<c> <effect_count>.\
                :\
        ]\

;;Up message

/set eff_msg_up=<effect_name> up.[<effect_stackable>? Count<c> <effect_count>:][<effect_timed>? Expected duration<c> <effect_duration>:]

;;Down message

/set eff_msg_down=<effect_name> down.[<effect_stackable>? Count<c> <effect_count>:][<effect_timed>? Duration<c> <effect_duration>:]

;;Force down message

/set eff_msg_force_down=Forcing <effect_name> down!

;;Warning message

/set eff_msg_warning=Warning!! <effect_name> will drop in <effect_warning> seconds!!

;;Ready message

/set eff_msg_ready=<effect_name> is ready to go!
