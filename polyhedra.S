.global makebox
.global makesphere
.global maketorus
.global cos2
.global sin2
.data
    storage: .zero 64
    pointo3: .double .1256637061
.bss
.text
makebox://X,Y,Z in xmm0-2, h,w,d in xmm3-5
    //½ box
    sub $32, %rsp
    vsubsd %xmm5, %xmm2, %xmm8
    movsd %xmm8, 16(%rsp)
    vsubsd %xmm4, %xmm1, %xmm8
    movsd %xmm8, 8(%rsp)
    movsd %xmm0, (%rsp)
    movsd %xmm5, 24(%rsp)
    vxorpd %ymm7, %ymm7, %ymm7
    movsd 24(%rsp), %xmm7
    vpermq $0b11001111, %ymm7, %ymm7
    movsd %xmm4, 24(%rsp)
    vxorpd %ymm6, %ymm6, %ymm6
    movsd 24(%rsp), %xmm6
    vpermq $0b11110011, %ymm6, %ymm6
    movsd %xmm3, 24(%rsp)
    vxorpd %ymm5, %ymm5, %ymm5
    movsd 24(%rsp), %xmm5
    vmovups (%rsp), %ymm4
    add $32, %rsp
    //front and back
    vmovapd %ymm4, %ymm0
    vaddpd %ymm5, %ymm4, %ymm1
    vaddpd %ymm6, %ymm4, %ymm2
    vaddpd %ymm5, %ymm4, %ymm3
    vaddpd %ymm6, %ymm3, %ymm3
    call quadrilateralface
    vaddpd %ymm4, %ymm7, %ymm0
    vaddpd %ymm5, %ymm4, %ymm2
    vaddpd %ymm7, %ymm2, %ymm2
    vaddpd %ymm6, %ymm4, %ymm1
    vaddpd %ymm7, %ymm1, %ymm1
    vaddpd %ymm5, %ymm4, %ymm3
    vaddpd %ymm6, %ymm3, %ymm3
    vaddpd %ymm7, %ymm3, %ymm3
    call quadrilateralface
    //top and bottom
    vmovapd %ymm4, %ymm0
    vaddpd %ymm5, %ymm4, %ymm2
    vaddpd %ymm7, %ymm4, %ymm1
    vaddpd %ymm5, %ymm4, %ymm3
    vaddpd %ymm7, %ymm3, %ymm3
    call quadrilateralface
    vaddpd %ymm4, %ymm6, %ymm0
    vaddpd %ymm5, %ymm4, %ymm1
    vaddpd %ymm6, %ymm1, %ymm1
    vaddpd %ymm7, %ymm4, %ymm2
    vaddpd %ymm6, %ymm2, %ymm2
    vaddpd %ymm5, %ymm4, %ymm3
    vaddpd %ymm6, %ymm3, %ymm3
    vaddpd %ymm7, %ymm3, %ymm3
    call quadrilateralface
    //sides
    vmovapd %ymm4, %ymm0
    vaddpd %ymm6, %ymm4, %ymm1
    vaddpd %ymm7, %ymm4, %ymm2
    vaddpd %ymm6, %ymm4, %ymm3
    vaddpd %ymm7, %ymm3, %ymm3
    call quadrilateralface
    vaddpd %ymm4, %ymm5, %ymm0
    vaddpd %ymm6, %ymm4, %ymm2
    vaddpd %ymm5, %ymm2, %ymm2
    vaddpd %ymm7, %ymm4, %ymm1
    vaddpd %ymm5, %ymm1, %ymm1
    vaddpd %ymm6, %ymm4, %ymm3
    vaddpd %ymm7, %ymm3, %ymm3
    vaddpd %ymm5, %ymm3, %ymm3
    call quadrilateralface
    ret
quadrilateralface:
    sub $176, %rsp
    vmovups %ymm1, (%rsp)
    vmovups %ymm2, 24(%rsp)
    vmovups %ymm3, 48(%rsp)
    vmovups %ymm4, 72(%rsp)
    vmovups %ymm5, 96(%rsp)
    vmovups %ymm6, 120(%rsp)
    vmovups %ymm7, 144(%rsp)
    vmovups 24(%rsp), %ymm1
    vmovups (%rsp), %ymm2
    call addtri
    vmovups (%rsp), %ymm0
    vmovups 24(%rsp), %ymm1
    vmovups 48(%rsp), %ymm2
    call addtri
    vmovups 72(%rsp), %ymm4
    vmovups 96(%rsp), %ymm5
    vmovups 120(%rsp), %ymm6
    vmovups 144(%rsp), %ymm7
    add $176, %rsp
    ret
