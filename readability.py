def main():
    print("Text: ", end="")
    text = input()
    letters = count_letters(text)
    words = count_words(text)
    sentences = count_sentences(text)

    index = int(0.0588 * (letters * 100 / words) - .296 * (sentences * 100 / words) - 15.8)


    if index < 1:
        print("Before Grade 1")
    elif index < 17:
        print(f"Grade {index}")
    else:
        print("Grade 16+")


def count_letters(text):
    count = 0
    for c in text:
        if c.isalpha():
            count += 1
    return count


def count_words(text):
    count = 0
    for w in text:
        if w == " ":
            count += 1
    return count


def count_sentences(text):
    count = 0
    for s in text:
        if s in ('.', '!', '?'):
            count += 1
    return count


main()