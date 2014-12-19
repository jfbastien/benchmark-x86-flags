.text
.globl   test_intervening_call
.type    test_intervening_call, @function

bar:
	retq
	
test_intervening_call:
	pushq	%rbx
	movq	%rsi, %rax
	lock
	cmpxchgq	%rdx, (%edi)
	pushq	%rax
	sete	%al
	movq	%rax, %rbx
	popq	%rax
	movq	%rax, %rdi
	callq	bar
	movq	%rbx, %rax
	test	%al, %al
	jne	.LBB0_2
	movl	$42, %eax
	popq	%rbx
	retq
.LBB0_2:
	xorl	%eax, %eax
	popq	%rbx
	retq
