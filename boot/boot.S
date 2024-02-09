.section .data
buffer: .space 20


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
  # prologue
  pushw %bp               # store caller base pointer
  movw %sp, %bp           # set my own base pointer
  pushw %bx               # store caller-saved registers used
  pushw %si               # ...
  
  movw $buffer, %si       # load buffer address to %si reg
wl_cond: 
  cmpb $0x0, (%si)        # test if the string's end was found
  je wl_end
  
  pushw (%si)            # pass %si as parameter 1
  call PrintChar         # invoice PrintCar
  add $0x2, %sp          # restore stack pointer and free mem
  
  incw %si               # move to next char and repeat
  jmp wl_cond

wl_end:
  # epilogue
  popw %si
  popw %bx                # restore caller-saved registers used
  popw %bp                # restore caller base pointer
  ret




.type PrintChar, @function
PrintChar:
  # prologue
  pushw %bp               # store caller base pointer
  movw %sp, %bp           # set my own base pointer
  pushw %bx               # store caller-saved registers used

  # then do print stuff
  movb 4(%bp), %al        # al% represents the char to be printed
  movb $0x0E, %ah         # teletype function
  movb $0x00, %bh         # unknown config
  movb $0x08, %bl         # unknown config                    
  int $0x10               # display interrupt

  cmpb $0xD, %al
  jne pc_end

  pushw $0xA
  call PrintChar
  add $0x2, %sp

pc_end:
  # epilogue
  popw %bx                # restore caller-saved registers used
  popw %bp                # restore caller base pointer
  ret




.type PrintSign, @function
PrintSign:
  # prologue
  pushw %bp               # store caller base pointer
  movw %sp, %bp           # set my own base pointer

  pushw $0x24
  call PrintChar
  add $0x2, %sp

  pushw $0x20
  call PrintChar
  add $0x2, %sp

  # epilogue
  popw %bp                # restore caller base pointer
  ret




.globl ReadLine
.type ReadLine, @function
ReadLine:
  # prologue
  pushw %bp               # store caller base pointer
  movw %sp, %bp           # set my own base pointer
  pushw %si               # store caller-saved registers used
  
  call PrintSign

  movw $buffer, %si       # load buffer address to %si reg
rl_repeat:
  movw $0x0, %ax          # clear %al (%ah must be 0x0 and %al stores the result)
  int $0x16               # keyboard interrup

  movb %al, (%si)         # insert result into buffer
  inc %si                 # move to next empty space in buffer

  pushw %ax               # push to pass as parameter 1
  call PrintChar          # print this char
  add $0x2, %sp           # restore stack pointer

rl_cond:
  cmpb $0xD, -1(%si)      # compare %al (result) with \r
  jne rl_repeat           # if it's a normal char, then repeat
   
  movw $0, %si            # insert <end of string>
  
  # epilogue
  popw %si                # restore caller-saved registers used
  popw %bp                # restore caller base pointer
  ret




# Bootstrap GDT
.p2align 2                                # force 4 byte alignment
 
