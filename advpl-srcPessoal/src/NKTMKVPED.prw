#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

user function NKTMKVPED(_naten)
	Local _area := GetArea()
	Local cItemNovo := "00"
	Local _lAuxi := _lAlteraItem
	Local _cOcoIns := getmv("MV_UOCOINS")
	Local _cOcoEnd := getmv("MV_UOCOEND")
	Local _cSerIns := getmv("MV_USERINS")
	Local _cOcoDes := getmv("MV_UOCODES")
	Local _cSerDes := getmv("MV_USERDES")
	Local _cAtAtiv := getmv("MV_UATATIV") // COD ATENDENTE DE ATIVACAO
	Local _cAtInst := getmv("MV_UATINST") // Cod. Atendente para Ordem de Servico de Instalacao
	Local _cAtPlug := getmv("MV_UATPLUG") // Cod. Atendente para Ordem de Servico de Instalacao
	Local _cProEnd := getmv("MV_UPROEND") // se produto for do getmv("MV_UPROEND") VAI PRO getmv("MV_UATATIV")
	Local _cProCan := getmv("MV_UPROCAN") // Cod. Produto para Cancelamento de item parcial   
	Local _cAtAtend1 := getmv("MV_UATEND1") // COD ATENDENTE DE INSTALACAO DE LINK FULL	
	Local _cPrdLnkFl := getmv("MV_UPDLKF") //Cod dos produto LinkFull
	Local _lIncluiItem := .f.
	Local _NCRTANT := ""
	Local _nCobAnt := ""
	Local _cNumCtr := ""
	Local _geraJunto := getmv("MV_UGERAOS")
	Local aDados := {}
	Local _novaOS := aleatorio(5)
	Local _os := ""  
	Local isLnkFull := .F.
	
	Local _emailGeoGrid := getmv("MV_UEMLGEO")
	Local _ocorrenciaGeoGrids := getmv("MV_UOCOGEO")
	Local _atendenteGeoGrids := getmv("MV_UATGEO")
	Local _msgLIGTEC07_ELSE := "RESERVA DE CLIENTE NO GEOGRIDS"
	Local _msgEmptyOS_ELSE := "N�O FOI POSSIVEL CRIAR A ORDEM DE CADASTRO DE CLIENTES NO GEOGRIDS"
	Local _msgERRO_ELSE := "ERRO AO TENTAR INCLUIR UMA OS DE CADASTRO DE CLIENTES NO GEOGRIDS "
	Local _msgNovaOS_ELSE := "<p>Nova Ordem de Servi�o criada para Cadastro de Clientes no GeoGrids</p>"
	Local _msgContatoAgendamento_ELSE := "<p></p>"
	Local _titulo_ELSE := "Cadastro de Clientes no GeoGrids"
	
	CONOUT("ENTROU TMKVPED "+_naten)
	
	dbselectarea("SUA")
	dbsetorder(1)
	if dbseek(xFilial()+_naten)
		lNovo := .T.
		dbselectarea("ADA")
		dbsetorder(2)//ADA_FILIAL+ADA_CODCLI+ADA_LOJCLI
		if dbseek(xFilial()+SUA->UA_CLIENTE+SUA->UA_LOJA)
			dbselectarea("SUB")
			dbsetorder(1)
			if dbseek(xFilial()+SUA->UA_NUM)
				while !eof()
					if !empty(SUB->UB_UCTR)
						conout("entrou if 1, lNovo := .f. ")
						lNovo := .f.
						IF empty(SUB->UB_UITTROC)
							_lIncluiItem := .t.
						ENDIF
					endif
					if !empty(SUB->UB_UITTROC) .and. !empty(SUB->UB_UCTR)
						conout("entrou if 2, lNovo := .f. _lIncluiItem := .T.")
						lNovo := .f.
						_lIncluiItem := .t.
					endif
					dbselectarea("SUB")
					dbskip()
				enddo
			endif
		endif	
	endif
	
	conout("TMKVPED VAI OLHAR O VENDEDOR")
	IF EMPTY(SUA->UA_VEND)
		_VEND1 := POSICIONE("SA3",7,XFILIAL("SA3")+__cUserID,"A3_COD")   //INDICE 7 - A3_FILIAL+A3_CODUSR
		_VEND2 := POSICIONE("SA3",7,XFILIAL("SA3")+__cUserID,"A3_SUPER")
	ELSE
		_VEND1 := SUA->UA_VEND
		_VEND2 := POSICIONE("SA3",1,XFILIAL("SA3")+SUA->UA_VEND,"A3_SUPER")
	ENDIF
	
	CONOUT("TMKVPED VAI VER SE INCLUI UM NOVO")
	IF LNOVO
		CONOUT('NOVO')
	ELSE
		CONOUT('VELHO')
	ENDIF
	
	if lNovo
		if ADA->ADA_ULIBER=="S" .and. !lNovo
			_liberado := "S"
		else
			_liberado := "N"
		endif
		
		//INICIO CODIGO ROBSON 01/03/2014
		//VERIFICAR SE TELE VENDAS (SUA) TEM VINCULO(COPIA) COM ALGUM TELE VENDAS ANTIGO
		IF !EMPTY(SUA->UA_UCCANT)
			DBSELECTAREA("ADA")
			DBSETORDER(3)
			IF DBSEEK(xFilial("ADA")+ SUA->UA_UCCANT)
				_nCrtAnt := ADA->ADA_NUMCTR //PEGAR CONTRATO DO TELEVENDAS COPIADO
				_nCobAnt := ADA->ADA_UNRCOB
			ENDIF
		ENDIF
		//FIM DO CODIGO ROBSON 01/03/2014
		
		dbselectarea("ADA")
		dbsetorder(1)
		dbgotop()
		//dbseek(xFilial()+"999999",.t.)robso
		//dbskip(-1)
		_cod := GETSX8NUM("ADA","ADA_NUMCTR") //soma1(ADA->ADA_NUMCTR,6)
		confirmsx8()
		
		reclock("SUA",.F.)
			SUA->UA_UNUMCTR := _cod
		msunlock()
		//		if bof()
		//			_cod := "000001"
		//		endif
		
		reclock("ADA",.t.)
		ADA->ADA_FILIAL := xFilial("ADA")
		ADA->ADA_NUMCTR := _cod
		ADA->ADA_EMISSA := date()
		ADA->ADA_CODCLI := SUA->UA_CLIENTE
		ADA->ADA_LOJCLI := SUA->UA_LOJA
		ADA->ADA_CONDPG := SUA->UA_CONDPG
		ADA->ADA_VEND1  := _VEND1
		ADA->ADA_VEND2  := _VEND2
		ADA->ADA_MOEDA  := 1
		ADA->ADA_TIPLIB  := "1"
		ADA->ADA_STATUS := "B"
		ADA->ADA_UVALI  := SUA->UA_UVCTR
		
		ADA->ADA_UOBS := MSMM(SUA->UA_CODOBS,,,,3,,,"SUA","UA_OBS")
		
		//ENDERECO
		IF !EMPTY(SUA->UA_UEND)
			ADA->ADA_UEST := SUA->UA_UEST
			ADA->ADA_UCEP := SUA->UA_UCEP
			ADA->ADA_UEND := SUA->UA_UEND
			ADA->ADA_UNUM := SUA->UA_UMUN
			ADA->ADA_UBAIRR := SUA->UA_UBAIRRO
			ADA->ADA_UCOMPL := SUA->UA_UCOMPLE
			ADA->ADA_UCOD_M := SUA->UA_UCOD_MU
			ADA->ADA_UMUN := SUA->UA_UMUN
		ENDIF
		//FIM ENDERECO
		
		ADA->ADA_UDIAFE := SUA->UA_UDIAFE
		ADA->ADA_ULIBER := "N"
		ADA->ADA_ULIBEQ := "N"
		ADA->ADA_UNFIMP := "N"
		ADA->ADA_UTIPO  := SUA->UA_UTIPO //TIPO DO CONTRATO
		ADA->ADA_UIDAGA := SUA->UA_UIDAGA
		
		
		ADA->ADA_UCALLC := SUA->UA_NUM //VINCULAR CONTRATO AO TELE VENDAS
		IF !EMPTY(_nCrtAnt)//VINCULAR CONTRATO ANTIGO CASO TENHA
			ADA->ADA_UCTANT := _nCrtAnt
			ADA->ADA_UNRCOB := _nCobAnt
		ENDIF
		
		_TESCTR := ALLTRIM(GETMV("MV_UTESPF"))
		IF (SA1->A1_PESSOA = 'J')
			_TESCTR :=ALLTRIM(GETMV("MV_UTESCTR"))
		ENDIF
		msunlock()
		
		
		dbselectarea("SUB")
		dbsetorder(1)
		if dbseek(xFilial()+_naten)
			while !eof() .and. xFilial()+_naten==SUB->UB_FILIAL+SUB->UB_NUM
				dbselectarea("SB1")
				dbsetorder(1)
				dbseek(xFilial()+SUB->UB_PRODUTO)
				cItemNovo := soma1(cItemNovo)
				reclock("ADB",.t.)
				ADB->ADB_FILIAL := xFilial("SUB")
				ADB->ADB_NUMCTR := _cod
				ADB->ADB_ITEM   := cItemNovo
				ADB->ADB_CODPRO := SB1->B1_COD
				ADB->ADB_DESPRO := SB1->B1_DESC
				ADB->ADB_UM     := SB1->B1_UM
				ADB->ADB_QUANT  := SUB->UB_QUANT
				ADB->ADB_PRCVEN := SUB->UB_VRUNIT //Preco Venda
				ADB->ADB_TOTAL  := SUB->UB_QUANT*SUB->UB_VRUNIT //Total Mensal
				ADB->ADB_UVLCHE := SUB->UB_UVLCHE //Valor Total
				ADB->ADB_VALDES := SUB->UB_VALDESC
				ADB->ADB_DESC 	:= SUB->UB_DESC
				
				ADB->ADB_TES    := _TESCTR
				
				ADB->ADB_LOCAL  := SB1->B1_LOCPAD
				ADB->ADB_CODCLI := SUA->UA_CLIENTE
				ADB->ADB_LOJCLI := SUA->UA_LOJA
				ADB->ADB_UVEND1  := _VEND1
				ADB->ADB_UVEND2  := _VEND2
				ADB->ADB_UMSG    := SUB->UB_UMSG
				ADB->ADB_UNUMAT	 := SUB->UB_NUM
				ADB->ADB_UITATE	 := SUB->UB_ITEM
				
				ADB->ADB_UMESIN	 := SUB->UB_UMESINI
				ADB->ADB_UMESCO	 := SUB->UB_UMESCOB
				
				ADB->ADB_UIDAGA	 := SUB->UB_UIDAGA
				msunlock()
				
				dbselectarea("SUB")
				dbskip()
			enddo
		endif
		U_LIGTMKA3(_cod)
		
		//inicio da cria��o da O.S para o GeoGrids
		_nCtr := SUA->UA_UNUMCTR //n�mero do contrato
			
		IF LNOVO
			CONOUT('NOVO')
			
			u_TMKVPEDB()
			aItens := U_LIGTEC08(SUA->UA_CLIENTE, SUA->UA_LOJA, _ocorrenciaGeoGrids,_nCtr)                          				
			//Funcao que monta o cabecalho(AB6) da O.S e usa TECA450 para gerar chamados
									//1	Cliente		2 Loja 		  3	Cond Pgto		4 msg	5 itens, 6 ATENDE, 7 ASSUNTO, 8 CTR
			_os := U_LIGTEC07(SUA->UA_CLIENTE, SUA->UA_LOJA, SUA->UA_CONDPG,_msgLIGTEC07,aItens,_atendenteGeoGrids,"2",_nCtr,SUA->UA_UCAIXA)
			
			if empty(_os) //GERAR SZ2 PARA FIM DE VINGENCIA NOS ITENS DO CONTRATO ANTIGO QUANDO FOR RETIRADO O EQUIPAMENTO
				MsgInfo(_msgEmptyOS  + SUA->UA_CLIENTE," Msg Info ")
				//memowrite("\logerro\ERRO_"+strtran(time(),":","")+".log",_msgERRO+ADB->ADB_NUMCTR+" NA ROTINA AT450GRV")	
			endif
	
		//cria O.S
		//u_AT450G(_emailGeoGrid, _ocorrenciaGeoGrids, _atendenteGeoGrids, _msgLIGTEC07_ELSE, _msgEmptyOS_ELSE, _msgERRO_ELSE, _msgNovaOS_ELSE, _msgContatoAgendamento_ELSE, _titulo_ELSE)
			
		ELSE
			CONOUT('VELHO')
		ENDIF
		//fim da cria��o da O.S para o GeoGrids	
	else
		CONOUT("ENTROU PRA VERIFICAR O _AALTCTR ")
		CONOUT(type('_aAltCtr'))
		if type('_aAltCtr')=='A'
			CONOUT("ENTROU _aAltCtr "+CVALTOCHAR(LEN(_aAltCtr)))
			cont := 0
			if _lAuxi //lAlteraItem
				if len(_aAltCtr)>0 //VAI TROCAR OS ITENS
					for j:=1 to len(_aAltCtr)
						//N�O PERMITIR SOLICITA��O SE CONTRATO JA TIVER LIBERADO EQUIPAMENTO
						//					IF U_LIGTMKA1(_aAltCtr[j,1])
						//						RETURN
						//					ENDIF
						
						_cNumCtr := _aAltCtr[j,1]
						U_LIGTMKA2(_aAltCtr[j,1])
						
						// 				 1               2               3                 4                 5                 6               7               8                 9             10						11					12					13
						//aadd(_aAltCtr,{ADA->ADA_NUMCTR,ADB->ADB_CODPRO,aCols[i,_nPosPro],aCols[i,_nPosQtd],aCols[i,_nPosVlr],ADA->ADA_CODCLI,ADA->ADA_LOJCLI,aCols[i,_nPosMsg],ADB->ADB_ITEM,aCols[i,_nPosIt],aCols[i,_nMesIn], aCols[i,_nMesCo],aCols[i,_nIdAga]})
						
						_TESCTR := ALLTRIM(GETMV("MV_UTESPF"))
						IF (SA1->A1_PESSOA = 'J')
							_TESCTR :=ALLTRIM(GETMV("MV_UTESCTR"))
						ENDIF
						
						
						//INICIO DA VIGENCIA
						dbselectarea("SB1")
						dbsetorder(1)
						if dbseek(xFilial()+_aAltCtr[j,3])
							IF ALLTRIM(SB1->B1_COD) <> _cProCan //TESTAR SE E CANCELAMENTO PARCIAL
								dbselectarea("ADB")
								dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
								dbgotop()
								dbseek(xFilial()+_aAltCtr[j,1]+"ZZ",.T.)
								dbskip(-1)
								cItemNovo := SOMA1(ADB->ADB_ITEM)
								reclock("ADB",.t.)
								ADB->ADB_FILIAL := xFilial("SUB")
								ADB->ADB_NUMCTR := _aAltCtr[j,1]
								ADB->ADB_ITEM   := cItemNovo
								ADB->ADB_CODPRO := SB1->B1_COD
								ADB->ADB_DESPRO := SB1->B1_DESC
								ADB->ADB_UM     := SB1->B1_UM
								ADB->ADB_QUANT  := _aAltCtr[j,4]
								ADB->ADB_PRCVEN := _aAltCtr[j,5]
								ADB->ADB_TOTAL  := _aAltCtr[j,4]*_aAltCtr[j,5]
								ADB->ADB_UVLCHE := _aAltCtr[j,14]
								ADB->ADB_VALDES := _aAltCtr[j,15]
								ADB->ADB_DESC 	:= _aAltCtr[j,16]
								
								ADB->ADB_TES    := _TESCTR
								ADB->ADB_LOCAL  := SB1->B1_LOCPAD
								ADB->ADB_CODCLI := _aAltCtr[j,6]
								ADB->ADB_LOJCLI := _aAltCtr[j,7]
								ADB->ADB_UVEND1  := _VEND1
								ADB->ADB_UVEND2  := _VEND2
								ADB->ADB_UMSG    := _aAltCtr[j,8]
								ADB->ADB_UNUMAT	 := _naten
								ADB->ADB_UITATE	 := _aAltCtr[j,10]
								
								ADB->ADB_UMESIN	 := _aAltCtr[j,11]
								ADB->ADB_UMESCO	 := _aAltCtr[j,12]
								ADB->ADB_UIDAGA	 := _aAltCtr[j,13]
								msunlock()
								
								//vai come�ar a preparar as variaveis pra chamar a LIGTEC01
								_condi := ADA->ADA_CONDPG
								
								if empty(alltrim(_condi))
									_condi := ALLTRIM(GETMV("MV_UCONCTR"))
								endif
								
								dbselectarea("SX6")
								dbsetorder(1)
								dbseek("    "+"MV_ATBSSEQ")
								_numser := SOMA1(ALLTRIM(SX6->X6_CONTEUD))
								reclock("SX6",.f.)
								SX6->X6_CONTEUD := _numser
								msunlock()
								_numser := alltrim(GETMV("MV_ATBSPRF"))+_numser
								
								dbselectarea("AA3")
								reclock("AA3",.t.)
								AA3->AA3_FILIAL := xFilial()
								AA3->AA3_CODCLI := ADB->ADB_CODCLI
								AA3->AA3_LOJA   := ADB->ADB_LOJCLI
								AA3->AA3_NUMSER := _numser
								AA3->AA3_CODPRO := SB1->B1_COD
								AA3->AA3_DTVEND := ddatabase
								AA3->AA3_DTGAR  := ddatabase
								AA3->AA3_STATUS := "03"
								AA3->AA3_HORDIA := 8
								AA3->AA3_UNUCTR := ADB->ADB_NUMCTR 	//Numero do contrato que gerou a base de atendimento
								AA3->AA3_UITCTR := ADB->ADB_ITEM 	//Codigo do item do contrato que gerou a base de atendimento
								AA3->AA3_UIDAGA := _aAltCtr[j,13]
								msunlock()
								
								_cItemCtr := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + ADB->ADB_CODPRO, "B1_UITCONT")
								_numAda := posicione("ADA",1,xFilial("ADA")+ADB->ADB_NUMCTR,"ADA->ADA_NUMCTR")
								conout("tmkvped add adados 1 "+ADB->ADB_CODPRO+" - "+_cItemCtr) 
								
								if(At(ALLTRIM(ADB->ADB_CODPRO),_cPrdLnkFl,1)>=1)//Se o codigo do produto de ADB est� em _cPrdLnkFl, fa�a o atendente ser o atendente da insta��o link full
									isLnkFull := .T.								
								endif
								
								IF _gerajunto
									conout("_gerajunto true")
								else
									conout("_gerajunto false")
								endif
								IF (_cItemCtr = 'N')
									if _geraJunto
										aadd(aDados,{SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtInst,"1",_numAda,cItemNovo,"INICIO VIGENCIA",_naten})
									else
										_os := U_LIGTEC01(SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtInst,"1",_numAda,cItemNovo,"INICIO VIGENCIA",_naten)
									endif
								ELSE
									conout("tmkvped add adados 2 "+SB1->B1_GRUPO+" - "+_cItemCtr)
									IF SB1->B1_GRUPO == '0106' .OR. SB1->B1_GRUPO == '0107' .OR. SB1->B1_GRUPO == '0108'
										if _geraJunto
											aadd(aDados,{SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtPlug,"3",_numAda,cItemNovo,"INICIO VIGENCIA",_naten})
										else
											_os := U_LIGTEC01(SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtPlug,"3",_numAda,cItemNovo,"INICIO VIGENCIA",_naten)
										endif
									ELSE
										conout("tmkvped add adados 3 "+SB1->B1_GRUPO+" - "+_cItemCtr)
										if _geraJunto
											aadd(aDados,{SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtAtiv,"3",_numAda,cItemNovo,"INICIO VIGENCIA",_naten})
										else
											_os := U_LIGTEC01(SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtAtiv,"3",_numAda,cItemNovo,"INICIO VIGENCIA",_naten)
										endif
									ENDIF
								ENDIF
								
							ENDIF
						endif
						
						//FINAL DA VIGENCIA
						dbselectarea("SB1")
						dbsetorder(1)
						if dbseek(xFilial()+_aAltCtr[j,2])
							dbselectarea("ADB")
							dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
							if dbseek(xFilial()+_aAltCtr[j,1]+_aAltCtr[j,9])
								
								//vai come�ar a preparar as variaveis pra chamar a LIGTEC01
								_condi := posicione("SA1",1,xFilial("SA1")+ADB->ADB_CODCLI+ADB->ADB_LOJCLI,"A1_COND")
								
								if empty(alltrim(_condi))
									_condi := "115"
								endif
								
								//d							dbselectarea("AA3")
								//d							dbsetorder(1)//AA3_FILIAL+AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER
								//d							if dbseek(xFilial()+ADB->ADB_CODCLI+ADB->ADB_LOJCLI+SB1->B1_COD)
								//d								_numser := AA3->AA3_NUMSER
								//d							else
								dbselectarea("SX6")
								dbsetorder(1)
								dbseek("    "+"MV_ATBSSEQ")
								_numser := SOMA1(ALLTRIM(SX6->X6_CONTEUD))
								reclock("SX6",.f.)
								SX6->X6_CONTEUD := _numser
								msunlock()
								_numser := alltrim(GETMV("MV_ATBSPRF"))+_numser
								dbselectarea("AA3")
								reclock("AA3",.t.)
								AA3->AA3_FILIAL := xFilial()
								AA3->AA3_CODCLI := ADB->ADB_CODCLI
								AA3->AA3_LOJA   := ADB->ADB_LOJCLI
								AA3->AA3_CODPRO := SB1->B1_COD
								AA3->AA3_NUMSER := _numser
								AA3->AA3_DTVEND := ddatabase
								AA3->AA3_DTGAR  := ddatabase
								AA3->AA3_STATUS := "03"
								AA3->AA3_HORDIA := 8
								AA3->AA3_UNUCTR := ADB->ADB_NUMCTR //Numero do contrato que gerou a base de atendimento
								AA3->AA3_UITCTR := ADB->ADB_ITEM //Codigo do item do contrato que gerou a base de atendimento
								AA3->AA3_UIDAGA := ADB->ADB_UIDAGA
								msunlock()
								//d							endif
								
								_cItemCtr := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + ADB->ADB_CODPRO, "B1_UITCONT")
								_numAda := posicione("ADA",1,xFilial("ADA")+ADB->ADB_NUMCTR,"ADA->ADA_NUMCTR")
								conout("tmkvped add adados 4 "+SB1->B1_COD+" - "+_cItemCtr)
								IF (_cItemCtr = 'N')
									if _geraJunto
										aadd(aDados,{SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoDes,_cSerDes,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtInst,"1",_numAda,ADB->ADB_ITEM,"FINAL VIGENCIA",_naten})
									else
										_os := U_LIGTEC01(SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoDes,_cSerDes,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtInst,"1",_numAda,ADB->ADB_ITEM,"FINAL VIGENCIA",_naten)
									endif
								ELSE
									conout("tmkvped add adados 5 "+SB1->B1_GRUPO+" - "+_cItemCtr)
									IF SB1->B1_GRUPO == '0106' .OR. SB1->B1_GRUPO == '0107' .OR. SB1->B1_GRUPO == '0108'
										if _geraJunto
											aadd(aDados,{SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoDes,_cSerDes,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtPlug,"3",_numAda,ADB->ADB_ITEM,"FINAL VIGENCIA",_naten})
										else
											_os := U_LIGTEC01(SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoDes,_cSerDes,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtPlug,"3",_numAda,ADB->ADB_ITEM,"FINAL VIGENCIA",_naten)
										endif
									ELSE
										conout("tmkvped add adados 6 "+SB1->B1_COD+" - "+_cItemCtr)
										if _geraJunto
											aadd(aDados,{SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoDes,_cSerDes,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtAtiv,"3",_numAda,ADB->ADB_ITEM,"FINAL VIGENCIA",_naten})
										else
											_os := U_LIGTEC01(SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoDes,_cSerDes,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtAtiv,"3",_numAda,ADB->ADB_ITEM,"FINAL VIGENCIA",_naten)
										endif
									ENDIF
								ENDIF
								
							endif
						endif
					next
				endif
				
				U_LIGTMKA3(_cNumCtr)
			else
				if _lIncluiItem //aqui vai implementar a adicao de um novo item no contrato
					
					// 				 1               2               3                 4                 5                 6               7               8                 9             10						11					12					13
					//aadd(_aAltCtr,{ADA->ADA_NUMCTR,ADB->ADB_CODPRO,aCols[i,_nPosPro],aCols[i,_nPosQtd],aCols[i,_nPosVlr],ADA->ADA_CODCLI,ADA->ADA_LOJCLI,aCols[i,_nPosMsg],ADB->ADB_ITEM,aCols[i,_nPosIt],aCols[i,_nMesIn], aCols[i,_nMesCo],aCols[i,_nIdAga]})
					
					
					for j:=1 to len(_aAltCtr)
						//N�O PERMITIR SOLICITA��O SE CONTRATO JA TIVER LIBERADO EQUIPAMENTO
						_cNumCtr := _aAltCtr[j,1]
						U_LIGTMKA2(_aAltCtr[j,1])
						
						_TESCTR := ALLTRIM(GETMV("MV_UTESPF"))
						IF (SA1->A1_PESSOA = 'J')
							_TESCTR :=ALLTRIM(GETMV("MV_UTESCTR"))
						ENDIF
						//INICIO DA VIGENCIA
						dbselectarea("SB1")
						dbsetorder(1)
						if dbseek(xFilial()+_aAltCtr[j,3])
							dbselectarea("ADB")
							dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
							dbgotop()
							dbseek(xFilial()+_aAltCtr[j,1]+"ZZ",.T.)
							dbskip(-1)
							cItemNovo := SOMA1(ADB->ADB_ITEM)
							reclock("ADB",.t.)
							ADB->ADB_FILIAL := xFilial("SUB")
							ADB->ADB_NUMCTR := _aAltCtr[j,1]
							ADB->ADB_ITEM   := cItemNovo
							ADB->ADB_CODPRO := SB1->B1_COD
							ADB->ADB_DESPRO := SB1->B1_DESC
							ADB->ADB_UM     := SB1->B1_UM
							ADB->ADB_QUANT  := _aAltCtr[j,4]
							ADB->ADB_PRCVEN := _aAltCtr[j,5]
							ADB->ADB_TOTAL  := _aAltCtr[j,4]*_aAltCtr[j,5]
							ADB->ADB_UVLCHE := _aAltCtr[j,14]
							ADB->ADB_VALDES := _aAltCtr[j,15]
							ADB->ADB_DESC 	:= _aAltCtr[j,16]
							
							ADB->ADB_TES    := _TESCTR
							
							ADB->ADB_LOCAL  := SB1->B1_LOCPAD
							ADB->ADB_CODCLI := _aAltCtr[j,6]
							ADB->ADB_LOJCLI := _aAltCtr[j,7]
							ADB->ADB_UVEND1  := _VEND1
							ADB->ADB_UVEND2  := _VEND2
							ADB->ADB_UMSG    := _aAltCtr[j,8]
							ADB->ADB_UNUMAT	 := _naten
							ADB->ADB_UITATE	 := _aAltCtr[j,10]
							
							ADB->ADB_UMESIN	 := _aAltCtr[j,11]
							ADB->ADB_UMESCO	 := _aAltCtr[j,12]
							ADB->ADB_UIDAGA	 := _aAltCtr[j,13]
							msunlock()
							
							//vai come�ar a preparar as variaveis pra chamar a LIGTEC01
							_condi := ADA->ADA_CONDPG
							
							if empty(alltrim(_condi))
								_condi := ALLTRIM(GETMV("MV_UCONCTR"))
							endif
							
							dbselectarea("SX6")
							dbsetorder(1)
							dbseek("    "+"MV_ATBSSEQ")
							_numser := SOMA1(ALLTRIM(SX6->X6_CONTEUD))
							reclock("SX6",.f.)
							SX6->X6_CONTEUD := _numser
							msunlock()
							_numser := alltrim(GETMV("MV_ATBSPRF"))+_numser
							
							dbselectarea("AA3")
							reclock("AA3",.t.)
							AA3->AA3_FILIAL := xFilial()
							AA3->AA3_CODCLI := ADB->ADB_CODCLI
							AA3->AA3_LOJA   := ADB->ADB_LOJCLI
							AA3->AA3_NUMSER := _numser
							AA3->AA3_CODPRO := SB1->B1_COD
							AA3->AA3_DTVEND := ddatabase
							AA3->AA3_DTGAR  := ddatabase
							AA3->AA3_STATUS := "03"
							AA3->AA3_HORDIA := 8
							AA3->AA3_UNUCTR := ADB->ADB_NUMCTR //Numero do contrato que gerou a base de atendimento
							AA3->AA3_UITCTR := ADB->ADB_ITEM //Codigo do item do contrato que gerou a base de atendimento
							AA3->AA3_UIDAGA := _aAltCtr[j,13]
							msunlock()
							
							_cItemCtr := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + ADB->ADB_CODPRO, "B1_UITCONT")
							_numAda := posicione("ADA",1,xFilial("ADA")+ADB->ADB_NUMCTR,"ADA->ADA_NUMCTR")
							conout("tmkvped add adados 7 "+SB1->B1_COD+"..."+_cProEnd+" - "+_cItemCtr) 
							
							if(At(ALLTRIM(ADB->ADB_CODPRO),_cPrdLnkFl,1)>=1)//Se o codigo do produto de ADB est� em _cPrdLnkFl, fa�a o atendente ser o atendente da insta��o link full
								isLnkFull := .T.								
							endif
							
							IF (_cItemCtr = 'N')
								IF _cProEnd$ADB->ADB_CODPRO
									if _geraJunto
										aadd(aDados,{SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoEnd,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtInst,"8",_numAda,cItemNovo,"INICIO VIGENCIA",_naten})
									else
										_os := U_LIGTEC01(SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoEnd,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtInst,"8",_numAda,cItemNovo,"INICIO VIGENCIA",_naten)
									endif
								ELSE
									conout("tmkvped add adados 8 "+SB1->B1_COD+" - "+_cItemCtr)
									if _geraJunto
										aadd(aDados,{SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtInst,"1",_numAda,cItemNovo,"INICIO VIGENCIA",_naten})
									else
										_os := U_LIGTEC01(SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtInst,"1",_numAda,cItemNovo,"INICIO VIGENCIA",_naten)
									endif
								ENDIF
							ELSE
								conout("tmkvped add adados 9 "+SB1->B1_GRUPO+" - "+_cItemCtr)
								IF SB1->B1_GRUPO == '0106' .OR. SB1->B1_GRUPO == '0107' .OR. SB1->B1_GRUPO == '0108'
									if _gerajunto
										aadd(aDados,{SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtPlug,"3",_numAda,cItemNovo,"INICIO VIGENCIA",_naten})
									else
										_os := U_LIGTEC01(SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtPlug,"3",_numAda,cItemNovo,"INICIO VIGENCIA",_naten)
									endif
								ELSE
									conout("tmkvped add adados 10 "+SB1->B1_COD+" - "+_cItemCtr)
									if _geraJunto
										aadd(aDados,{SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtAtiv,"3",_numAda,cItemNovo,"INICIO VIGENCIA",_naten})
									else
										_os := U_LIGTEC01(SB1->B1_COD,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,_aAltCtr[j,4],_aAltCtr[j,5],_numser,ADB->ADB_UMSG,_cAtAtiv,"3",_numAda,cItemNovo,"INICIO VIGENCIA",_naten)
									endif
								ENDIF
							ENDIF
							
						endif
						
						U_LIGTMKA3(_cNumCtr)
						//INICIO DANIEL FINAL VIGENCIA
					next
					
				endif
			endif
			reclock("SUA",.F.)
				SUA->UA_UNUMCTR := _cNumCtr
			msunlock()
		ELSE
			CONOUT("ENTROU ELSE _AALTCTR")
		endif
	endif
	CONOUT("VAI VERIFICAR aDados")
	if len(aDados)>0
		CONOUT("ENTROU ADADOS>0 "+CVALTOCHAR(LEN(ADADOS)))
		//IMPLEMENTACAO DA REGRA DE ASSUNTO E CODIGO DE ATENDENTE
		lPlug := .T.
		lInst := .F.
		lMudE := .F.
		cAssunto := "3"
		for _i:=1 to len(aDados)
			dbselectarea("SB1")
			dbsetorder(1)
			if dbseek(xFilial()+aDados[_i,1])
				if !(SB1->B1_GRUPO $ "0106/0107/0108")
					lPlug := .F.
				endif
				if SB1->B1_UITCONT=="N"
					lInst := .T.
					if ALLTRIM(SB1->B1_COD)==ALLTRIM(_cProEnd)
						lMudE := .T.
						cAssunto := "8"
					elseif !lMudE
						cAssunto := "1"
					endif
				endif
			endif
		next
		
		if lPlug
			for _i:=1 to len(aDados)
				aDados[_i,11] := _cAtPlug
				aDados[_i,12] := cAssunto
			next
		elseif lInst
			for _i:=1 to len(aDados)
				aDados[_i,11] := _cAtInst
				aDados[_i,12] := cAssunto
			next
		else
			for _i:=1 to len(aDados)
				aDados[_i,11] := _cAtAtiv
				aDados[_i,12] := cAssunto
			next
		endif
		if(isLnkFull = .T.)
			for _i:=1 to len(aDados)
				aDados[_i,11] := _cAtAtend1					
			next  
		endif
		
		
		if lMudE
			u_TMKVPEDB()
			aItens := U_LIGTEC08(SUA->UA_CLIENTE, SUA->UA_LOJA, _ocorrenciaGeoGrids,_cNumCtr)                          				
			//Funcao que monta o cabecalho(AB6) da O.S e usa TECA450 para gerar chamados
			//1	Cliente		2 Loja 		  3	Cond Pgto		4 msg	5 itens, 6 ATENDE, 7 ASSUNTO, 8 CTR
			_os := U_LIGTEC07(SUA->UA_CLIENTE, SUA->UA_LOJA, SUA->UA_CONDPG,"TRANSFERENCIA DE ENDERECO GEOGRIDS",aItens,_atendenteGeoGrids,"2",_cNumCtr)	
		endif
		
		CONOUT("VAI CHAMAR A LIGTEC1A")
		_os := U_LIGTEC1A(aDados)
		IF !EMPTY(_os)
			cQuery := " UPDATE "+RetSqlName("SZ2")+" "
			cQuery += " SET Z2_NUMOS='"+_os+"' WHERE Z2_NUMOS='"+_novaOS+"'
			TCSQLEXEC(cQuery)
		ENDIF
		
		if(isLnkFull = .T.) 
			IF !EMPTY(_os) 
				U_TEC02F(_os)
			ENDIF
		endif	
	ELSE
		CONOUT("NAO ACHOU ADADOS "+CVALTOCHAR(LEN(ADADOS)))
	endif
	
	restarea(_area)
return .t.


