#include <stdio.h>
#include <sleep.h>
#include "xparameters.h"
#include "xil_printf.h"
#include "Switch_to_LED.h"

#define SWITCH_TO_LED_ADDR		XPAR_SWITCH_TO_LED_0_S00_AXI_BASEADDR

int main()
{
	int LEDOutputData = 0;
	int SwitchInputData = 0;
	int Status = 0;

	Status = SwitchToLed_Initialize(SWITCH_TO_LED_ADDR);
	if(Status != XST_SUCCESS)
	{
		xil_printf("Switch to LED IP Initialize error!\r\n");
		return XST_FAILURE;
	}

	while(1)
	{
		// User Program Here
		SwitchInputData = SwitchToLed_ReadSwitchData(SWITCH_TO_LED_ADDR);
		xil_printf("Switch Input Data = 0x%1X\r\n",SwitchInputData);

		sleep(1);
		// User Program End
	}

	return 0;
}
