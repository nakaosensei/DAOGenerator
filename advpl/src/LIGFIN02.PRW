#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���PROGRAMA  �LIGFIN02 �AUTOR  �CASSIUS CARLOS MARTINS �DATA � 12/06/14   ���
�������������������������������������������������������������������������͹��
���DESC.     � ROTINA DE APURACAO DE COMISSAO                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���USO       � LIGUE                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                  
USER FUNCTION LIGFIN02
************************************   
PRIVATE _CPERG     := "FIN02A"     
PRIVATE _ACONTR    := {} //{1-CONTRATO, 2-ITEM, 3-PRODUTO, 4-QTDE, 5-VALOR, 6-VEND1, 7-VEND2, 8-%COM1, 9-%COM2, 10-POR QTDE})
PRIVATE _CUFIN02A  := GETMV("MV_UFIN02A") //PARAMETRO INDICATIVO DO GRUPO DE PRODUTOS COM COMISSAO POR QUANTIDADE (USO DA TABELA SZ3)

VALIDPERG()                    
IF !PERGUNTE(_CPERG)
	RETURN
ENDIF

PROCESSA({|| FIN02A()}) //CARREGA  CONTRATOS EM _ACONTR

PROCESSA({|| FIN02B()}) //GRAVA COMISSAO NO SE3

RETURN      


STATIC FUNCTION FIN02A()
**************************************
LOCAL _AREA 	:= GETAREA()                                              
LOCAL _ATTCOM 	:= {} //{1-VENDEDOR, 2-GRUPO, 3-TOTAL}
LOCAL _APRDEXT 	:= {} //{1-PRODUTO, 2-VL.FRANQUIA, 3-VL.BASE COMISSAO}                    
                 
