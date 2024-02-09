
obj/boot/boot.out:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
start:
  # FIRST PHASE: Register y operation mode setup.
  # Assemble for 16-bit mode  

  # disable interrupts
  cli
    7c00:	fa                   	cli    

	# The BIOS loads this code from the first sector of the hard disk into
	# memory at physical address 0x7c00 and starts executing in real mode
	# with %cs=0 %ip=7c00.
  movw $0x07C0, %ax 
    7c01:	b8 c0 07 8e d8       	mov    $0xd88e07c0,%eax
  movw %ax, %ds
  movw %ax, %es
    7c06:	8e c0                	mov    %eax,%es
  movw %ax, %fs
    7c08:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
    7c0a:	8e e8                	mov    %eax,%gs

	#Stack Initialization
  movw $0x0000, %ax 
    7c0c:	b8 00 00 8e d0       	mov    $0xd08e0000,%eax
  movw %ax, %ss
  movw $0xFFFF, %sp
    7c11:	bc ff ff fb e8       	mov    $0xe8fbffff,%esp
  
  # enable interrupts
  sti

  call bootmain
    7c16:	27                   	daa    
	...

00007c18 <WriteLine>:

.globl WriteLine
.type WriteLine, @function
WriteLine:
  # save caller base pointer
  push %ebp
    7c18:	66 55                	push   %bp
  movl %esp, %ebp
    7c1a:	66 89 e5             	mov    %sp,%bp
 
  # local variables
  # no local variables were used

  # save calle-saved regiters
  push %ebx
    7c1d:	66 53                	push   %bx
  push %edi
    7c1f:	66 57                	push   %di
  push %esi
    7c21:	66 56                	push   %si

  movw $buffer, %si
    7c23:	be                   	.byte 0xbe
    7c24:	84                   	.byte 0x84
    7c25:	7c                   	.byte 0x7c

00007c26 <while_loop>:
while_loop: 
  movb (%si), %al
    7c26:	8a 04 b4             	mov    (%esp,%esi,4),%al
  movb $0x0E, %ah         #Bios Teletype,This number must be used to
    7c29:	0e                   	push   %cs
                          #tell the BIOS to put a character on the screen 
  movb $0x00, %bh         #Page number (For most of our work this will remain 0x00)
    7c2a:	b7 00                	mov    $0x0,%bh
  movb $0x07, %bl         #Text attribute (For most of our work this will remain 0x07)
    7c2c:	b3 07                	mov    $0x7,%bl
                          #Try to change this value
  int $0x10
    7c2e:	cd 10                	int    $0x10
 
  # increase buffer
  inc %si
    7c30:	46                   	inc    %esi
  cmp $0, (%si)
    7c31:	83 3c 00 75          	cmpl   $0x75,(%eax,%eax,1)
  jne while_loop
    7c35:	f0 66 5e             	lock pop %si
  # no local variables were used
  # mov %bp, %sp

  # Restore the caller's registers.
  pop %esi
  pop %edi
    7c38:	66 5f                	pop    %di
  pop %ebx
    7c3a:	66 5b                	pop    %bx
  pop %ebp
    7c3c:	66 5d                	pop    %bp
  
  # return :D
  ret
    7c3e:	c3                   	ret    

00007c3f <bootmain>:

extern void WriteLine();

void
bootmain(void)
{
    7c3f:	66 55                	push   %bp
    7c41:	66 89 e5             	mov    %sp,%bp
    7c44:	66 83 ec 08          	sub    $0x8,%sp

 //for (int i = 0; i < 10; i ++) {
  WriteLine();
    7c48:	e8 cd ff eb fe       	call   feec7c1a <__bss_start+0xfeebff92>
