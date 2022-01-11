#include "hashtable.h"
#include <stdlib.h>
#include <stdio.h>

/*
 * This creates a new hash table of the specified size and with
 * the given hash function and comparison function.
 */
HashTable *createHashTable(int size, unsigned int (*hashFunction)(void *),
                           int (*equalFunction)(void *, void *)) {
  int i = 0;
  HashTable *newTable = malloc(sizeof(HashTable));
  newTable->size = size;
  newTable->data = malloc(sizeof(struct HashBucket *) * size);
  for (i = 0; i < size; ++i) {
    newTable->data[i] = NULL;
  }
  newTable->hashFunction = hashFunction;
  newTable->equalFunction = equalFunction;
  return newTable;
}

/*
 * This inserts a key/data pair into a hash table.  To use this
 * to store strings, simply cast the char * to a void * (e.g., to store
 * the string referred to by the declaration char *string, you would
 * call insertData(someHashTable, (void *) string, (void *) string).
 * Because we only need a set data structure for this spell checker,
 * we can use the string as both the key and data.
 */
void insertData(HashTable *table, void *key, void *data) {
  // 1. Find the right hash bucket location with table->hashFunction.
  // 2. Allocate a new hash bucket struct.
  // 3. Append to the linked list or create it if it does not yet exist. 
  unsigned int hash_value = table->hashFunction(key);
  int idx = hash_value % table->size;
  struct HashBucket* bucket = (struct HashBucket*) table->data[idx];
  if (table->data[idx] == NULL) {
    table->data[idx] = malloc(sizeof(struct HashBucket));
    bucket = (struct HashBucket*) table->data[idx];
  }
  else {
    bucket = table->data[idx];
    while (bucket->next != NULL) {
      bucket = bucket->next;
    }
    bucket->next = (struct HashBucket*) malloc(sizeof(struct HashBucket));
    bucket = bucket->next;
  }

  bucket->data = data;
  bucket->key = key;
  bucket->next = NULL;
  
  return;
}

/*
 * This returns the corresponding data for a given key.
 * It returns NULL if the key is not found. 
 */
void *findData(HashTable *table, void *key) {
  // 1. Find the right hash bucket with table->hashFunction.
  // 2. Walk the linked list and check for equality with table->equalFunction.
  unsigned int hash_value = table->hashFunction(key);
  int idx = hash_value % table->size;
  struct HashBucket* bucket = (struct HashBucket*) table->data[idx];
  while (bucket != NULL) {
    if (table->equalFunction(key, bucket->key)) {
      return bucket->data;
    }
  }
  return NULL;
}