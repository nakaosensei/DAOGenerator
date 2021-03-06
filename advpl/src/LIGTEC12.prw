#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#include "rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "MSGRAPHI.CH"
#Include "TOPCONN.CH"


//Desenvolvido por Robson Adriano
//Para os atendentes visualizar os Help Desk fechados para validacao.

User Function LIGTEC12()
Local oBrowse	  := Nil 
Local cFiltra := "ABK_SITUAC = '1' .AND. ABK_UVALAT <> '0'

Private aRotina := MenuDef()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("ABK")//Seleciona o Alias que estamos trabalhando.
oBrowse:SetDescription("Help desk : Valida��o")// "Descri��o"
oBrowse:SetFilterDefault(cFiltra)

oBrowse:AddLegend( "ABK_UVALAT==' '", "YELLOW", "Aguardando" )
oBrowse:AddLegend( "ABK_UVALAT=='1'", "GREEN", "Conforme" )
oBrowse:AddLegend( "ABK_UVALAT=='2'", "RED" , "N�o Conforme" )

// Remove os bot�es de navega��o na edi��o ou visualiza��o do model
oBrowse:SetUseCursor(.F.)

oBrowse:Activate()
Return

User Function TEC12LEG()
Local aLegenda := {}
	AADD(aLegenda,{"BR_VERDE" ,"Conforme" })
	AADD(aLegenda,{"BR_AMARELO" ,"Aguardando" })
	AADD(aLegenda,{"BR_VERMELHO" ,"N�o Conforme" })
BrwLegenda("Valida��o Help Desk", "Legenda", aLegenda)
Return (aLegenda)

Static Function MenuDef() 
Local aRotina       := {}
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.LIGTEC12' OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Validar Help Desk" ACTION 'U_TEC12A' OPERATION 4  ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Legenda" ACTION 'U_TEC12LEG' OPERATION 6  ACCESS 0 //"Leganda"
	IF __CUSERID$GETMV("MV_UADMHD")
		ADD OPTION aRotina TITLE "Grafico" ACTION 'U_TEC12B' OPERATION 1  ACCESS 0 //"Excluir"
	ENDIF
Return aRotina

Static Function ModelDef()
Local oModel
Local oStr1:= FWFormStruct(1,'ABK')

oModel := MPFormModel():New('ModelName')
oModel:addFields('FIELD1',,oStr1)

Return oModel

Static Function ViewDef()
Local oView
Local oModel := ModelDef()
 
Local oStr1:= FWFormStruct(2, 'ABK')

oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FORM1' , oStr1,'FIELD1' ) 

oView:CreateHorizontalBox( 'BOXFORM1', 100)

oView:SetOwnerView('FORM1','BOXFORM1')

Return oView

User Function TEC12A()
Local lOk:=.f.
Local oDlg

cTexto := ""
cCombo := "1" 
aItem := {"1=Conforme", "2=N�o Conforme"} 

@ 116,001 To 416,1020 Dialog oDlgMemo Title "Valida��o da Ordem de Servi�o 'Boas Vindas'"
@ 05,010 SAY "Situa��o:" OF oDlgMemo Pixel
@ 05,050 ComboBox oCombo Var cCombo Items aItem Size 085,09 Of oDlgMemo Pixel 

@ 20,10 Get cTexto Size 490,110 MEMO of OdlgMemo Pixel

@ 135,200 Button "Salvar"         Size 35,14 Action FRSalva() of OdlgMemo Pixel
@ 135,250 Button "Sair"          Size 35,14 Action Close(oDlgMemo) of OdlgMemo Pixel
Activate Dialog oDlgMemo  
Return

static function valTexto()
	if len(alltrim(cTexto))>400
		msginfo("Texto muito grande. No maximo 400 caracteres.")
		return .f.
	endif
	
	if EMPTY(alltrim(cTexto))
		msginfo("Por favor informe uma Mensagem.")
		return .f.
	ENDIF
