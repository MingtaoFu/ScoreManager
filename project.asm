
DATAS SEGMENT
    ;�˴��������ݶδ���  
    SCORE1 DB '4123456789298765432123456789898765432123456789198765'
    SCORE2 DB '0000000000000000000000000000000000000000000000100000'
    SCORE3 DB '0000000000200000000000000000000000000000000000000000'
    SCORE4 DB '0000000000000000000000000000000000000000000000000000'
    SCORE5 DB '0000000000000000000000000000400000000000000000000000'
    SCORE6 DB '0000000000000000000000000000000000000000000000000000'
    TOTAL  DB '0000000000000000000000000000000000000000000000000000',
    '00000000000000001001001000'
    LS DB 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26
    DIR DB 'Please enter the NO.$'
    COMMAND DB 'Please input the command. 1:show one, 2: set 6th score, 3:show list$'
    SETSCOREDIR DB 'Please input the score.$'
    CHENG10 DB 10
    CHENG2 DB 2
    CHENG3 DB 3
BUF DB 10
	DB 0
	DB 10 DUP(0)
	CRLF DB 0DH,0AH,'$'
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

;---------------------------------------
;-------չʾ�б�ð������
;---------------------------------------
SHOWLIST MACRO N

	MOV CH,N - 1
	MOV SI,0
	CALC_L:
		MOV CL,LS[SI]
		CALL CALC
		INC SI
		DEC CH
		CMP CH,0
		JNZ CALC_L


	;������������CL
	MOV CL,N - 1
	
	;��LS�����������
	FIR_L:
		MOV CH,CL
		MOV SI,N - 1
		SEC_L:
			;---DL=>��ǰλ��
			MOV AL,LS[SI]
			MUL CHENG3
			MOV BX,AX
			
			MOV AL,LS[SI-1]
			MUL CHENG3
			MOV DI,AX
			
			CALL COMPARE
			DEC SI
			DEC CH
			CMP CH,0
			JNZ SEC_L
		DEC CL
		CMP CL,1
		JNZ FIR_L
	
	;��ʾ����
	MOV CH,N - 1
	MOV SI,0
	SHOW_L:
		MOV CL,LS[SI]
		CALL SHOWONE
		INC SI
		DEC CH
		CMP CH,0
		JNZ SHOW_L
	
	ENDM


;---------------------------------------
;-------չʾ�ܷ�
;---------------------------------------
SHOWTOTAL MACRO SCORE
	;ѧ�ţ����֣�����CL��
	MOV AL,CL
	;�ܷ�Ϊ3λ������ѧ�š�3���Զ�λ���ܷ��ַ�����ָ��λ��
	MUL CHENG3
	
	MOV BX,AX
	
	;�ֱ�չʾ3λ��
	MOV DL,SCORE[BX]
	MOV AH,2
	INT 21H
	
	MOV DL,SCORE[BX+1]
	MOV AH,2
	INT 21H
	
	MOV DL,SCORE[BX+2]
	MOV AH,2
	INT 21H
	ENDM
	

;---------------------------------------
;-------չʾһ�ŵķ���
;---------------------------------------
SHOWSCORE MACRO SCORE
	;ѧ�ţ����֣�����CL��
	MOV AL,CL
	;����Ϊ2λ������ѧ�š�2���Զ�λ�������ַ�����ָ��λ��
	MUL CHENG2
	MOV BX,AX
	
	;�ֱ�չʾ2λ��
	MOV DL,SCORE[BX]
	MOV AH,2
	INT 21H
	
	MOV DL,SCORE[BX+1]
	MOV AH,2
	INT 21H
	
	;��ӡ�ո�
	MOV DL,32
	MOV AH,2
	INT 21H
	ENDM
	
;---------------------------------------
;-------�س�����
;---------------------------------------
ENTER1 MACRO CODE
	LEA DX,CODE
	MOV AH,9
	INT 21H
	ENDM

;---------------------------------------
;------->>>>>>>>>>>>����ο�ʼ���������
;---------------------------------------
CODES SEGMENT USE16
    ASSUME CS:CODES,DS:DATAS,SS:STACKS,ES:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX
    
