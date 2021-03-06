#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#include "rwmake.ch"
#INCLUDE "TOTVS.CH"

User Function AGASA1_MVC()
Local oBrowse	  := Nil 
Local cFiltra := ""

Private aRotina := MenuDef()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SA1")//Seleciona o Alias que estamos trabalhando.
oBrowse:SetDescription("Cadastro de Clientes")// "Descri��o"
oBrowse:SetFilterDefault(cFiltra)

//oBrowse:AddLegend( "AB6_UVALAT==' '", "YELLOW", "Aguardando" )
//oBrowse:AddLegend( "AB6_UVALAT=='1'", "GREEN", "Conforme" )
//oBrowse:AddLegend( "AB6_UVALAT=='2'", "RED" , "N�o Conforme" )

// Remove os bot�es de navega��o na edi��o ou visualiza��o do model
//oBrowse:SetUseCursor(.F.)
oBrowse:Activate()

Return

Static Function MenuDef() 
Local aRotina       := {}
	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.AGASA1_MVC' OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina Title 'Incluir' Action 'VIEWDEF.AGASA1_MVC' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar' Action 'VIEWDEF.AGASA1_MVC' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir' Action 'VIEWDEF.AGASA1_MVC' OPERATION 5 ACCESS 0
	ADD OPTION aRotina Title 'Imprimir' Action 'VIEWDEF.AGASA1_MVC' OPERATION 8 ACCESS 0
	ADD OPTION aRotina Title 'TESTE' Action 'U_AGASA101' OPERATION 9 ACCESS 0
Return aRotina

Static Function ModelDef()
Local oModel
Local oStr1:= FWFormStruct(1,'SA1')
Local oStr2:= FWFormStruct(1,'AGA')

oModel := MPFormModel():New('MODSA1AGA', /*bPreValidacao*/, { | oModel | AGASA101( oModel ) } , /*{ | oMdl | MVC001C( oMdl ) }*/ ,, /*bCancel*/ )

//Iniciar o campo com conteudo
oStr2:SetProperty('AGA_CODIGO' , MODEL_FIELD_INIT,{||'0'} )
oStr2:SetProperty('AGA_ENTIDA' , MODEL_FIELD_INIT,{||'SA1'} )
oStr2:SetProperty('AGA_CODENT' , MODEL_FIELD_INIT,{||SA1->A1_COD+SA1->A1_LOJA} )

oStr2:RemoveField( 'AGA_FILIAL' )
//oStr2:RemoveField( 'AGA_CODIGO' )
//oStr2:RemoveField( 'AGA_ENTIDA' )
//oStr2:RemoveField( 'AGA_CODENT' )

oModel:addFields('FIELD1',,oStr1)
oModel:AddGrid( 'AGADETAIL1', 'FIELD1', oStr2 ,{ |oModelGrid, nLine, cAction, cField| AGASA1LPRE(oModelGrid, nLine, cAction, cField) })

oModel:SetRelation( 'AGADETAIL1', { { 'AGA_FILIAL', 'xFilial( "AGA" )' }, { 'AGA_CODENT', 'A1_COD + A1_LOJA' } }, AGA->( IndexKey( 1 ) ) )

Return oModel

Static Function ViewDef()
Local oView
Local oModel := ModelDef()
Local oStr1:= FWFormStruct(2, 'SA1')
Local oStr2:= FWFormStruct(2, 'AGA', { |cCampo| AGASA1STRU(cCampo) })

//oModelZA2 := oModel:GetModel( 'DETAIL1' )
//oModelZA2:SetVldActivate( { |oModel| COMP011ACT( oModelZA2 ) } )

oView := FWFormView():New()
oView:SetModel(oModel)


oView:AddField('FORM1' , oStr1,'FIELD1' ) 
oView:AddGrid( 'TABLE1', oStr2, 'AGADETAIL1' )

//oView:CreateFolder( 'PASTAS' )
//oView:AddSheet( 'PASTAS', 'SHEET1', 'Cadastro' )

//oView:CreateFolder( 'PASTAS2' )
//oView:AddSheet( 'PASTAS2', 'SHEET2', 'Endere�o' )

oView:CreateHorizontalBox( 'BOXFORM1', 70)
//oView:CreateHorizontalBox( 'BOXFORM1', 70,,, 'PASTAS', 'SHEET1')
oView:CreateHorizontalBox( 'BOXTABLE1', 30)
//oView:CreateHorizontalBox( 'BOXTABLE1', 30,,, 'PASTAS2', 'SHEET2')

oView:SetOwnerView('FORM1','BOXFORM1')
oView:SetOwnerView('TABLE1','BOXTABLE1')

//oView:SetViewAction( 'BUTTONOK' ,{ |oView| AGASA101( oView ) } )
Return oView

Static Function AGASA1LPRE( oModelGrid, nLinha, cAcao, cCampo )
Local lRet := .T.
Local oModel := oModelGrid:GetModel()
Local nOperation := oModel:GetOperation()
    

// Valida se pode ou n�o apagar uma linha do Grid
If cAcao == 'DELETE' .AND. nOperation == MODEL_OPERATION_UPDATE
	lRet := .F.
	Help( ,, 'Help',, 'N�o permitido apagar linhas na altera��o.' +;
	CRLF + 'Voc� esta na linha ' + Alltrim( Str( nLinha ) ), 1, 0 )
EndIf

Return lRet

Static Function AGASA1ACT( oModelGrid)
Local lRet := .T.
Local oModel := oModelGrid:GetModel()

Return lRet

Static Function AGASA1STRU( cCampo )
Local lRet := .T.

/*If cCampo == 'AGA_CODIGO' .OR. cCampo == 'AGA_ENTIDA' .OR. cCampo == 'AGA_CODENT'
	lRet := .F.
EndIf*/
Return lRet

Static Function AGASA101(oModel)
Local lRet      := .T.
Local oModelAGA := oModel:GetModel( 'AGADETAIL1' )
Local nOpc      := oModel:GetOperation()
Local aArea     := GetArea()
Local nI := 0

	For nI := 1 To oModelAGA:Length()
		oModelAGA:GoLine( nI )
		
		If oModelAGA:IsInserted()
			cCod := GetSXENum("AGA","AGA_CODIGO")
			ConfirmSX8()
			oModelAGA:SetValue('AGA_CODIGO', cCod )
		endif
		
	Next nI

RestArea(aArea)
	
FwModelActive( oModel, .T. )

return lRet
