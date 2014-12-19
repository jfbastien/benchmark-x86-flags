.text
.globl   test_intervening_call
.type    test_intervening_call, @function

bar:
	retl

test_intervening_call:
	pushl	%ebx
	pushl	%esi
	subl	$20, %esp
	movl	36(%esp), %eax
	movl	40(%esp), %edx
	movl	44(%esp), %ebx
	movl	48(%esp), %ecx
	movl	32(%esp), %esi
	lock
	cmpxchg8b	(%esi)
	pushfl
	popl	%esi
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	calll	bar
	pushl	%esi
	popfl
	jne	.LBB0_3
	movl	$42, %eax
	jmp	.LBB0_2
.LBB0_3:
	xorl	%eax, %eax
.LBB0_2:
	xorl	%edx, %edx
	addl	$20, %esp
	popl	%esi
	popl	%ebx
	retl
