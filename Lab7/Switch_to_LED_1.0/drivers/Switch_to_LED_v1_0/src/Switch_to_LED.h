
#ifndef SWITCH_TO_LED_H
#define SWITCH_TO_LED_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
#include "xil_io.h"

#define SIDR_OFFSET 0
#define LODR_OFFSET 4
#define LODCR_OFFSET 8
#define SWITCH_TO_LED_S00_AXI_SLV_REG3_OFFSET 12


/**************************** Type Definitions *****************************/
/**
 *
 * Write a value to a SWITCH_TO_LED register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the SWITCH_TO_LEDdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void SWITCH_TO_LED_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define SWITCH_TO_LED_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a SWITCH_TO_LED register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the SWITCH_TO_LED device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 SWITCH_TO_LED_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define SWITCH_TO_LED_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the SWITCH_TO_LED instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus SWITCH_TO_LED_Reg_SelfTest(void * baseaddr_p);

int SwitchToLed_Initialize(unsigned int baseaddr);
int SwitchToLed_ReadSwitchData(unsigned int baseaddr);
int SwitchToLed_WriteLedData(unsigned int baseaddr, int data);
int SwitchToLed_SetLedDataControl(unsigned int baseaddr, int data);

#endif // SWITCH_TO_LED_H
