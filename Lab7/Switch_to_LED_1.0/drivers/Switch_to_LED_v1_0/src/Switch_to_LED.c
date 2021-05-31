

/***************************** Include Files *******************************/
#include "Switch_to_LED.h"


/************************** Function Definitions ***************************/
int SwitchToLed_Initialize(unsigned int baseaddr)
{
    Xil_Out32(baseaddr + LODR_OFFSET, 0x00);
    Xil_Out32(baseaddr + LODCR_OFFSET, 0x00);
    return XST_SUCCESS;
}

int SwitchToLed_ReadSwitchData(unsigned int baseaddr)
{
    return Xil_In32(baseaddr + SIDR_OFFSET);
}

int SwitchToLed_WriteLedData(unsigned int baseaddr, int data)
{
    Xil_Out32(baseaddr + LODR_OFFSET, data);
    return XST_SUCCESS;
}

int SwitchToLed_SetLedDataControl(unsigned int baseaddr, int data)
{
    Xil_Out32(baseaddr + LODCR_OFFSET, data);
    return XST_SUCCESS;
}