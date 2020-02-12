#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

int Count_Letters(string text);
int Count_Words(string text);
int Count_Sentences(string text);
float Average_Letters(float letters, float words);
float Average_Sentences(float sentences, float words);
float Coleman_Liau_Index(float avg_letters, float avg_sentences);

int main(void)
{
    string text = get_string("Text: ");

    float letters = Count_Letters(text);
    float words = Count_Words(text);
    float sentences = Count_Sentences(text);

    float avg_letters = Average_Letters(letters, words);
    float avg_sentences = Average_Sentences(sentences, words);

    int index = roundf(Coleman_Liau_Index(avg_letters, avg_sentences));

    if (index < 1)
    {
        printf("Before Grade 1\n");
    }
    else if (index < 17)
    {
        printf("Grade %i\n", index);
    }
    else
    {
        printf("Grade 16+\n");
    }
}


// Returns count of letters in text
int Count_Letters(string text)
{
    int count = 0;

    for (int i = 0; i < strlen(text); i++)
    {
        char letter = tolower(text[i]);

        if (letter >= 'a' && letter <= 'z')
        {
            count++;
        }
    }

    return count;
}

// Return count of words in text
int Count_Words(string text)
{
    int count = 1;

    for (int i = 0; i < strlen(text); i++)
    {
        if (text[i] == ' ')
        {
            count++;
        }
    }

    return count;
}

// Returns count of sentences in text
int Count_Sentences(string text)
{
    int count = 0;

    for (int i = 0; i < strlen(text); i++)
    {
        if (text[i] == '.' || text[i] == '!' || text[i] == '?')
        {
            count++;
        }
    }

    return count;
}

// Returns average count of letters per 100 words
float Average_Letters(float letters, float words)
{
    return (letters * 100) / words;
}

// Returns average count of sentences per 100 words
float Average_Sentences(float sentences, float words)
{
    return (sentences * 100) / words;
}

// Returns Coleman-Liau index
float Coleman_Liau_Index(float avg_letters, float avg_sentences)
{
    return 0.0588 * avg_letters - .296 * avg_sentences - 15.8;
}