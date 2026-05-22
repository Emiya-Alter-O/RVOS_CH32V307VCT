#ifndef SOFT_TIMER_H
#define SOFT_TIMER_H

#include "debug.h"
//配置项
#define MAX_TIMERS 64 //最大定时器数量255

//数据类型定义
typedef void (*timer_callback_t)(uint32_t user_data); // 定时器回调函数类型

typedef enum 
{
    TIMER_ONCE = 0,
    TIMER_PERIODIC
} timer_type_t;

typedef enum 
{
    TIMER_STOP = 0,
    TIMER_UNUSED,
    TIMER_RUNNING
} timer_status_t;

typedef struct 
{
    uint8_t           id;             // 定时器ID
    uint32_t          duration_ms;    // 定时器持续时间（毫秒）
    uint32_t          remaining_ms;   // 剩余时间（毫秒）
    timer_status_t    status;         // 定时器状态
    timer_callback_t  callback;       // 定时器到期回调函数
    uint32_t          user_data;     // 用户数据
    timer_type_t      is_periodic;    // 是否为周期性定时器
} soft_timer_t;

//外部接口
extern int soft_timer_init(void);
extern soft_timer_t *soft_timer_new(uint32_t duration_ms, timer_callback_t callback, timer_type_t is_periodic, uint32_t user_data);
extern int soft_timer_start(soft_timer_t *timer);
extern int soft_timer_reset(soft_timer_t *timer);
extern int soft_timer_stop(soft_timer_t *timer);
extern int soft_timer_free(soft_timer_t *timer);
extern void soft_timer_update(void);
extern void soft_timer_process(void);
#endif // SOFT_TIMER_H