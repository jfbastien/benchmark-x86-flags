.text
.globl   test_intervening_call
.type    test_intervening_call, @function

bar:
	retq

test_intervening_call:
	pushq	%rbx
	movq	%rsi, %rax
	lock
	cmpxchgq	%rdx, (%rdi)
	pushfq
	popq	%rbx
	movq	%rax, %rdi
	callq	bar
	pushq	%rbx
	popfq
	jne	.LBB0_2
	movl	$42, %eax
	popq	%rbx
	retq
.LBB0_2:
	xorl	%eax, %eax
	popq	%rbx
	retq
