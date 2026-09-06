
#ifdef VERSION_STRING
    #define VER     " "VERSION_STRING
#else
    #define VER     ""
#endif

    const char Version[]      = AUTHOR_STRING " " VER;
    const char Edition[]      = EDITION_STRING;

const char UART_Version[] = "UV-K5 Firmware, " AUTHOR_STRING VER "\r\n";
