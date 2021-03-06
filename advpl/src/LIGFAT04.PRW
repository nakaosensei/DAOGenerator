#INCLUDE "RWMAKE.CH"                                                           
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���PROGRAMA  �LIGFAT04  �AUTOR  �ROBSON ADRIANO      � DATA �  12/06/14   ���
�������������������������������������������������������������������������͹��
���DESC.     �DEFINE CODIGO PARA GERAR TELA MODELO2		      			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���USO       � LIG                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                         
USER FUNCTION LIGFAT04()   
************************************
PRIVATE OTELA                  
PRIVATE NOPC
PRIVATE ACOLS 	 	:= {}                                                           
PRIVATE AHEADER	 	:= {}
PRIVATE ACAB		:= {}
PRIVATE AROD		:= {}
PRIVATE ALAY		:= {}
PRIVATE CEOL    	:= CHR(13)+CHR(10)
PRIVATE CTAB	 	:= "SZ3"

PRIVATE CFILIAL		:= CRIAVAR("Z3_FILIAL")
PRIVATE CGRUPO 		:= CRIAVAR("Z3_GRUPO") 
PRIVATE CDSGRUPO 	:= CRIAVAR("BM_DESC")
PRIVATE CTPQT		:= CRIAVAR("Z3_TPQTVL")


PRIVATE	CCADASTRO    	:= "CADASTRO DE COMISSAO"
                                       
/* COMENTADO POR DANIEL GOUVEA EM 28/10/16
PRIVATE AROTINA := { {"PESQUISAR","AXPESQUI",0,1} ,;
					 {"INCLUIR","U_CAD081()",0,3},;
					 {"ALTERAR","U_CAD082()",0,4},;
					 {"EXCLUIR","U_CAD083()",0,2},;
					 {"VISUALIZAR","U_CAD084()",0,2}}           
*/
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }					 
					 
					 
PRIVATE CDELFUNC := ".T." // VALIDACAO PARA A EXCLUSAO. PODE-SE UTILIZAR EXECBLOCK

DBSELECTAREA(CTAB)
MBROWSE( 6,1,22,75,CTAB,,,,,,,,,,,.F.)
RETURN


USER FUNCTION CAD081() //INCLUIR
****************************************              
NOPC    	:= 3                               

PRIVATE CFILIAL		:= CRIAVAR("Z3_FILIAL")
PRIVATE CGRUPO 		:= CRIAVAR("Z3_GRUPO") 
PRIVATE CDSGRUPO 	:= CRIAVAR("BM_DESC")
PRIVATE CTPQT		:= CRIAVAR("Z3_TPQTVL")

LTELA := CADZ3A()

IF LTELA
	DBSELECTAREA("SZ3")
	DBSETORDER(4)         
	DBGOTOP()
	DBSEEK(CFILIAL+CGRUPO+CTPQT) 
	WHILE !EOF() .AND. SZ3->Z3_FILIAL+SZ3->Z3_GRUPO+SZ3->Z3_TPQTVL==CFILIAL+CGRUPO+CTPQT
		RECLOCK("SZ3",.F.)
		DBDELETE()
		MSUNLOCK()
		DBSKIP()
	ENDDO	
	FOR I:=1 TO LEN(ACOLS)
		IF !ACOLS[I,LEN(ACOLS[I])]
			RECLOCK("SZ3",.T.)
			SZ3->Z3_FILIAL 	:= CFILIAL
			SZ3->Z3_GRUPO	:= CGRUPO
			SZ3->Z3_TPQTVL	:= CTPQT
			SZ3->Z3_VEND	:= ACOLS[I,1]
			SZ3->Z3_TIPO	:= ACOLS[I,2]
			SZ3->Z3_QINI	:= ACOLS[I,3]
			SZ3->Z3_QFIM	:= ACOLS[I,4]
			SZ3->Z3_COM1	:= ACOLS[I,5]
			SZ3->Z3_COM2	:= ACOLS[I,6]
			SZ3->Z3_VLINI	:= ACOLS[I,7]
			SZ3->Z3_VLFIM	:= ACOLS[I,8]
			MSUNLOCK()
		ENDIF
	NEXT I		
ENDIF
RETURN


USER FUNCTION CAD082() //ALTERAR
****************************************
NOPC    := 4   

CFILIAL		:= SZ3->Z3_FILIAL
CGRUPO 		:= SZ3->Z3_GRUPO
CTPQT		:= SZ3->Z3_TPQTVL

LTELA := CADZ3A()

IF LTELA
	DBSELECTAREA("SZ3")
	DBSETORDER(4)         
	DBGOTOP()
	DBSEEK(CFILIAL+CGRUPO+CTPQT) 
	WHILE !EOF() .AND. SZ3->Z3_FILIAL+SZ3->Z3_GRUPO+SZ3->Z3_TPQTVL==CFILIAL+CGRUPO+CTPQT
		RECLOCK("SZ3",.F.)
		DBDELETE()
		MSUNLOCK()
		DBSKIP()
	ENDDO	
	FOR I:=1 TO LEN(ACOLS)
		IF !ACOLS[I,LEN(ACOLS[I])]
			RECLOCK("SZ3",.T.)
			SZ3->Z3_FILIAL 	:= CFILIAL
			SZ3->Z3_GRUPO	:= CGRUPO
			SZ3->Z3_TPQTVL	:= CTPQT
			SZ3->Z3_VEND	:= ACOLS[I,1]
			SZ3->Z3_TIPO	:= ACOLS[I,2]
			SZ3->Z3_QINI	:= ACOLS[I,3]
			SZ3->Z3_QFIM	:= ACOLS[I,4]
			SZ3->Z3_COM1	:= ACOLS[I,5]
			SZ3->Z3_COM2	:= ACOLS[I,6]
			SZ3->Z3_VLINI	:= ACOLS[I,7]
			SZ3->Z3_VLFIM	:= ACOLS[I,8]
			MSUNLOCK()
		ENDIF
	NEXT I		
