#include 'protheus.ch'
#include 'parmtype.ch'

/*
Ponto de entrada para validar usu�rio que 
realiza altera��o/exclus�o em solicita��o de compras
Ponto de entrada para validar usu�rio que 
realiza altera��o/exclus�o em pedido de compras
AUTOR: Noemi Scherer
DATA: 24/02/17
*/


/*
Fun��o respons�vel por veririficar
se o usu�rio logado
� o Rog�rio, leandro,
Gabriel ou Robson
*/
user function LIGCOM02()
	Local lModifca := .T.//Valida��es do usuario para continuar a exclus�o da SC
	
	IF __CUSERID$GETMV("MV_UADMCOM")
		lModifca := .T.
	ELSE
		lModifca := .F.
	ENDIF
	
return lModifca