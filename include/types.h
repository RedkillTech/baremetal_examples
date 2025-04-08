
#ifndef TYPES_H
#define TYPES_H

typedef unsigned long u64;
typedef unsigned int  u32;
typedef unsigned char u8;

#define BITS_PER_BYTE 8

#define DECLARE_BITMAP(x, bits)  unsigned char x[bits/BITS_PER_BYTE]

static inline void bitmap_set_bit(unsigned char *bitmap, u32 bit)
{
	bitmap[bit/BITS_PER_BYTE] |= (1 << (bit % BITS_PER_BYTE));
}

static inline void bitmap_clear_bit(unsigned char *bitmap, u32 bit)
{
	bitmap[bit/BITS_PER_BYTE] &= ~(1 << (bit % BITS_PER_BYTE));
}

static inline u32 bitmap_test_bit(unsigned char *bitmap, u32 bit)
{
	return bitmap[bit/BITS_PER_BYTE] & (1 << (bit % BITS_PER_BYTE));
}

#endif
