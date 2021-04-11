# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CLOCK_IN" -parent ${Page_0}
  set CLOCK_OUT [ipgui::add_param $IPINST -name "CLOCK_OUT" -parent ${Page_0}]
  set_property tooltip {Clock Out ferquency} ${CLOCK_OUT}


}

proc update_PARAM_VALUE.CLOCK_IN { PARAM_VALUE.CLOCK_IN } {
	# Procedure called to update CLOCK_IN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLOCK_IN { PARAM_VALUE.CLOCK_IN } {
	# Procedure called to validate CLOCK_IN
	return true
}

proc update_PARAM_VALUE.CLOCK_OUT { PARAM_VALUE.CLOCK_OUT } {
	# Procedure called to update CLOCK_OUT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLOCK_OUT { PARAM_VALUE.CLOCK_OUT } {
	# Procedure called to validate CLOCK_OUT
	return true
}


proc update_MODELPARAM_VALUE.CLOCK_IN { MODELPARAM_VALUE.CLOCK_IN PARAM_VALUE.CLOCK_IN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLOCK_IN}] ${MODELPARAM_VALUE.CLOCK_IN}
}

proc update_MODELPARAM_VALUE.CLOCK_OUT { MODELPARAM_VALUE.CLOCK_OUT PARAM_VALUE.CLOCK_OUT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLOCK_OUT}] ${MODELPARAM_VALUE.CLOCK_OUT}
}

