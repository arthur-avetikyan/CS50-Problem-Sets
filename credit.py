def main():
    exit = True
    card_num = 0

    while exit:
        print("Number: ", end="")
        card_num = int(input())
        if test_card_number(card_num):
            determine_card_type(card_num)
            exit = False
        else:
            print("INVALID")
            exit = False

# Determine card type.


def determine_card_type(card_num):
    if (card_num % 10**15 - card_num % 10**13) / 10**13 == 34 or (card_num % 10**15 - card_num % 10**13) / 10**13 == 37:
        print("AMEX")
    elif (card_num - card_num % 10**14) / 10**14 == 51 or (card_num - card_num % 10**14) / 10**14 == 52 or (card_num - card_num % 10**14) / 10**14 == 53 or (card_num - card_num % 10**14) / 10**14 == 54 or (card_num - card_num % 10**14) / 10**14 == 55:
        print("MASTERCARD")
    elif (card_num - card_num % 10**15) / 10**15 == 4 or (card_num % 10**14 - card_num % 10**13) / 10**13 == 4:
        print("VISA")
    else:
        print("INVALID")

# Card number validation test.


def test_card_number(card_num):
    if card_num < 10**17 and card_num >= 10**14:
        evenDigitsSum = 0
        evenDigits = 0
        oddDigits = 0
        oddDigitsSum = 0
        i = 100
        while i < 10**17:
            evenDigits = (((card_num % i) - (card_num % (i / 10))) / (i / 10)) * 2
            evenDigitsSum = evenDigitsSum + (evenDigits % 10 + ((evenDigits % 100) - (evenDigits % 10)) / 10)
            oddDigits = ((card_num % (i / 10)) - (card_num % (i / 100))) / (i / 100)
            oddDigitsSum = oddDigitsSum + oddDigits
            i *= 100
        if (evenDigitsSum + oddDigitsSum) % 10 == 0:
            return True
        else:
            return False
    else:
        return False


main()