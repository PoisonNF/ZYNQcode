/*
 * main.c
 *
 *  Created on: 2023年4月21日
 *      Author: bcl
 */

#include <stdio.h>
#include "xparameters.h"
#include "xgpiops.h"
#include "xstatus.h"
#include "xplatform_info.h"
#include <xil_printf.h>
#include "sleep.h"


#define GPIO_DEVICE_ID  	XPAR_XGPIOPS_0_DEVICE_ID

#define GPIO_MIO_LED0		0
#define GPIO_MIO_LED7		7
#define GPIO_MIO_LED8		8

XGpioPs Gpio;
XGpioPs_Config *ConfigPtr;
int Status;

int main()
{
	printf("GPIO MIO TEST\r\n");

	//初始化GPIO的驱动

	//根据设备ID,查找器件配置信息
	ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
	//初始化GPIO驱动
	Status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr,
					ConfigPtr->BaseAddr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	//把GPIO设置为输出模式
	XGpioPs_SetDirectionPin(&Gpio,GPIO_MIO_LED0,1);
	XGpioPs_SetDirectionPin(&Gpio,GPIO_MIO_LED7,1);
	XGpioPs_SetDirectionPin(&Gpio,GPIO_MIO_LED8,1);

	//设置输出使能
	XGpioPs_SetOutputEnablePin(&Gpio,GPIO_MIO_LED0,1);
	XGpioPs_SetOutputEnablePin(&Gpio,GPIO_MIO_LED7,1);
	XGpioPs_SetOutputEnablePin(&Gpio,GPIO_MIO_LED8,1);

	while(1)
	{
		//写数据1到GPIO的引脚
		XGpioPs_WritePin(&Gpio,GPIO_MIO_LED0,1);
		XGpioPs_WritePin(&Gpio,GPIO_MIO_LED7,1);
		XGpioPs_WritePin(&Gpio,GPIO_MIO_LED8,1);

		//延时1s
		sleep(1);

		//写数据0到GPIO的引脚
		XGpioPs_WritePin(&Gpio,GPIO_MIO_LED0,0);
		XGpioPs_WritePin(&Gpio,GPIO_MIO_LED7,0);
		XGpioPs_WritePin(&Gpio,GPIO_MIO_LED8,0);

		//延时1s
		sleep(1);
	}

	return 0;
}
