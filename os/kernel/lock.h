#ifndef __LOCK_H__
#define __LOCK_H__

extern uint32_t spin_lock(void);
extern void spin_unlock(uint32_t reg);

#endif /* __LOCK_H__ */