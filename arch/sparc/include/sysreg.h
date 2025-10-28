#ifndef SYSREG_H
#define SYSREG_H

#define PSR_CWP_MASK	0x1f
#define PSR_CWP(cwp)	((cwp) & PSR_CWP_MASK)
#define PSR_ET			(1 << 5)
#define PSR_PS			(1 << 6)
#define PSR_S			(1 << 7)
#define PSR_PIL(pil)	(((pil) & 0xf) << 8)
#define PSR_EF			(1 << 12)
#define PSR_EC			(1 << 13)

#define PSR_DEFAULT		(PSR_CWP(7) | PSR_ET | PSR_S | PSR_PIL(0xf))

#define WIM(win)		(1 << (win))

#define TBR_TT_SHIFT	4
#define TBR_TT_MASK		0xff

#define NUM_WINDOWS		8
#endif // !SYSREG_H