DBSELECTAREA("ADA")
DBSETORDER(1)              
PROCREGUA(ADA->(RECCOUNT()))
DBGOTOP()
WHILE !EOF()     
	INCPROC("Lendo contratos...")
	
	IF ADA->ADA_ULIBER=="S" 
		
		_APRDEXT 	:= {} //{1-PRODUTO, 2-VL.FRANQUIA, 3-VL.BASE COMISSAO}
		
		//INICIO - COMISSAO SOBRE NOVAS VENDAS
		DBSELECTAREA("ADB")
		DBSETORDER(1)                          
		DBGOTOP()
		DBSEEK(XFILIAL("ADB")+ADA->ADA_NUMCTR)
		WHILE !EOF() .AND. ADB->ADB_FILIAL+ADB->ADB_NUMCTR==ADA->ADA_FILIAL+ADA->ADA_NUMCTR
				
			DBSELECTAREA("SB1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SB1")+ADB->ADB_CODPRO)
			
			DBSELECTAREA("SA3")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SA3")+ADB->ADB_UVEND1)
			
			IF EMPTY(ADB->ADB_ULTCOM) .AND. ADB->ADB_UDTINI>=MV_PAR03  .AND. ADB->ADB_UDTINI<=MV_PAR04                                
				
				//_ACONTR {1-CONTRATO, 2-ITEM, 3-PRODUTO, 4-QTDE, 5-VALOR, 6-VEND1, 7-VEND2, 8-%COM1, 9-%COM2, 10-POR QTDE/VALOR})
				IF SB1->B1_GRUPO$_CUFIN02A
				
					DBSELECTAREA("SZ3")
					DBSETORDER(2)                      
					DBGOTOP()
					IF DBSEEK(XFILIAL("SZ3")+SB1->B1_GRUPO+SA3->A3_TIPO)
				
						IF SZ3->Z3_TPQTVL=="Q"                                                         
							//ARMAZENA O TOTAL DO GRUPO PARA POSTERIORMENTE LOCALIZAR A COMISSAO NO SZ3
							_NP := ASCAN(_ATTCOM,{|X|X[1]+X[2]==ADB->ADB_UVEND1+SB1->B1_GRUPO})
							IF _NP==0
								AADD(_ATTCOM,{ADB->ADB_UVEND1, SB1->B1_GRUPO, ADB->ADB_QUANT})
							ELSE
								_ATTCOM[_NP,3] += ADB->ADB_QUANT
							ENDIF                                         
							
							AADD(_ACONTR,{ADB->ADB_NUMCTR, ADB->ADB_ITEM, ADB->ADB_CODPRO, ADB->ADB_QUANT, ADB->ADB_TOTAL, ADB->ADB_UVEND1, ADB->ADB_UVEND2, 0, 0, "S",SB1->B1_DESC})
							
						ELSE                   
							
							//ARMAZENA O TOTAL DO GRUPO PARA POSTERIORMENTE LOCALIZAR A COMISSAO NO SZ3
							_NP := ASCAN(_ATTCOM,{|X|X[1]+X[2]==ADB->ADB_UVEND1+SB1->B1_GRUPO})
							IF _NP==0
								AADD(_ATTCOM,{ADB->ADB_UVEND1, SB1->B1_GRUPO, ADB->ADB_TOTAL})
							ELSE
								_ATTCOM[_NP,3] += ADB->ADB_TOTAL
							ENDIF
							
							AADD(_ACONTR,{ADB->ADB_NUMCTR, ADB->ADB_ITEM, ADB->ADB_CODPRO, ADB->ADB_QUANT, ADB->ADB_TOTAL, ADB->ADB_UVEND1, ADB->ADB_UVEND2, 0, 0, "S",SB1->B1_DESC})
							
						ENDIF
						
					ENDIF
					
				ELSE
					AADD(_ACONTR,{ADB->ADB_NUMCTR, ADB->ADB_ITEM, ADB->ADB_CODPRO, ADB->ADB_QUANT, ADB->ADB_TOTAL, ADB->ADB_UVEND1, ADB->ADB_UVEND2, SB1->B1_UCOM1, SB1->B1_UCOM2, "N",SB1->B1_DESC})
				ENDIF
				 
			ENDIF			
			
			IF !EMPTY(SB1->B1_UPRDEXT) //VERIFICA SE DEVE CONSULTAR CONSUMO EXTRA E QUAL E O PRODUTO DE CONSUMO EXTRA
				_NP := ASCAN(_APRDEXT,{|X|X[1]==SB1->B1_UPRDEXT})
				IF _NP==0
					AADD(_APRDEXT, {SB1->B1_UPRDEXT, ADB->ADB_TOTAL, 0})
				ELSE
					_APRDEXT[_NP,2] += ADB->ADB_TOTAL
				ENDIF
			ENDIF
			
			DBSELECTAREA("ADB")
			DBSKIP()
		ENDDO                                
		//FIM - COMISSAO SOBRE NOVAS VENDAS
		
		
		//INICIO - COMISSAO SOBRE CONSUMO EXTRA                                                    
		FOR _I:=1 TO LEN(_APRDEXT)

		    IF ADA->ADA_UTIPO=="F" //FTTH
			    
			    _CNRCOB	   := ADA->ADA_UNRCOB
			    _CDTDE     := DTOC(MV_PAR03)
			    _CDTATE    := DTOC(MV_PAR04)
		    
			    _AREAADA   := ADA->(GETAREA())
			    _NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
			    _NCONNPTG  := TCLINK("POSTGRES/PostGreLigue","10.0.1.98",7890) //CONECTA AO POSTGRES
			    
			    _CQUERY := " SELECT SUM(CDR.TOTAL) TOTAL "
				_CQUERY += " FROM TELEFONIA.CDR CDR "
				_CQUERY += " WHERE CDR.ACCOUNTCODE = '"+_CNRCOB+"' "
				_CQUERY += " AND CDR.DATA >= '"+_CDTDE+"' "
				_CQUERY += " AND CDR.DATA <= '"+_CDTATE+"' "
			 	IF SELECT("TRB0")!=0
			 		TRB0->(DBCLOSEAREA())
			 	ENDIF
			 	TCQUERY _CQUERY NEW ALIAS "TRB0" 
			 	_APRDEXT[_I,3] += TRB0->TOTAL  
			 	
			 	TRB0->(DBCLOSEAREA())
			 	
			 	TCUNLINK(_NCONNPTG)  //FECHA CONEXAO POSTGRES
				TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
				
				RESTAREA(_AREAADA)    
			endif
			/*ELSE                                   
				
				_CNRCOB	:= ADA->ADA_UNRCOB
		    	_CDTDE 	:= YEAR2STR(MV_PAR03)
		    	_CDTDE 	+= "-"
		    	_CDTDE 	+= MONTH2STR(MV_PAR03)
		    	_CDTDE 	+= "-"
		    	_CDTDE 	+= DAY2STR(MV_PAR03)
		    	_CDTATE	:= YEAR2STR(MV_PAR04)
		    	_CDTATE += "-"
		    	_CDTATE += MONTH2STR(MV_PAR04)
		    	_CDTATE += "-"
		    	_CDTATE += DAY2STR(MV_PAR04)
			    					                                 
			    _AREAADA   := ADA->(GETAREA())
			    _NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
			    _NCONNMYS  := TCLINK("MYSQL/MySqlLigue","10.0.1.98",7890) //CONECTA AO MYSQL
			                                       				    
				_CQUERY := " SELECT SUM(C.COST) TOTAL "
				_CQUERY += " FROM CALLS C, CLIENTSSHARED CLI "
				_CQUERY += " WHERE C.ID_CLIENT = CLI.ID_CLIENT "
				_CQUERY += " AND CLI.ID_INTEGRADOR = "+_CNRCOB
				_CQUERY += " AND C.CALL_START >= '"+_CDTDE+"' "
				_CQUERY += " AND C.CALL_START <= '"+_CDTATE+"' " 
			 	IF SELECT("TRB0")!=0
			 		TRB0->(DBCLOSEAREA())
			 	ENDIF
			 	TCQUERY _CQUERY NEW ALIAS "TRB0" 
			 	
			 	IF _APRDEXT[_I,2]>=TRB0->TOTAL
			 		_APRDEXT[_I,3] += (TRB0->TOTAL-_APRDEXT[_I,2])
			 	ENDIF
			 	
			 	TRB0->(DBCLOSEAREA())
			 	
			 	TCUNLINK(_NCONNMYS)  //FECHA CONEXAO MYSQL
				TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
				
				RESTAREA(_AREAADA)            
			
			ENDIF   */
			
		NEXT _I		                                              
		
		FOR _I:=1 TO LEN(_APRDEXT) //PREECHE O VALOR DEVIDO DAS COMISSOES EXTRA
			
			DBSELECTAREA("SB1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SB1")+_APRDEXT[_I,1])                                                               
			
			//{1-CONTRATO, 2-ITEM, 3-PRODUTO, 4-QTDE, 5-VALOR, 6-VEND1, 7-VEND2, 8-%COM1, 9-%COM2, 10-POR QTDE})
			AADD(_ACONTR, {ADA->ADA_NUMCTR, "EXT", _APRDEXT[_I,1], 1, _APRDEXT[_I,3], ADA->ADA_VEND1, ADA->ADA_VEND2, SB1->B1_UCOM1, SB1->B1_UCOM2, " ","CONSUMO EXTRA"})

		NEXT _I
		//FIM - COMISSAO SOBRE CONSUMOS EXTRA
			
	ENDIF   
	
	DBSELECTAREA("ADA")
	DBSKIP()
