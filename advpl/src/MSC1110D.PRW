#include 'protheus.ch'
#include 'parmtype.ch'

/*
MSC1110D: Antes da apresenta�ao da dialog de exclus�o 
da SC possibilita validar a solicita��o posicionada 
para continuar e executar a exclus�o ou n�o.
*/
user function MSC1110D()
	Local lExclui := U_LIGCOM02()
	
	IF lExclui = .F.
		MsgInfo("Usu�rio n�o possui permiss�o para exclus�o")
	ENDIF
	
return lExclui