quadrilateral:
    sub $80, %rsp
    vmovups %ymm1, (%rsp)
    vmovups %ymm2, 24(%rsp)
    vmovups %ymm3, 48(%rsp)
    vmovups %ymm1, %ymm4
    vmovups %ymm0, %ymm1
    vmovups %ymm4, %ymm1
    call addtri
    vmovups (%rsp), %ymm1
    vmovups 24(%rsp), %ymm0
    vmovups 48(%rsp), %ymm2
    call addtri
    add $80, %rsp
    ret
roundmatrix://0-19 phi in rdi, 0-19 theta in rsi, radius is in %xmm3
    sub $32, %rsp
    vmovsd %xmm3, (%rsp)
    vcvtsi2sd %rsi, %xmm0, %xmm0
    vcvtsi2sd %rdi, %xmm1, %xmm1
    vmulsd pointo3(%rip), %xmm0, %xmm0
    vmulsd pointo3(%rip), %xmm1, %xmm1
    vmovsd %xmm0, 8(%rsp)
    vmovsd %xmm1, 16(%rsp)
    mov tempmatrix4(%rip), %rdi
    lea blankmatrix(%rip), %rax
    call forcematrix
    vmovsd 8(%rsp), %xmm0
    call sin@PLT
    vmovsd %xmm0, 24(%rsp)
    vmovsd 8(%rsp), %xmm0
    call cos2
    mov tempmatrix4(%rip), %rdi
    mov (%rdi), %rdi
    mov one(%rip), %rax
    mov %rax, (%rdi)
    vmovsd %xmm0, 40(%rdi)
    vmovsd %xmm0, 80(%rdi)
    vmovsd 24(%rsp), %xmm0
    vmovsd %xmm0, 48(%rdi)
    vxorpd %ymm1, %ymm1, %ymm1
    vsubsd %xmm0, %xmm1, %xmm0
    vmovsd %xmm0, 72(%rdi)
    vmovsd 16(%rsp), %xmm0
    call sin2
    vmovsd %xmm0, 24(%rsp)
    vmovsd 16(%rsp), %xmm0
    call cos2
    mov tempmatrixX(%rip), %rdi
    mov (%rdi), %rdi
    vmulsd (%rsp), %xmm0, %xmm0
    vmovsd %xmm0, (%rdi)
    vmovsd 24(%rsp), %xmm0
    vmulsd (%rsp), %xmm0, %xmm0
    vmovsd %xmm0, 8(%rdi)
    movq $0, 16(%rdi)
    movq $0, 24(%rdi)
    mov tempmatrix4(%rip), %rdi
    mov tempmatrixX(%rip), %rsi
    call multiplymatrix
    add $32, %rsp
    ret
    
maketorus:
    mov %rdi, %r15
    push %r15
    call gentorus
    xor %rdx, %rdx
    twohunnid2:
    vmovupd (%rax, %rdx,8), %ymm0
    vmovupd 32(%rax, %rdx,8), %ymm1
    vmovupd 1600(%rax, %rdx,8), %ymm2
    vmovupd 1632(%rax, %rdx,8), %ymm3
    push %rax
    push %rdx
    call quadrilateral
    mov (%rsp), %rdx
    mov 8(%rsp), %rax
    xor %rax, %rax
    xor %rdx, %rdx
    mov $50, %r8
    div %r8
    mov %rdx, %r8
    pop %rdx
    pop %rax
    add $4, %rdx
    mov %rdx, %rcx
    add $4, %rcx
    cmp $49, %r8
    cmove %rcx, %rdx
    cmp $10000, %rdx
    jl twohunnid2
    mov %rax, %rdi
    call free@PLT
    mov trim(%rip), %rax
    subq $3,24(%rax)
    pop %r15
    ret