ENDDO 
                                       

//INICIO - PREENCHE AS COMISSOES DE PRODUTOS COM APURACAO EM TOTAIS
FOR _I:=1 TO LEN(_ACONTR)              
	
	IF _ACONTR[_I,10]=="S"
		
		DBSELECTAREA("SB1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SB1")+_ACONTR[_I,3])
		
		DBSELECTAREA("SA3")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SA3")+_ACONTR[_I,6])				
		
		_NP  := ASCAN(_ATTCOM,{|X|X[1]+X[2]==_ACONTR[_I,6]+SB1->B1_GRUPO})
		_NTT := _ATTCOM[_NP,3] //PEGA O TOTAL DO GRUPO
		
		_NCOM1 := 0     
		_NCOM2 := 0
		DBSELECTAREA("SZ3")
		DBSETORDER(2)
		DBGOTOP()
		DBSEEK(XFILIAL("SZ3")+SB1->B1_GRUPO+SA3->A3_TIPO)
		WHILE !EOF() .AND. SZ3->Z3_FILIAL+SZ3->Z3_GRUPO+SZ3->Z3_TIPO==XFILIAL("SZ3")+SB1->B1_GRUPO+SA3->A3_TIPO
			IF SZ3->Z3_TPQTVL=="Q"
				IF SZ3->Z3_QINI<=_NTT .AND. SZ3->Z3_QFIM>=_NTT
					_NCOM1 := SZ3->Z3_COM1
					_NCOM2 := SZ3->Z3_COM2
					EXIT
				ENDIF
			ELSE
				IF SZ3->Z3_VLINI<=_NTT .AND. SZ3->Z3_VLFIM>=_NTT
					_NCOM1 := SZ3->Z3_COM1
					_NCOM2 := SZ3->Z3_COM2
					EXIT
				ENDIF
			ENDIF					             
			DBSELECTAREA("SZ3")
			DBSKIP()
		ENDDO
		
		_ACONTR[_I,8] := _NCOM1
		_ACONTR[_I,9] := _NCOM2

	ENDIF
			
