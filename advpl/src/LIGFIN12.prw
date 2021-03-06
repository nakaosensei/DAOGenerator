#Include 'Protheus.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "FWPrintSetup.ch"
#include "ap5mail.ch"
#INCLUDE "RPTDEF.CH"        

/*
LIGFIN12 - IMPRESS�O DE BOLETO CAIXA
DATA     - 14/07/16
CLIENTE  - LIGUE TELECOM
*/


User Function LIGFIN12(data, envMail, nCod, nCliente)
	Private _CPERG := "LIGFIN04"
	Private dData
	
	dData := data
	//Verificar a data
	IF EMPTY(dData)
		dData:=DDATABASE
	ENDIF
	
IF ALLTRIM(FUNNAME())<>"FINA040" .AND. ALLTRIM(FUNNAME())<> "TMKA271" .AND. ALLTRIM(FUNNAME())<> "TECA300"
	VALIDPERG()
	IF !PERGUNTE(_CPERG)
		RETURN
	ENDIF    
	
	_CNUMINI  	:= MV_PAR01
	_CNUMFIM  	:= MV_PAR02
	_CPREFIXO	:= MV_PAR03
	_CTIPO  	:= MV_PAR04
	_CPARCINI  	:= MV_PAR05
	_CPARCFIM  	:= MV_PAR06
	
	_dadosbanco := alltrim(getmv("MV_UBCOCXA"))
endif	 

	dbSelectArea("SE1")
	dbSetOrder(1)
	if dbSeek(xFilial("SE1")+_CPREFIXO+_CNUMINI)
		while !eof() .And. SE1->E1_FILIAL == xFilial("SE1") .And. SE1->E1_PREFIXO == _CPREFIXO .and. SE1->E1_NUM <= _CNUMFIM .AND. SE1->E1_NUM>=_CNUMINI
			
			if _CPARCINI<=SE1->E1_PARCELA .AND. _CPARCFIM>=SE1->E1_PARCELA
				IF SE1->E1_TIPO <> _CTIPO // SAI SE TIPO DIFERENTE
					dbSelectArea("SE1")
					DbSkip()
					loop
				Endif
				IF SE1->E1_SALDO == 0 .OR. SE1->E1_TIPO $ 'RA /NCC'
					dbSelectArea("SE1")
					DbSkip()
					loop
				Endif
				dbselectarea("SA1")
				dbsetorder(1)
				if dbseek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
					
					_banco      := substr(_dadosbanco,1,3)
					_agencia    := substr(_dadosbanco,4,5)
					_conta      := substr(_dadosbanco,9,10)
					_subconta   := substr(_dadosbanco,19,3)
					dbselectarea("SA6")
					dbsetorder(1)//A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
					if dbseek(xFilial()+_banco+_agencia+_conta)
						dbselectarea("SEE")
						dbsetorder(1)
						if dbseek(xFilial()+_banco+_agencia+_conta+_subconta)
							LIGFIN12(envMail, nCod, nCliente)
						ENDIF //IF DO SEE
					ENDIF//IF DO SA6
				endif //IF DO SA1
			endif
			dbselectarea("SE1")
			dbskip()
		enddo
	endif

return

