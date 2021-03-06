#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVSWEBSRV.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LIGWS001  �Autor Daniel Gouvea           Data � 13/02/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     �WS para gravar dados do cliente                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LIGUE TELECOM                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

WSSERVICE LIGWS001 Description "WS Cadastro Cliente"

WSDATA CPESSOA  AS STRING OPTIONAL
WSDATA CCGC		AS STRING OPTIONAL
WSDATA CNOME	AS STRING OPTIONAL
WSDATA CFANTAS  AS STRING OPTIONAL
WSDATA CEMAIL   AS STRING OPTIONAL
WSDATA CESTADO  AS STRING OPTIONAL
WSDATA CCEP		AS STRING OPTIONAL
WSDATA CEND     AS STRING OPTIONAL
WSDATA CCOMPLE  AS STRING OPTIONAL
WSDATA CBAIRRO  AS STRING OPTIONAL
WSDATA CCODMUN  AS STRING OPTIONAL
WSDATA CMUN	    AS STRING OPTIONAL
WSDATA CDDD     AS STRING OPTIONAL
WSDATA CTEL     AS STRING OPTIONAL
WSDATA CDDDC    AS STRING OPTIONAL
WSDATA CCEL     AS STRING OPTIONAL
WSDATA CDTNASC  AS STRING OPTIONAL
WSDATA CINSCR   AS STRING OPTIONAL
WSDATA CRG		AS STRING OPTIONAL
WSDATA CCONTAT  AS STRING OPTIONAL
WSDATA CCPFCON  AS STRING OPTIONAL
WSDATA CTIPO    AS STRING OPTIONAL
WSDATA COK      AS STRING 
WSDATA _DADOS1 AS ITENSLIST OPTIONAL
WSDATA _DADOS2 AS ITENSLIST OPTIONAL

WSMETHOD LIGWS1GR DESCRIPTION "Grava Dados Do Cliente" 

ENDWSSERVICE

WSSTRUCT LISTA
  WSDATA DADOS AS STRING
ENDWSSTRUCT

WSSTRUCT ITENSLIST
  WSDATA REGISTROS AS ARRAY OF LISTA
ENDWSSTRUCT

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LIGWS1GR  �Autor Daniel Gouvea         � Data � 13/02/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava dados Cliente                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ligue                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

WSMETHOD LIGWS1GR WSRECEIVE CPESSOA,CCGC,CNOME,CFANTAS,CEMAIL,CESTADO,CCEP,CEND,CCOMPLE,CBAIRRO,CCODMUN,CMUN,CDDD,CTEL,CDDDC,CCEL,CDTNASC,CINSCR,CRG,CCONTAT,CCPFCON,CTIPO,_DADOS1,_DADOS2 WSSEND COK WSSERVICE LIGWS001

LOCAL NCAMPOS := 0
LOCAL CCAMPO  := ""
LOCAL ACAMPOS := {}
LOCAL NCONT   := 0

RpcSetEnv("01","LG01",,,'FRT','Inicializacao',{"SA1"})

::cOk := "OK"

CONOUT("ENTROU LIGWS1GR ."+CCGC+"."+TIME())

DBSELECTAREA("SA1")
DBSETORDER(3)
dbgotop()
IF DBSEEK(xFilial()+ALLTRIM(CCGC))
	_ERRO := "JA EXISTE O CPF/CNPJ "+CCGC
	CONOUT(_ERRO)
	::cOk := _ERRO
ELSE
	RECLOCK("SA1",.T.)
	SA1->A1_FILIAL := XFILIAL("SA1")
	SA1->A1_COD    := SUBSTR(CCGC,1,9)
	IF LEN(ALLTRIM(CCGC))==11
		SA1->A1_LOJA   := "001"
	ELSE
		SA1->A1_LOJA   := SUBSTR(CCGC,10,3)
	ENDIF 
	SA1->A1_PESSOA   :=  CPESSOA  
	SA1->A1_CGC 	 :=  CCGC		
	SA1->A1_NOME 	 :=  CNOME	
	SA1->A1_NREDUZ 	 :=  CFANTAS    
	SA1->A1_EMAIL    :=  CEMAIL   
	SA1->A1_EST 	 :=  CESTADO  
	SA1->A1_CEP 	 :=  CCEP		
	SA1->A1_END 	 :=  CEND     
	SA1->A1_COMPLEM  :=  CCOMPLE  
	SA1->A1_BAIRRO   :=  CBAIRRO  
	SA1->A1_COD_MUN  :=  CCODMUN  
	SA1->A1_MUN 	 :=  CMUN	    
	SA1->A1_DDD      :=  CDDD     
	SA1->A1_TEL 	 :=  CTEL     
	SA1->A1_UDDDCEL  :=  CDDDC    
	SA1->A1_CEL      :=  CCEL     
	SA1->A1_DTNASC   :=  CTOD(CDTNASC)  
	SA1->A1_INSCR    :=  CINSCR   
	SA1->A1_PFISICA  :=  CRG
	SA1->A1_PAIS     := "105"		
	SA1->A1_CONTATO  :=  CCONTAT  
	SA1->A1_UCGCTIT  :=  CCPFCON  
	SA1->A1_TIPO     :=  CTIPO       
	MSUNLOCK()
	
	DBSELECTAREA("AGA")
	DBSETORDER(2)
	DBSEEK(XFILIAL()+"999999",.T.)
	DBSKIP(-1)
	_COD := SOMA1(AGA->AGA_CODIGO)
	RECLOCK("AGA",.T.)
	AGA->AGA_FILIAL := XFILIAL("AGA")
	AGA->AGA_CODIGO := _COD
	AGA->AGA_ENTIDA := "SA1"
	AGA->AGA_CODENT := SA1->A1_COD+SA1->A1_LOJA
	AGA->AGA_TIPO   := "2"
	AGA->AGA_PADRAO := "1"
	AGA->AGA_END    := SA1->A1_END
	AGA->AGA_CEP    := SA1->A1_CEP
	AGA->AGA_BAIRRO := SA1->A1_BAIRRO
	AGA->AGA_MUNDES := SA1->A1_MUN
	AGA->AGA_EST    := SA1->A1_EST
	AGA->AGA_MUN    := SA1->A1_COD_MUN
	AGA->AGA_PAIS   := SA1->A1_PAIS
	MSUNLOCK()
	
	DBSELECTAREA("AGB")
	DBSETORDER(2)
	DBSEEK(XFILIAL()+"999999",.T.)
	DBSKIP(-1)
	_COD := SOMA1(AGB->AGB_CODIGO)
	RECLOCK("AGB",.T.)
	AGB->AGB_FILIAL := XFILIAL()
	AGB->AGB_CODIGO := _COD
	AGB->AGB_ENTIDA := "SA1"
	AGB->AGB_CODENT := SA1->A1_COD+SA1->A1_LOJA
	AGB->AGB_TIPO   := "2"
	AGB->AGB_PADRAO := "1"
	AGB->AGB_DDD    := SA1->A1_DDD
	AGB->AGB_TELEFO := SA1->A1_TEL	
	msunlock()
	
ENDIF

RETURN .T. 