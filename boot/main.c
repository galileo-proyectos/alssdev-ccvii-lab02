__asm__(".code16\n");

extern void WriteLine(void);

void
bootmain(void)
{
  while (1) {
    WriteLine();
  }
}

