
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
    7c16:	74 00                	je     7c18 <WriteLine>

00007c18 <WriteLine>:

.globl WriteLine
.type WriteLine, @function
WriteLine:
  # prologue
  pushw %bp               # store caller base pointer
    7c18:	55                   	push   %ebp
  movw %sp, %bp           # set my own base pointer
    7c19:	89 e5                	mov    %esp,%ebp
  pushw %bx               # store caller-saved registers used
    7c1b:	53                   	push   %ebx
  pushw %si               # ...
    7c1c:	56                   	push   %esi
  
  movw $buffer, %si       # load buffer address to %si reg
    7c1d:	be                   	.byte 0xbe
    7c1e:	d4 7c                	aam    $0x7c

00007c20 <wl_cond>:
wl_cond: 
  cmpb $0x0, (%si)        # test if the string's end was found
    7c20:	80 3c 00 74          	cmpb   $0x74,(%eax,%eax,1)
  je wl_end
    7c24:	0b ff                	or     %edi,%edi
  
  pushw (%si)            # pass %si as parameter 1
    7c26:	34 e8                	xor    $0xe8,%al
  call PrintChar         # invoice PrintCar
    7c28:	0a 00                	or     (%eax),%al
  add $0x2, %sp          # restore stack pointer and free mem
    7c2a:	83 c4 02             	add    $0x2,%esp
  
  incw %si               # move to next char and repeat
    7c2d:	46                   	inc    %esi
  jmp wl_cond
    7c2e:	eb f0                	jmp    7c20 <wl_cond>

00007c30 <wl_end>:

wl_end:
  # epilogue
  popw %si
    7c30:	5e                   	pop    %esi
  popw %bx                # restore caller-saved registers used
    7c31:	5b                   	pop    %ebx
  popw %bp                # restore caller base pointer
    7c32:	5d                   	pop    %ebp
  ret
    7c33:	c3                   	ret    

00007c34 <PrintChar>:


.type PrintChar, @function
PrintChar:
  # prologue
  pushw %bp               # store caller base pointer
    7c34:	55                   	push   %ebp
  movw %sp, %bp           # set my own base pointer
    7c35:	89 e5                	mov    %esp,%ebp
  pushw %bx               # store caller-saved registers used
    7c37:	53                   	push   %ebx

  # then do print stuff
  movb 4(%bp), %al        # al% represents the char to be printed
    7c38:	8a 46 04             	mov    0x4(%esi),%al
  movb $0x0E, %ah         # teletype function
    7c3b:	b4 0e                	mov    $0xe,%ah
  movb $0x00, %bh         # unknown config
    7c3d:	b7 00                	mov    $0x0,%bh
  movb $0x08, %bl         # unknown config                    
    7c3f:	b3 08                	mov    $0x8,%bl
  int $0x10               # display interrupt
    7c41:	cd 10                	int    $0x10

  cmpb $0xD, %al
    7c43:	3c 0d                	cmp    $0xd,%al
  jne pc_end
    7c45:	75 08                	jne    7c4f <pc_end>

  pushw $0xA
    7c47:	6a 0a                	push   $0xa
  call PrintChar
    7c49:	e8 e8 ff 83 c4       	call   c4847c36 <__bss_start+0xc483ff4e>
  add $0x2, %sp
    7c4e:	02                   	.byte 0x2

00007c4f <pc_end>:

pc_end:
  # epilogue
  popw %bx                # restore caller-saved registers used
    7c4f:	5b                   	pop    %ebx
  popw %bp                # restore caller base pointer
    7c50:	5d                   	pop    %ebp
  ret
    7c51:	c3                   	ret    

00007c52 <PrintSign>:


.type PrintSign, @function
PrintSign:
  # prologue
  pushw %bp               # store caller base pointer
    7c52:	55                   	push   %ebp
  movw %sp, %bp           # set my own base pointer
    7c53:	89 e5                	mov    %esp,%ebp

  pushw $0x24
    7c55:	6a 24                	push   $0x24
  call PrintChar
    7c57:	e8 da ff 83 c4       	call   c4847c36 <__bss_start+0xc483ff4e>
  add $0x2, %sp
    7c5c:	02 6a 20             	add    0x20(%edx),%ch

  pushw $0x20
  call PrintChar
    7c5f:	e8 d2 ff 83 c4       	call   c4847c36 <__bss_start+0xc483ff4e>
  add $0x2, %sp
    7c64:	02 5d c3             	add    -0x3d(%ebp),%bl

00007c67 <ReadLine>:

.globl ReadLine
.type ReadLine, @function
ReadLine:
  # prologue
  pushw %bp               # store caller base pointer
    7c67:	55                   	push   %ebp
  movw %sp, %bp           # set my own base pointer
    7c68:	89 e5                	mov    %esp,%ebp
  pushw %si               # store caller-saved registers used
    7c6a:	56                   	push   %esi
  
  call PrintSign
    7c6b:	e8 e4 ff be d4       	call   d4bf7c54 <__bss_start+0xd4beff6c>

  movw $buffer, %si       # load buffer address to %si reg
    7c70:	7c                   	.byte 0x7c

00007c71 <rl_repeat>:
rl_repeat:
  movw $0x0, %ax          # clear %al (%ah must be 0x0 and %al stores the result)
    7c71:	b8 00 00 cd 16       	mov    $0x16cd0000,%eax
  int $0x16               # keyboard interrup

  movb %al, (%si)         # insert result into buffer
    7c76:	88 04 46             	mov    %al,(%esi,%eax,2)
  inc %si                 # move to next empty space in buffer

  pushw %ax               # push to pass as parameter 1
    7c79:	50                   	push   %eax
  call PrintChar          # print this char
    7c7a:	e8 b7 ff 83 c4       	call   c4847c36 <__bss_start+0xc483ff4e>
  add $0x2, %sp           # restore stack pointer
    7c7f:	02                   	.byte 0x2

00007c80 <rl_cond>:

rl_cond:
  cmpb $0xD, -1(%si)      # compare %al (result) with \r
    7c80:	80 7c ff 0d 75       	cmpb   $0x75,0xd(%edi,%edi,8)
  jne rl_repeat           # if it's a normal char, then repeat
    7c85:	eb be                	jmp    7c45 <PrintChar+0x11>
   
  movw $0, %si            # insert <end of string>
    7c87:	00 00                	add    %al,(%eax)
  
  # epilogue
  popw %si                # restore caller-saved registers used
    7c89:	5e                   	pop    %esi
  popw %bp                # restore caller base pointer
    7c8a:	5d                   	pop    %ebp
  ret
    7c8b:	c3                   	ret    

00007c8c <bootmain>:
extern void WriteLine();
extern void ReadLine();

void
bootmain(void)
{
    7c8c:	66 55                	push   %bp
    7c8e:	66 89 e5             	mov    %sp,%bp
    7c91:	66 83 ec 08          	sub    $0x8,%sp
  while (1) {
    ReadLine();
    7c95:	e8 cf ff e8 7d       	call   7de97c69 <__bss_start+0x7de8ff81>
    WriteLine();
    7c9a:	ff                   	(bad)  
    7c9b:	eb f8                	jmp    7c95 <bootmain+0x9>
