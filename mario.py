def main():
    h = 0
    while not 0 < h < 9:
        print("Height: ", end="")
        h = input().isdigit()
    draw_pyramid(h)

def ask_for_number():
    print("Height: ", end="")
    h = int(input())
    if 0 < h < 9:
        return h
    else:
        ask_for_number()

def draw_pyramid(h):
    for i in range(h):
        y = h - i - 1
        z = h - y
        print_left_column(y, z)
        print("  ", end="")
        print_right_column(i)
        print()


def print_left_column(y, z):
    for n in range(y):
        print(" ", end="")
    for n in range(z):
        print("#", end="")

def print_right_column(i):
    for y in range(i + 1):
        print("#", end="")

main()