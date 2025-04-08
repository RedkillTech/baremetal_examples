
#include <memory_layout.h>

#define UART_PHY_BASE      0x9000000
#define UART_ADDR(x)      (UART_PHY_BASE + x)

#define UART_DR           UART_ADDR(0x00)
#define UART_FR           UART_ADDR(0x18)
#define UART_LCRH         UART_ADDR(0x2C)
#define UART_CR           UART_ADDR(0x30)
#define UART_IMSC         UART_ADDR(0x38)
#define UART_ICR          UART_ADDR(0x44)

#define LCRH_FEN          (1 << 4)
#define LCRH_WLEN_8BIT    (3 << 5)

#define UART_EN           1
#define UART_TXE          (1 << 8)
#define UART_RXE          (1 << 9)

#define UART_IMSC_RXIM    (1 << 4)
#define UART_IMSC_TXIM    (1 << 5)

#define UART_ICR_RXIC     (1 << 4)
#define UART_ICR_TXIC     (1 << 5)

#define FR_RXFE           (1 << 4)
#define FR_TXFF           (1 << 5)
