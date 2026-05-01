#ifndef __TIMER_H__
#define __TIMER_H__

extern void os_timer_init(void);
extern void sw_setpend(void);
extern void sw_clearpend(void);
extern uint32_t os_get_tick(void);
extern void os_delay_ms(uint32_t ms);

#endif /* __TIMER_H__ */