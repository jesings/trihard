.global addtri
.global drawtris
.data
    viewvect: .double 0, 1, 0, 0
.bss
.text
addtri://%ymm0, %ymm1, %ymm2
    mov trim(%rip), %rdi
    sub $64, %rsp
    vmovupd %ymm1, (%rsp)
    vmovupd %ymm2, 32(%rsp)
    vpermq $0b01, %ymm0, %ymm1
    vpermq $0b10, %ymm0, %ymm2
    call addpoint
    movsd (%rsp), %xmm0
    movsd 8(%rsp), %xmm1
    movsd 16(%rsp), %xmm2
    call addpoint
    movsd 32(%rsp), %xmm0
    movsd 40(%rsp), %xmm1
    movsd 48(%rsp), %xmm2
    call addpoint
    add $64, %rsp
    ret
drawtri://first point in ymm0, second point in ymm1, third point in ymm2
    sub $136,%rsp
    vmovups %ymm0,(%rsp)
    vmovups %ymm1,32(%rsp)
    vmovups %ymm2,64(%rsp)
    call crossproduct
    call normalize
    vmovups viewvect(%rip), %ymm1
    call dotproduct
    vcomisd zero(%rip), %xmm0
    jbe enddraw
    vmovups (%rsp), %ymm0
    vmovups 32(%rsp), %ymm1
    vmovups 64(%rsp), %ymm2
    vcvtpd2dq %ymm0, %xmm0
    vcvtpd2dq %ymm1, %xmm1
    vcvtpd2dq %ymm2, %xmm2
    movlps %xmm0, (%rsp)
    movlps %xmm1, 8(%rsp)
    movlps %xmm2, 16(%rsp)
    mov $0xffffff, %rdi
    movsxd (%rsp), %rsi
    movsxd 4(%rsp), %rdx
    movsxd 8(%rsp), %rcx
    movsxd 12(%rsp), %r8
    call bresenham
    mov $0xffffff, %rdi
    movsxd 16(%rsp), %rsi
    movsxd 20(%rsp), %rdx
    movsxd 8(%rsp), %rcx
    movsxd 12(%rsp), %r8
    call bresenham
    mov $0xffffff, %rdi
    movsxd 16(%rsp), %rsi
    movsxd 20(%rsp), %rdx
    movsxd (%rsp), %rcx
    movsxd 4(%rsp), %r8
    call bresenham
    enddraw:
    add $136, %rsp
    ret
drawtris://trimatrix AAAAAAAAAAAA
    mov trim(%rip), %rdi
    mov 24(%rdi), %rax
    mov (%rdi), %rdi
    sub $3, %rax
    trisl:
    mov %rax, %rcx
    sal $2, %rcx
    vmovupd (%rdi,%rcx,8), %ymm0
    add $4, %rcx
    vmovupd (%rdi,%rcx,8), %ymm1
    add $4, %rcx
    vmovupd (%rdi,%rcx,8), %ymm2
    push %rax
    push %rcx
    push %rdi
    call drawtri
    pop %rdi
    pop %rcx
    pop %rax
    sub $3, %rax
    cmp $0, %rax
    jge trisl
    ret
