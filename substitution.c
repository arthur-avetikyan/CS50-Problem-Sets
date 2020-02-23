#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

int check_key (string key);
bool check_key_chars(string key);
void cypher_text(string cyphertext, string key, string plaintext);
int indexof(string key, char value);

int main(int argc, string argv[])
{
    string key = argv[1];


    if (argc != 2)
    {
        printf ("Usage: ./substitution key\n");
        return 1;
    }
    else if (check_key(key) == 1 )
    {
        return 1;
    }

    string plaintext = get_string("plaintext: ");
    char cyphertext[strlen(plaintext)];
    cypher_text(cyphertext, key, plaintext);

    printf("ciphertext: %s\n", cyphertext);
    return 0;
}

int check_key (string key)
{
    if (strlen(key) != 26)
    {
       printf("Key must contain 26 characters.\n");
       return 1;
    }
    else if (check_key_chars(key))
    {
        printf("Key must contain only alphabetical non-reapeting characters.\n");
        return 1;
    }

    return 0;
}

bool check_key_chars(string key)
{
    bool check = false;

    for (int i = 0; i < strlen(key); i++)
    {
        if ( key[i] < 'A' || (key[i] > 'Z' && key[i] < 'a') || key[i] > 'z')
        {
            check = true;
            break;
        }
        for (int y = i + 1; y < strlen(key); y++)
        {
            //todo
            if (key[i] == key[y])
            {
                check = true;
                break;
            }
        }
    }
    return check;
}

void cypher_text(string cyphertext, string key, string plaintext)
{
    string all_upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    string all_lower = "abcdefghijklmnopqrstuvwxyz";
    int index = 0;
    char temp;

    for (int i = 0; i < strlen(plaintext); i++)
    {
        if (plaintext[i] <= 'Z' && plaintext[i] >= 'A')
        {
            index = indexof(all_upper, plaintext[i]);
            temp = key[index] <= 'Z' && key[index] >= 'A' ? key[index] : key[index] + 'a' - 'A';
        }
        else if (plaintext[i] <= 'z' && plaintext[i] >= 'a')
        {
            index = indexof(all_lower, plaintext[i]);
            temp = key[index] <= 'z' && key[index] >= 'a' ? key[index] : key[index] + 'a' - 'A';
        }
        else
        {
            temp = plaintext[i];
        }
        cyphertext[i] = temp;
    }
}

int indexof(string key, char value)
{
    for (int i = 0; i < strlen(key); i++)
    {
        if (key[i] == value)
        {
            return i;
        }
    }

    return 1000;
}
