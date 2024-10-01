#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pwd.h>
#include <grp.h>
#include <unistd.h>
#include <sys/types.h>

void display_user_info(const char* username) {
    struct passwd *pw;
    struct group *gr;
    gid_t *groups;
    int ngroups = 0;

    pw = getpwnam(username);
    if (pw == NULL) {
        printf("User '%s' not found.\n", username);
        return;
    }

    printf("Username: %s\n", pw->pw_name);
    printf("User ID: %d\n", pw->pw_uid);
    printf("Home Directory: %s\n", pw->pw_dir);

    // Lấy danh sách các nhóm của user
    getgrouplist(username, pw->pw_gid, NULL, &ngroups);
    groups = malloc(ngroups * sizeof(gid_t));
    getgrouplist(username, pw->pw_gid, groups, &ngroups);

    printf("Groups: ");
    for (int i = 0; i < ngroups; i++) {
        gr = getgrgid(groups[i]);
        if (gr != NULL) {
            printf("%s ", gr->gr_name);
        }
    }
    printf("\n");

    free(groups);
}

int main() {
    char username[256];

    printf("Enter username: ");
    scanf("%s", username);

    display_user_info(username);

    return 0;
}
