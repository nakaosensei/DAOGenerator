#INCLUDE "PROTHEUS.CH"

//Desenvolvido por Everton Forti
//06/04/2014
//Usado por gatilho/formula para valida informacao em tela 
User Function MSGCAL01()

local cret

IF Empty(M->U7_NREDUZ)

MSGINFO( "INCLUIR USUARIO PELA OP��O A��ES RELACIONADAS"," ATENC�O")
      
Endif

Return(cret)


User Function MSGCAL02()

local cret2

IF Empty(M->U7_POSTO)

MSGINFO( "INCLUIR GRUPO PELA OP��O A��ES RELACIONADAS"," ATEN��O")
      
Endif

Return(cret2)
