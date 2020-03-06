#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

typedef uint8_t BYTE;

const BYTE first_byte = 0xff;
const BYTE second_byte = 0xd8;
const BYTE third_byte = 0xff;
const int block = 512;

void access_memory(FILE *file, BYTE *memory_block, int *file_name, bool *counter, char *name, int *size);
void recover_image(BYTE *memory_block, int *file_name, bool *counter, char *name);

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Usage: ./recover image");
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (file == NULL)
    {
        printf("Could not access the memory.");
    }

    BYTE *memory_block = malloc(block);
    char *name = malloc(8 * sizeof(char));
    int file_name = 0;
    bool counter = false;
    fseek(file, 0, SEEK_END);
    int size = ftell(file);
    rewind(file);

    access_memory(file, memory_block, &file_name, &counter, name, &size);

    free(memory_block);
    free(name);
    fclose(file);
}

void access_memory(FILE *file, BYTE *memory_block, int *file_name, bool *counter, char *name, int *size)
{
    int it_count = 0;
    for (int i = 0; i < *size / block; i++)
    {
        fread(memory_block, sizeof(char), block, file);

        if (memory_block[0] == first_byte && memory_block[1] == second_byte && memory_block[2] == third_byte && !*counter)
        {
            recover_image(memory_block, file_name, counter, name);
        }
        else if (*counter)
        {
            recover_image(memory_block, file_name, counter, name);
        }
        it_count ++;
    }

    printf("%i\n", it_count);
}

void recover_image(BYTE *memory_block, int *file_name, bool *counter, char *name)
{
    if (!*counter)
    {
        *file_name < 10 ? sprintf(name, "00%i.jpg", *file_name) : *file_name >= 10
        && *file_name < 100 ? sprintf(name, "0%i.jpg", *file_name) : sprintf(name, "%i.jpg", *file_name);
    }

    FILE *image = fopen(name, "a");

    for (int y = 0; y < block; y++)
    {
        if (memory_block[0] == first_byte && memory_block[1] == second_byte && memory_block[2] == third_byte && *counter)
        {
            *file_name += 1;
            *counter = false;
            fclose(image);
            recover_image(memory_block, file_name, counter, name);
            return;
        }
        fputc(memory_block[y], image);
    }
    *counter = true;
    fclose(image);
}