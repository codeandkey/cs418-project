#include "event_queue.h"

#include <stdlib.h>
#include <string.h>

void event_queue_init(event_queue* dst) {
    dst->len = EVENT_BUF_SLEN;
    dst->buf = calloc(dst->len, sizeof dst->buf[0]);
    dst->count = 0;
}

void event_queue_free(event_queue* dst) {
    free(dst->buf);
    dst->len = dst->count = 0;
}

void event_queue_push_event(event_queue* dst, event* ev) {
    /* expand buffer if needed */
    if (++dst->count >= dst->len) {
        dst->len *= 2;
        dst->buf = realloc(dst->buf, dst->len * sizeof dst->buf[0]);
    }

    /* put event at end of heap */
    dst->buf[dst->count] = *ev;

    /* shift event towards the top */
    int cur = dst->count;
    event tmp;

    while (cur > 1) {
        if (dst->buf[cur].priority > dst->buf[cur / 2].priority) {
            /* swap the current with the parent */
            tmp = dst->buf[cur];
            dst->buf[cur] = dst->buf[cur / 2];
            dst->buf[cur / 2] = tmp;
            cur /= 2;
        } else {
            break;
        }
    }
}

void event_queue_push_site(event_queue* dst, int x, int y) {
    event new_event;

    new_event.priority = y;
    new_event.type = EVENT_SITE;

    new_event.site.x = x;
    new_event.site.y = y;

    event_queue_push_event(dst, &new_event);
}

void event_queue_push_circle(event_queue* dst, int y) {
    event new_event;

    new_event.priority = y;
    new_event.type = EVENT_CIRCLE;

    new_event.circle.y = y;

    event_queue_push_event(dst, &new_event);
}

int event_queue_next(event_queue* dst, event* out) {
    if (!dst->count) return 0;

    if (dst->count == 1) {
        dst->count = 0;
        *out = dst->buf[1];
        return 1;
    }

    /* output the top priority element */
    *out = dst->buf[1];

    /* move the last buffer element to the top */
    dst->buf[1] = dst->buf[dst->count--];

    /* swap with children to maintain heap order */
    int cur = 1, to_swap;
    event tmp;

    while (cur * 2 <= dst->count) {
        /* assume left child is highest first */
        to_swap = cur * 2;

        /* check if right child exists and is higher priority */
        if (cur * 2 + 1 <= dst->count && dst->buf[cur * 2 + 1].priority > dst->buf[cur * 2].priority) {
            to_swap = cur * 2 + 1;
        }

        /* do a swap if needed */
        if (dst->buf[cur].priority < dst->buf[to_swap].priority) {
            tmp = dst->buf[cur];
            dst->buf[cur] = dst->buf[to_swap];
            dst->buf[to_swap] = tmp;

            cur = to_swap;
        } else {
            /* no swap needed. can terminate loop */
            break;
        }
    }

    return 1;
}
