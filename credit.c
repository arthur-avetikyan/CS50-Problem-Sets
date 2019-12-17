#include <cs50.h>
#include <stdio.h>

void determine_card_type(long cardNumber);
bool test_card_number(long cardNumber);
long Pow(long num, long power);

int main(void)
{
    bool exit = true;
    long cardNumber;
    
    while (exit)
    {
        cardNumber = get_long("Number: \n");
        if (test_card_number(cardNumber))
        {
            determine_card_type(cardNumber);
            exit = false;
        }
        else
        {
            exit = false;
        }
    }
}

// Determine card type.
void determine_card_type(long cardNumber)
{
    if ((cardNumber % Pow(10, 15) - cardNumber % Pow(10, 13)) / Pow(10, 13) == 34 ||
        (cardNumber % Pow(10, 15) - cardNumber % Pow(10, 13)) / Pow(10, 13) == 37)
    {
        printf("AMEX\n");
    }
    else if ((cardNumber - cardNumber % Pow(10, 14)) / Pow(10, 14) == 51 ||
             (cardNumber - cardNumber % Pow(10, 14)) / Pow(10, 14) == 52 ||
             (cardNumber - cardNumber % Pow(10, 14)) / Pow(10, 14) == 53 ||
             (cardNumber - cardNumber % Pow(10, 14)) / Pow(10, 14) == 54 ||
             (cardNumber - cardNumber % Pow(10, 14)) / Pow(10, 14) == 55)
    {
        printf("MASTERCARD\n");
    }
    else if ((cardNumber - cardNumber % Pow(10, 15)) / Pow(10, 15) == 4 ||
             (cardNumber % Pow(10, 14) - cardNumber % Pow(10, 13)) / Pow(10, 13) == 4)
    {
        printf("VISA\n");
    }
    else
    {
        printf("INVALID\n");
    }
}

// Card number validation test.
bool test_card_number(long cardNumber)
{
    if (cardNumber < Pow(10, 17) && cardNumber >= Pow(10, 14))
    {
        long evenDigitsSum = 0;
        long evenDigits = 0;
        long oddDigits = 0;
        long oddDigitsSum = 0;
        for (long i = 100; i < Pow(10, 17); i *= 100)
        {
            evenDigits = (((cardNumber % i) - (cardNumber % (i / 10))) / (i / 10)) * 2;
            evenDigitsSum = evenDigitsSum + (evenDigits % 10 + ((evenDigits % 100) - (evenDigits % 10)) / 10);
            
            oddDigits = ((cardNumber % (i / 10)) - (cardNumber % (i / 100))) / (i / 100);
            oddDigitsSum = oddDigitsSum + oddDigits;
        } 
        
        if ((evenDigitsSum + oddDigitsSum) % 10 == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    else
    {
        printf("INVALID\n");
        return false;
    }    
}

// Returns a specified number raised to the specified power.
long Pow(long num, long power)
{
    long result = num;
    for (int i = 0; i < power - 1; i++)
    {
        result = num * result;
    }
    return result;
}
