#include <stdio.h>
#include "stm32f7xx_hal.h"
#include "stm32f7xx_nucleo_144.h"

static UART_HandleTypeDef UartHandle;
static EXTI_HandleTypeDef ExtiHandle;

int __io_putchar(int ch);
int _write(int file,char *ptr, int len);
static void EXTI15_10_IRQCallback(void);
static void SystemClock_Config(void);
static void Error_Handler(void);

int main(void)
{
    /* Enable the CPU caches */
    SCB_EnableICache();
    SCB_EnableDCache();

    /* Configure the system clock to 216 MHz */
    SystemClock_Config();

    /* HAL initialization */
    if (HAL_Init() != HAL_OK)
    {
        Error_Handler();
    }

    /* Configure LEDs */
    BSP_LED_Init(LED1);
    BSP_LED_Init(LED2);
    BSP_LED_Init(LED3);

    /* Configure user push button */
    __HAL_RCC_GPIOC_CLK_ENABLE();

    GPIO_InitTypeDef GPIO_InitStruct;
    GPIO_InitStruct.Mode = GPIO_MODE_IT_RISING;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Pin = GPIO_PIN_13;
    HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

    /* Configure EXTI to generate interrupt for user push button GPIO */
    EXTI_ConfigTypeDef EXTI_InitStruct;
    EXTI_InitStruct.Line = EXTI_LINE_13;
    EXTI_InitStruct.Mode = EXTI_MODE_INTERRUPT;
    EXTI_InitStruct.Trigger = EXTI_TRIGGER_RISING;
    EXTI_InitStruct.GPIOSel = EXTI_GPIOC;
    if (HAL_EXTI_SetConfigLine(&ExtiHandle, &EXTI_InitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    if (HAL_EXTI_RegisterCallback(&ExtiHandle, HAL_EXTI_COMMON_CB_ID, EXTI15_10_IRQCallback) != HAL_OK)
    {
        Error_Handler();
    }

    /* Enable the relevant EXTI interrupt for user push button GPIO */
    HAL_NVIC_EnableIRQ(EXTI15_10_IRQn);

    /* Configure UART for printf */
    UartHandle.Instance = USART3;
    UartHandle.Init.BaudRate = 115200;
    UartHandle.Init.WordLength = UART_WORDLENGTH_8B;
    UartHandle.Init.StopBits = UART_STOPBITS_1;
    UartHandle.Init.Parity = UART_PARITY_NONE;
    UartHandle.Init.HwFlowCtl = UART_HWCONTROL_NONE;
    UartHandle.Init.Mode = UART_MODE_TX_RX;
    UartHandle.Init.OverSampling = UART_OVERSAMPLING_16;
    if (HAL_UART_Init(&UartHandle) != HAL_OK)
    {
        Error_Handler();
    }

    while (1)
    {
        printf("Hello World!\r\n");
        BSP_LED_Toggle(LED1);
        HAL_Delay(1000);
    }
}

int __io_putchar(int ch)
{
    /* Support printf over UART */
    (void) HAL_UART_Transmit(&UartHandle, (uint8_t *) &ch, 1, 0xFFFFU);
    return ch;
}

int _write(int file, char *ptr, int len)
{
    /* Send chars over UART */
    for (int i = 0; i < len; i++)
    {
        (void) __io_putchar(*ptr++);
    }

    return len;
}

void SysTick_Handler(void)
{
    HAL_IncTick();
}

void EXTI15_10_IRQHandler(void)
{
    HAL_EXTI_IRQHandler(&ExtiHandle);
}

static void EXTI15_10_IRQCallback(void)
{
    BSP_LED_Toggle(LED2);
}

static void SystemClock_Config(void)
{
    RCC_ClkInitTypeDef RCC_ClkInitStruct;
    RCC_OscInitTypeDef RCC_OscInitStruct;

    /* Enable power control clock */
    __HAL_RCC_PWR_CLK_ENABLE();

    /* Update the voltage scaling value */
    __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

    /* Enable HSE Oscillator and activate PLL with HSE as source */
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState = RCC_HSE_BYPASS;
    RCC_OscInitStruct.HSIState = RCC_HSI_OFF;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
    RCC_OscInitStruct.PLL.PLLM = 8;
    RCC_OscInitStruct.PLL.PLLN = 432;
    RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
    RCC_OscInitStruct.PLL.PLLQ = 9;
    RCC_OscInitStruct.PLL.PLLR = 7;
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /* Activate the overdrive to reach the 216 MHz frequency */
    if (HAL_PWREx_EnableOverDrive() != HAL_OK)
    {
        Error_Handler();
    }

    /* Select PLL as system clock source and configure the HCLK, PCLK1 and PCLK2 clocks dividers */
    RCC_ClkInitStruct.ClockType = (RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_HCLK  | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2);
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
    RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_7) != HAL_OK)
    {
        Error_Handler();
    }
}

static void Error_Handler(void)
{
    /* Turn on a red LED */
    BSP_LED_On(LED3);

    /* Spin loop */
    while (1)
    {
        ;
    }
}
