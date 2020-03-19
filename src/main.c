#include "event_queue.h"

#include <stdlib.h>
#include <stdio.h>

int main(int argc, char** argv) {
    printf("Starting.\n");

    event_queue eq;
    event_queue_init(&eq);

    event_queue_push_site(&eq, 10, 10);
    event_queue_push_site(&eq, 15, 6);
    event_queue_push_site(&eq, 13, 20);
    event_queue_push_site(&eq, 18, 1);
    event_queue_push_site(&eq, 12, 12);
    event_queue_push_site(&eq, 5, 100);
    event_queue_push_circle(&eq, -5);
    event_queue_push_circle(&eq, 500);

    event next;
    while (event_queue_next(&eq, &next)) {
        switch (next.type) {
            case EVENT_SITE:
                printf("Popped site event: (%d, %d)\n", next.site.x, next.site.y);
                break;
            case EVENT_CIRCLE:
                printf("Popped circle event: %d\n", next.circle.y);
                break;
        }
    }

    event_queue_free(&eq);

    return 0;
}