makesphere:
    mov %rdi, %r15
    push %r15
    call gensphere
    mov $0, %rdx
    cap:
    vmovupd (%rax, %rdx,8), %ymm0
    vmovupd 1600(%rax, %rdx,8), %ymm2
    vmovupd 1632(%rax, %rdx,8), %ymm1
    push %rax
    push %rdx
    call addtri
    pop %rdx
    pop %rax
    add $4, %rdx
    cmp $196, %rdx
    jl cap
    vmovupd (%rax, %rdx,8), %ymm0
    vmovupd 1600(%rax, %rdx,8), %ymm2
    vmovupd 32(%rax, %rdx,8), %ymm1
    push %rax
    push %rdx
    call addtri
    pop %rdx
    pop %rax
    add $4, %rdx
    twohunnid:
    vmovupd (%rax, %rdx,8), %ymm0
    vmovupd 32(%rax, %rdx,8), %ymm1
    vmovupd 1600(%rax, %rdx,8), %ymm2
    vmovupd 1632(%rax, %rdx,8), %ymm3
    push %rax
    push %rdx
    call quadrilateral
    mov (%rsp), %rax
    sar $2, %rax
    xor %rdx, %rdx
    mov $50, %r8
    div %r8
    mov %rdx, %r8
    pop %rdx
    pop %rax
    add $4, %rdx
    cmp $48, %r8
    jne over
    vmovupd 32(%rax, %rdx,8), %ymm0
    vmovupd 64(%rax, %rdx,8), %ymm1
    vmovupd 1632(%rax, %rdx,8), %ymm2
    vmovupd 1664(%rax, %rdx,8), %ymm3
    cmp $4792, %rdx
    jge nodont
    push %rax
    push %rdx
    call quadrilateral
    pop %rdx
    pop %rax
    nodont:
    vmovupd (%rax, %rdx,8), %ymm0
    vmovupd -1568(%rax, %rdx,8), %ymm1
    vmovupd 1600(%rax, %rdx,8), %ymm2
    vmovupd 32(%rax, %rdx,8), %ymm3
    push %rax
    push %rdx
    call quadrilateral
    pop %rdx
    pop %rax
    add $8, %rdx
    over:
    cmp $4800, %rdx
    jl twohunnid
    bottom:
    vmovupd (%rax, %rdx,8), %ymm0
    vmovupd 32(%rax, %rdx,8), %ymm1
    vmovupd 1600(%rax, %rdx,8), %ymm2
    push %rax
    push %rdx
    call addtri
    pop %rdx
    pop %rax
    add $4, %rdx
    cmp $4996, %rdx
    jl bottom
    vmovupd (%rax, %rdx,8), %ymm0
    vmovupd -1568(%rax, %rdx,8), %ymm1
    vmovupd 1600(%rax, %rdx,8), %ymm2
    push %rax
    call addtri
    pop %rax
    mov %rax, %rdi
    call free@PLT
    pop %r15
    ret
gensphere:
    sub $32, %rsp
    vmovsd %xmm0, (%rsp)
    vmovsd %xmm1, 8(%rsp)
    vmovsd %xmm2, 16(%rsp)
    vmovsd %xmm3, 24(%rsp)
    mov $2500, %rdi
    mov $32, %rsi
    call calloc@PLT
    mov %rax,tempmatrixG(%rip)
    xor %rax, %rax
    startrot:
    xor %rcx, %rcx
    startcirc:

    vmovsd 24(%rsp), %xmm3
    push %rax
    push %rcx
    mov %rdi, %rdx
    mov %rax, %rdi
    mov %rcx, %rsi
    call roundmatrix
    pop %rcx
    pop %rax
    mov tempmatrixX(%rip), %rdi
    mov (%rdi), %r8
    vmovsd (%rsp), %xmm0
    vmovsd 8(%rsp), %xmm1
    vmovsd 16(%rsp), %xmm2
    vaddsd (%r8), %xmm0, %xmm0
    vmovsd %xmm0, (%r8)
    vaddsd 8(%r8), %xmm1, %xmm1
    vmovsd %xmm1, 8(%r8)
    vaddsd 16(%r8), %xmm2, %xmm2
    vmovsd %xmm2, 16(%r8)
    vmovupd (%r8), %ymm0
    mov tempmatrixG(%rip), %rdx
    mov %rax, %r8
    imul $50, %r8
    add %rcx, %r8
    sal $2, %r8
    vmovupd %ymm0, (%rdx, %r8, 8)

    inc %rcx
    cmp $50, %rcx
    jne startcirc

    inc %rax
    cmp $50, %rax
    jne startrot
    add $32, %rsp
    mov tempmatrixG(%rip), %rax
    ret

