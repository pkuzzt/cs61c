/* Include the system headers we need */
#include <stdlib.h>
#include <stdio.h>

/* Include our header */
#include "vector.h"

/* Define what our struct is */
struct vector_t {
    size_t size;
    int *data;
};

/* Utility function to handle allocation failures. In this
   case we print a message and exit. */
static void allocation_failed() {
    fprintf(stderr, "Out of memory.\n");
    exit(1);
}

/* Create a new vector with a size (length) of 1
   and set its single component to zero... the
   RIGHT WAY */
vector_t *vector_new() {
    /* Declare what this function will return */
    vector_t *retval;

    /* First, we need to allocate memory on the heap for the struct */
    retval = malloc(sizeof(vector_t));
    if (retval == NULL) {
        allocation_failed();
    }
    retval->size = 1;
    retval->data = malloc(sizeof(int));
    if (retval->data == NULL) {
        free(retval);
        allocation_failed();
    }
    retval->data[0] = 0;
    return retval;
}

/* Return the value at the specified location/component "loc" of the vector */
int vector_get(vector_t *v, size_t loc) {

    /* If we are passed a NULL pointer for our vector, complain about it and exit. */
    if(v == NULL) {
        fprintf(stderr, "vector_get: passed a NULL vector.\n");
        abort();
    }

    /* If the requested location is higher than we have allocated, return 0.
     * Otherwise, return what is in the passed location.
     */
    if (loc < v->size) {
        return v->data[loc];
    } else {
        return 0;
    }
}

/* Free up the memory allocated for the passed vector.
   Remember, you need to free up ALL the memory that was allocated. */
void vector_delete(vector_t *v) {
    free(v->data);
    free(v);
}

/* Set a value in the vector. If the extra memory allocation fails, call
   allocation_failed(). */
void vector_set(vector_t *v, size_t loc, int value) {
    /* What do you need to do if the location is greater than the size we have
     * allocated?  Remember that unset locations should contain a value of 0.
     */

    if (loc < v->size) {
        v->data[loc] = value;
    }
    else {
        int *tmp = (int*) malloc(sizeof(int) * (loc + 1));
        if (tmp == NULL) {
            vector_delete(v);
            allocation_failed();
        }
        for (int i = 0; i < v->size; i++) {
            tmp[i] = v->data[i];
        }
        for (int i = v->size; i < loc; i++) {
            tmp[i] = 0;
        }
        tmp[loc] = value;
        
        free(v->data);
        v->data = tmp;
        v->size = loc + 1;
    }
}