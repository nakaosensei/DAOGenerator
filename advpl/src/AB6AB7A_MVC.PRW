#include 'protheus.ch'
#include 'parmtype.ch'
#include 'FWMVCDEF.CH'
 
user function AB6AB7A_MVC()
	Local oBrowse 
	Private aRotina := MenuDef()
	
	// Instanciamento da Classe de Browse 
	oBrowse := FWMBrowse():New() 
 
	// Defini��o da tabela do Browse 
	oBrowse:SetAlias('AB6') 
	
	//Filtro
	codUsr := RetCodUsr()
	if ALLTRIM(FUNNAME())=="LIGCAL02"
		cdCliente := SUBSTR(ADE->ADE_CHAVE,0,9)
		oBrowse:SetFilterDefault( "AB6_USITU1=='6' .AND. AB6_CODCLI == '"+cdCliente+"'")
	else
		tpUsr := POSICIONE("SU7",4,xFilial("SU7")+codUsr,"U7_TIPO")
			if(tpUsr == '1') //vendedor
				filtroTeste := "(SUBSTRING(AB6_USERGI,11,1) + SUBSTRING(AB6_USERGI,15,1) + SUBSTRING(AB6_USERGI,2,1) + SUBSTRING(AB6_USERGI,6,1) + SUBSTRING(AB6_USERGI,10,1) + SUBSTRING(AB6_USERGI,14,1))"
				oBrowse:SetFilterDefault( "AB6_USITU1=='6' .and. "+filtroTeste+" == '"+codUsr+"'") 	
			else // gerente
				oBrowse:SetFilterDefault( "AB6_USITU1=='6'")
			endif
	endif
 
	// Titulo da Browse 
	oBrowse:SetDescription('Viabilidade') 
	
	// Legenda 
	oBrowse:addLegend("AB6_STATUS=='A'", "GREEN", "ABERTO")
	oBrowse:addLegend("AB6_STATUS=='E'", "RED", "ENCERRADO")
	oBrowse:addLegend("AB6_STATUS=='B'", "YELLOW", "ATENDIMENTO")
	
	// Ativa��o da Classe
	oBrowse:Activate()
	
return

Static Function MenuDef() 
	Local aRotina := {} 
	ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.AB6AB7A_MVC' OPERATION 2 ACCESS 0 
	ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.AB6AB7A_MVC' OPERATION 3 ACCESS 0 
	ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.AB6AB7A_MVC' OPERATION 4 ACCESS 0 
	ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.AB6AB7A_MVC' OPERATION 5 ACCESS 0 
	ADD OPTION aRotina Title 'Imprimir OS' Action 'U_LIGTEC03' OPERATION 8 ACCESS 0 
	ADD OPTION aRotina Title 'Ver Atends'  Action 'U_LIGATOSW(AB6->AB6_NUMOS)' OPERATION 2 ACCESS 0 
	ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.AB6AB7A_MVC' OPERATION 8 ACCESS 0
Return aRotina


Static Function ModelDef() 
	// Cria a estrutura a ser usada no Modelo de Dados 
	Local oStruAB6 := FWFormStruct( 1, 'AB6' ) 
	Local oStruAB7 := FWFormStruct( 1, 'AB7' ) 
	
	// Modelo de dados que ser� constru�do 
	Local oModel 
	
	// Cria o objeto do Modelo de Dados 
	oModel := MPFormModel():New('AB6AB7A' ) 
	 
	// Adiciona ao modelo um componente de formul�rio 
	oModel:AddFields( 'AB6OS', /*cOwner*/, oStruAB6) 
	
//	oStruAB7:RemoveField( 'AB7_MEMO1' )
//	oStruAB7:RemoveField( 'AB7_MEMO2' )
//	oStruAB7:RemoveField( 'AB7_MEMO3' )
//	oStruAB7:RemoveField( 'AB7_MEMO4' )
	oStruAB7:addField('Laudo','Laudo','AB7_MEMO1', 'C', 6, 0, {||.T.},nil,,.F.,nil,.T.,.F.,.F.)
	oStruAB7:addField('Laudo','Laudo','AB7_MEMO3', 'C', 6, 0, {||.T.},nil,,.F.,nil,.T.,.F.,.F.)
	FWMemoVirtual( oStruAB7,{ { 'AB7_MEMO1' , 'AB7_MEMO2'} } )
	FWMemoVirtual( oStruAB7,{ { 'AB7_MEMO3' , 'AB7_MEMO4'} } )
	
	
	// Adiciona Grid da tabela filha
	oModel:AddGrid( 'AB7DETAIL', 'AB6OS', oStruAB7 ) 
//	oModel:SetRelation( 'AB7DETAIL', { { 'AB7_FILIAL', 'xFilial( "AB7" )'  }, { 'AB6_NUMOS', 'AB7_NUMOS' } }, AB7->( IndexKey( 1 ) ) ) 
	oModel:SetRelation( 'AB7DETAIL', { { 'AB7_FILIAL', 'xFilial( "AB7" )'  }, { 'AB7_NUMOS', 'AB6_NUMOS' } }, AB7->( IndexKey( 1 ) ) ) 
	// Adiciona a descri��o do Modelo de Dados 
	oModel:SetDescription( 'Viabilidade' ) 
	 
	// Adiciona a descri��o do Componente do Modelo de Dados 
	oModel:GetModel( 'AB6OS' ):SetDescription( 'Viabilidade' ) 
	 
	// Retorna o Modelo de dados 
Return oModel 


Static Function ViewDef() 
	// Interface de visualiza��o constru�da 
	Local oView
	// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado 
	Local oModel := FWLoadModel( 'AB6AB7A_MVC' ) 
 
	// Cria a estrutura a ser usada na View 
	Local oStruAB6 := FWFormStruct( 2, 'AB6' )
	Local oStruAB7 := FWFormStruct( 2, 'AB7' ) 
	
//	oStruAB7:RemoveField( 'AB7_MEMO1' )
//	oStruAB7:RemoveField( 'AB7_MEMO2' )
//	oStruAB7:RemoveField( 'AB7_MEMO3' )
//	oStruAB7:RemoveField( 'AB7_MEMO4' )
//	
	FWMemoVirtual( oStruAB7,{ { 'AB7_MEMO1' , 'AB7_MEMO2'} } )
	FWMemoVirtual( oStruAB7,{ { 'AB7_MEMO3' , 'AB7_MEMO4'} } )
	  
	// Cria o objeto de View 
	oView := FWFormView():New() 
	 
	// Define qual o Modelo de dados ser� utilizado na View 
	oView:SetModel( oModel ) 
	// Adiciona no nosso View um controle do tipo formul�rio  
	// (antiga Enchoice) 
	oView:AddField( 'VIEW_AB6', oStruAB6, 'AB6OS' ) 

	//Adiciona no nosso View um controle do tipo Grid (antiga Getdados) 
	oView:AddGrid( 'VIEW_AB7', oStruAB7, 'AB7DETAIL' )
		 	 
		 	 
	// Cria um "box" horizontal para receber cada elemento da view 
	oView:CreateHorizontalBox( 'SUPERIOR', 60 ) 
	oView:CreateHorizontalBox( 'INFERIOR', 40 ) 
	 
	// Relaciona o identificador (ID) da View com o "box" para exibi��o 
	oView:SetOwnerView( 'VIEW_AB6', 'SUPERIOR' ) 
	oView:SetOwnerView( 'VIEW_AB7', 'INFERIOR' ) 
	 
	// Retorna o objeto de View criado 
	
	
Return oView 

