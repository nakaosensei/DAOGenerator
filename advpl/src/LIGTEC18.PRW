#include 'protheus.ch'
#include 'parmtype.ch'


/*
Atualizar boleto pela tela de Chamados
AUTOR: NOEMI SCHERER
DATA: 10/03/17
*/

/*
Fun��o respons�vel por verificar
se o cliente escolhido na ordem de servi�o
possui uma fatura em aberto.
Se sim, chama a rotina que adiciona
um bot�o para atualizar suas faturas
*/

user function LIGTEC18(nCodCli)
Local _area := getarea()
Local _aSE1 := SE1->(getarea())
	Private dData := dDataBase
	
	Public lDeve := .F.
	Public codCli := nCodCli
		
	dbSelectArea("SE1")
	dbSetOrder(8) //E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_STATUS	
	//Verificar se cliente possui contas em aberto
	IF dbSeek(xFilial("SE1") + nCodCli)		
		WHILE !EOF() .AND. E1_FILIAL + E1_CLIENTE == xFilial("SE1") + nCodCli
//			IF E1_STATUS == "A" .AND. E1_VENCTO < dData .AND. EMPTY(E1_BAIXA)
			IF E1_STATUS == "A" .AND. EMPTY(E1_BAIXA)
				lDeve := .T.
				MsgInfo("Cliente com faturas em aberto")
				EXIT
			ENDIF
			
			dbSelectArea("SE1")
			dbSkip()
		ENDDO
	ENDIF
	
restarea(_aSE1)
restarea(_area)	
return " "


/*
Retorna o codigo do cliente
selecionado no chamado tecnico,
Se ele exisitir
*/
user function TEC18A()
	Local nCodCli
	
	IF Type("codCli")<>"U" 
		nCodCli := codCli
	ELSE
		nCodCli := ""
	ENDIF
return nCodCli

/*
Retorna o nome do cliente
selecionado no chamado tecnico,
Se ele exisitir
*/
user function TEC18B()
	Local lFaturas
	
	IF Type("lDeve")<>"U" 
		lFaturas := lDeve
	ELSE
		lFaturas := ""
	ENDIF
	
	//lFaturas := lDeve
return lFaturas