NEXT _I
//FIM - PREENCHE AS COMISSOES DE PRODUTOS COM APURACAO EM TOTAIS

RESTAREA(_AREA)
RETURN   


STATIC FUNCTION FIN02B() //GRAVA SE3                                                                                         
****************************************                                                                                     
LOCAL _CNUMLOTE := GETSXENUM("SE3","E3_ULTCOM")                                                                                                          
    
BEGIN TRANSACTION

//{1-CONTRATO, 2-ITEM, 3-PRODUTO, 4-QTDE, 5-VALOR, 6-VEND1, 7-VEND2, 8-%COM1, 9-%COM2, 10-POR QTDE})    
PROCREGUA(LEN(_ACONTR))
FOR _I:=1 TO LEN(_ACONTR) //GRAVA COMISSAO VEND1   
	INCPROC("Gravando comissoes vendedor...")           
	
	IF _ACONTR[_I,6]>=MV_PAR01 .AND. _ACONTR[_I,6]<=MV_PAR02

		DBSELECTAREA("ADA")
		DBSETORDER(1)
		DBSEEK(XFILIAL("ADA")+_ACONTR[_I,1])
		
		DBSELECTAREA("SE3")
		RECLOCK("SE3",.T.)
		SE3->E3_FILIAL	:= XFILIAL("SE3")
		SE3->E3_VEND	:= _ACONTR[_I,6]
		SE3->E3_NUM		:= _ACONTR[_I,1]+_ACONTR[_I,2]
		SE3->E3_EMISSAO	:= DATE()
		SE3->E3_CODCLI	:= ADA->ADA_CODCLI
		SE3->E3_LOJA	:= ADA->ADA_LOJCLI
		SE3->E3_BASE	:= _ACONTR[_I,5]
		SE3->E3_PORC	:= _ACONTR[_I,8]
		SE3->E3_COMIS	:= ROUND((_ACONTR[_I,5]*_ACONTR[_I,8])/100,2)
		SE3->E3_BAIEMI	:= "E"
		SE3->E3_ORIGEM	:= "F"
		SE3->E3_VENCTO	:= DATE()
		SE3->E3_MOEDA	:= "01"
		SE3->E3_ULTCOM	:= _CNUMLOTE
		SE3->E3_UDSPROD	:= _ACONTR[_I,11]
		MSUNLOCK()
	
	ENDIF
			
