			AREA PROJECT, CODE, Readonly
				
			ENTRY ;The first instruction to execute follows
M			EQU	10 ;number of data sets
N			EQU	10 ;number of elements in each data set
			
			MOV r0, #N ;number of elements in the data set
			MOV r1, #M ;number of data sets 
			LDR r2, =INPUTSET ;source
			ADR r3, SET0 ;Load address of the reference data set 
			MOV r5, #0 ;this register will hold the running sum 
			MOV r11, #0 ;index for reference sets (SET 0..9)
			MOV r4, #0x40000000
			MOV r12, #0 ;index for main set (INPUT SET)
			
loop2		;outer loop
			
calc		
			LDR r6, [r2, r12, LSL #2];input set
			LDR r7, [r3, r11, LSL #2];reference set
			SUB r7, r6, r7 ;subtract input set value from the reference set value
			MUL r6, r7, r7 ;square the answer
			ADD r5, r5, r6 ;add it to the previous answer
			ADD r11, r11, #1 ;move through elements of reference set
			ADD r12, r12, #1 ;move through elements of input set
			SUBS r0, r0, #1 ;decrement no. of elements
			BNE calc ;is it equal to 0?

			STR r5,[r4] ;store the answer
			LDR r5,[r4] ;load the answer
			
			MOV r12, #0 
			LDR r2, =INPUTSET
			ADD r4, r4, #12 ;next address
			MOV r5, #0 ;reset the running sum to 0 again
			MOV r0, #N 
			SUBS r1, r1, #1 ;decrement no. of sets [outer loop]
			BNE loop2 ;is it equal 0?
			

			MOV r5, #M
			LDR r4, =0x40000000
			LDR r6, =0x4000000C
			
gcd2		;finding the greatest error
			LDR r2, [r4]
			LDR r3, [r6]

			CMP r2, r3 ; r2>r3?
			MOVGT r0, r2 ;if r2>r3 then move r2 to r0
			MOVLT r0, r3 ;if r2<r3? then move r3 to r0
			ADDGT r6, r6, #12 ;if r2>r3 
			ADDLT r4, r4, #12
			ADDEQ r6,r6,#12
			SUBS r5, r5, #1 ;decrement counter
			BNE gcd2
			
			MOV r5, #M
			LDR r4, =0x40000000
			LDR r6, =0x4000000C
			
lcd2		;finding the least error 
			LDR r2, [r4]
			LDR r3, [r6]

			CMP r2, r3 ; r2>r3?
			MOVGT r1, r3 ;if r2>r3 then move r3 to r1
			MOVLT r1, r2 ;if r2<r3? then move r2 to r1
			ADDGT r4, r4, #12 ;if r2>r3 
			ADDLT r6, r6, #12
			ADDEQ r4,r4,#12
			SUBS r5, r5, #1 ;decrement counter
			BNE lcd2

				
stop		B stop



INPUTSET	
			DCD -100,-43,5,20,5,-15,-60,-148,-268,-340 
	
SET0		
			DCD -95, -39, 1, 20, 7, -15, -55, -148, -266, -340
			DCD	-98, -38, 2, 20, 9, -13, -57, -152, -264, -330 ;199
			DCD -105, -40, 5, 21, 6, -14, -63, -150, -260, -333
			DCD -106, -41, 5, 15, 6, -12, -66, -141, -261, -331 ;290
			DCD -101, -42, 4, 27, 8, -19, -69, -139, -262, -344 ;291
			DCD -99, -43, 5, 20, 4, -17, -61, -144, -269, -341
			DCD -102, -49, 7, 24, 4, -16, -60, -145, -270, -348
			DCD -95, -39, 5, 22, 3, -15, -62, -148, -272, -330
			DCD -96, -35, 9, 19, 5, -14, -58, -149, -272, -335 ;
			DCD -100, -43, 6, 18, 5, -14, -55, -140, -274, -340 ;131
			END