;---------------------------------------
;-------��ѭ������������
;---------------------------------------
L:
	;��ʾ��ʾ�����û���������
	LEA DX,COMMAND
	MOV AH,9
	INT 21H
	
	;�س�����
	ENTER1 CRLF
	
	;�����������BUF
	LEA DX,BUF
	MOV AH,0AH
	INT 21H
	
	;����������1����ת����showOneSec(չʾһ���˵���Ϣ�Ĳ���)��
	CMP BUF[2],31H
	JZ SHOWONESEC
	
	;����������2����ת����setSec(���õ�6�ſγ̷����Ĳ���)��
	CMP BUF[2],32H
	JZ SETSEC
	
	;����������3����ת����showListSec(��ʾ���еĲ���)��
	CMP BUF[2],33H
	JZ SHOWLISTSEC
	
	;������������ѭ������
	JMP L

;-----------------------------------------
;------showOneSec(չʾһ���˵���Ϣ�Ĳ���)
;-----------------------------------------
SHOWONESEC:
	;���á����ѧ�š���������ѧ�Ŵ���CL
	CALL GETNUM
	
	;����չʾһ������Ϣ�ĺ���
	CALL SHOWONE
	JMP L
	
;-----------------------------------------
;------showListSec(��ʾ���еĲ���)--------
;-----------------------------------------
SHOWLISTSEC:
	SHOWLIST 26
	JMP L
		
;-----------------------------------------
;------setSec(����6th�����Ĳ���)--------
;-----------------------------------------
SETSEC:
	CALL GETNUM
	
	;��ʾ��ʾ
	LEA DX,SETSCOREDIR
	MOV AH,9
	INT 21H
	
	ENTER1 CRLF
	
	;��������ķ������ŵ�BUF
	LEA DX,BUF
	MOV AH,0AH
	INT 21H
	
	
	;ѧ�ţ����֣�����CL��
	MOV AL,CL

	;����Ϊ2λ������ѧ�š�2���Զ�λ�������ַ�����ָ��λ��
	MUL CHENG2
	MOV BX,AX
	
	
	MOV DL,BUF+2
	MOV SCORE6[BX],DL
	
	MOV DL,BUF+3
	MOV SCORE6[BX+1],DL
	
	JMP L  

;-----------------------------------------
;------չʾһ���˵���Ϣ
;-----------------------------------------
SHOWONE PROC NEAR
	MOV AL,CL
	MOV AH,0
	DIV CHENG10
	ADD AH,30H
	ADD AL,30H
	
	MOV DH,AH
	
	MOV DL,AL
	MOV AH,2
	INT 21H
	
	MOV DL,DH
	MOV AH,2
	INT 21H
	
	;��ӡ�ո�
	MOV DL,32
	MOV AH,2
	INT 21H
	
	;�����ܷ�
	CALL CALC
	
	;�ֱ��ӡ���Ƴɼ����ܷ�
	SHOWSCORE SCORE1
	SHOWSCORE SCORE2
	SHOWSCORE SCORE3
	SHOWSCORE SCORE4
	SHOWSCORE SCORE5
	SHOWSCORE SCORE6
	SHOWTOTAL TOTAL
	
	;�س�����
	ENTER1 CRLF
	
	
	;��ӡ�ո�
	;MOV DL,32
	;MOV AH,2
	;INT 21H
	
	RET
SHOWONE ENDP

;-----------------------------------------
;------���ѧ�Ų�����CL
;-----------------------------------------
GETNUM PROC NEAR
	;��ʾ��ʾ
	LEA DX,DIR
	MOV AH,9
	INT 21H
	
	;�س�����
	ENTER1 CRLF
	
	;���������ѧ�ţ��ŵ�BUF
	LEA DX,BUF
	MOV AH,0AH
	INT 21H
	
	;�س�����
	ENTER1 CRLF
	
	;ʮλ��AL,��λ��BL
	MOV AL, BUF+2
	MOV BL, BUF+3
	
	;�����Ǵ��ַ��������
	SUB AL,30H
	SUB BL,30H	;���ڴ�0��ʼ���1��ʼ
	
	;AL���ݡ�10������AX
	MUL CHENG10
	
	;�Ѹ�λ������ȥ���õ�ѧ�ţ��������ͣ�
	MOV BH,0
	ADD AX,BX
	
	;��ѧ�Ŵ���CL����Ȼ��AX�У�����С���϶�ֻ��AL�У�
	MOV CL,AL

	RET
