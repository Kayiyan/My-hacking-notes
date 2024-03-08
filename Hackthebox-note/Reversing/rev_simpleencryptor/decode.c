#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

int main()
{
    uint8_t rand1, rand2, x, size;
    FILE *fp; 
    int seed;           // 1655780698
    uint8_t flag[29];   // +1 for null terminator
    flag[28] = '\0';    // Null-terminate the flag string

    fp = fopen("flag.enc", "rb"); 
    
    fread(&seed, 4, 1, fp); 
    fread(&flag, 1, 28, fp); 
    srand(seed); 
    for(int i = 0; i < 28; i++){
    	rand1 = rand(); 
    	rand2 = rand() & 7; 
	flag[i] = (flag[i]>>rand2 | flag[i]<<8-rand2) ^ (rand1);
    }
    printf("%s\n",flag);
    fclose(fp);
}