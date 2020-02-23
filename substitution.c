#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

int check_key (string key);
bool check_key_chars(string key);
void cipher_text(string ciphertext, string key, string plaintext);

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
    string ciphertext = plaintext;
    //[strlen(plaintext)];
    cipher_text(ciphertext, key, plaintext);

    printf("ciphertext: %s\n", ciphertext);
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
            if (key[i] == key[y])
            {
                check = true;
                break;
            }
        }
    }
    return check;
}

void cipher_text(string ciphertext, string key, string plaintext)
{
    //string all_upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //string all_lower = "abcdefghijklmnopqrstuvwxyz";
    int index = 0;
    char temp;

    for (int i = 0; i < strlen(plaintext); i++)
    {
        if (plaintext[i] <= 'Z' && plaintext[i] >= 'A')
        {
            index = plaintext[i] - 'A';
            temp = key[index] <= 'Z' && key[index] >= 'A' ? key[index] : key[index] - 'a' + 'A';
        }
        else if (plaintext[i] <= 'z' && plaintext[i] >= 'a')
        {
            index = plaintext[i] - 'a';
            temp = key[index] <= 'z' && key[index] >= 'a' ? key[index] : key[index] + 'a' - 'A';
        }
        else
        {
            temp = plaintext[i];
        }
        ciphertext[i] = temp;
    }
}