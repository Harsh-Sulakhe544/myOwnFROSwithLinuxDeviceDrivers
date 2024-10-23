#include <stdint.h>

// CLONE OF MEMCPY() FUNCTOIN
void memory_copy(uint8_t *source, uint8_t *dest, uint32_t nbytes) {
    int i;
    for (i = 0; i < nbytes; i++) {
        *(dest + i) = *(source + i);
    }
}

// GET THE LENGTH OF THE STRING 
int string_length(char s[]) {
    int i = 0;
    while (s[i] != '\0') ++i;
    return i;
}

// 2 POINTER APPROACH TO REVERSE THE  STRING 
void reverse(char s[]) {
    int c, i, j;
    for (i = 0, j = string_length(s)-1; i < j; i++, j--) {
        c = s[i]; // TEMP = CURR
        s[i] = s[j]; // CURR=LAST
        s[j] = c; // LAST=TEMP
    }
}

// INTEGER TO STRING 
void int_to_string(int n, char str[]) {
    int i, sign;
    if ((sign = n) < 0) n = -n; // TO CHECK NEGATIVE NO , CONVERT TO POSITIVE EQUIVALENT
    i = 0;
    do {
        str[i++] = n % 10 + '0'; // LAST-CHARACTER + TO CONVERT TO ASCII CHARACTER 
    } while ((n /= 10) > 0); // FOR ALL CHARACTERS 

    if (sign < 0) str[i++] = '-'; // APPEND THE -VE SIGN 
    str[i] = '\0'; // LAST TERMINATION CHARACTER 
	// EX : 15 ==> '5' , '1' , '\0' , REVERSE IT 
    reverse(str); // '1', '5' , '\0'
}
