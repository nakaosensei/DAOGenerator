#Include 'Protheus.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#include "totvs.ch"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"

//Desenvolvido por Robson Adriano
//Para listar as O.S que foram agendadas conforme as datas passadas e liberar para Instala��o
User Function LIGTEC14()
Local aArea := GetArea()
Private oMark
Private aRotina := MenuDef()
Private _CPERG		:= "TEC14A"

_NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
_NCONNPTG  := TCLINK("POSTGRES/PostGreLigue","10.0.1.98",7890) //CONECTA AO POSTGRES
TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL

VALIDPERG()
IF !PERGUNTE(_CPERG)
	RETURN
ENDIF

oMark := FWMarkBrowse():New()
oMark:SetAlias('ABB')

// Define se utiliza controle de marca��o exclusiva do oMark:SetSemaphore(.T.)
// Define a titulo do browse de marcacao
oMark:SetDescription('Sele��o para Impress�o de Faturas')
// Define o campo que sera utilizado para a marca��o
oMark:SetFieldMark( 'ABB_OK' )

// Define a legenda
filtro := "ABB_DTINI >= '" +DTOS(mv_par01)+ "' .AND. ABB_DTINI <= '" +DTOS(mv_par02)+ "' .AND. ABB_ULIBOS <> 'S'"

oMark:SetFilterDefault(filtro)

// Ativacao da classe
oMark:AllMark()
oMark:Activate()

TCUNLINK(_NCONNPTG)  //FECHA CONEXAO POSTGRES
TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
RestArea( aArea )
Return

Static Function MenuDef()
Local aRotina := {}
	ADD OPTION aRotina TITLE 'Liberar para Instala��o' ACTION 'U_TEC14A' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'AxVisual' OPERATION 2  ACCESS 0 //"Visualizar"
Return aRotina

User Function TEC14A()
	PROCESSA({||TEC14B()})
RETURN
	
Static Function TEC14B()
Local aArea := GetArea()
Local _aAB6 := AB6->(getarea())
Local _aAB7 := AB7->(getarea())
Local _aAA3 := AA3->(getarea())
Local cMarca := oMark:Mark()
Local nCt := 0
Local nEm := 0
Local _ATITULOS	:= {}
Local _NImprimi := ""
LOCAL _NQTREGUA := 0
Local _email := "robson.adriano@liguetelecom.com.br"
Local _cCemail := "suporte.ftth@liguetelecom.com.br"
Local _cAssunto := "Fatura Ligue Telecom"

DBSELECTAREA("ABB")
DBSETORDER(1)
DBGOTOP()
WHILE !EOF()
	_NQTREGUA++
	DBSKIP()
ENDDO

PROCREGUA(_NQTREGUA)

ABB->( dbGoTop() )
While !ABB->( EOF() ) 
	INCPROC("Processando...")

	If oMark:IsMark(cMarca)
			
			if  ABB->ABB_DTINI >= mv_par01 .AND. ABB->ABB_DTINI <= mv_par02 .AND. ABB_ULIBOS <> 'S'
				U_TEC14C(ABB->ABB_NUMOS)
   			    nCt++
			endif
	EndIf
	
	DbSelectArea("ABB")
	ABB->( dbSkip() )
End

IF nCt > 0
	ApMsgInfo( 'Foram marcados ' + AllTrim( Str( nCt ) ) + ' registros. Foram enviados ' + AllTrim( Str( nEm ) ) + ' emails.')
ENDIF

/*IF !EMPTY (_NImprimi)
	MSGINFO("Total de clientes sem email : " + Str(nCt - nEm))
	U_LIGGEN03(_email,"","",_cAssunto1,_NImprimi,.T.,"")
ENDIF
*/

restarea(_aAA3)
restarea(_aAB7)
restarea(_aAB6)
RestArea( aArea )
Return

