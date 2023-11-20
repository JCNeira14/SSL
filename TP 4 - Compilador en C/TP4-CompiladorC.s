	.file	"TP4-CompiladorC.c"
	.comm	_in, 4, 2
	.globl	_TS
	.data
	.align 32
_TS:
	.ascii "inicio\0"
	.space 26
	.space 3
	.long	0
	.ascii "fin\0"
	.space 29
	.space 3
	.long	1
	.ascii "leer\0"
	.space 28
	.space 3
	.long	2
	.ascii "escribir\0"
	.space 24
	.space 3
	.long	3
	.ascii "$\0"
	.space 31
	.space 3
	.long	99
	.space 39800
	.comm	_buffer, 33, 5
	.comm	_tokenActual, 4, 2
	.globl	_flagToken
	.bss
	.align 4
_flagToken:
	.space 4
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
	.align 4
LC0:
	.ascii "Debe ingresar el nombre del archivo fuente (en lenguaje Micro) en la linea de comandos\0"
	.align 4
LC1:
	.ascii "Numero incorrecto de argumentos\0"
	.align 4
LC2:
	.ascii "Nombre incorrecto del Archivo Fuente\0"
LC3:
	.ascii "r\0"
	.align 4
LC4:
	.ascii "No se pudo abrir archivo fuente\0"
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB14:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$48, %esp
	call	___main
	cmpl	$1, 8(%ebp)
	jne	L2
	movl	$LC0, (%esp)
	call	_puts
	movl	$-1, %eax
	jmp	L9
L2:
	cmpl	$2, 8(%ebp)
	je	L4
	movl	$LC1, (%esp)
	call	_puts
	movl	$-1, %eax
	jmp	L9
L4:
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	leal	23(%esp), %eax
	movl	%eax, (%esp)
	call	_strcpy
	leal	23(%esp), %eax
	movl	%eax, (%esp)
	call	_strlen
	movl	%eax, 44(%esp)
	cmpl	$21, 44(%esp)
	jle	L5
	movl	$LC2, (%esp)
	call	_puts
	movl	$-1, %eax
	jmp	L9
L5:
	movl	44(%esp), %eax
	subl	$1, %eax
	movzbl	23(%esp,%eax), %eax
	cmpb	$109, %al
	jne	L6
	movl	44(%esp), %eax
	subl	$2, %eax
	movzbl	23(%esp,%eax), %eax
	cmpb	$46, %al
	je	L7
L6:
	movl	$LC2, (%esp)
	call	_puts
	movl	$-1, %eax
	jmp	L9
L7:
	movl	$LC3, 4(%esp)
	leal	23(%esp), %eax
	movl	%eax, (%esp)
	call	_fopen
	movl	%eax, _in
	movl	_in, %eax
	testl	%eax, %eax
	jne	L8
	movl	$LC4, (%esp)
	call	_puts
	movl	$-1, %eax
	jmp	L9
L8:
	movl	$0, %eax
L9:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE14:
	.ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
	.def	_puts;	.scl	2;	.type	32;	.endef
	.def	_strcpy;	.scl	2;	.type	32;	.endef
	.def	_strlen;	.scl	2;	.type	32;	.endef
	.def	_fopen;	.scl	2;	.type	32;	.endef
