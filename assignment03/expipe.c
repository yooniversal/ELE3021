/**
 * This is the example code of using pipe between two processes.
 * A parent process will send messages periodically via the pipe,
 * and a child process will receive the message from the pipe and print it.
 */

#include "types.h"
#include "stat.h"
#include "user.h"

#define SIZE_MSG  1               /* Size of each message */
#define SIZE_BUF  (SIZE_MSG + 1)  /* Size of reader's buffer */
#define PERIOD    10              /* Period of sending messages */

int
main(int argc, char *argv[])
{
  char *str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  char buf[SIZE_BUF];
  int fds[2];
  int pid;
  int n, i;

  /* Create a pipe. */
  pipe(fds);

  pid = fork();
  if (pid > 0) {
    /* The parent process gets into here */
    /* Close the reader's fd */
    close(fds[0]);

    /* Send messages periodically */
    for (i = 0; i < strlen(str); i += SIZE_MSG) {
      write(fds[1], &str[i], SIZE_MSG);
      sleep(PERIOD);
    }

    /* Close the writer's fd */
    close(fds[1]);

    /* Wait for the child process to be done */
    wait();

  } else if (pid == 0) {
    /* The child process gets into here  */
    /* Close the writer's fd */
    close(fds[1]);

    while (1) {
      memset(buf, 0, SIZE_BUF);

      /* Read message from the pipe if any */
      n = read(fds[0], buf, SIZE_MSG);
      if (n <= 0) break;

      /* Print received message */
      printf(1, "%s\n", buf);
    }

    /* Close the reader's fd */
    close(fds[0]);

  } else {
    printf(1, "fork failed");
    exit();
  }
 
  exit();
}