User function TEC14C(_CNUMOS)
Local aItems:=  {""}
Local aSplliters:=  {""} 
Local aPortas:=  {""} 

	Private oDlg
	Private oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
	Private oGet1
	Private cGet1 := SPACE(20) //SERIAL, VAI GRAVAR NO AA3_NUMSER
	Private oGet2
	Private cGet2 := SPACE(20) //MAC, VAI GRAVAR NO AA3_CHAPA
	Private oSay1
	Private oSay2
	Private oSay3
	Private oSay4
	Private oSay5
	Private oSay6
	Private oSay7
	Private oSay8
	Private oSay9
	private cTexto
	
	_CLI := ""
	_CDTOTVS := ""
	_CLIYATE := ""
	dbselectarea("AB6")
	dbsetorder(1)//Z2_FILIAL+AB6_UNUMCT
	IF dbseek(xFilial()+_cNumOs) 	
		_CLI  := "CLIENTE "+POSICIONE("SA1",1,XFILIAL("SA1")+AB6->AB6_CODCLI+AB6->AB6_LOJA,"A1_NOME")
	
	
		DEFINE MSDIALOG oDlg TITLE "Tela de Libera��o de Ordem de Servi�o" FROM 180,180 TO 650,780 PIXEL                   
		  	@ 008, 004 SAY oSay1 PROMPT "Favor informar o serial e o MAC:" SIZE 155, 014 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
			@ 025, 007 SAY oSay2 PROMPT "O.S : " + AbB->ABB_NUMOS SIZE 130, 007 OF oDlg COLORS 0, 16777215 PIXEL
			@ 040, 007 SAY oSay3 PROMPT _CLI SIZE 130, 007 OF oDlg COLORS 0, 16777215 PIXEL
			//@ 055, 007 SAY oSay4 PROMPT ADB->ADB_UMSG SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL
			@ 060, 007 SAY oSay5 PROMPT "MAC" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
			@ 075, 007 SAY oSay6 PROMPT "Serial" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
			@ 095, 007 SAY oSay7 PROMPT "Caixas" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
			@ 115, 007 SAY oSay8 PROMPT "Splitter" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
			@ 135, 007 SAY oSay9 PROMPT "Portas" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
			
		
			
			@ 060, 040 MSGET oGet1 VAR cGet1 SIZE 130, 010 OF oDlg COLORS 0, 16777215 PIXEL
			@ 075, 040 MSGET oGet2 VAR cGet2 SIZE 130, 010 OF oDlg COLORS 0, 16777215 PIXEL
	
	 		
		  cCombo1:= aItems[1]    
		  oCombo1 := TComboBox():New(95,040,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},; 
		    aItems,100,20,oDlg,,{||U_TEC14D(cCombo1,_NCONNPTG,_NCONNSQL)}; 
		    ,,,,.T.,,,,,,,,,'cCombo1') 
		  cCombo2:=  aItems[1]      
		  oCombo2 := TComboBox():New(115,040,{|u|if(PCount()>0,cCombo2:=u,cCombo2)},; 
		    aSplliters,180,20,oDlg,,{||U_TEC14E(cCombo2,_NCONNPTG,_NCONNSQL)}; 
		    ,,,,.T.,,,,,,,,,'cCombo2')
		  cCombo3:=  aItems[1]      
		  oCombo3 := TComboBox():New(135,040,{|u|if(PCount()>0,cCombo3:=u,cCombo3)},; 
		    aPortas,180,20,oDlg,,; 
		    ,,,,.T.,,,,,,,,,'cCombo3')
		    
		   @ 155,007 Get cTexto Size 280,50 MEMO of oDlg Pixel
		    
		  // @ 105,170 Button "Alterar CX"         Size 35,14 Action TEC14H() of oDlg Pixel
		   	@ 215,202 Button "Salvar"         Size 35,14 Action TEC14F() of oDlg Pixel
			@ 215,252 Button "Sair"          Size 35,14 Action oDlg:end() of oDlg Pixel
			
			oBtnAlterar := TButton():New(95, 173,"Alterar CX",oDlg,{|| U_TEC14G(_NCONNPTG,_NCONNSQL)},045,012,,advfont,,.T.)
		 
		  ACTIVATE DIALOG oDlg CENTERED
	  ELSE
	  	MSGINFO("N�o foi possivel localizar a Ordem de Servi�o !")
	  ENDIF
return

//Consultar Splitter da Caixa
User function TEC14D(_cCaixa,_NCONNPTG,_NCONNSQL)
Local aArea := GetArea()
Local _aADA := ADA->(getarea())
Local _aADB := ADB->(getarea())
Local aMatriz := {}
Local aArray := {}
Local cont := 0

