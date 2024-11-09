#include <stdio.h>
#include <stdlib.h>

/*
 * PRE: /
 * POST: returns the value of c taken as a roman digit
 *       (ignores invalid characters)
 */
int digit_to_int(char c)
{
    switch (c) {
        case 'M':
        case 'm':
            return 1000;
        case 'D':
        case 'd':
            return 500;
        case 'C':
        case 'c':
            return 100;
        case 'L':
        case 'l':
            return 50;
        case 'X':
        case 'x':
            return 10;
        case 'V':
        case 'v':
            return 5;
        case 'I':
        case 'i':
            return 1;
        default:
            return 0;
    }
}

/*
 * PRE: /
 * POST: returns the value of c taken as a roman numeral
 *      (ignores invalid characters)
 */
int roman_to_int(char* c)
{
    int result = 0;
    char a;

    while (a = *c++) { /* traverse the entire string */
        if (digit_to_int(a) < digit_to_int(*c)) /* this handles cases like IV, XC, but also IC = 99 */
            result += digit_to_int(*c++)-digit_to_int(a);
        else
            result += digit_to_int(a);
    }
    return result;
}

/*
 * PRE: c is at least of size 16
 * (the longest output of this function is MMMDCCCLXXXVIII = 3888)
 * POST: c contains n in roman numerals, if it exists
 */
void int_to_roman(int n, char* c)
{
	char nums[7] = {'M','D','C','L','X','V','I'};
	int vals[7] = {1000,500,100,50,10,5,1};
	int i, j=0;

	if(n<=0 || n>=4000) {
		c[0] = '\0';
        return;
    }

    for(i=0;i<7;i++) {
		int k = n/vals[i];
		while(k--)
			c[j++] = nums[i];
		n %= vals[i];

        if (i%2==0) {
            if (n>= vals[i]-vals[i+2] && i<5) { //handles 9, 90 and 900
                c[j++] = nums[i+2];
                c[j++] = nums[i];
                n -= vals[i]-vals[i+2];
            }
        } else {
            if (n>= vals[i]-vals[i+1] && i<6) { // handles 4, 40, 400
                c[j++] = nums[i+1];
                c[j++] = nums[i];
                n -= vals[i]-vals[i+1];
            }
        }
	}
	c[j] = '\0';
}

int main(void)
{
	int i;
	char c[16];
	for(i=0;i<=100;i++) {
		int_to_roman(i, c);
		printf("%4d : %s  %i\n", i, c, roman_to_int(c));
	}
	return EXIT_SUCCESS;
}
