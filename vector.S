.global crossproduct
.global dotproduct
.global normalize
.data
.bss
.text
//dot product is just packed multiplication
crossproduct://points packed in ymm0, ymm1
    vsubpd %ymm0, %ymm1, %ymm1//do cross product, find normal vector
    vsubpd %ymm0, %ymm2, %ymm2//do product of magnitudes of View vector ( <0,0,1> ) and normal vector
    vmovups %ymm1, %ymm0      //something
    vmovups %ymm2, %ymm1      //a2*b3-a3*b2,a3*b1-a1*b3,a1*b2-a2*b
    vpermq $0b01100000, %ymm0, %ymm2
    vpermq $0b10000100, %ymm1, %ymm3
    vmulpd %ymm2, %ymm3, %ymm2
    vpermq $0b10000100, %ymm0, %ymm3
    vpermq $0b01100000, %ymm1, %ymm4
    vmulpd %ymm3, %ymm4, %ymm3
    vsubpd %ymm3, %ymm2, %ymm0
    vpermq $0b11100100, %ymm0, %ymm0
    ret
dotproduct://stuff in ymm0, ymm1
    vmulpd %ymm0, %ymm1, %ymm0
    vpermq $0b00000010, %ymm0, %ymm1
    vhaddpd %ymm0, %ymm0, %ymm0
    vaddsd %xmm0, %xmm1, %xmm0
    ret
magnitude://stuff in ymm0
    vmulpd %ymm0, %ymm0, %ymm0
    vpermq $0b00000010, %ymm0, %ymm1
    vhaddpd %ymm0, %ymm0, %ymm0
    vaddsd %xmm0, %xmm1, %xmm0
    vsqrtsd %xmm0, %xmm0, %xmm0
    ret
normalize://stuff in ymm0
    sub $32, %rsp
    vmovupd %ymm0, (%rsp)
    call magnitude
    vpbroadcastq %xmm0, %ymm1
    vmovupd (%rsp), %ymm0
    vdivpd %ymm1, %ymm0, %ymm0
    add $32, %rsp
    ret
