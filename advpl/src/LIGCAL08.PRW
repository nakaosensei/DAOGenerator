#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"

/*********************************************************************************************/
user function LIGCAL08()
Local oError
	Local oException
	Local aListNumeros := {}
	
	DEFINE DIALOG oDlg TITLE "Lista de Numeros" FROM 180,180 TO 550,700 PIXEL
	nList := {}

	_NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
	_NCONNPTG  := TCLINK("POSTGRES/PostGreLigue","10.0.1.98",7890) //CONECTA AO POSTGRES

	TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL

	_cCtr := ALLTRIM(ADA->ADA_UIDYAT)
	
	//FIM INSTRU��O MSSQL
	TRY
	//INICIO INSTRU��O POSTGRES
	IF !EMPTY(_cCtr)

		TCSETCONN(_NCONNPTG) //RETORNA CONEXAO POSTGRE 

		_CQUERY := " select * from telefonia.numero n "
		_CQUERY += " WHERE n.cd_cliente = '" + _cCtr + "'"

		IF SELECT("TRB2")!=0
			TRB2->(DBCLOSEAREA())
		ENDIF

		TCQUERY _CQUERY NEW ALIAS "TRB2"
		DbSelectArea("TRB2")

		while !eof()
			//INSTRU��ES
			
			//cNumero := TRB2->NUMERO
			AADD( aListNumeros, TRB2->NUMERO)

			dbselectarea("TRB2")
			dbskip()
		enddo
		
		// Usando o Create
		nList := aListNumeros[1]
		oList1 := TListBox():Create(oDlg,001,10,{|u|if(Pcount()>0,nList:=u,nList)},;
		aListNumeros,240,180,,,,,.T.)
	
		TRB2->(DBCLOSEAREA())
		TCUNLINK(_NCONNPTG)  //FECHA CONEXAO POSTGRES

		ELSE
			MsgInfo("N�o foi possivel localizar as linhas, o c�digo do Yate est� vazio neste contrato ! ")
		ENDIF
	CATCH e as IdxException
		TCUNLINK(_NCONNPTG)  //FECHA CONEXAO POSTGRES
	END
	//FIM INSTRU��O POSTGRES

	TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
	
	ACTIVATE DIALOG oDlg CENTERED
RETURN
   

