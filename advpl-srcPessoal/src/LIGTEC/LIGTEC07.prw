#Include 'Protheus.ch'

/*
LIGTEC07   - Programa para gerar O.S (AB6) apartir da rotina TECA450 
Autor      - Robson Adriano  05/09/2014
Parametros - 1 _cliente, 2 _loja, 3 Cond. PGTO, 4 Mensagem Cab. 5 _itens da Ordem, 6 Atendente , 7 Situacao
*/

User Function LIGTEC07(_cliente,_loja,_cond,_msg,aItens,_atend,_situ1,_cNumCtr,_cCaixa)
	Local _area := getarea()		
	Local aCabec := {} 
	Local cNumOS := ""
	Local _cOS := ""
	Local iOK := .T.
	
	PRIVATE lMsErroAuto := .F.
	
	ConOut("Inicio: "+Time())
	
	cNumOS := GetSXENum("AB6","AB6_NUMOS")
	RollBackSx8()
	
	// Montar cabecalho do chamado tecnico
	aAdd(aCabec,{"AB6_NUMOS",cNumOS,Nil})
	aAdd(aCabec,{"AB6_CODCLI",_cliente,Nil})
	aAdd(aCabec,{"AB6_LOJA"  ,_loja,Nil})
	aAdd(aCabec,{"AB6_EMISSA",dDataBase,Nil})
	aAdd(aCabec,{"AB6_CONPAG",_cond,Nil})
	aAdd(aCabec,{"AB6_HORA"  ,Time(),Nil})
	aAdd(aCabec,{"AB6_MSG"  ,_msg,Nil})
	IF !EMPTY(ALLTRIM(_cNumCtr)) 
		aAdd(aCabec,{"AB6_UNUMCT",cValToChar(ALLTRIM(_cNumCtr)),Nil}) 	
	ENDIF  
	  
	IF EMPTY(_atend)
		aAdd(aCabec,{"AB6_ATEND" ,usrfullname(__cuserid),Nil})
	ELSE
		aAdd(aCabec,{"AB6_UCODAT" ,_atend,Nil})
		aAdd(aCabec,{"AB6_ATEND" ,POSICIONE( "AA1", 1, XFILIAL( "AA1" ) + _atend, "AA1_NOMTEC"),Nil})						
	ENDIF					
	aAdd(aCabec,{"AB6_USITU1",_situ1,Nil}) 
	
	IF !EMPTY(_cCaixa)
		aAdd(aCabec,{"AB6_UCAIXA",_cCaixa,Nil}) 
	endif
	//_modAnt := nModulo
	//nModulo := 28
	TECA450(,aCabec,aItens,{},3)
	/*nModulo := _modAnt*/
	
	If !lMsErroAuto
			ConOut("Incluido com sucesso! " + cNumOS)
			_cOS := cNumOS
	Else
			iOK := .F.
			MostraErro()
			CONOUT(MostraErro())
			ConOut("Erro na inclusao da Ordem Servico!")
	EndIf
	
	ConOut("Fim : "+Time())
	
	restarea(_area)
Return _cOS			