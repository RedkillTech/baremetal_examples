
#include <asm_macros.S>

#define DATA(x) .global x; .type x, STT_OBJECT; x:
#define END_DATA(x) .size x, . - x
