// Implements a dictionary's functionality

#include <stdbool.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <stdbool.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 20000;

// Hash table
node *table[N];

int word_count = 0;

void destroy(node *n);

// Returns true if word is in dictionary else false
bool check(const char *word)
{
    //bool is_found = false;
    int index = hash(word);

    node *cursor;// = malloc(sizeof(node));
    // if (cursor == NULL)
    // {
    //     return false;
    // }

    for (cursor = table[index]; cursor != NULL; cursor = cursor->next)
    {
        if (strcasecmp(word, cursor->word) == 0)
        {
            //free(cursor);
            return true;
        }
    }

    //free(cursor);
    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // https://opendsa-server.cs.vt.edu/ODSA/Books/Everything/html/HashFuncExamp.html#string-folding
    unsigned int hash = 0;
    long sum = 0, mul = 1;
    int c;
    int i = 0;
    while ((c = tolower(*word++)) != '\0')
    {
        mul = (i % 4 == 0) ? 1 : mul * 256;
        sum += c * mul;
        i++;
    }
    hash = labs(sum) % N;
    return hash;
}

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    // Open the file.
    FILE *file = fopen(dictionary, "r");
    if (file == NULL)
    {
        return false;
    }

    // Read strings from the file.
    char *word = malloc(LENGTH);
    if (word == NULL)
    {
        return false;
    }

    while (fscanf(file, "%s", word) != EOF)
    {
        // Create a new node for each string.
        node *n = malloc(sizeof(node));
        if (n == NULL)
        {
            return false;
        }
        strcpy(n->word, word);
        n->next = NULL;

        // Insert the node to the hash table.
        int index = hash(word);

        if (table[index] == NULL)
        {
            table[index] = n;
        }
        else
        {
            n->next = table[index];
            table[index] = n;
        }

        word_count++;
    }

    fclose(file);
    free(word);

    return true;
}

// Returns number of words in dictionary if loaded else 0 if not yet loaded
unsigned int size(void)
{
    return word_count;
}

// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    bool check = false;
    for (int i = 0; i < N; i++)
    {
        if (table[i] != NULL)
        {
            destroy(table[i]);
            check = true;
        }
    }
    return check;
}

void destroy(node *n)
{
    if (n->next != NULL)
    {
        destroy(n->next);
    }
    free(n);
}