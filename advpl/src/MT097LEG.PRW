#include 'protheus.ch'
#include 'parmtype.ch'

/*
Alterar legenda da Libera��o de Pedidos
AUTOR: Noemi Scherer
DATA: 01/03/17
*/

/*
 AlterarCriar a Legenda da Libera��o de Documentos
*/
user function MT097LEG()
	local aLegenda :=Paramixb[1]   //Modifica��es Necess�rias 	
	aLegenda := {{ "BR_VERDE"	,  		"Liberado pelo usu�rio"  },;
				{ "BR_LARANJA"	,  		"Aguardando libera��o do usu�rio"  },;
				{ "BR_MARRON_OCEAN" 	, 	"Bloqueado (Aguardando outros niveis)" },;		
				{ "BR_VERMELHO"	,  		"Bloqueado pelo usu�rio"  },;
				{ "BR_VERDE_ESCURO"	, 	"Documento liberado por outro usu�rio"  }}

return aLegenda