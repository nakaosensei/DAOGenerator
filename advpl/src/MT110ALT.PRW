#include 'protheus.ch'
#include 'parmtype.ch'

/*
Valida o registro posicionado
da solicita��o de compra
*/
user function MT110ALT()
	Local lExecuta :=  .F.
	
	_cUser := ALLTRIM(UsrRetName(RetCodUsr())) 
	
	IF  U_LIGCOM02() .OR. ALLTRIM(SC1->C1_SOLICIT) == _cUser
		lExecuta :=  .T.
	ELSE
		MsgInfo("Usu�rio n�o possui permiss�o para alterar ou excluir")
	ENDIF
	
return lExecuta