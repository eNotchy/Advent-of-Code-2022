//////////////// Advent of Code 2022 / day 2 / puzzle 1 ///////////////
/// 64-bit ARM assembly. Written, assembled and executed on my phone //
.equ	SYS_EXIT,	0x5D	//x0=exit code
.equ	SYS_READ,	0X3F	//{x0}=in fd, [x1]=input buf,<x2>=count
.equ	SYS_WRITE,	0X40	//{x0}=out fd, [x1]=string, <x2>=count
.equ	SYS_CLOSE,	0X39	//x0=fd
.equ	SYS_OPENAT,	0x38	//x0=dirfd, x1=filename, x2=flags
.equ	AT_FDCWD,	-100
.equ	O_RDONLY,	0
.equ	STDIN,		0
.equ	STDOUT,		1
syscall	.req	x8
input	.req	x19
end	.req	x20
key	.req	x21
score	.req	x22
.data
Guide:		.asciz	"i2.txt"
.bss
Input:		.zero	1<<16
IObuf:		.zero	1024
.text
.global _start
_start:				// ZZZ YYY XXX
		ldr	key,	=0x693025807140
				// CBA CBA CBA
		ldr	input,	=Input
		mov	score,	0
////////////////////// load guide file into memory ////////////////////
	fdIn	.req	x9
		mov	syscall,#SYS_OPENAT
		mov	x0,	#AT_FDCWD
		adr	x1,	Guide		//filename
		mov	x2,	#O_RDONLY
		svc	0
		mov	fdIn,	x0
		mov	syscall,#SYS_READ
		mov	x0,	fdIn
		mov	x1,	input
		ldr	x2,	=20000
		svc	0
		add	end,	input,	x0
		mov	syscall,#SYS_CLOSE
		mov	x0,	fdIn
		svc	0
/////////////////////////// calculate score ///////////////////////////
	entry	.req	x10
	abc	.req	x11
	xyz	.req	x12
	mask	.req	x13
	keypos	.req	x15
	bonus	.req	x16
		mov	mask,	0b1100
	sum_up:		ldr	entry,	[input],4
			and	abc,	mask,	entry,	lsl #2
			and	xyz,	mask,	entry,	lsr #14
			orr	keypos,	abc,	xyz,	lsl #2
			lsr	bonus,	key,	keypos
			and	bonus,	bonus,	0xF
			add	score,	score,	bonus
			cmp	input,	end
			b.lt	sum_up
/////////////////////////// Output Solution ///////////////////////////
		mov	syscall,#SYS_WRITE
		adr	x1,	IObuf
		str	score,	[x1]
		mov	x0,	#STDOUT
		mov	x2,	8
		svc	0
exit:		mov	syscall, #SYS_EXIT
		svc	0
