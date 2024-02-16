
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
    7c01:	b8 c0 07 8e c0       	mov    $0xc08e07c0,%eax
  # movw %ax, %ds
  movw %ax, %es
  movw %ax, %fs
    7c06:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
    7c08:	8e e8                	mov    %eax,%gs

	#Stack Initialization
  movw $0x0000, %ax 
    7c0a:	b8 00 00 8e d0       	mov    $0xd08e0000,%eax
  movw %ax, %ss
  movw $0xFFFF, %sp
    7c0f:	bc ff ff fb e8       	mov    $0xe8fbffff,%esp
  
  # enable interrupts
  sti

  call bootmain
    7c14:	76 00                	jbe    7c16 <WriteLine>

00007c16 <WriteLine>:

.globl WriteLine
.type WriteLine, @function
WriteLine:
  # prologue
  pushw %bp               # store caller base pointer
    7c16:	55                   	push   %ebp
  movw %sp, %bp           # set my own base pointer
    7c17:	89 e5                	mov    %esp,%ebp
  pushw %bx               # store caller-saved registers used
    7c19:	53                   	push   %ebx
  pushw %si               # ...
    7c1a:	56                   	push   %esi
  
  movw $buffer, %si       # load buffer address to %si reg
    7c1b:	be                   	.byte 0xbe
    7c1c:	d4 7c                	aam    $0x7c

00007c1e <wl_cond>:
wl_cond: 
  cmpb $0x0, (%si)        # test if the string's end was found
    7c1e:	80 3c 00 74          	cmpb   $0x74,(%eax,%eax,1)
  je wl_end
    7c22:	0b ff                	or     %edi,%edi
  
  pushw (%si)            # pass %si as parameter 1
    7c24:	34 e8                	xor    $0xe8,%al
  call PrintChar         # invoice PrintCar
    7c26:	0a 00                	or     (%eax),%al
  add $0x2, %sp          # restore stack pointer and free mem
    7c28:	83 c4 02             	add    $0x2,%esp
  
  incw %si               # move to next char and repeat
    7c2b:	46                   	inc    %esi
  jmp wl_cond
    7c2c:	eb f0                	jmp    7c1e <wl_cond>

00007c2e <wl_end>:

wl_end:
  # epilogue
  popw %si
    7c2e:	5e                   	pop    %esi
  popw %bx                # restore caller-saved registers used
    7c2f:	5b                   	pop    %ebx
  popw %bp                # restore caller base pointer
    7c30:	5d                   	pop    %ebp
  ret
    7c31:	c3                   	ret    

00007c32 <PrintChar>:


.type PrintChar, @function
PrintChar:
  # prologue
  pushw %bp               # store caller base pointer
    7c32:	55                   	push   %ebp
  movw %sp, %bp           # set my own base pointer
    7c33:	89 e5                	mov    %esp,%ebp
  pushw %bx               # store caller-saved registers used
    7c35:	53                   	push   %ebx

  # then do print stuff
  movb 4(%bp), %al        # al% represents the char to be printed
    7c36:	8a 46 04             	mov    0x4(%esi),%al
  movb $0x0E, %ah         # teletype function
    7c39:	b4 0e                	mov    $0xe,%ah
  movb $0x00, %bh         # unknown config
    7c3b:	b7 00                	mov    $0x0,%bh
  movb $0x08, %bl         # unknown config                    
    7c3d:	b3 08                	mov    $0x8,%bl
  int $0x10               # display interrupt
    7c3f:	cd 10                	int    $0x10

  cmpb $0xD, %al
    7c41:	3c 0d                	cmp    $0xd,%al
  jne pc_end
    7c43:	75 08                	jne    7c4d <pc_end>

  pushw $0xA
    7c45:	6a 0a                	push   $0xa
  call PrintChar
    7c47:	e8 e8 ff 83 c4       	call   c4847c34 <_end+0xc483ff2c>
  add $0x2, %sp
    7c4c:	02                   	.byte 0x2

00007c4d <pc_end>:

pc_end:
  # epilogue
  popw %bx                # restore caller-saved registers used
    7c4d:	5b                   	pop    %ebx
  popw %bp                # restore caller base pointer
    7c4e:	5d                   	pop    %ebp
  ret
    7c4f:	c3                   	ret    

00007c50 <PrintSign>:


.type PrintSign, @function
PrintSign:
  # prologue
  pushw %bp               # store caller base pointer
    7c50:	55                   	push   %ebp
  movw %sp, %bp           # set my own base pointer
    7c51:	89 e5                	mov    %esp,%ebp

  pushw $0x24
    7c53:	6a 24                	push   $0x24
  call PrintChar
    7c55:	e8 da ff 83 c4       	call   c4847c34 <_end+0xc483ff2c>
  add $0x2, %sp
    7c5a:	02 6a 20             	add    0x20(%edx),%ch

  pushw $0x20
  call PrintChar
    7c5d:	e8 d2 ff 83 c4       	call   c4847c34 <_end+0xc483ff2c>
  add $0x2, %sp
    7c62:	02 5d c3             	add    -0x3d(%ebp),%bl

00007c65 <ReadLine>:

.globl ReadLine
.type ReadLine, @function
ReadLine:
  # prologue
  pushw %bp               # store caller base pointer
    7c65:	55                   	push   %ebp
  movw %sp, %bp           # set my own base pointer
    7c66:	89 e5                	mov    %esp,%ebp
  pushw %si               # store caller-saved registers used
    7c68:	56                   	push   %esi
  
  call PrintSign
    7c69:	e8 e4 ff be d4       	call   d4bf7c52 <_end+0xd4beff4a>

  movw $buffer, %si       # load buffer address to %si reg
    7c6e:	7c                   	.byte 0x7c

00007c6f <rl_repeat>:
rl_repeat:
  movw $0x0, %ax          # clear %al (%ah must be 0x0 and %al stores the result)
    7c6f:	b8 00 00 cd 16       	mov    $0x16cd0000,%eax
  int $0x16               # keyboard interrup

  movb %al, (%si)         # insert result into buffer
    7c74:	88 04 46             	mov    %al,(%esi,%eax,2)
  inc %si                 # move to next empty space in buffer

  pushw %ax               # push to pass as parameter 1
    7c77:	50                   	push   %eax
  call PrintChar          # print this char
    7c78:	e8 b7 ff 83 c4       	call   c4847c34 <_end+0xc483ff2c>
  add $0x2, %sp           # restore stack pointer
    7c7d:	02                   	.byte 0x2

00007c7e <rl_cond>:

rl_cond:
  cmpb $0xD, -1(%si)      # compare %al (result) with \r
    7c7e:	80 7c ff 0d 75       	cmpb   $0x75,0xd(%edi,%edi,8)
  jne rl_repeat           # if it's a normal char, then repeat
    7c83:	eb c6                	jmp    7c4b <PrintChar+0x19>
   
  movb $0, (%si)          # insert <end of string>
    7c85:	04 00                	add    $0x0,%al

  # epilogue
  popw %si                # restore caller-saved registers used
    7c87:	5e                   	pop    %esi
  popw %bp                # restore caller base pointer
    7c88:	5d                   	pop    %ebp
  ret
    7c89:	c3                   	ret    
    7c8a:	66 90                	xchg   %ax,%ax

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
    7c95:	e8 cd ff e8 7b       	call   7be97c67 <_end+0x7be8ff5f>
    WriteLine();
    7c9a:	ff                   	(bad)  
    7c9b:	eb f8                	jmp    7c95 <bootmain+0x9>
