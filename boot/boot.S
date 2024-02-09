.section .text


.code16
.globl start
start:
  # FIRST PHASE: Register y operation mode setup.
  # Assemble for 16-bit mode  

  # disable interrupts
  cli

	# The BIOS loads this code from the first sector of the hard disk into
	# memory at physical address 0x7c00 and starts executing in real mode
	# with %cs=0 %ip=7c00.
  movw $0x07C0, %ax 
  movw %ax, %ds
  movw %ax, %es
  movw %ax, %fs
  movw %ax, %gs

	#Stack Initialization
  movw $0x0000, %ax 
  movw %ax, %ss
  movw $0xFFFF, %sp
  
  # enable interrupts
  sti

  call bootmain

.globl WriteLine
.type WriteLine, @function
WriteLine:
  # save caller base pointer
  push %ebp
  movl %esp, %ebp
 
  # local variables
  # no local variables were used

  # save calle-saved regiters
  push %ebx
  push %edi
  push %esi

  movw $buffer, %si
while_loop: 
  movb (%si), %al
  movb $0x0E, %ah         #Bios Teletype,This number must be used to
                          #tell the BIOS to put a character on the screen 
  movb $0x00, %bh         #Page number (For most of our work this will remain 0x00)
  movb $0x07, %bl         #Text attribute (For most of our work this will remain 0x07)
                          #Try to change this value
  int $0x10
 
  # increase buffer
  inc %si
  cmp $0, (%si)
  jne while_loop

  # deallocate local variables
  # no local variables were used
  # mov %bp, %sp

  # Restore the caller's registers.
  pop %esi
  pop %edi
  pop %ebx
  pop %ebp
  
  # return :D
  ret

.section .data
buffer: .byte 0x41, 0x42, 0x43

# Bootstrap GDT
.p2align 2                                # force 4 byte alignment
 
