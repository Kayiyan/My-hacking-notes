#define _XOPEN_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pwd.h>
#include <shadow.h>
#include <crypt.h>
#include <errno.h>

int check_password(const char *username, const char *old_password) {
    struct spwd *spw;
    char *encrypted;

    spw = getspnam(username);
    if (spw == NULL) {
        perror("getspnam");
        return -1;
    }

    encrypted = crypt(old_password, spw->sp_pwdp);
    if (strcmp(encrypted, spw->sp_pwdp) == 0) {
        return 1;  
    } else {
        return 0; 
    }
}

int change_password(const char *username, const char *new_password) {
    char *salt = "$6$";
    char *encrypted = crypt(new_password, salt);

    if (encrypted == NULL) {
        perror("crypt");
        return -1;
    }

    FILE *shadow_file = fopen("/etc/shadow", "r+");
    if (shadow_file == NULL) {
        perror("fopen");
        return -1;
    }

    char buffer[1024];
    char new_shadow_line[1024];
    struct spwd *spw;

    while (fgets(buffer, sizeof(buffer), shadow_file)) {
        if (strstr(buffer, username)) {
            spw = getspnam(username);
            if (spw != NULL) {
                sprintf(new_shadow_line, "%s:%s:%ld::::::\n", username, encrypted, spw->sp_lstchg);
                fseek(shadow_file, -strlen(buffer), SEEK_CUR);
                fputs(new_shadow_line, shadow_file);
            }
            break;
        }
    }

    fclose(shadow_file);
    return 0;
}

int main() {
    char username[256];
    char old_password[256];
    char new_password[256];

    printf("Enter username: ");
    scanf("%s", username);

    printf("Enter old password: ");
    scanf("%s", old_password);

    if (check_password(username, old_password)) {
        printf("Old password is correct. Enter new password: ");
        scanf("%s", new_password);

        if (change_password(username, new_password) == 0) {
            printf("Password changed successfully.\n");
        } else {
            printf("Error changing password.\n");
        }
    } else {
        printf("Old password is incorrect.\n");
    }

    return 0;
}
