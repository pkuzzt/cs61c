#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    struct node *hare, *tortoise;
    hare = head;
    tortoise = head;
    while (hare && tortoise) {
        tortoise = tortoise->next;
        hare = hare->next;
        if (hare == NULL)
            break;
        hare = hare->next;
        if (tortoise == hare) {
            return 1;
        }
    }
    return 0;
}