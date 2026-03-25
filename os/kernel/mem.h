#ifndef __MEM_H__
#define __MEM_H__

extern void os_heap_init(void);
extern void *os_alloc(uint16_t nwords);
extern void os_free(void *p);

#endif /* __MEM_H__ */