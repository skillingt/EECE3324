
    # Example program to find the mimimum and maximum.


    ###########################################################
    # data segment

    .data

    array: .word 11, 12, 13, 19, 15, -16, 9, 18, 20, 21

                
    len:     .word 10
    min:     .word 0
    max:     .word 0


    ###########################################################
    # text/code segment

    # This program will use pointers.
    # t0 - array address
    # t1 - count of elements
    # t2 - min
    # t3 - max
    # s1 - index for the loop iteration
    # s2 - index for the min element
    # s3 - index for the max element
    # t4 - each word from array

    .text 
    .globl main

    main:


    # Find max and min of the array.
    la $t0, array       # set $t0 addr of array
    lw $t1, len         # set $t1 to length

    lw $t2, ($t0)      # set min, $t2 to array[0]
    lw $t3, ($t0)       # set max, $t3 to array[0]

    addi $s1, $0, 0
    addi $s2, $0, 0
    addi $s3, $0, 0 
    addi $t0, $t0, 4    # skip array[0]
    addi $t1, $t1, -1       # length=length-1
    
    
    loop:
     lw $t4, ($t0)      # get array[n]
     slt $t5,$t4, $t2
     addi $s1, $s1, 1	#two delay instruction slots to solve the data hazard on beq, because for beq the comparison is moved to "D" stage which requires readout from the register file
     add $t6, $t6, $zero	
     beq $t5, $zero, noMin 
     add $t2, $t4, $zero
     add $s2, $s1, $zero

    noMin:
    slt $t5,$t3, $t4
    add $t6, $t6, $zero  
    add $t6, $t6, $zero  
    beq $t5, $zero, noMax 
    add $t3, $t4, $zero
    add $s3, $s1, $zero
    
    noMax:
    addi $t1, $t1, -1             # decrement counter
    addi $t0, $t0, 4             # increment addr by word
    add $t6, $t6, $zero	
    beq $t1, $zero, endloop
    j loop
    
endloop:    sw $t2, min               # save min
    sw $t3, max               # save max



    #hlt                   # all done!

