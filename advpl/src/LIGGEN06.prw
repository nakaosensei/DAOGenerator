#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"


//AJUSTAR A1_NTELCON (TELEFONE) NO CADASTRO DO CLIENTE P/ CONVENIO 115/03
User Function LIGGEN06()
Local _area := getarea()
if msgyesno("Rotina para efetuar ajuste do CONVENIO 115/03 para gerar o TED. Deseja continuar ?") 
	PROCESSA({||GEN06A()})
	
	MsgInfo("A rotina foi executada ! ")	
ENDIF

restarea(_area)		 
Return

STATIC FUNCTION GEN06A() //PROCESSAMENTO DOS CONTRATOS
LOCAL _NQTREGUA := 0

DBSELECTAREA("SA1")
DBSETORDER(1)
DBGOTOP()
WHILE !EOF()
	_NQTREGUA++
	DBSKIP()
ENDDO

PROCREGUA(_NQTREGUA)

		DBSELECTAREA("SA1")
		DBGoTop()
		while !eof()
			INCPROC("Processando...")
			
			_nNumCob := ""	
						
			DBSELECTAREA("ADA")
			DBSETORDER(2)
			IF DBSEEK(xFilial("ADA")+SA1->A1_COD+SA1->A1_LOJA)
				IF !EMPTY(ADA->ADA_UNRCOB)
					//	_nNumCob := 	SUBSTR(ADA->ADA_UNRCOB,3,10)
					_nNumCob := ADA->ADA_UNRCOB
				ENDIF	
			ENDIF			
			 
			DBSELECTAREA("SA1")
			reclock("SA1",.F.)
				IF !EMPTY(_nNumCob) 
					IF LENGTH(ALLTRIM(_nNumCob)) = 10
						SA1->A1_NTELCON := _nNumCob		
					ELSE
						SA1->A1_NTELCON := "4438100000"	
					ENDIF	
				ELSE
					_nDDD := ""
					IF LENGTH(ALLTRIM(SA1->A1_DDD)) > 2
						_nDDD := ALLTRIM(SUBSTR(SA1->A1_DDD,2))
					ELSE
						_nDDD := ALLTRIM(SUBSTR(SA1->A1_DDD,1))
					ENDIF	
					
					IF	LENGTH(_nDDD + ALLTRIM(SA1->A1_TEL)) = 10
						SA1->A1_NTELCON := _nDDD + ALLTRIM(SA1->A1_TEL)	
					ELSE
						SA1->A1_NTELCON := "4438100001"
					ENDIF
				ENDIF
				
				IF (SA1->A1_PESSOA = 'F')
					SA1->A1_TPASS :=  "3"
					SA1->A1_TPCLI :=  "03"		
				ELSE
					SA1->A1_TPASS :=  "1"	
					SA1->A1_TPCLI :=  "01"
			    ENDIF
			msunlock()
			
			/*IF EMPTY(SA1->A1_EMAIL) .AND. !EMPTY(SA1->A1_ULOGIN)
				DBSELECTAREA("SA1")
				reclock("SA1",.F.)
				    SA1->A1_EMAIL := LOWER(SA1->A1_ULOGIN)
				msunlock()   
			ENDIF*/
			/*
			DBSELECTAREA("AA3")
			reclock("AA3",.F.)
				AA3->AA3_UMAC := UPPER(AA3->AA3_UMAC)
			msunlock() */
			
			dbselectarea("SA1")
			dbskip()
		enddo	

RETURN

