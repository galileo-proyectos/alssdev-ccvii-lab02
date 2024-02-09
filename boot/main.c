__asm__(".code16\n");

extern void WriteLine();
extern void ReadLine();

void
bootmain(void)
{
  while (1) {
    ReadLine();
    WriteLine();
  }
}

