__kernel void calculate_pixel(
	__global const unsigned char* ImgIn,
	__global const float* GaussKernel,
	__global const int* radiusRef,
	__global const int* widthRef,
	__global const int* heightRef,
	__global unsigned char* ImgOut)
{
	int col = get_global_id(0);
	int row = get_global_id(1);

	int radius = *radiusRef;
	int diameter = radius * 2;
	int width = *widthRef;
	int height = *heightRef;

	if (col == 0 && row == 0)
	{
		printf("col: %d \n", col);
		printf("row: %d \n", row);
		printf("radius: %d \n", radius);
		printf("diameter: %d \n", diameter);
		printf("width: %d \n", width);
		printf("height: %d \n", height);
	}

	for (int c = 0; c < 3; c++)
	{
		float sum = 0;
		float sumKernel = 0;

		for (int y = -radius; y <= radius; y++)
		{
			for (int x = -radius; x <= radius; x++)
			{
				float kernelValue = GaussKernel[(x + radius) * diameter + y + radius];

				int rowPixel = row;
				int colPixel = col;

				if ((row + y) >= 0 && (row + y) < height)
				{
					rowPixel += y;
				}

				if ((col + x) >= 0 && (col + x) < width)
				{
					colPixel += x;
				}

				int color = ImgIn[rowPixel * 3 * width + colPixel * 3 + c];
				sum += color * kernelValue;
				sumKernel += kernelValue;
			}
		}

		double newValue = sum / sumKernel;

		if (col == 0 && row == 0)
		{
			printf("sumKernel channel #%d: %f \n", c, sumKernel);
			printf("sum channel #%d: %f \n", c, sum);
			printf("sum / sumKernel channel #%d: %f \n", c, newValue);
		}

		ImgOut[3 * row * width + 3 * col + c] = newValue;
	}
}