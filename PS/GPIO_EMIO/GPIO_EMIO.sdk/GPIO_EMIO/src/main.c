/*
 * main.c
 *
 *  Created on: 2023��4��21��
 *      Author: bcl
 */

#include <stdio.h>
#include "xparameters.h"
#include "xgpiops.h"
#include "xstatus.h"
#include "xplatform_info.h"
#include <xil_printf.h>
#include "sleep.h"

//�豸ID
#define GPIO_DEVICE_ID  	XPAR_XGPIOPS_0_DEVICE_ID

//����LED�ܽ�
#define GPIO_MIO_LED0		0
#define GPIO_MIO_PSLED0		7

//���ð����ܽ�
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

	//��ʼ��GPIO������

	//�����豸ID,��������������Ϣ
	ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
	//��ʼ��GPIO����
	Status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr,
					ConfigPtr->BaseAddr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	//��GPIO����Ϊ���ģʽ
	XGpioPs_SetDirectionPin(&Gpio,GPIO_MIO_LED0,1);
	XGpioPs_SetDirectionPin(&Gpio,GPIO_MIO_PSLED0,1);

	//�������ʹ��
	XGpioPs_SetOutputEnablePin(&Gpio,GPIO_MIO_LED0,1);
	XGpioPs_SetOutputEnablePin(&Gpio,GPIO_MIO_PSLED0,1);

	//����GPIO����Ϊ����ģʽ
	XGpioPs_SetDirectionPin(&Gpio,GPIO_MIO_PSKEY0,0);
	XGpioPs_SetDirectionPin(&Gpio,GPIO_EMIO_PLKEY0,0);

	//Ĭ��LEDϨ��
	XGpioPs_WritePin(&Gpio,GPIO_MIO_LED0,0);
	XGpioPs_WritePin(&Gpio,GPIO_MIO_PSLED0,0);

	while(1)
	{
		//PL�������ƺ��İ��LED
		KeyvaluePL = XGpioPs_ReadPin(&Gpio,GPIO_EMIO_PLKEY0);
		XGpioPs_WritePin(&Gpio,GPIO_MIO_LED0,~KeyvaluePL);

		//PS�������Ƶװ�PS��LED
		KeyvaluePS = XGpioPs_ReadPin(&Gpio,GPIO_MIO_PSKEY0);
		XGpioPs_WritePin(&Gpio,GPIO_MIO_PSLED0,~KeyvaluePS);
	}

	return 0;
}