gentorus:
    sub $40, %rsp
    vmovsd %xmm0, (%rsp)
    vmovsd %xmm1, 8(%rsp)
    vmovsd %xmm2, 16(%rsp)
    vmovsd %xmm3, 24(%rsp)
    vmovsd %xmm4, 32(%rsp)
    mov $2550, %rdi
    mov $32, %rsi
    call calloc@PLT
    mov %rax,tempmatrixG(%rip)
    xor %rax, %rax
    startrotd:
    xor %rcx, %rcx
    startdonut:

    vmovsd 24(%rsp), %xmm3
    vmovsd 32(%rsp), %xmm4
    push %rax
    push %rcx
    mov %rdi, %rdx
    mov %rax, %rdi
    mov %rcx, %rsi
    call donutmatrix
    pop %rcx
    pop %rax
    mov tempmatrixX(%rip), %rdi
    mov (%rdi), %r8
    vmovsd (%rsp), %xmm0
    vmovsd 8(%rsp), %xmm1
    vmovsd 16(%rsp), %xmm2
    vaddsd (%r8), %xmm0, %xmm0
    vmovsd %xmm0, (%r8)
    vaddsd 8(%r8), %xmm1, %xmm1
    vmovsd %xmm1, 8(%r8)
    vaddsd 16(%r8), %xmm2, %xmm2
    vmovsd %xmm2, 16(%r8)
    vmovupd (%r8), %ymm0
    mov tempmatrixG(%rip), %rdx
    mov %rax, %r8
    imul $50, %r8
    add %rcx, %r8
    sal $2, %r8
    vmovupd %ymm0, (%rdx, %r8, 8)

    inc %rcx
    cmp $50, %rcx
    jne startdonut

    inc %rax
    cmp $50, %rax
    jle startrotd
    add $40, %rsp
    mov tempmatrixG(%rip), %rax
    ret

donutmatrix://0-19 phi in rdi, 0-19 theta in rsi, radius is in %xmm3, Radius is in %xmm4
    sub $40, %rsp
    vmovsd %xmm3, (%rsp)
    vmovsd %xmm4, 32(%rsp)
    cvtsi2sd %rdi, %xmm0
    cvtsi2sd %rsi, %xmm1
    vmulsd pointo3(%rip), %xmm0, %xmm0
    vmulsd pointo3(%rip), %xmm1, %xmm1
    vmovsd %xmm0, 8(%rsp)
    vmovsd %xmm1, 16(%rsp)
    mov tempmatrix4(%rip), %rdi
    lea blankmatrix(%rip), %rax
    call forcematrix
    vmovsd 8(%rsp), %xmm0
    call sin2
    vmovsd %xmm0, 24(%rsp)
    vmovsd 8(%rsp), %xmm0
    call cos2
    mov tempmatrix4(%rip), %rdi
    mov (%rdi), %rdi
    mov one(%rip), %rax
    mov %rax, 40(%rdi)
    vmovsd %xmm0, (%rdi)
    vmovsd %xmm0, 80(%rdi)
    vmovsd 24(%rsp), %xmm0
    vmovsd %xmm0, 64(%rdi)
    vxorpd %ymm1, %ymm1, %ymm1
    vsubsd %xmm0, %xmm1, %xmm0
    vmovsd %xmm0, 16(%rdi)
    vmovsd 16(%rsp), %xmm0
    call sin2
    vmovsd %xmm0, 24(%rsp)
    vmovsd 16(%rsp), %xmm0
    call cos2
    vmovsd %xmm0, 8(%rsp)
    mov tempmatrixX(%rip), %rdi
    mov (%rdi), %rdi
    vmovsd 32(%rsp), %xmm1
    vmulsd (%rsp), %xmm0, %xmm0
    vaddsd %xmm1, %xmm0, %xmm0
    vmovsd %xmm0, (%rdi)
    vmovsd 24(%rsp), %xmm0
    vmulsd (%rsp), %xmm0, %xmm0
    vmovsd %xmm0, 8(%rdi)
    //properly get new point for 3rd matrix slot
    vmovsd 8(%rsp), %xmm0
    vmulsd (%rsp), %xmm0, %xmm0
    vaddsd %xmm1, %xmm0, %xmm0
    vmovsd %xmm0, 16(%rdi)
    movq $0, 24(%rdi)
    mov tempmatrix4(%rip), %rdi
    mov tempmatrixX(%rip), %rsi
    call multiplymatrix
    add $40, %rsp
    ret

cos2:
    sub $4, %rsp
    cvtsd2ss %xmm0, %xmm0
    vmovss %xmm0, (%rsp)
    fld (%rsp)
    fcos
    fstp (%rsp)
    vmovss  (%rsp), %xmm0
    cvtss2sd %xmm0, %xmm0
    add $4, %rsp
    ret
sin2:
    sub $4, %rsp
    cvtsd2ss %xmm0, %xmm0
    vmovss %xmm0, (%rsp)
    fld (%rsp)
    fsin
    fstp (%rsp)
    vmovss  (%rsp), %xmm0
    cvtss2sd %xmm0, %xmm0
    add $4, %rsp
    ret

