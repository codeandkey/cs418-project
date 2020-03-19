#pragma once

/*
 * Event queue structure.
 */

#define EVENT_SITE 0
#define EVENT_CIRCLE 1

/* Starting length for event buffer */
#define EVENT_BUF_SLEN 128

typedef struct {
    int x, y;
} site_event;

typedef struct {
    int y;
} circle_event;

typedef struct {
    int priority, type;

    union {
        site_event site;
        circle_event circle;
    };
} event;

typedef struct {
    event* buf;
    int len, count;
} event_queue;

void event_queue_init(event_queue* dst);
void event_queue_free(event_queue* dst);

void event_queue_push_event(event_queue* dst, event* ev);
void event_queue_push_site(event_queue* dst, int x, int y);
void event_queue_push_circle(event_queue* dst, int y);

int event_queue_next(event_queue* dst, event* out);
