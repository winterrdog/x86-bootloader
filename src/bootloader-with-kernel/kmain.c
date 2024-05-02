#define SCREEN_WIDTH            80
#define SCREEN_LENGTH           25
#define VGA_BUFFER_ADDR         0xb8000
#define TEXT_COLOR_GREEN        0xe000 // yellow bkg(e) & white text(0)

static unsigned int strlen(const char* s)
{
    unsigned int length = 0;
    const char* p = s;

    while (*p++)
        length++;

    return length;
}

void kmain(void)
{
    const char* message = "hey from C world!!!";
    short msg_len = strlen(message);
    
    const short color = TEXT_COLOR_GREEN;
    short* vga = (short*)VGA_BUFFER_ADDR;

    for (int i = 0; i != msg_len; ++i) {
        // write on the third row( 80 x 2 ) since the asm program
        // will have written to the first row. So 3rd row starts at
        // 80 and beyond
        vga[i + SCREEN_WIDTH*2] = color | message[i];
    }

    return;
}