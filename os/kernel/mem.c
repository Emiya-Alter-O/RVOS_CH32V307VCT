#include "os.h"

#define OS_HEAP_SIZE (1024)

#if OS_HEAP_SIZE > 65535
    #define OS_HEAP_SIZE (65535)
#endif

#if OS_HEAP_SIZE%8
    #define OS_HEAP_STATE_INDEX (OS_HEAP_SIZE/8 + 1)
#else
    #define OS_HEAP_STATE_INDEX (OS_HEAP_SIZE/8)
#endif

static struct
{
    uint32_t mem[OS_HEAP_SIZE]; // heap default size: 4K(1024 * 4)
    uint8_t  is_used[OS_HEAP_STATE_INDEX];
    uint8_t  is_last[OS_HEAP_STATE_INDEX];
}os_heap;

void os_heap_init(void)
{
    for(uint16_t i=0; i<(OS_HEAP_STATE_INDEX); i++)
    {
        os_heap.is_used[i] = 0;
        os_heap.is_last[i] = 0;
    }

    os_kprintf("os_heap start: %p\r\n", os_heap.mem);
    os_kprintf("os_heap end: %p\r\n", &os_heap.mem[OS_HEAP_SIZE - 1]);
    os_kprintf("os_heap size: %d\r\n", &os_heap.mem[OS_HEAP_SIZE - 1] - os_heap.mem + 1);
}

/*
 * Allocate a memory block which is composed of contiguous word
 * - nwords: the number of memory to allocate
 */
void *os_alloc(uint16_t nwords)
{
    if(nwords == 0 || nwords > OS_HEAP_SIZE)
    {
        return NULL;
    }

    for(uint16_t start = 0; start <= OS_HEAP_SIZE - nwords; start++)
    {
        uint8_t found = 1;
        for(uint16_t j = 0; j < nwords; j++)
        {
            uint16_t idx  = start + j;
            uint8_t  byte = idx/8;
            uint8_t  bit  = idx%8;

            if(os_heap.is_used[byte] & (1 << bit))
            {
                found = 0;
                break;
            }
        }

        if(found)
        {
            for(uint16_t j = 0; j < nwords; j++)
            {
                uint16_t idx  = start + j;
                uint8_t  byte = idx / 8;
                uint8_t  bit  = idx % 8;

                os_heap.is_used[byte] |= (1 << bit);

                if(j == nwords - 1)
                {
                    os_heap.is_last[byte] |= (1 << bit);
                }
            }

            return (void *)&os_heap.mem[start];
        }
    }
    return NULL;
}

/*
 * Free the memory block
 * - p: start address of the memory block
 */
void os_free(void *p)
{
    if(p == NULL || (uint32_t *)p < os_heap.mem || (uint32_t *)p > &os_heap.mem[OS_HEAP_SIZE - 1])
    {
        return;
    }

    uint32_t *ptr = (uint32_t *)p;
    uint16_t idx = ptr - os_heap.mem;

    for(; idx < OS_HEAP_SIZE; idx++)
    {
        uint8_t byte = idx / 8;
        uint8_t bit  = idx % 8;

        os_heap.is_used[byte] &= ~(1 << bit);

        if(os_heap.is_last[byte] & (1 << bit))
        {
            os_heap.is_used[byte] &= ~(1 << bit);
            break;
        }
    }
}