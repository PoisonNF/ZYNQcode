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

//设备ID
#define GPIO_DEVICE_ID  	XPAR_XGPIOPS_0_DEVICE_ID

//配置LED管脚
#define GPIO_MIO_LED0		0
#define GPIO_MIO_PSLED0		7

//配置按键管脚
#define GPIO_MIO_PSKEY0		12
#define GPIO_EMIO_PLKEY0	54

XGpioPs Gpio;
XGpioPs_Config *ConfigPtr;
int Status;
int KeyvaluePL = 0;
int KeyvaluePS = 0;

int main()
{
	printf("GPIO EMIO TEST\r\n");

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
	XGpioPs_SetDirectionPin(&Gpio,GPIO_MIO_PSLED0,1);

	//设置输出使能
	XGpioPs_SetOutputEnablePin(&Gpio,GPIO_MIO_LED0,1);
	XGpioPs_SetOutputEnablePin(&Gpio,GPIO_MIO_PSLED0,1);

	//按键GPIO设置为输入模式
	XGpioPs_SetDirectionPin(&Gpio,GPIO_MIO_PSKEY0,0);
	XGpioPs_SetDirectionPin(&Gpio,GPIO_EMIO_PLKEY0,0);

	//默认LED熄灭
	XGpioPs_WritePin(&Gpio,GPIO_MIO_LED0,0);
	XGpioPs_WritePin(&Gpio,GPIO_MIO_PSLED0,0);

	while(1)
	{
		//PL按键控制核心板的LED
		KeyvaluePL = XGpioPs_ReadPin(&Gpio,GPIO_EMIO_PLKEY0);
		XGpioPs_WritePin(&Gpio,GPIO_MIO_LED0,~KeyvaluePL);

		//PS按键控制底板PS的LED
		KeyvaluePS = XGpioPs_ReadPin(&Gpio,GPIO_MIO_PSKEY0);
		XGpioPs_WritePin(&Gpio,GPIO_MIO_PSLED0,~KeyvaluePS);
	}

	return 0;
}