IF !EMPTY(ALLTRIM(_cCaixa))
   aMatriz := STRTOKARR(_cCaixa, ":")
	
	TCSETCONN(_NCONNPTG) //RETORNA CONEXAO MSSQL	
							    
	_CQUERY := " SELECT c.cd_splitter, c.ds_splitter, po.ds_porta, pl.ds_placa , ch.ds_descricao, c.obs "
	_CQUERY += " FROM integrador.splitter c"
	_CQUERY += " left join integrador.porta_chassi po on c.cd_porta = po.cd_porta"
	_CQUERY += " left join integrador.placa_chassi pl on po.cd_placa = pl.cd_placa"
	_CQUERY += " left join  integrador.chassi ch on pl.cd_chassi = ch.cd_chassi"
	_CQUERY += " WHERE c.cd_caixa = '" +ALLTRIM(aMatriz[1]) +"'"
	_CQUERY += " ORDER BY c.ds_splitter"
		
	IF SELECT("TRB1")!=0
			TRB1->(DBCLOSEAREA())
	ENDIF
	TCQUERY _CQUERY NEW ALIAS "TRB1"
	DbSelectArea("TRB1")
	
	
	
	while !eof()
		//caixas := {TRB0->CD_CAIXA,TRB0->DS_CAIXA}
			AADD(aArray,CVALTOCHAR(TRB1->CD_SPLITTER) + ": SPLITTER " + ALLTRIM(TRB1->DS_SPLITTER) + " : " + ALLTRIM(TRB1->DS_DESCRICAO)+ " : "+ ALLTRIM(TRB1->DS_PLACA) +" : "+ ALLTRIM(TRB1->DS_PORTA))
			
			IF cont == 0 
				cTexto := TRB1->OBS
				cont += cont + 1
			ENDIF
		
		dbselectarea("TRB1")
		dbskip()
	enddo
	
	oCombo2:SetItems(aArray)
	
	TRB1->(DBCLOSEAREA())
	
	TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
ENDIF	

RestArea( _aADA )
RestArea( _aADB )
RestArea( aArea )
return

//Consultar Porta do Splitter da Caixa
User function TEC14E(_cSplitter,_NCONNPTG,_NCONNSQL)
Local aArea := GetArea()
Local _aADA := ADA->(getarea())
Local _aADB := ADB->(getarea())
Local aMatriz := {}
Local aArray := {}
Local cont := 0

IF !EMPTY(ALLTRIM(_cSplitter))
   aMatriz := STRTOKARR(_cSplitter, ":")

	TCSETCONN(_NCONNPTG) //RETORNA CONEXAO MSSQL
								    
	_CQUERY := " SELECT p.cd_porta,p.nr_porta,e.cd_porta_splitter,pe.nm_pessoa,c.cd_totvs, s.obs "
	_CQUERY += " FROM integrador.porta_splitter p"
	_CQUERY += " LEFT join integrador.cad_equipamento e on p.cd_porta = e.cd_porta_splitter"
	_CQUERY += " LEFT Join integrador.equipamento_cliente ec on e.cd_equipamento = ec.cd_equipamento"
	_CQUERY += " Left join integrador.cliente c on ec.cd_cliente = c.cd_cliente"
	_CQUERY += " LEFT join integrador.pessoa pe on c.cd_pessoa = pe.cd_pessoa"
	_CQUERY += " LEFT join integrador.splitter s on s.cd_splitter = p.cd_splitter"
	_CQUERY += " WHERE p.cd_splitter = '" +ALLTRIM(aMatriz[1]) +"'"
	_CQUERY += " ORDER BY p.ds_porta"
		
	IF SELECT("TRB2")!=0
			TRB2->(DBCLOSEAREA())
	ENDIF
	TCQUERY _CQUERY NEW ALIAS "TRB2"
	DbSelectArea("TRB2")
	
	while !eof()
	
			IF cont == 0 
				cTexto := TRB2->OBS
				cont += cont + 1
			ENDIF
		//caixas := {TRB0->CD_CAIXA,TRB0->DS_CAIXA}
			IF !EMPTY(TRB2->CD_PORTA_SPLITTER)	
				_CDTOTVS := TRB2->CD_TOTVS	
				_CLIYATE := TRB2->NM_PESSOA
			ENDIF	
			
			AADD(aArray,CVALTOCHAR(TRB2->CD_PORTA) + ": PORTA " + CVALTOCHAR(TRB2->NR_PORTA))
	
		dbselectarea("TRB2")
		dbskip()
	enddo
	
	oCombo3:SetItems(aArray)
	
	TRB2->(DBCLOSEAREA())
			
	TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
ENDIF	

RestArea( _aADA )
RestArea( _aADB )
RestArea( aArea )
return