static function LIGFIN12(envMail, nCod, nNome )
//                                      TAM   BOLD        SUB   ITA
//                           1         2 3    4   5 6 7 8 9 10  11
	Local oFont9  := TFont():New("Arial", ,9 , ,.F., , , , , ,.F.,.F.)
	Local oFont9b := TFont():New("Arial", ,9 , ,.T., , , , , ,.F.,.F.)
	Local oFont10 := TFont():New("Arial", ,10, ,.F., , , , , ,.F.,.F.)
	Local oFont10b:= TFont():New("Arial", ,10, ,.T., , , , , ,.F.,.F.)
	Local oFont11 := TFont():New("Arial", ,11, ,.F., , , , , ,.F.,.F.)
	Local oFont11b:= TFont():New("Arial", ,11, ,.T., , , , , ,.F.,.F.)
	Local oFont12 := TFont():New("Arial", ,12, ,.F., , , , , ,.F.,.F.)
	Local oFont12b:= TFont():New("Arial", ,12, ,.T., , , , , ,.F.,.F.)
	Local oFont14 := TFont():New("Arial", ,14, ,.F., , , , , ,.F.,.F.)
	Local oFont14b:= TFont():New("Arial", ,14, ,.T., , , , , ,.F.,.F.)
	
	
	_caminho := gettemppath()
		
	_nome := "BOL"+ALLTRIM(SE1->E1_NUM)+STRTRAN(TIME(),":","")
	oPrint:= FWMSPrinter():New(_nome,6,.t.,_caminho,.T.,,,,,,,)
	oPrint:SetPortrait()	// ou SetLandscape()
	oPrint:SetMargin(1,1,1,1)
	oPrint:cPathPDF := _caminho
		
	_dVencto := IIF(SE1->E1_VENCTO>dData, SE1->E1_VENCTO, dData)
	
	if SEE->EE_UFATORV=="S"
		_cFatorVcto := Str((_dVencto - Ctod("07/10/1997")),4)
	else
		_cFatorVcto := "0000"
	endif
	
	_nValorTit  := SE1->E1_SALDO + SE1->E1_ACRESC
	IF ddatabase>SE1->E1_VENCREA
		_nValorTit += NOROUND(SE1->E1_SALDO*(2/100),2) //2% DE MULTA
		_nValorTit += ROUND(SE1->E1_SALDO*(ddatabase-SE1->E1_VENCREA)*SE1->E1_PORCJUR/100,2) //JUROS 1% AO DIA
	ENDIF
	if EMPTY(SE1->E1_NUMBCO)
		dbselectarea("SEE")
		dbsetorder(1)	
		if dbseek(xFilial()+_banco+_agencia+_conta+_subconta)
			cNossoNum := StrZero(Val(SEE->EE_FAXATU)+1,15,0)
			RecLock("SEE",.F.)
				SEE->EE_FAXATU := StrZero(Val(SEE->EE_FAXATU)+1,12,0)
			MsUnlock()	
		ELSE
			MSGINFO("N�o foi possivel gerar o numero do boleto")		
			RETURN	
		ENDIF //IF DO SEE
	else
		cNossoNum := SUBSTR(SE1->E1_NUMBCO,3,15)
	endif
	_auxValor :=_nValorTit*100
	
	// composi��o campo livre HSBC
	// 20 a 30 - 11 - nosso numero sem dv
	// 31 a 34 - 04 - C�digo da Agencia
	// 35 a 41 - 07 - Agencia cedente (sem dv, crompletar com zeros a esquerda se necess�rio)
	// 42 a 43 - 02 - Carteira
	// 44 a 44 - 01 - C�digo do aplicativo da Cobran�a(COB) = "1" 
	cNossoNum := ALLTRIM(SEE->EE_CODCART)+"4"+right(cNossoNum,15)
	
	cDgV      := NNDgV(cNossoNum) // DIGITO EM MODULO 11
	 
	_cCodBar  := SA6->A6_COD+'9'+_cFatorVcto+STRZERO(_auxValor,10) //Padr�o em Todos os Bancos
	
	//_cCampoLivre  := STRZERO(val(ALLTRIM(SA6->A6_NUMCON) + ALLTRIM(SA6->A6_DVCTA)),7)
	_cCampoLivre  := ALLTRIM(SEE->EE_CODEMP)
	_cCampoLivre  += SUBSTR(cNossoNum,3,3)
	_cCampoLivre  += SUBSTR(cNossoNum,1,1)
	_cCampoLivre  += SUBSTR(cNossoNum,6,3)
	_cCampoLivre  += SUBSTR(cNossoNum,2,1)
	_cCampoLivre  += SUBSTR(cNossoNum,9,9)
	
	_cCodBar += _cCampoLivre + NNDgVCampoLivre(_cCampoLivre)
	
	//_cCodBar  += cNossoNum+cDgV
	//_cCodBar  += STRZERO(val(ALLTRIM(SA6->A6_AGENCIA)),4)
	//_cCodBar  += "00"//SUBSTR(ALLTRIM(SEE->EE_CODCART),2,2)
	//_cCodBar  += '1'
	
	//_cCodBar := "3999100100000311551111122222500546666666001"
	//_cCodBar := "1079324200000321120055077222133347777777771"
	
	_cCodBar  := SUBSTR(_cCodBar,1,4) + BarraDgV(_cCodBar) + SUBSTR(_cCodBar,5,44)
	_cLinhaD  := montalinha(_cCodBar)	
	         
	_numbco := cNossoNum + cDgV
	RecLock("SE1",.F.)
	SE1->E1_NUMBCO  := _numbco
	SE1->E1_UCODBAR := _cCodBar
	SE1->E1_ULINDIG := _cLinhaD
	SE1->E1_PORTADO := SA6->A6_COD
	SE1->E1_AGEDEP  := SA6->A6_AGENCIA
	SE1->E1_CONTA   := SA6->A6_NUMCON
	SE1->E1_IDCNAB  := right(_numbco,9)
	msunlock()
	
	aBolText := {"","","","","",""}
	_n := 1
	if SE1->E1_VALJUR>0
		aBolText[_n] := "MORA DIA/COM. PERMANENC ....... "+cvaltochar(SE1->E1_VALJUR)
		_n++
	endif
	if !empty(SEE->EE_UMSG1)
		aBolText[_n] := alltrim(SEE->EE_UMSG1)
		_n++
	endif
	if !empty(SEE->EE_UMSG2)
		aBolText[_n] := alltrim(SEE->EE_UMSG2)
		_n++
	endif
	
	aDadosTit := {}
	aadd(aDadosTit,AllTrim(SE1->E1_NUM)+"-"+AllTrim(SE1->E1_PARCELA))					// [1] N�mero do t�tulo
	aadd(aDadosTit,ConvDT4(SE1->E1_EMISSAO)) 											// [2] Data da emiss�o do t�tulo
	aadd(aDadosTit,ConvDT4(DDATABASE))				  									// [3] Data da emiss�o do boleto
	aadd(aDadosTit,ConvDT4(_dVencto))		// [4] Data do vencimento
	aadd(aDadosTit,_nValorTit)															// [5] Valor do t�tulo
	aadd(aDadosTit,alltrim(SE1->E1_NUMBCO)) 											// [6] Nosso n�mero
	aadd(aDadosTit,SE1->E1_PREFIXO)														// [7] Prefixo
	aadd(aDadosTit,SE1->E1_TIPO)
	
	//cLogoBco := "bradesco.bmp"
	cLogoBco := SEE->EE_ULOGO
	oPrint:StartPage()
	
	nRow2 := -400
	oPrint:line(nRow2+0710,100,nRow2+0710,2300)
	oPrint:line(nRow2+0710,500,nRow2+0630, 500)
	oPrint:line(nRow2+0710,710,nRow2+0630, 710)
	
	//oPrint:SayBitmap(nRow2+0595,0100,cLogoBco,0338,0113)
	oPrint:SayBitmap(nRow2+0595,0100,cLogoBco,0338,0113)
	
	oPrint:say(nRow2+0660,513,SA6->A6_COD+"-"+SA6->A6_UDGCOD,oFont14b )	// [1]Numero do Banco
	oPrint:say(nRow2+0644,1800,"Recibo do Pagador",oFont10)
	
	oPrint:line(nRow2+0810,100,nRow2+0810,2300 )
	oPrint:line(nRow2+0910,100,nRow2+0910,2300 )
	oPrint:line(nRow2+0980,100,nRow2+0980,2300 )
	oPrint:line(nRow2+1050,100,nRow2+1050,2300 )
	
	oPrint:line(nRow2+0980,340,nRow2+1050,340)
	oPrint:line(nRow2+0910,500,nRow2+1050,500)
	oPrint:line(nRow2+0980,750,nRow2+1050,750)
	oPrint:line(nRow2+0910,1000,nRow2+1050,1000)
	oPrint:line(nRow2+0910,1300,nRow2+0980,1300)
	oPrint:line(nRow2+0910,1480,nRow2+1050,1480)
	
	oPrint:say(nRow2+0730,100 ,"Local de Pagamento",oFont9)
	oPrint:say(nRow2+0780,350 ,SEE->EE_UMSG3,oFont10)
		
	oPrint:say(nRow2+0730,1810,"Vencimento"                                     ,oFont9)
	
	cString	:= aDadosTit[4]
	nCol := 1810+(374-(len(cString)*22))
	oPrint:say(nRow2+0780,nCol,cString,oFont10)
	
	oPrint:say(nRow2+0830,100 ,"benefici�rio"                                        ,oFont9)
	oPrint:say(nRow2+0880,100 ,"LIGUE TELECOMUNICA��ES LTDA - CNPJ 10.442.435/0001-40",oFont10) //Nome + CNPJ
	
	oPrint:say(nRow2+0830,1810,"Ag�ncia/C�digo benefici�rio",oFont9)
	cString := STRZERO(VAL(Alltrim(SEE->EE_AGENCIA)),4)+" / "+ substr(ALLTRIM(SEE->EE_CODEMP),1,6)  + "-" + substr(ALLTRIM(SEE->EE_CODEMP),7,1)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:say(nRow2+0880,nCol,cString,oFont10)
	
	oPrint:say(nRow2+0930,100 ,"Data do Documento"                              ,oFont9)
	oPrint:say(nRow2+0960,100, aDadosTit[2],oFont10)
	
	oPrint:say(nRow2+0930,505 ,"Nro.Documento"                                  ,oFont9)
	oPrint:say(nRow2+0960,605 ,aDadosTit[7]+"-"+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
	
	oPrint:say(nRow2+0930,1005,"Esp�cie Doc."                                   ,oFont9)
	oPrint:say(nRow2+0960,1050,"DS"									,oFont10) //Tipo do Titulo
	
	oPrint:say(nRow2+0930,1305,"Aceite"                                         ,oFont9)
	oPrint:say(nRow2+0960,1400,"N"                                             ,oFont10)
	
	oPrint:say(nRow2+0930,1485,"Data Processamento"                          ,oFont9)
	oPrint:say(nRow2+0960,1550,aDadosTit[3],oFont10) // Data impressao
	
	oPrint:say(nRow2+0930,1810,"Nosso N�mero"                                   ,oFont9)
	cString := Alltrim(aDadosTit[6])
	oPrint:say(nRow2+0960,nCol,substr(cString,1,2)+"/"+substr(cString,3,15)+"-"+ substr(cString,18,1),oFont10)
	                          
	oPrint:say(nRow2+1000,100 ,"Uso do Banco"                                   ,oFont9)
	
	oPrint:say(nRow2+1000,350 ,"" 		                                    ,oFont9)
	
	oPrint:say(nRow2+1000,505 ,"Carteira"                                       ,oFont9)
	oPrint:say(nRow2+1040,555 ,"RG"  						                        ,oFont10)
	
	oPrint:say(nRow2+1000,755 ,"Esp�cie Moeda"                                  ,oFont9)
	oPrint:say(nRow2+1040,805 ,"R$"                                             ,oFont10)
	
	oPrint:say(nRow2+1000,1005,"Quantidade"                                     ,oFont9)
	oPrint:say(nRow2+1000,1485,"Valor"                                          ,oFont9)
	
	oPrint:say(nRow2+1000,1810,"Valor do Documento"                          	,oFont9)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol := 1810+(374-(len(cString)*22))
	oPrint:say(nRow2+1040,nCol,cString ,oFont10)
	
	oPrint:say(nRow2+1080,100 ,"Instru��es (Texto de responsabilidade do benefici�rio)",oFont9)
	oPrint:say(nRow2+1130,100 ,(aBolText[1]),oFont10)
	oPrint:say(nRow2+1175,100 ,(aBolText[2]),oFont10)
	oPrint:say(nRow2+1220,100 ,(aBolText[3]),oFont10)
	oPrint:say(nRow2+1265,100 ,(aBolText[4]),oFont10)
	oPrint:say(nRow2+1310,100 ,(aBolText[5]),oFont10)
	oPrint:say(nRow2+1355,100 ,(aBolText[6]),oFont10)
	
	oPrint:say(nRow2+1070,1810,"(-)Desconto/Abatimento"                         ,oFont9)
	oPrint:say(nRow2+1150,1810,"(-)Outras Dedu��es"                             ,oFont9)
	oPrint:say(nRow2+1220,1810,"(+)Mora/Multa"                                  ,oFont9)
	oPrint:say(nRow2+1290,1810,"(+)Outros Acr�scimos"                           ,oFont9)
	oPrint:say(nRow2+1360,1810,"(=)Valor Cobrado"                               ,oFont9)
	
	oPrint:say(nRow2+1380,100 ,"Pagador"                                         ,oFont9)
	oPrint:say(nRow2+1430,400 ,AllTrim(SA1->A1_NOME)+" ("+AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA+")",oFont10)
	oPrint:say(nRow2+1483,400 ,AllTrim(SA1->A1_END)+" -"+AllTrim(SA1->A1_BAIRRO)                               ,oFont10)
	oPrint:say(nRow2+1536,400 ,SA1->A1_CEP+"    "+SA1->A1_MUN+" - "+SA1->A1_EST,oFont10) // CEP+Cidade+Estado
	
	if SA1->A1_PESSOA = "J"
		oPrint:say(nRow2+1589,400 ,"CNPJ: "+TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont10)
	else
		oPrint:say(nRow2+1589,400 ,"CPF: "+TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99"),oFont10)
	endif
	
	oPrint:say(nRow2+1635,100 ,"Sacador/Avalista",oFont9)
	oPrint:say(nRow2+1675,1500,"Autentica��o Mec�nica",oFont9)
	
	oPrint:say(nRow2+1675,100 ,"Recebimento do Cheque No.",oFont9)
	oPrint:say(nRow2+1715,100 ,"Do Banco:",oFont9)
	oPrint:say(nRow2+1755,100 ,"Esta quita��o s� ter� validade ap�s o pagamento do cheque pelo banco sacado",oFont9)
	
	oPrint:line(nRow2+0710,1800,nRow2+1400,1800 )
	oPrint:line(nRow2+1120,1800,nRow2+1120,2300 )
	oPrint:line(nRow2+1190,1800,nRow2+1190,2300 )
	oPrint:line(nRow2+1260,1800,nRow2+1260,2300 )
	oPrint:line(nRow2+1330,1800,nRow2+1330,2300 )
	oPrint:line(nRow2+1400,100 ,nRow2+1400,2300 )
	oPrint:line(nRow2+1640,100 ,nRow2+1640,2300 )
	

	nRow3 := -380 //-180
	oPrint:line(nRow3+2000,100,nRow3+2000,2300)
	oPrint:line(nRow3+2000,500,nRow3+1920, 500)
	oPrint:line(nRow3+2000,710,nRow3+1920, 710)
	
	oPrint:SayBitmap(nRow3+1935,0100,cLogoBco,188,63)

	oPrint:say(nRow3+1975,513,SA6->A6_COD+"-"+SA6->A6_UDGCOD,oFont14b )	// 	[1]Numero do Banco
	oPrint:say(nRow3+1975,755,ALLTRIM(SE1->E1_ULINDIG),oFont14b)			//	Linha Digitavel do Codigo de Barras
	                                                                                                       
	oPrint:line(nRow3+2060,100,nRow3+2060,2300 )
	oPrint:line(nRow3+2120,100,nRow3+2120,2300 )
	oPrint:line(nRow3+2180,100,nRow3+2180,2300 )
	oPrint:line(nRow3+2240,100,nRow3+2240,2300 )
	
	oPrint:line(nRow3+2120,500 ,nRow3+2240,500 )
	oPrint:line(nRow3+2180,750 ,nRow3+2240,750 )
	oPrint:line(nRow3+2180,1000,nRow3+2240,1000)
	oPrint:line(nRow3+2120,1300,nRow3+2180,1300)
	oPrint:line(nRow3+2120,1480,nRow3+2240,1480)
	
	oPrint:say(nRow3+2030,100 ,"Local de Pagamento",oFont9)
	oPrint:say(nRow3+2050,300 ,SEE->EE_UMSG3,oFont10)
	
	oPrint:say(nRow3+2030,1810,"Vencimento",oFont9)
	cString := aDadosTit[4]
	nCol	:= 1810+(374-(len(cString)*22))
	oPrint:say(nRow3+2050,nCol,cString,oFont11)
	
	oPrint:say(nRow3+2080,100 ,"benefici�rio",oFont9)
	oPrint:say(nRow3+2105,300 ,"LIGUE TELECOMUNICA��ES LTDA - CPNJ 10.442.435/0001-40",oFont10) //Nome + CNPJ
	
	oPrint:say(nRow3+2080,1810,"Ag�ncia/C�digo benefici�rio",oFont9)
	//cString := STRZERO(VAL(Alltrim(SEE->EE_AGENCIA)),4)+" "+STRZERO(val(ALLTRIM(SA6->A6_NUMCON) + ALLTRIM(SA6->A6_DVCTA)),7)
	cString := STRZERO(VAL(Alltrim(SEE->EE_AGENCIA)),4)+" / "+ substr(ALLTRIM(SEE->EE_CODEMP),1,6)  + "-" + substr(ALLTRIM(SEE->EE_CODEMP),7,1)
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:say(nRow3+2105,nCol,cString ,oFont11)
	
	
	oPrint:say(nRow3+2140,100 ,"Data do Documento",oFont9)
	oPrint:say(nRow3+2165,100, aDadosTit[2], oFont10)
	
	oPrint:say(nRow3+2140,505 ,"Nro.Documento",oFont9)
	oPrint:say(nRow3+2165,605 ,aDadosTit[7]+"-"+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
	
	oPrint:say(nRow3+2140,1005,"Esp�cie Doc.",oFont9)
	oPrint:say(nRow3+2165,1050,"DS",oFont10) //Tipo do Titulo
	
	oPrint:say(nRow3+2140,1305,"Aceite",oFont9)
	oPrint:say(nRow3+2165,1400,"N",oFont10)
	
	oPrint:say(nRow3+2140,1485,"Data do Processamento",oFont9)
	oPrint:say(nRow3+2165,1550,aDadosTit[3],oFont10) // Data impressao	
	
	oPrint:say(nRow3+2140,1810,"Nosso N�mero",oFont9)
	cString := Alltrim(aDadosTit[6])
	oPrint:say(nRow3+2165,nCol,substr(cString,1,2)+"/"+substr(cString,3,15)+"-"+substr(cString,18,1),oFont10)
	
	oPrint:say(nRow3+2200,100 ,"Uso do Banco"                                   ,oFont9)

	oPrint:say(nRow3+2200,505 ,"Carteira"                                       ,oFont9)
	oPrint:say(nRow3+2225,555 ,"RG"						                        ,oFont10)
	
	oPrint:say(nRow3+2200,755 ,"Esp�cie"                                        ,oFont9)
	oPrint:say(nRow3+2225,805 ,"R$"                                             ,oFont10)
	
	oPrint:say(nRow3+2200,1005,"Quantidade"                                     ,oFont9)
	
	oPrint:say(nRow3+2200,1485,"Valor"                                          ,oFont9)
	
	oPrint:say(nRow3+2200,1810,"Valor do Documento"                          	,oFont9)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:say(nRow3+2225,nCol,cString,oFont11)
	
	
	oPrint:say(nRow3+2260,100 ,"Instru��es (Texto de responsabilidade do benefici�rio)",oFont9)
	oPrint:say(nRow3+2320,100 ,(aBolText[1]),oFont9)
	oPrint:say(nRow3+2380,100 ,(aBolText[2]),oFont9)
	oPrint:say(nRow3+2440,100 ,(aBolText[3]),oFont9)
	oPrint:say(nRow3+2500,100 ,(aBolText[4]),oFont9)
	oPrint:say(nRow3+2560,100 ,(aBolText[5]),oFont9)
	
	oPrint:say(nRow3+2260,1810,"(-)Desconto/Abatimento"                         ,oFont9)
	oPrint:say(nRow3+2320,1810,"(-)Outras Dedu��es"                             ,oFont9)
	oPrint:say(nRow3+2380,1810,"(+)Mora/Multa"                                  ,oFont9)
	oPrint:say(nRow3+2440,1810,"(+)Outros Acr�scimos"                           ,oFont9)
	oPrint:say(nRow3+2500,1810,"(=)Valor Cobrado"                               ,oFont9)
	
	oPrint:say(nRow3+2560,100 ,"Pagador"                                         ,oFont9)
	oPrint:say(nRow3+2580,400 ,AllTrim(SA1->A1_NOME)+" ("+AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA+")"             ,oFont10)
	
	if SA1->A1_PESSOA = "J"
		oPrint:say(nRow3+2580,1750,"CNPJ: "+TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:say(nRow3+2580,1750,"CPF: "+TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf
	
	oPrint:say(nRow3+2630,400 ,AllTrim(SA1->A1_END)+" -"+AllTrim(SA1->A1_BAIRRO)     ,oFont10)
	oPrint:say(nRow3+2680,400 ,SA1->A1_CEP+"    "+SA1->A1_MUN+" - "+SA1->A1_EST,oFont10) // CEP+Cidade+Estado
	//oPrint:Say(nRow3+2836,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)
	
	oPrint:say(nRow3+2720,100 ,"Sacador/Avalista"                               ,oFont9)
	oPrint:say(nRow3+2720,1500,"Autentica��o Mec�nica - Ficha de Compensa��o"                        ,oFont9)
	
	oPrint:line(nRow3+2000,1800,nRow3+2540,1800 )
	oPrint:line(nRow3+2300,1800,nRow3+2300,2300 )
	oPrint:line(nRow3+2360,1800,nRow3+2360,2300 )
	oPrint:line(nRow3+2420,1800,nRow3+2420,2300 )
	oPrint:line(nRow3+2480,1800,nRow3+2480,2300 )
	oPrint:line(nRow3+2540,100 ,nRow3+2540,2300 )
	
	oPrint:line(nRow3+2700,100,nRow3+2700,2300  )
	
	//oPrint:Code128c(nRow3+2950, 100, SE1->E1_UCODBAR, 50)
	oPrint:FWMSBAR("INT25" /*cTypeBar*/,54 ,3,SE1->E1_UCODBAR/*cCode*/,oPrint/*oPrint*/,.F./*lCheck*/,/*Color*/,.T./*lHorz*/,0.017/*nWidth*/,1.3/*nHeigth*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,.F./*lCmtr2Pix*/)
	
	//MSBAR3("CODE128", nRow3+2950, 100 ,"12345678901" ,oPrint,NIL,NIL,NIL,NIL,NIL,NIL,NIL,"A")
	//oPrint:FWMsBar("INT25" /*cTypeBar*/,nRow3+2950 ,100 ,SE1->E1_UCODBAR  /*cCode*/,oPrint/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/, /*nWidth*/,/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)
	
	oPrint:EndPage()
	oPrint:Print()
	
	/*
	Verifica se pode enviar email
	*/
	IF envMail
		u_LIGFIN15(nCod, nNome, _nome, _caminho)
	ENDIF
return
	
Static Function ValidPerg
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i:= 0
	Local j:= 0

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(_CPERG,10)
//          Grupo/Ordem/Pergunta/                                           Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Numero de                    ?","?","?","mv_ch1","C",09,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Numero ate                   ?","?","?","mv_ch2","C",09,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Prefixo                      ?","?","?","mv_ch3","C",03,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Tipo                         ?","?","?","mv_ch4","C",03,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Parcela de                   ?","?","?","mv_ch5","C",03,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Parcela ate                  ?","?","?","mv_ch6","C",03,0,0,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)
Return

static function NNDgV(_cNNum)

	_nDgV := ''
	nCont   := 0
	nPeso   := 2
	cBoleta := _cNNum
	_nDgV   := ''
	
	For i := 17 To 1 Step -1
		nCont := nCont + (Val(SUBSTR(cBoleta,i,1))) * nPeso
		nPeso += 1
		If nPeso == 10
			nPeso := 2
		Endif
	Next
	nResto  := (nCont % 11 )
	nResult := (11 - nResto)
	Do Case
	Case nResult == 10 .or. nResult == 11
		_nDgV := "0"
	OtherWise
		_nDgV := Str(nResult,1)
	EndCase
	
Return(_nDgV)


static function NNDgVCampoLivre(_cNNum)

	_nDgV := ''
	nCont   := 0
	nPeso   := 2
	cBoleta := _cNNum
	_nDgV   := ''
	
	For i := 24 To 1 Step -1
		nCont := nCont + (Val(SUBSTR(cBoleta,i,1))) * nPeso
		nPeso += 1
		If nPeso == 10
			nPeso := 2
		Endif
	Next

	nResto  := (nCont % 11 )
	nResult := (11 - nResto)
	Do Case
	Case nResult == 10 .or. nResult == 11
		_nDgV := "0"
	OtherWise
		_nDgV := Str(nResult,1)
	EndCase
Return(_nDgV)



//Calculo do Digito do Codigo de Barras
Static Function BarraDgV(_cCodB)
	cDV_BARRA := ''

	nCont := 0
	nPeso := 2
	For i := 43 To 1 Step -1
		nCont := nCont + (Val(SUBSTR(_cCodB,i,1)) * nPeso )
		nPeso := nPeso + 1
		If nPeso == 10
			nPeso := 2
		Endif
	Next
	nResto  := (nCont % 11 )
	nResult := (11 - nResto)
	Do Case
	Case nResult == 10 .or. nResult == 11
		cDV_BARRA := "1"
	OtherWise
		cDV_BARRA := Str(nResult,1)
	EndCase

Return(cDV_BARRA)

Static Function MontaLinha(_cCodB)
	_cLineDig   := ""
	_cPedaco    := ""

//Primeiro Campo
//Codigo do Banco + Moeda + 5 primeiras posi��es do campo livre do Cod Barras
	_cPedaco := Substr(_cCodB,01,03) + Substr(_cCodB,04,01) + Substr(_cCodB,20,5)
	_cLineDig := Substr(_cCodB,1,3)+Substr(_cCodB,4,1)+Substr(_cCodB,20,1)+"."+;
		Substr(_cCodB,21,4) + dvMod10(_cPedaco) + Space(2)

//Segundo Campo
	_cPedaco  := Substr(_cCodB,25,10)
	_cLineDig += Substr(_cPedaco,1,5)+"."+Substr(_cPedaco,6,5)+;
		dvMod10(_cPedaco) + Space(2)

//Terceiro Campo
	_cPedaco  := Substr(_cCodB,35,10)
	_cLineDig += + Substr(_cPedaco,1,5)+"."+Substr(_cPedaco,6,5)+;
		dvMod10(_cPedaco) + Space(2)

//Quarto Campo
	_cLineDig += Substr(_cCodB,05,01) + Space(2)

//Quinto Campo
	_cLineDig  += Substr(_cCodB,06,04) + Substr(_cCodB,10,10)

Return(_cLineDig)

static function dvMod10(_cdata)

	LOCAL L,D,P := 0
	LOCAL B     := .F.

	L := Len(_cdata)
	B := .T.
	D := 0
	While L > 0
		P := Val(SubStr(_cdata, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End

Return(STRZERO(D,1,0))

Static Function ConvDT4(_cDT)

	_cDT := DTOS(_cDT)

Return(substr(_cDT,7,2)+'/'+substr(_cDT,5,2)+'/'+substr(_cDT,1,4))
