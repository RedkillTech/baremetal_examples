#ifndef MEMORY_LAYOUT_H

#pragma once

#define KERNEL_PHY_BASE 0x40100000

#define ROM_BASE ((KERNEL_PHY_BASE))
#define ROM_SIZE ((1 << 14))

#define RAM_BASE (ROM_BASE + ROM_SIZE)
#define RAM_SIZE 256M

#endif // !MEMORY_LAYOUT_H
