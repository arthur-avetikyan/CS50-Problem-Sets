#include "helpers.h"

#include <math.h>
#include <stdlib.h>
#include <stdio.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
	for (int i = 0; i < height; i++)
	{
		for (int y = 0; y < width; y++)
		{
			BYTE temp_color = round((image[i][y].rgbtBlue + image[i][y].rgbtGreen + image[i][y].rgbtRed) / 3.0);

			image[i][y].rgbtBlue = temp_color;
			image[i][y].rgbtGreen = temp_color;
			image[i][y].rgbtRed = temp_color;
		}
	}
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
	RGBTRIPLE temp;
	for (int i = 0; i < height; i++)
	{
		for (int y = 0; y < width / 2; y++)
		{
			if (y != width - y - 1)
			{
				temp = image[i][width - y - 1];
				image[i][width - y - 1] = image[i][y];
				image[i][y] = temp;
			}
		}
	}
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
	RGBTRIPLE temp_image[height][width];
	for (int i = 0; i < height; i++)
	{
		for (int y = 0; y < width; y++)
		{
			int rgbtBlue = 0;
			int rgbtGreen = 0;
			int rgbtRed = 0;

			float pixel_count = 1.0;

			BYTE average_blue = 0;
			BYTE average_red = 0;
			BYTE average_green = 0;

			rgbtBlue = image[i][y].rgbtBlue;
			rgbtGreen = image[i][y].rgbtGreen;
			rgbtRed = image[i][y].rgbtRed;
			if (i + 1 >= 0 && i + 1 < height)
			{
				rgbtBlue += image[i + 1][y].rgbtBlue;
				rgbtGreen += image[i + 1][y].rgbtGreen;
				rgbtRed += image[i + 1][y].rgbtRed;
				pixel_count++;
			}
			if (i - 1 >= 0 && i - 1 < height)
			{
				rgbtBlue += image[i - 1][y].rgbtBlue;
				rgbtGreen += image[i - 1][y].rgbtGreen;
				rgbtRed += image[i - 1][y].rgbtRed;
				pixel_count++;
			}
			if (y + 1 >= 0 && y + 1 < width)
			{
				rgbtBlue += image[i][y + 1].rgbtBlue;
				rgbtGreen += image[i][y + 1].rgbtGreen;
				rgbtRed += image[i][y + 1].rgbtRed;
				pixel_count++;
			}
			if (y - 1 >= 0 && y - 1 < width)
			{
				rgbtBlue += image[i][y - 1].rgbtBlue;
				rgbtGreen += image[i][y - 1].rgbtGreen;
				rgbtRed += image[i][y - 1].rgbtRed;
				pixel_count++;
			}
			if (i + 1 >= 0 && i + 1 < height && y + 1 >= 0 && y + 1 < width)
			{
				rgbtBlue += image[i + 1][y + 1].rgbtBlue;
				rgbtGreen += image[i + 1][y + 1].rgbtGreen;
				rgbtRed += image[i + 1][y + 1].rgbtRed;
				pixel_count++;
			}
			if (i + 1 >= 0 && i + 1 < height && y - 1 >= 0 && y - 1 < width)
			{
				rgbtBlue += image[i + 1][y - 1].rgbtBlue;
				rgbtGreen += image[i + 1][y - 1].rgbtGreen;
				rgbtRed += image[i + 1][y - 1].rgbtRed;
				pixel_count++;
			}
			if (i - 1 >= 0 && i - 1 < height && y + 1 >= 0 && y + 1 < width)
			{
				rgbtBlue += image [i - 1][y + 1].rgbtBlue;
				rgbtGreen += image [i - 1][y + 1].rgbtGreen;
				rgbtRed += image [i - 1][y + 1].rgbtRed;
				pixel_count++;
			}
			if (i - 1 >= 0 && i - 1 < height && y - 1 >= 0 && y - 1 < width)
			{
				rgbtBlue += image[i - 1][y - 1].rgbtBlue;
				rgbtGreen += image[i - 1][y - 1].rgbtGreen;
				rgbtRed += image[i - 1][y - 1].rgbtRed;
				pixel_count++;
			}

			average_blue = (BYTE) round(rgbtBlue / pixel_count);
			average_green = (BYTE) round(rgbtGreen / pixel_count);
			average_red = (BYTE) round(rgbtRed / pixel_count);

			temp_image[i][y].rgbtBlue = average_blue;
			temp_image[i][y].rgbtGreen = average_green;
			temp_image[i][y].rgbtRed = average_red;
		}
	}

	for (int i = 0; i < height; i++)
	{
		for (int y = 0; y < width; y++)
		{
			image[i][y].rgbtBlue = temp_image[i][y].rgbtBlue;
			image[i][y].rgbtGreen = temp_image[i][y].rgbtGreen;
			image[i][y].rgbtRed = temp_image[i][y].rgbtRed;
		}
	}
}

// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{
	RGBTRIPLE temp_image[height][width];

	for (int i = 0; i < height; i++)
	{
		for (int y = 0; y < width; y++)
		{
			int rgbtBlue_gy = 0;
			int rgbtGreen_gy = 0;
			int rgbtRed_gy = 0;

			int rgbtBlue_gx = 0;
			int rgbtGreen_gx = 0;
			int rgbtRed_gx = 0;

			int avg_blue = 0;
			int avg_red = 0;
			int avg_green = 0;

			rgbtBlue_gy += -1 * ((i - 1 >= 0 && i - 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i - 1][y - 1].rgbtBlue : 0);
			rgbtBlue_gy += -2 * ((i - 1 >= 0 && i - 1 < height) ? image[i - 1][y].rgbtBlue : 0);
			rgbtBlue_gy += -1 * ((i - 1 >= 0 && i - 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i - 1][y + 1].rgbtBlue : 0);
			rgbtBlue_gy += 1 * ((i + 1 >= 0 && i + 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i + 1][y - 1].rgbtBlue : 0);
			rgbtBlue_gy += 2 * ((i + 1 >= 0 && i + 1 < height) ? image[i + 1][y].rgbtBlue : 0);
			rgbtBlue_gy += 1 * ((i + 1 >= 0 && i + 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i + 1][y + 1].rgbtBlue : 0);

			rgbtGreen_gy += -1 * ((i - 1 >= 0 && i - 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i - 1][y - 1].rgbtGreen : 0);
			rgbtGreen_gy += -2 * ((i - 1 >= 0 && i - 1 < height) ? image[i - 1][y].rgbtGreen : 0);
			rgbtGreen_gy += -1 * ((i - 1 >= 0 && i - 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i - 1][y + 1].rgbtGreen : 0);
			rgbtGreen_gy += 1 * ((i + 1 >= 0 && i + 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i + 1][y - 1].rgbtGreen : 0);
			rgbtGreen_gy += 2 * ((i + 1 >= 0 && i + 1 < height) ? image[i + 1][y].rgbtGreen : 0);
			rgbtGreen_gy += 1 * ((i + 1 >= 0 && i + 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i + 1][y + 1].rgbtGreen : 0);

			rgbtRed_gy += -1 * ((i - 1 >= 0 && i - 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i - 1][y - 1].rgbtRed : 0);
			rgbtRed_gy += -2 * ((i - 1 >= 0 && i - 1 < height) ? image[i - 1][y].rgbtRed : 0);
			rgbtRed_gy += -1 * ((i - 1 >= 0 && i - 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i - 1][y + 1].rgbtRed : 0);
			rgbtRed_gy += 1 * ((i + 1 >= 0 && i + 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i + 1][y - 1].rgbtRed : 0);
			rgbtRed_gy += 2 * ((i + 1 >= 0 && i + 1 < height) ? image[i + 1][y].rgbtRed : 0);
			rgbtRed_gy += 1 * ((i + 1 >= 0 && i + 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i + 1][y + 1].rgbtRed : 0);

			rgbtBlue_gx += -1 * ((i - 1 >= 0 && i - 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i - 1][y - 1].rgbtBlue : 0);
			rgbtBlue_gx += -2 * ((y - 1 >= 0 && y - 1 < width) ? image[i][y - 1].rgbtBlue : 0);
			rgbtBlue_gx += -1 * ((i + 1 >= 0 && i + 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i + 1][y - 1].rgbtBlue : 0);
			rgbtBlue_gx += 1 * ((i - 1 >= 0 && i - 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i - 1][y + 1].rgbtBlue : 0);
			rgbtBlue_gx += 2 * ((y + 1 >= 0 && y + 1 < width) ? image[i][y + 1].rgbtBlue : 0);
			rgbtBlue_gx += 1 * ((i + 1 >= 0 && i + 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i + 1][y + 1].rgbtBlue : 0);

			rgbtGreen_gx += -1 * ((i - 1 >= 0 && i - 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i - 1][y - 1].rgbtGreen : 0);
			rgbtGreen_gx += -2 * ((y - 1 >= 0 && y - 1 < width) ? image[i][y - 1].rgbtGreen : 0);
			rgbtGreen_gx += -1 * ((i + 1 >= 0 && i + 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i + 1][y - 1].rgbtGreen : 0);
			rgbtGreen_gx += 1 * ((i - 1 >= 0 && i - 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i - 1][y + 1].rgbtGreen : 0);
			rgbtGreen_gx += 2 * ((y + 1 >= 0 && y + 1 < width) ? image[i][y + 1].rgbtGreen : 0);
			rgbtGreen_gx += 1 * ((i + 1 >= 0 && i + 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i + 1][y + 1].rgbtGreen : 0);

			rgbtRed_gx += -1 * ((i - 1 >= 0 && i - 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i - 1][y - 1].rgbtRed : 0);
			rgbtRed_gx += -2 * ((y - 1 >= 0 && y - 1 < width) ? image[i][y - 1].rgbtRed : 0);
			rgbtRed_gx += -1 * ((i + 1 >= 0 && i + 1 < height && y - 1 >= 0 && y - 1 < width) ? image[i + 1][y - 1].rgbtRed : 0);
			rgbtRed_gx += 1 * ((i - 1 >= 0 && i - 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i - 1][y + 1].rgbtRed : 0);
			rgbtRed_gx += 2 * ((y + 1 >= 0 && y + 1 < width) ? image[i][y + 1].rgbtRed : 0);
			rgbtRed_gx += 1 * ((i + 1 >= 0 && i + 1 < height && y + 1 >= 0 && y + 1 < width) ? image[i + 1][y + 1].rgbtRed : 0);

			int edge = 50;

			if (((rgbtBlue_gy > -edge && rgbtBlue_gy < edge) && (rgbtGreen_gy > -edge && rgbtGreen_gy < edge) && (rgbtRed_gy > -edge && rgbtRed_gy < edge))
			&& ((rgbtBlue_gx > -edge && rgbtBlue_gx < edge) && (rgbtGreen_gx > -edge && rgbtGreen_gx < edge) && (rgbtRed_gx > -edge && rgbtRed_gx < edge)))
			{
				temp_image[i][y].rgbtBlue = image[i][y].rgbtBlue;
				temp_image[i][y].rgbtGreen = image[i][y].rgbtGreen;
				temp_image[i][y].rgbtRed = image[i][y].rgbtRed;
			}
			else
			{
				avg_blue = round(sqrt(pow(rgbtBlue_gy, 2) + pow(rgbtBlue_gx, 2)));
				avg_green = round(sqrt(pow(rgbtGreen_gy, 2) + pow(rgbtGreen_gx, 2)));
				avg_red = round(sqrt(pow(rgbtRed_gy, 2) + pow(rgbtRed_gx, 2)));

				temp_image[i][y].rgbtBlue = avg_blue > 255 ? 255 : (BYTE) avg_blue;
				temp_image[i][y].rgbtGreen = avg_green > 255 ? 255 : (BYTE) avg_green;
				temp_image[i][y].rgbtRed = avg_red > 255 ? 255 : (BYTE) avg_red;
			}
		}
	}

	for (int i = 0; i < height; i++)
	{
		for (int y = 0; y < width; y++)
		{
			image[i][y].rgbtBlue = temp_image[i][y].rgbtBlue;
			image[i][y].rgbtGreen = temp_image[i][y].rgbtGreen;
			image[i][y].rgbtRed = temp_image[i][y].rgbtRed;
		}
	}
}