GETNUM ENDP


;-----------------------------------------
;------�����ֲܷ�������Ӧλ��
;-----------------------------------------
CALC PROC NEAR
	;ѧ�ţ����֣�����CL��
	MOV AL,CL

	;����Ϊ2λ������ѧ�š�2���Զ�λ�������ַ�����ָ��λ��
	MUL CHENG2
	MOV BX,AX
	
	;��ÿһ��ʮλ����ȫ�����
	;��Ȼ���ڱ������ַ��ͣ�����Ҫ��ȥ30H
	;�Է����ʱ���������ȫ����Ӻ�һ�μ�ȥ30H��n
	;���Ҿ��㲻�������Ҳ������Ҫ������
	MOV AX,0
	ADD AL,SCORE1[BX]
	SUB AL,30H
	ADD AL,SCORE2[BX]
	SUB AL,30H
	ADD AL,SCORE3[BX]
	SUB AL,30H
	ADD AL,SCORE4[BX]
	SUB AL,30H
	ADD AL,SCORE5[BX]
	SUB AL,30H
	ADD AL,SCORE6[BX]
	SUB AL,30H
	;ʮλ����10
	MUL CHENG10
	
	;��λ������DL
	MOV DX,0
	ADD DL,SCORE1[BX+1]
	SUB DL,30H
	ADD DL,SCORE2[BX+1]
	SUB DL,30H
	ADD DL,SCORE3[BX+1]
	SUB DL,30H
	ADD DL,SCORE4[BX+1]
	SUB DL,30H
	ADD DL,SCORE5[BX+1]
	SUB DL,30H
	ADD DL,SCORE6[BX+1]
	SUB DL,30H
	
	;�ܷ����
	ADD AX,DX
	
	;�ִܷ���DX����ΪAXҪ������ã�
	MOV DX,AX
	
	;����Ϊ���������ַ�������ʽ����ָ���ڴ�
	;ѧ�ŷ���AL
	MOV AL,CL
	
	;��3���ҵ�ָ��λ��
	MUL CHENG3
	MOV BX,AX
	
	;��DX�еķ�������AX��Ҫ������
	MOV AX,DX
	
	;�ֳܷ���10������AL�У�����(��λ)��AH��
	DIV CHENG10
	
	;�Ѹ�λ������ַ��ͣ��浽ָ��λ��
	ADD AH,30H
	MOV TOTAL[BX+2],AH
	
	;��������10
	MOV AH,0
	DIV CHENG10

	;��ʮλ������ַ��ͣ��浽ָ��λ��
	ADD AH,30H
	MOV TOTAL[BX+1],AH

	;�Ѱ�λ������ַ��ͣ��浽ָ��λ��
	ADD AL,30H
	MOV TOTAL[BX],AL
	
	RET
CALC ENDP

;-----------------------------------------
;------�Ƚ�TOTAL�������ֵĴ�С
;-----------------------------------------
COMPARE PROC NEAR
	MOV AL,TOTAL[DI]
	MOV AH,TOTAL[BX]

	
	CMP AL,AH
	JB EXCHANGE
	
	MOV AL,TOTAL[DI+1]
	MOV AH,TOTAL[BX+1]
	
	CMP AL,AH
	JB EXCHANGE
	
	MOV AL,TOTAL[DI+2]
	MOV AH,TOTAL[BX+2]
	CMP AL,AH
	JB EXCHANGE
	RET
	
EXCHANGE:
	
	MOV AL,LS[SI]
	MOV AH,LS[SI-1]
	XCHG AH,AL
	MOV LS[SI],AL
	MOV LS[SI-1],AH
	
	RET
COMPARE ENDP
CODES ENDS
    END START