ENDIF
RETURN
      

USER FUNCTION CAD083() //EXCLUIR
****************************************
NOPC    := 3      
                         
CFILIAL		:= SZ3->Z3_FILIAL
CGRUPO 		:= SZ3->Z3_GRUPO
CTPQT		:= SZ3->Z3_TPQTVL

LTELA := CADZ3A()

IF LTELA
	DBSELECTAREA("SZ3")
	DBSETORDER(4)         
	DBGOTOP()
	DBSEEK(CFILIAL+CGRUPO+CTPQT) 
	WHILE !EOF() .AND. SZ3->Z3_FILIAL+SZ3->Z3_GRUPO+SZ3->Z3_TPQTVL==CFILIAL+CGRUPO+CTPQT
		RECLOCK("SZ3",.F.)
		DBDELETE()
		MSUNLOCK()
		DBSKIP()
	ENDDO	
ENDIF
RETURN


USER FUNCTION CAD084() //VISUALIZAR
****************************************
NOPC    := 3     
                          
CFILIAL		:= SZ3->Z3_FILIAL
CGRUPO 		:= SZ3->Z3_GRUPO
CTPQT		:= SZ3->Z3_TPQTVL

LTELA := CADZ3A()

RETURN


STATIC FUNCTION CADZ3A() //MODELO2
****************************************
ACOLS 	 	:= {}
AHEADER	 	:= {}
ACAB		:= {}
AROD		:= {}
ALAY		:= {}

CNULL := ""
AADD(ACAB,{"CGRUPO" 			,{15,020},  "GRUPO" 	, "@!",,"SBM",.T.})
//AADD(ACAB,{"CGRUPO" 		,{15,050},  "" 			, "@!",,,.T.})
//AADD(ACAB,{"CDSGRUPO" 		,{15,100},  ""	  		, "@!",,,.F.})
AADD(ACAB,{"CTPQT" 			,{30,020},  "TIPO" 	, "@!","PERTENCE('VQ')",,.T.})
//AADD(ACAB,{"CTPQT"			,{30,050},  "" 			, "@!",,,.T.})


ALAY := {105,15,118,315}

DBSELECTAREA("SX3")
DBSETORDER(1)
DBSEEK(CTAB)

WHILE !EOF() .AND. SX3->X3_ARQUIVO==CTAB
	IF SX3->X3_CAMPO!="Z3_FILIAL" .AND. SX3->X3_CAMPO!="Z3_GRUPO" .AND. SX3->X3_CAMPO!="Z3_TPQTVL" 
		AADD(AHEADER,{ TRIM(X3_TITULO), ALLTRIM(X3_CAMPO), X3_PICTURE,X3_TAMANHO, X3_DECIMAL,,X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT } )		                               
    END		
	DBSKIP()	
ENDDO

DBSELECTAREA("SZ3")
DBSETORDER(4)
DBGOTOP()
IF DBSEEK(CFILIAL+CGRUPO+CTPQT)
	WHILE !EOF() .AND. SZ3->Z3_FILIAL+SZ3->Z3_GRUPO+SZ3->Z3_TPQTVL==CFILIAL+CGRUPO+CTPQT
		AADD(ACOLS,{SZ3->Z3_VEND, SZ3->Z3_TIPO, SZ3->Z3_QINI, SZ3->Z3_QFIM, SZ3->Z3_COM1, SZ3->Z3_COM2, SZ3->Z3_VLINI, SZ3->Z3_VLFIM, .F.})	 
		DBSKIP()	
	ENDDO	
ELSE
	AADD(ACOLS,{"","", 0, 0, 0, 0, 0, 0, .F.})	
ENDIF 
   

RETURN MODELO2(CCADASTRO,ACAB,AROD,ALAY,NOPC,,,)
                                             


USER FUNCTION CAD08B(_COQUE) //VALIDACOES
****************************************
LOCAL LOK := .T.
DO CASE
	CASE _COQUE=="SEGMEN"
		IF !EMPTY(CSEGMEN)
			IF !EXISTCPO("SZ0",CSEGMEN,1)
				MSGALERT("SEGMENTO INVALIDO")
				RETURN(.F.)
			ENDIF
			CDSSEGMEN := POSICIONE("SZ0",1,CFILIAL+CSEGMEN,"Z0_NOME")
		ENDIF   
	CASE _COQUE=="LINHA"
		IF !EMPTY(CLINHA)
			IF !EXISTCPO("SZ1",CSEGMEN+CLINHA,1)
				MSGALERT("LINHA INVALIDA")
				RETURN(.F.) 
			ENDIF
			CDSLINHA  := POSICIONE("SZ1",1,CFILIAL+CSEGMEN+CLINHA,"Z1_NOME")
		ENDIF	                    
	CASE _COQUE=="GRUPO"
		IF !EMPTY(CGRUPO)
			IF !EXISTCPO("SZ2",CGRUPO+CLINHA+CSEGMEN,1)
				MSGALERT("GRUPO INVALIDO")
				RETURN(.F.)
			ENDIF                                                    
			CDSGRUPO  := POSICIONE("SZ2",1,CFILIAL+CGRUPO+CLINHA+CSEGMEN,"Z2_NOME")
		ENDIF              
	CASE _COQUE=="GERAL"
		RETURN(LOK) //DEFINIR VALIDACOES
ENDCASE
RETURN(LOK)
RETURN