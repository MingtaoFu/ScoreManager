.386
DATAS SEGMENT USE16
    ;�˴��������ݶδ���  
    SCORE1 DB '6375638472847362748273719473945927499865346546786543'
    SCORE2 DB '2748273719473945927499865346546786543637563847284736'
    SCORE3 DB '7362748273719473945927499865346546786543637563847284'
    SCORE4 DB '5467865463756384728473627482737194739459274998653463'
    SCORE5 DB '4827371947394592749986534654678654637563847284736273'
    SCORE6 DB '0200000000000000000000000000000000000000000000000000'
    TOTAL DB '1230000000000000000000000000000000000000000000000000',
    '000000000000'
    
    DIR DB 'Please enter the NO.$'
    COMMAND DB 'Please input the command. 1:show one, 2: set 6th score.$'
    SETSCOREDIR DB 'Please input the score.$'
    CHENG10 DB 10
    CHENG2 DB 2
    CHENG3 DB 3
BUF DB 10
	DB 0
	DB 10 DUP(0)
	CRLF DB 0DH,0AH,'$'
DATAS ENDS

STACKS SEGMENT USE16
    ;�˴������ջ�δ���
STACKS ENDS

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
	
	;������������ѭ������
	JMP L

;-----------------------------------------
;------showOneSec(չʾһ���˵���Ϣ�Ĳ���)
;-----------------------------------------
SHOWONESEC:
	;����չʾһ������Ϣ�ĺ���
	CALL SHOWONE
	JMP L
	
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
	;���á����ѧ�š���������ѧ�Ŵ���CL
	CALL GETNUM
	
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


CODES ENDS
    END START









