
#include <types.h>

void memset8(u8 *buf, u64 size, u8 c)
{
	for(u64 i = 0; i < size; i++)
		buf[i] = c;
}
