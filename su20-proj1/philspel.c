#include "hashtable.h"
#include "philspel.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

HashTable *dictionary;


int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }

  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  return 0;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string) and is already done for you here 
 * for convenience.
 */
unsigned int stringHash(void *s) {
  char *string = (char *)s; 
  unsigned int res = 0;
  while (*string != 0){
    res = res * 54 + (*string - 'A');
    string++;
  }
  return res;
}

/*
 * This should return a nonzero value if the two strings are identical 
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2) {
  char *string1 = (char *)s1;
  char *string2 = (char *)s2;
  //fprintf(stderr, "%s %s\n", string1, string2);
  while (*string1 != '\0' && *string2 != '\0'){
    if (*string1 != *string2){
      return 0;
    }
    string1++;
    string2++;
  }
  if (*string1 != 0 || *string2 != 0){
    return 0;
  }
  return 1;
}

/*
 * This function should read in every word from the dictionary and
 * store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final 20% of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(1)
 * to cleanly exit the program.
 *
 * Since the format is one word at a time, with new lines in between,
 * you can safely use fscanf() to read in the strings until you want to handle
 * arbitrarily long dictionary chacaters.
 */

char* readword(FILE *file, char* buffer, char* last_ch, int* len) {
  char ch;
  int cnt = 0;
  while (1) {
    ch = fgetc(file);
    if (ch < 'A' || ch > 'z') {
      *last_ch = ch;
      break;
    }
    buffer[cnt] = ch;
    cnt = cnt + 1;
    if (cnt >= *len){
      char *tmp = buffer;
      buffer = (char*) malloc(sizeof(char) * (*len) * 2);
      for (int i = 0; i < *len; i++){
        buffer[i] = tmp[i];
      }
      free(tmp);
      (*len) = (*len) * 2;
    }
  }
  buffer[cnt] = '\0';
  return buffer;
}

void readDictionary(char *dictName) {
  // -- TODO --
  int len = 60;
  void* data = malloc(sizeof(char));
  char *buffer = (char*) malloc(sizeof(char) * len); 
  char last_ch;
  FILE *fp = fopen(dictName, "r");
  while (1) {
    buffer = readword(fp, buffer, &last_ch, &len);
    if (last_ch == EOF) {
      break;
    }
    if (buffer[0] == '\0') {
      continue;
    }
    else {
      int cnt;
      for (int i = 0; i < len; i++) {
        if (buffer[i] == '\0') {
          cnt = i;
        }
      }
      void *key = malloc(sizeof(char) * (cnt + 1));
      for (int i = 0; i <= cnt; i++) {
        ((char*)key)[i] = buffer[i];
      }
      insertData(dictionary, key, data);
    }
  }
}

/*
 * This should process standard input (stdin) and copy it to standard
 * output (stdout) as specified in the spec (e.g., if a standard 
 * dictionary was used and the string "this is a taest of  this-proGram" 
 * was given to stdin, the output to stdout should be 
 * "this is a teast [sic] of  this-proGram").  All words should be checked
 * against the dictionary as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the dictionary should it
 * be reported as not found by appending " [sic]" after the error.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final 20% of your grade, you cannot assume words have a bounded length.
 */
void processInput() {
  int len = 60;
  char *buffer = (char*) malloc(sizeof(char) * len);
  char last_ch;
  while (1) {
    buffer = readword(stdin, buffer, &last_ch, &len);

    if (buffer[0] != '\0') {
      char *_buffer = malloc(sizeof(char) * len);
      for (int i = 0; i < len; i++){
        _buffer[i] = buffer[i];
      }
      int flag = 0;
      if (findData(dictionary, buffer)) {
        flag = 1;
      }
      for (int i = 1; i < len && buffer[i] != '\0'; i++) {
        if (buffer[i] < 'a') {
          buffer[i] += 'a' - 'A';
        }
      }
      if (findData(dictionary, buffer)) {
        flag = 1;
      }
      if (buffer[0] < 'a') {
        buffer[0] += 'a' - 'A';
      }
      if (findData(dictionary, buffer)) {
        flag = 1;
      }
      fprintf(stdout, "%s", _buffer);
      if (flag == 0) {
        fprintf(stdout, " [sic]");
      }
      free(_buffer);
    }
    if (last_ch == EOF)
      break;
    else
      fprintf(stdout, "%c", last_ch);
  }
}