return .t.

Static Function FRSalva()
	IF valTexto()
		RecLock("ABK",.f.)
			ABK->ABK_UVALAT := cCombo
			ABK->ABK_UMEMO := cTexto
		msunlock()     
	
		msginfo("Mensagem gravada com sucesso")
		Close(oDlgMemo)
	endif
Return

Return

User Function TEC12B()
Private	CPERG       := "LIGTEC13  "
contA := 0
contN := 0
contC := 0 

validperg()   //Chama perguntas
If !pergunte(cPerg,.T.)
	Return()
Endif

_CQUERY := " SELECT ABK.ABK_UVALAT, ABL.ABL_DTHELP "
_CQUERY += " FROM "+RETSQLNAME("ABK")+" ABK, " +RETSQLNAME("ABL")+" ABL "
_CQUERY += " WHERE ABL.ABL_NRCHAM = ABK.ABK_NRCHAM"                               
_CQUERY += " AND ABL.ABL_DTHELP >= '"+DTOS(MV_PAR01)+"'                                  
_CQUERY += " AND ABL.ABL_DTHELP <= '"+DTOS(MV_PAR02)+"'                                                                                                              
_CQUERY += " AND ABK.ABK_SITUAC= '1'"                                                                              
_CQUERY += " AND ABK.D_E_L_E_T_=' ' "                                           
                                                                                                                         
_CQUERY := CHANGEQUERY(_CQUERY)

IF SELECT("TEMP1")!=0
	TEMP1->(DBCLOSEAREA())
ENDIF
TCQUERY _CQUERY NEW ALIAS "TEMP1"
dbSelectArea("TEMP1") 
dbGoTop()

While ! TEMP1->(EOF())	
	IF EMPTY(TEMP1->ABK_UVALAT)
		contA ++
	ELSE
		IF TEMP1->ABK_UVALAT = '1'
			contC++
		ELSE
			contN++
		ENDIF
	ENDIF 
dbselectarea("TEMP1") 		
dbSkip()
enddo	

DEFINE DIALOG oDlg TITLE "Visuali��o de Help Desk" FROM 180,180 TO 550,700 PIXEL

    // Cria o gr�fico
    oGraphic := TMSGraphic():New( 01,01,oDlg,,,RGB(239,239,239),260,184)    
    oGraphic:SetTitle('Titulo do Grafico', "Data:" + dtoc(Date()), CLR_HRED, A_LEFTJUST, GRP_TITLE )
    oGraphic:SetMargins(2,6,6,6)
    oGraphic:SetLegenProp(GRP_SCRRIGHT, CLR_LIGHTGRAY, GRP_AUTO, .T.)
     
    // Itens do Gr�fico
    nSerie := oGraphic:CreateSerie( GRP_PIE ) 
    oGraphic:Add(nSerie, contC, 'Conforme', CLR_HGREEN )  
    oGraphic:Add(nSerie, contN, 'N�o Conforme', CLR_HRED)
    oGraphic:Add(nSerie, contA, 'Aguardando', CLR_YELLOW )
 
ACTIVATE DIALOG oDlg CENTERED 

DBSELECTAREA("TEMP1")
TEMP1->(DBCLOSEAREA())
Return Nil

Static Function ValidPerg
LOCAL _AREA := GETAREA()
LOCAL AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
CPERG 	:= PADR(CPERG,10)

AADD(AREGS,{CPERG,"01","Data Inicio  ?  "," ?"," ?","MV_CH01","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{CPERG,"02","Data Fim ?  "," ?"," ?","MV_CH01","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})

FOR I:=1 TO LEN(AREGS)
	IF !DBSEEK(CPERG+AREGS[I,2])
		RECLOCK("SX1",.T.)
		FOR J:=1 TO FCOUNT()
			IF J <= LEN(AREGS[I])
				FIELDPUT(J,AREGS[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
RESTAREA(_AREA)
RETURN
