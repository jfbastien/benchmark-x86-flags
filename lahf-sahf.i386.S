.text
.globl   test_intervening_call
.type    test_intervening_call, @function

bar:
	retl
	
test_intervening_call:
	pushl	%ebx
	pushl	%esi
	subl	$8, %esp
	movl	24(%esp), %eax
	movl	28(%esp), %edx
	movl	32(%esp), %ebx
	movl	36(%esp), %ecx
	movl	20(%esp), %esi
	lock
	cmpxchg8b	(%esi)
	pushl	%eax
	seto	%al
	lahf
	movl	%eax, %esi
	popl	%eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	calll	bar
	movl	%esi, %eax
	addb	$127, %al
	sahf
	jne	.LBB0_3
	movl	$42, %eax
	jmp	.LBB0_2
.LBB0_3:
	xorl	%eax, %eax
.LBB0_2:
	xorl	%edx, %edx
	addl	$8, %esp
	popl	%esi
	popl	%ebx
	retl
