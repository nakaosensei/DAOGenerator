#include 'protheus.ch'
#include 'parmtype.ch'

/*
Manipula apresenta��o das cores na mBrowse
Para pedido de compras
*/
User Function MT120LEG()
	Local aNewLegenda  := aClone(PARAMIXB[1])	
	aNewLegenda := {{ "BR_VERDE"	,  		"Pedido Pendente"  },;
					{ "BR_AMARELO"	,  		"Pedido Parcialmente Atendido"  },;
					{ "BR_LARANJA" 	, 		"Pr�-nota" },;
					{ "BR_VERDE_ESCURO"	,  	"Pedido Atendido"  },;
					{ "BR_AZUL"	,  	"Em aprova��o"  },;		
					{ "BR_VERMELHO"	,  		"Pedido Bloqueado, Devolvido e Reprovado"  },;
					{ "BR_PRETO"	,  		"Pedido com Elimina��o de Res�duo"  }}
					
Return aNewLegenda