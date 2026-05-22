#include "soft_timer.h"
#define soft_timer_hw_init()  ch32V_tick_init()

static soft_timer_t timers[MAX_TIMERS] = {0};
static uint8_t timers_index[MAX_TIMERS] = {0};
static uint8_t timer_used_cnt = 0;
static uint8_t timer_activate_cnt = 0;


static void ch32V_tick_init(void)
{
    SysTick->CTLR= 0;
    SysTick->SR  = 0;
    SysTick->CNT = 0;
    SysTick->CMP = SystemCoreClock/1000;
    SysTick->CTLR= 0xf;

	NVIC_SetPriority(SysTicK_IRQn, 15);
    NVIC_EnableIRQ(SysTicK_IRQn);
}

int soft_timer_init(void)
{
    for (int i = 0; i < MAX_TIMERS; i++) 
    {
        timers[i].id           = i;
        timers[i].duration_ms  = 0;
        timers[i].remaining_ms = 0;
        timers[i].status       = TIMER_UNUSED;
        timers[i].callback     = NULL;
        timers[i].user_data    = 0;
        timers[i].is_periodic  = TIMER_ONCE;
        timers_index[i]        = 0;
    }
    timer_used_cnt         = 0;
    timer_activate_cnt     = 0;
    soft_timer_hw_init(); // 初始化硬件定时器
    return 0;
}
// AUTO_INIT(soft_timer_init);

soft_timer_t *soft_timer_new(uint32_t duration_ms, timer_callback_t callback, timer_type_t is_periodic, uint32_t user_data)
{
    if(timer_used_cnt >= MAX_TIMERS) 
    {
        return NULL; // 超过最大定时器数量
    }

    for (int i = 0; i < MAX_TIMERS; i++) 
    {
        if (timers[i].status == TIMER_UNUSED) 
        {
            timers[i].duration_ms  = duration_ms;
            timers[i].status       = TIMER_STOP;
            timers[i].callback     = callback;
            timers[i].user_data    = user_data;
            timers[i].is_periodic  = is_periodic;           
            timer_used_cnt++;

            return &timers[i];
        }
    }
    return NULL; // 没有可用的定时器
}       

int soft_timer_start(soft_timer_t *timer)
{
    if(timer < &timers[0] || timer >= &timers[MAX_TIMERS] || timer->status != TIMER_STOP) 
    {
        return -1; // 定时器无效或已在运行
    }
    timer->remaining_ms = timer->duration_ms;
    timer->status = TIMER_RUNNING;
    timers_index[timer_activate_cnt] = timer->id;
    timer_activate_cnt++;
    return 0; // 成功启动定时器
}

int soft_timer_reset(soft_timer_t *timer)
{
    // uint8_t i = 0;
    if(timer < &timers[0] || timer >= &timers[MAX_TIMERS] || timer->status != TIMER_RUNNING) 
    {
        return -1; // 定时器无效或未在运行
    }

    timer->remaining_ms = timer->duration_ms;

    return 0; // 成功复位定时器
}

int soft_timer_stop(soft_timer_t *timer)
{
    uint8_t i = 0;
    if(timer < &timers[0] || timer >= &timers[MAX_TIMERS] || timer->status != TIMER_RUNNING) 
    {
        return -1; // 定时器无效或未在运行
    }
    timer->status    = TIMER_STOP;
    for(; i < timer_activate_cnt; i++) 
    {
        if(timers_index[i] == timer->id) 
        {
            break;
        }
    }
    for(; i < timer_activate_cnt-1; i++)
    {
        timers_index[i] = timers_index[i + 1];
    }
    timer_activate_cnt--;
    return 0; // 成功停止定时器
}

int soft_timer_free(soft_timer_t *timer)
{
    if(timer < &timers[0] || timer >= &timers[MAX_TIMERS] || timer->status == TIMER_UNUSED)
    {
        return -1; 
    }
    if(timer->status == TIMER_RUNNING) 
    {
        soft_timer_stop(timer); 
    }
    timer->duration_ms  = 0;
    timer->remaining_ms = 0;
    timer->status       = TIMER_UNUSED;
    timer->callback     = NULL;
    timer->user_data    = 0;
    timer->is_periodic  = TIMER_ONCE;
    timer_used_cnt--;
    return 0;
}

void soft_timer_update(void)
{
    for(uint8_t i = 0; i < timer_activate_cnt; i++) 
    {
        if (timers[timers_index[i]].status == TIMER_RUNNING) 
        {
            if (timers[timers_index[i]].remaining_ms > 0) 
            {
                timers[timers_index[i]].remaining_ms--;
            }
        }
    }
}

void soft_timer_process(void)
{
    for(uint8_t i = 0; i < timer_activate_cnt; i++) 
    {
        if(timers[timers_index[i]].status == TIMER_RUNNING && timers[timers_index[i]].remaining_ms == 0) 
        {
            if(timers[timers_index[i]].callback) 
            {
                timers[timers_index[i]].callback(timers[timers_index[i]].user_data);
            }
            
            if(timers[timers_index[i]].is_periodic == TIMER_PERIODIC) 
            {
                timers[timers_index[i]].remaining_ms = timers[timers_index[i]].duration_ms;
            } 
            else 
            {
                soft_timer_stop(&timers[timers_index[i]]);
                i--; // 调整索引以避免跳过下一个定时器
            }
        }
    }
}

//以下为测试程序，不提供给外部调用

static void timer1_1s_callback(uint32_t user_data)
{
    printf("timer_activate_cnt=%d\r\n",timer_activate_cnt);
    for(uint8_t i = 0; i < timer_activate_cnt; i++) 
    {
        printf("timer %d is active\r\n", timers_index[i]);
    }
}

static void timer2_5s_callback(uint32_t user_data)
{
    printf("timer2_5s expired and timer_activate_cnt = %d\r\n", timer_activate_cnt);
}

static void timer3_10s_callback(uint32_t user_data)
{
    printf("timer3_10s expired , data is = %d\r\n", user_data);
}

__attribute__((used)) static void soft_timer_test(void)
{
    soft_timer_t *timer1_1s = soft_timer_new(1000, timer1_1s_callback, TIMER_PERIODIC, 0);
    if(timer1_1s != NULL) 
    {
        printf("timer1_1s created successfully\r\n");
        soft_timer_start(timer1_1s);
    }
    else 
    {
        printf("Failed to create timer1_1s\r\n");
    }

    soft_timer_t *timer2_5s = soft_timer_new(5000, timer2_5s_callback, TIMER_ONCE, 0);
    if(timer2_5s != NULL) 
    {
        printf("timer2_5s created successfully\r\n");
        soft_timer_start(timer2_5s);
    }
    else 
    {
        printf("Failed to create timer2_5s\r\n");
    }

    soft_timer_t *timer3_10s = soft_timer_new(10000, timer3_10s_callback, TIMER_PERIODIC, 12345);
    if(timer3_10s != NULL) 
    {
        printf("timer3_10s created successfully\r\n");
        soft_timer_start(timer3_10s);
    }
    else 
    {
        printf("Failed to create timer3_10s\r\n");
    }
}