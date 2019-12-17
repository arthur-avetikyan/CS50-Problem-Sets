#include <cs50.h>
#include <stdio.h>

void print_pyramid(int n);
void print_left_column(int y, int z);
void print_right_column(int i);

int main(void)
{
    int n = get_int("How much?\n");
    if (n > 0 && n < 9)
    {
        print_pyramid(n);
    }
}

// Use this method to paint the pyramid.
void print_pyramid(int n)
{
    int y;
    int z;
    for (int i = 0; i < n; i++)
    {   
        y = n - i - 1;
        z = n - y;
        
        print_left_column(y, z);        
        printf(" ");
        print_right_column(i);        
        printf("\n");   
    }
}

// Use this method to paint left side of pyramid.
void print_left_column(int y, int z)
{
    for (; y > 0; y--)
    {
        printf(" ");
    }   
    for (; z > 0; z--)
    {
        printf("#");
    }
}

// Use this method to paint right side of pyramid.
void print_right_column(int i)
{
    for (int y = 0; y < i + 1; y++)
    {
        printf("#");
    }
}
