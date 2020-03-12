def main():
    h = 0
    while not 0 < h < 9:
        print("Height: ", end="")
        i = input()
        if i.isdigit():
            h = int(i)
    draw_pyramid(h)

# Draw pyramid


def draw_pyramid(h):
    for i in range(h):
        y = h - i - 1
        z = h - y
        print_left_column(y, z)
        print("  ", end="")
        print_right_column(i)
        print()

# Draw left column


def print_left_column(y, z):
    for n in range(y):
        print(" ", end="")
    for n in range(z):
        print("#", end="")

# Draw right column


def print_right_column(i):
    for y in range(i + 1):
        print("#", end="")


main()