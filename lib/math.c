#include <types.h>

int gcd(u32 a, u32 b)
{
	if (a == 0 || a >= b)
		return -1;

	while (1) {
		u32 t = b - ((b / a) * a);
		b = a;
		a = t;

		if (t == 0)
			return b;
	}

	return -1;
}
