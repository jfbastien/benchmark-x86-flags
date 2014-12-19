.text
.globl   test_intervening_call
.type    test_intervening_call, @function

bar:
	retl
	
test_intervening_call:
	pushl	%ebx
	pushl	%esi
	subl	$8, %esp
	movl	20(%esp), %esi
	movl	36(%esp), %ecx
	movl	32(%esp), %ebx
	movl	28(%esp), %edx
	movl	24(%esp), %eax
	lock
	cmpxchg8b	(%esi)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	seto	%al
	lahf
	movl	%eax, %esi
	calll	bar
	movl	%esi, %eax
	addb	$127, %al
	sahf
	jne	.LBB0_3
	movl	$42, %eax
	jmp	.LBB0_2
.LBB0_3:                                # %f
	xorl	%eax, %eax
.LBB0_2:                                # %t
	xorl	%edx, %edx
	addl	$8, %esp
	popl	%esi
	popl	%ebx
	retl
