FROM ubuntu:22.04

RUN apt update && apt install -y g++-aarch64-linux-gnu qemu-user-static
RUN touch main.c
RUN echo "#include <stdio.h>              " >> main.c
RUN echo "                                " >> main.c
RUN echo "int main(){                     " >> main.c
RUN echo "    printf(\"Hello World\\\n\");" >> main.c
RUN echo "    return 0;                   " >> main.c
RUN echo "}                               " >> main.c
RUN aarch64-linux-gnu-g++ -static main.c -o for_arm64
