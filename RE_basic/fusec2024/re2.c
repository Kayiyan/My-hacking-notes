#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>

void scrambleData(char *data, char key);

char *generateSerial(const char *username) {
    size_t username_len = strlen(username);
    char *serial = (char *)malloc(username_len + 12);
    strcpy(serial, username);
    strcat(serial, "youfoundme");
    scrambleData(serial, 171);  // scrambleData takes a pointer and a char
    size_t serial_len = strlen(serial);

    char *result = (char *)malloc(2 * serial_len + 1);
    for (size_t i = 0; i < serial_len; ++i) {
        sprintf(result + 2 * i, "%02x", (unsigned char)serial[i]);
    }
    free(serial);
    return result;
}

void scrambleData(char *data, char key) {
    for (int i = 0;; ++i) {
        if (data[i] == '\0') break;
        data[i] ^= key;
    }
}

int modifyString(char *str) {
    const char *prefix = "FUSec{";
    const char *suffix = "}";

    size_t prefix_len = strlen(prefix);
    size_t suffix_len = strlen(suffix);
    size_t str_len = strlen(str);

    if (str_len < prefix_len + suffix_len ||
        strncmp(str, prefix, prefix_len) != 0 ||
        strncmp(str + str_len - suffix_len, suffix, suffix_len) != 0) {
        return 0;
    }

    memmove(str, str + prefix_len, str_len - prefix_len - suffix_len);
    str[str_len - prefix_len - suffix_len] = '\0';

    size_t new_len = strlen(str);
    for (size_t i = 0; i < new_len / 2; ++i) {
        char temp = str[i];
        str[i] = str[new_len - i - 1];
        str[new_len - i - 1] = temp;
    }
    return 1;
}

int compare(const char *username, const char *license_key) {
    char *serial = generateSerial(username);
    int result = 1;

    printf("Generated Serial: %s\n", serial);

    if (strlen(serial) == strlen(license_key)) {
        for (size_t i = 0; i < strlen(serial); ++i) {
            if (toupper(serial[i]) != toupper(license_key[i])) {
                result = 0;
                break;
            }
        }
    } else {
        result = 0;
    }

    free(serial);
    return result;
}

int main(int argc, const char **argv, const char **envp) {
    char username[256];
    char license_key[256];

    printf("Enter username: ");
    fgets(username, sizeof(username), stdin);
    username[strcspn(username, "\n")] = 0;

    // Generate and print license key if username is "fpt"
    if (strcmp(username, "fpt") == 0) {
        char *correct_key = generateSerial("fpt");
        printf("Correct License Key for user fpt: %s\n", correct_key);
        free(correct_key);
    }

    printf("Enter license key: ");
    fgets(license_key, sizeof(license_key), stdin);
    license_key[strcspn(license_key, "\n")] = 0;

    if (!modifyString(license_key)) {
        puts("Invalid License Key!");
        return 1;
    }

    printf("Modified License Key: %s\n", license_key);

    if (compare(username, license_key)) {
        puts("Valid License Key!");
    } else {
        puts("Invalid License Key!");
    }

    return 0;
}