NEXT _I	
	
PROCREGUA(LEN(_ACONTR))	
FOR _I:=1 TO LEN(_ACONTR) //GRAVA COMISSAO VEND2
	INCPROC("Gravando comissoes gerente...")   
	
	IF _ACONTR[_I,6]>=MV_PAR01 .AND. _ACONTR[_I,6]<=MV_PAR02 

		DBSELECTAREA("ADA")
		DBSETORDER(1)
		DBSEEK(XFILIAL("ADA")+_ACONTR[_I,1])
		
		DBSELECTAREA("SE3")
		RECLOCK("SE3",.T.)
		SE3->E3_FILIAL	:= XFILIAL("SE3")
		SE3->E3_VEND	:= _ACONTR[_I,7]
		SE3->E3_NUM		:= _ACONTR[_I,1]+_ACONTR[_I,2]
		SE3->E3_EMISSAO	:= DATE()
		SE3->E3_CODCLI	:= ADA->ADA_CODCLI
		SE3->E3_LOJA	:= ADA->ADA_LOJCLI
		SE3->E3_BASE	:= _ACONTR[_I,5]
		SE3->E3_PORC	:= _ACONTR[_I,9]
		SE3->E3_COMIS	:= ROUND((_ACONTR[_I,5]*_ACONTR[_I,9])/100,2)
		SE3->E3_BAIEMI	:= "E"
		SE3->E3_ORIGEM	:= "F"
		SE3->E3_VENCTO	:= DATE()
		SE3->E3_MOEDA	:= "01"
		SE3->E3_ULTCOM	:= _CNUMLOTE
		SE3->E3_UDSPROD	:= _ACONTR[_I,11]
		MSUNLOCK()   
		
	ENDIF
	
NEXT _I	                               


PROCREGUA(LEN(_ACONTR))
FOR _I:=1 TO LEN(_ACONTR) //GRAVA NUM LOTE APURACAO NOS ITENS DO CONTRATO
	INCPROC("Atualizando contratos...")
	
	IF _ACONTR[_I,6]>=MV_PAR01 .AND. _ACONTR[_I,6]<=MV_PAR02
	
		DBSELECTAREA("ADB")                               
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("ADB")+_ACONTR[_I,1]+_ACONTR[_I,2])
			RECLOCK("ADB",.F.)
			ADB->ADB_ULTCOM := _CNUMLOTE
			MSUNLOCK()
		ENDIF 
		
	ENDIF
		
NEXT _I

END TRANSACTION

CONFIRMSX8() 

MSGINFO("Lote de apuracao Nr. "+_CNUMLOTE+" gerado com sucesso ")
	
RETURN


STATIC FUNCTION VALIDPERG  
*********************************
_SALIAS := ALIAS()
AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
_CPERG := PADR(_CPERG,10)

//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG
AADD(AREGS,{_CPERG,"01","VENDEDOR DE      ?","","","MV_CH1","C",06,0,0, "G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(AREGS,{_CPERG,"02","VENDEDOR ATE     ?","","","MV_CH2","C",06,0,0, "G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
AADD(AREGS,{_CPERG,"03","DATA DE          ?","","","MV_CH3","D",08,0,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"04","DATA ATE         ?","","","MV_CH4","D",08,0,0, "G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

FOR I:=1 TO LEN(AREGS)
	IF !DBSEEK(_CPERG+AREGS[I,2])
		RECLOCK("SX1",.T.)
		FOR J:=1 TO FCOUNT()
			IF J <= LEN(AREGS[I])
				FIELDPUT(J,AREGS[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
DBSELECTAREA(_SALIAS)
RETURN