//Liberar para Instala��o
Static function TEC14F() 
Local aArea := GetArea()
Local _aADA := ADA->(getarea())
Local _aADB := ADB->(getarea())
Local _cNumOs := AbB->ABB_NUMOS

//Alert(_cNumOs)
dbselectarea("AB6")
dbsetorder(1)//Z2_FILIAL+AB6_UNUMCT
IF dbseek(xFilial()+_cNumOs) 	
		dbselectarea("AB7")
		dbsetorder(1)//Z2_FILIAL+AB6_UNUMCT
		IF dbseek(xFilial()+_cNumOs) 
			while !eof() .AND. xFilial()+_cNumOs==AB7->AB7_FILIAL+AB7->AB7_NUMOS
				
			 //	IF AB6->AB6_UNUMCT == ALLTRIM(_CDTOTVS) .OR. !EMPTY(ALLTRIM(_CLIYATE))
				
			 //		MSGINFO("Essa porta j� cont�m Cliente : " + ALLTRIM(_CLIYATE))
			 //		RETURN
			 //	ENDIF	
				
				DbSelectArea("AA3")
				DBSETORDER(1)   //  FILIAL + CODCLI + LOJA + CODPRO + NUMSER  
				IF DBSEEK(xFilial() + AB7->AB7_CODCLI + AB7->AB7_LOJA + AB7->AB7_CODPRO + AB7->AB7_NUMSER) 
					RECLOCK("AA3",.F.)
						AA3->AA3_UMAC := UPPER(cGet1)
						AA3->AA3_CHAPA := UPPER(cGet2)										
						AA3->AA3_UCAIXA	:= cCombo1										
						AA3->AA3_USPLT	:= cCombo2										
						AA3->AA3_UPORTA	:= cCombo3										
					MSUNLOCK()   			
				ENDIF
					
				dbselectarea("AB7")
				dbskip()
			enddo
		ENDIF
		
	dbselectarea("AB6")
	RECLOCK("AB6",.F.)
		AB6->AB6_ULIBOS := "S"
		AB6->AB6_UCAIXA := cCombo1	+ ":" + cCombo2 + ":" + cCombo3																
	MSUNLOCK()   
	
	dbselectarea("ABB")
	RECLOCK("ABB",.F.)
		ABB->ABB_ULIBOS := "S"
	//	AB6->AB6_UCAIXA := cCombo1	+ ":" + cCombo2 + ":" + cCombo3																
	MSUNLOCK() 
	
	U_LIGTEC03()  
ENDIF
	
oDlg:End()

RestArea( _aADA )
RestArea( _aADB )
RestArea( aArea )
return

//Consultar Caixa
User Function TEC14G(_NCONNPTG,_NCONNSQL)
Local aItems:=  {} 

	TCSETCONN(_NCONNPTG) //RETORNA CONEXAO MSSQL
							    
	_CQUERY := " SELECT * "
	_CQUERY += " FROM integrador.caixa c"
	_CQUERY += " ORDER BY c.ds_caixa"
		
	IF SELECT("TRB0")!=0	
		DBCLOSEAREA("TRB0")
	ENDIF
	TCQUERY _CQUERY NEW ALIAS "TRB0"
	
	DbSelectArea("TRB0")
	while !eof() 
		//caixas := {TRB0->CD_CAIXA,TRB0->DS_CAIXA}
			AADD(aItems, CVALTOCHAR(TRB0->CD_CAIXA) + " : " + TRB0->AREA + " " + TRB0->DS_CAIXA)
		dbselectarea("TRB0")
		dbskip()
	enddo

	DBCLOSEAREA("TRB0")
	
	TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
	
	oCombo1:SetItems(aItems)	
RETURN aItems

User Function TEC14H()
Local aItems:=  TEC14G()
RETURN

User Function TEC14I(cCombo3)



Return


/*
	VALIDAPERG
*/
STATIC FUNCTION VALIDPERG
*********************************
_SALIAS := ALIAS()
AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
_CPERG := PADR(_CPERG,10)

//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG
AADD(aRegs,{_CPERG,"01","Vencimento de         ?","Espanhol","Ingles","mv_ch1","D",8,0,0,"G","","mv_par01","","","","'"+DTOC(dDataBase)+"'","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_CPERG,"02","Vencimento ate        ?","Espanhol","Ingles","mv_ch2","D",8,0,0,"G","","mv_par02","","","","'"+DTOC(dDataBase)+"'","","","","","","","","","","","","","","","","","","","","","",""})

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