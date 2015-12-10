.386
DATAS SEGMENT USE16
    ;此处输入数据段代码  
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
    ;此处输入堆栈段代码
STACKS ENDS

;---------------------------------------
;-------展示总分
;---------------------------------------
SHOWTOTAL MACRO SCORE
	;学号（数字）放在CL中
	MOV AL,CL
	;总分为3位数，将学号×3，以定位到总分字符串的指定位置
	MUL CHENG3
	
	MOV BX,AX
	
	;分别展示3位数
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
;-------展示一门的分数
;---------------------------------------
SHOWSCORE MACRO SCORE
	;学号（数字）放在CL中
	MOV AL,CL
	;分数为2位数，将学号×2，以定位到分数字符串的指定位置
	MUL CHENG2
	MOV BX,AX
	
	;分别展示2位数
	MOV DL,SCORE[BX]
	MOV AH,2
	INT 21H
	
	MOV DL,SCORE[BX+1]
	MOV AH,2
	INT 21H
	
	;打印空格
	MOV DL,32
	MOV AH,2
	INT 21H
	ENDM
	
;---------------------------------------
;-------回车换行
;---------------------------------------
ENTER1 MACRO CODE
	LEA DX,CODE
	MOV AH,9
	INT 21H
	ENDM

;---------------------------------------
;------->>>>>>>>>>>>代码段开始，程序入口
;---------------------------------------
CODES SEGMENT USE16
    ASSUME CS:CODES,DS:DATAS,SS:STACKS,ES:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX
    
;---------------------------------------
;-------主循环，永不跳出
;---------------------------------------
L:
	;显示提示，让用户输入命令
	LEA DX,COMMAND
	MOV AH,9
	INT 21H
	
	;回车换行
	ENTER1 CRLF
	
	;读入命令，存入BUF
	LEA DX,BUF
	MOV AH,0AH
	INT 21H
	
	;如果输入的是1，跳转到“showOneSec(展示一个人的信息的部分)”
	CMP BUF[2],31H
	JZ SHOWONESEC
	
	;如果输入的是2，跳转到“setSec(设置第6门课程分数的部分)”
	CMP BUF[2],32H
	JZ SETSEC
	
	;若输入其他，循环继续
	JMP L

;-----------------------------------------
;------showOneSec(展示一个人的信息的部分)
;-----------------------------------------
SHOWONESEC:
	;调用展示一个人信息的函数
	CALL SHOWONE
	JMP L
	
SETSEC:
	CALL GETNUM
	
	;显示提示
	LEA DX,SETSCOREDIR
	MOV AH,9
	INT 21H
	
	ENTER1 CRLF
	
	;读入输入的分数，放到BUF
	LEA DX,BUF
	MOV AH,0AH
	INT 21H
	
	
	;学号（数字）放在CL中
	MOV AL,CL

	;分数为2位数，将学号×2，以定位到分数字符串的指定位置
	MUL CHENG2
	MOV BX,AX
	
	
	MOV DL,BUF+2
	MOV SCORE6[BX],DL
	
	MOV DL,BUF+3
	MOV SCORE6[BX+1],DL
	
	JMP L  

;-----------------------------------------
;------展示一个人的信息
;-----------------------------------------
SHOWONE PROC NEAR
	;调用“获得学号”函数，将学号存入CL
	CALL GETNUM
	
	;计算总分
	CALL CALC
	
	;分别打印各科成绩及总分
	SHOWSCORE SCORE1
	SHOWSCORE SCORE2
	SHOWSCORE SCORE3
	SHOWSCORE SCORE4
	SHOWSCORE SCORE5
	SHOWSCORE SCORE6
	SHOWTOTAL TOTAL
	
	;回车换行
	ENTER1 CRLF
	
	RET
SHOWONE ENDP

;-----------------------------------------
;------获得学号并存入CL
;-----------------------------------------
GETNUM PROC NEAR
	;显示提示
	LEA DX,DIR
	MOV AH,9
	INT 21H
	
	;回车换行
	ENTER1 CRLF
	
	;读入输入的学号，放到BUF
	LEA DX,BUF
	MOV AH,0AH
	INT 21H
	
	;回车换行
	ENTER1 CRLF
	
	;十位放AL,个位放BL
	MOV AL, BUF+2
	MOV BL, BUF+3
	
	;把它们从字符变成数字
	SUB AL,30H
	SUB BL,30H	;关于从0开始与从1开始
	
	;AL内容×10，送入AX
	MUL CHENG10
	
	;把个位数加上去，得到学号（数字类型）
	MOV BH,0
	ADD AX,BX
	
	;把学号存入CL（虽然在AX中，但很小，肯定只在AL中）
	MOV CL,AL

	RET
GETNUM ENDP


;-----------------------------------------
;------计算总分并存入相应位置
;-----------------------------------------
CALC PROC NEAR
	;学号（数字）放在CL中
	MOV AL,CL

	;分数为2位数，将学号×2，以定位到分数字符串的指定位置
	MUL CHENG2
	MOV BX,AX
	
	;把每一门十位数字全部相加
	;虽然由于本身是字符型，所以要减去30H
	;以防相加时溢出，不能全部相加后一次减去30H×n
	;况且就算不溢出，我也懒得算要减多少
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
	;十位数×10
	MUL CHENG10
	
	;个位数存入DL
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
	
	;总分算出
	ADD AX,DX
	
	;总分存入DX（因为AX要做别的用）
	MOV DX,AX
	
	;以下为将分数以字符串的形式存入指定内存
	;学号放入AL
	MOV AL,CL
	
	;×3，找到指定位置
	MUL CHENG3
	MOV BX,AX
	
	;将DX中的分数放入AX，要做出发
	MOV AX,DX
	
	;总分除以10，商在AL中，余数(个位)在AH中
	DIV CHENG10
	
	;把个位数变成字符型，存到指定位置
	ADD AH,30H
	MOV TOTAL[BX+2],AH
	
	;继续除以10
	MOV AH,0
	DIV CHENG10

	;把十位数变成字符型，存到指定位置
	ADD AH,30H
	MOV TOTAL[BX+1],AH

	;把百位数变成字符型，存到指定位置
	ADD AL,30H
	MOV TOTAL[BX],AL
	
	RET
CALC ENDP


CODES ENDS
    END START









