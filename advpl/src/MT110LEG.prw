#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT110LEG()

	Local aLegend := {} //ParamIxb[1] 

	//Testo o Tipo
	IF !( ValType( aLegend ) == "A" )
		aLegend := {}
	EndIF
	
	aAdd( aLegend , { "BR_BRANCO"  , OemToAnsi( "Solicita��o Pendente" ) } )
	aAdd( aLegend , { "BR_VERDE"  ,  OemToAnsi( "Solicita��o Aprovada" ) } )
	aAdd( aLegend , { "BR_CINZA"  ,  OemToAnsi( "Solicita��o em Cota��o" ) } )
	aAdd( aLegend , { "BR_AZUL"  ,   OemToAnsi( "Solicita��o em Pedido de Compra" ) } )
	aAdd( aLegend , { "BR_AMARELO" , OemToAnsi( "Solicita��o Parcialmente Atendida" ) } )
	aAdd( aLegend , { "BR_LARANJA"  , OemToAnsi( "Solicita��o Bloqueada" ) } )
	aAdd( aLegend , { "BR_VERMELHO"  , OemToAnsi( "Solicita��o Rejeitada " ) } )
	
Return( aLegend )
