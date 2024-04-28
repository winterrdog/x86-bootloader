static unsigned int strlen(const char *s) {
  unsigned int length = 0;
  const char *p = s;

  while (*p++) {
    length++;
  }

  return length;
}

void kmain(void) {
  const short color = 0x0e00;
  const char *message = "hey from C world!!!";
  short msg_len = strlen(message);
  short *vga = (short *)0xb8000;

  for (int i = 0; i != msg_len; ++i) {
    vga[i + 80] = color | message[i]; // todo: fix vga index
  }

  return;
}