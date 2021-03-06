#Include 'Protheus.ch'

//RELATORIO DE INSTALA��ES VS ATIVA��ES DE FATURAMENTO
User Function LIGTEC15()
	Local oReport := nil
	Local cPerg:= Padr("TEC15A",10)

	/*//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	*/
	//gero a pergunta de modo oculto, ficando dispon�vel no bot�o a��es relacionadas
	Pergunte(cPerg,.F.) 
	
	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction

	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Relat�rio NCM x Cadastro Produtos",cNome,{|oReport| ReportPrint(oReport)},"Descri��o do meu relat�rio")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	//Monstando a primeira se��o
	//Neste exemplo, a primeira se��o ser� composta por duas colunas, c�digo da NCM e sua descri��o
	//Iremos disponibilizar para esta se��o apenas a tabela SYD, pois quando voc� for em personalizar
	//e entrar na primeira se��o, voc� ter� todos os outros campos dispon�veis, com isso, ser�
	//permitido a inser��o dos outros campos
	//Neste exemplo, tamb�m, j� deixarei definido o nome dos campos, mascara e tamanho, mas voc�
	//ter� toda a liberdade de modific�-los via relatorio. 
	oSection1:= TRSection():New(oReport, "Ordem de Servi�o", {"AB6"}, , .F., .T.)
	TRCell():New(oSection1,"ADA_NUMCTR" 	,"ADA","CONTRATO"  		,"@!",20)
	TRCell():New(oSection1,"AB6_NUMOS"  	,"AB6","ORDEM DE SERVI�O"	,"@!",20)
	TRCell():New(oSection1,"AA1_NOMTEC" 	,"AA1","ATENDENTE "	,"@!",50)
	TRCell():New(oSection1,"AB9_DTCHEG" 	,"AB9","DT INICIO"	,"@E",20)
	TRCell():New(oSection1,"AB9_DTSAID"  	,"AB6","DT FIM"	,"@E",20)
	TRCell():New(oSection1,"AB9_TOTFAT"  	,"AB6","HR FAT"	,"@E",10)
	TRCell():New(oSection1,"AB6_UDTVIG"  	,"AB6","DT VIG"	,"@E",20)
	TRCell():New(oSection1,"A1_NOME"  		,"SA1","CLIENTE"	,"@!",50)
	TRCell():New(oSection1,"A1_CGC"  		,"SA1","CPF/CNPJ"	,"@!",20)
	TRCell():New(oSection1,"A1_TEL"  		,"SA1","TELEFONE"	,"@!",20)
	TRCell():New(oSection1,"A1_END"  		,"SA1","ENDERE�O"	,"@!",50)
	TRCell():New(oSection1,"A1_MUN"  		,"SA1","CIDADE"	,"@!",30)
	TRCell():New(oSection1,"AB9_CODPRB"  	,"AB9","COD. AGG"	,"@!",20)
	TRCell():New(oSection1,"AAG_DESCRI"  	,"AAG","OCORRENCIA"	,"@!",50)
	
	//TRFunction():New(oSection1:Cell("AA1_NOMTEC"),NIL,"COUNT",,,,,.F.,.T.)
	
	//A segunda se��o, ser� apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb�m a tabela de NCM, com isso, voc� poderia incluir os campos da tabela
	//SYD.Semelhante a se��o 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Atendentes", {"AA1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"AA1_NOMTEC"   	,"AA1","ATENDENTE"		,"@!",200)
	TRCell():New(oSection2,"AA1_TOTAL"   	,"AA1","TOTAL"		,"@!",200)

	//TRFunction():New(oSection2:Cell("B1_COD"),NIL,"COUNT",,,,,.F.,.T.)
	
	oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por se��o
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cNcm      := ""   
	Local lPrim 	:= .T.	 
	LOCAL _NTOTALFAT := 0 
	Local _cPgtOco := getmv("MV_UPGTOCO")
	    
	_AITENS  := {}
	_AITENS2 := {}
	_DDTINI  := MV_PAR01
	_DDTFIM  := MV_PAR02
	_CATINI  := MV_PAR03
	_CATFIM  := MV_PAR04   
	
	DBSELECTAREA("ADA")
	DBGoTop()
	while !eof()					
			IF (ADA->ADA_MSBLQL!="1" .OR. (ADA->ADA_MSBLQL=="1" .AND. ADA->ADA_UDTFEC<=ADA->ADA_UDTBLQ)) .AND. EMPTY(ADA->ADA_UCTANT)
				_DAUXDT := ""
				_CNUMCTR := ""
				//INICIO - PRODUTOS CONTRATO
				DBSELECTAREA("ADB")
				DBSETORDER(1)
				DBGOTOP()
				IF DBSEEK(XFILIAL("ADB")+ADA->ADA_NUMCTR)
					WHILE !EOF() .AND. ADB->ADB_FILIAL+ADB->ADB_NUMCTR==ADA->ADA_FILIAL+ADA->ADA_NUMCTR
						_cItemCtr := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + ADB->ADB_CODPRO, "B1_UITCONT")
						IF (_cItemCtr = 'S')	
							IF !EMPTY( ADB->ADB_UDTINI)						
								IF EMPTY(_DAUXDT)
									_DAUXDT := MonthSub(ADB->ADB_UDTINI,ADB->ADB_UMESIN)
								ENDIF
									
								IF ADB->ADB_UDTINI < _DAUXDT
									_DAUXDT := MonthSub(ADB->ADB_UDTINI,ADB->ADB_UMESIN)
								ENDIF	
							ENDIF											
						ENDIF
										
						DBSELECTAREA("ADB")
						DBSKIP()
					ENDDO
					//FIM - PRODUTOS CONTRATO
				ENDIF //IF DO ADB	ROBSON	
				
				IF !EMPTY(_DAUXDT)
					IF	_DAUXDT >= _DDTINI  .AND. _DAUXDT <= _DDTFIM	
						_NTOTALFAT := _NTOTALFAT + 1
						//TEC15BA(ADA->ADA_NUMCTR)
						
						dbselectarea("AB6")
						dbsetorder(7)//Z2_FILIAL+AB6_UNUMCT
						if dbseek(xFilial("AB6")+ADA->ADA_NUMCTR) 
							//nLin += 0030	
							while !eof() .AND. AB6->AB6_FILIAL+AB6->AB6_UNUMCT == xFilial("AB6")+ADA->ADA_NUMCTR	
								dbselectarea("AB9")
								dbsetorder(1)//AB9_FILIAL+AB9_NUMOS
								if dbseek(xFilial()+AB6->AB6_NUMOS) 
									while !eof() .AND. xFilial("AB9")+AB6->AB6_NUMOS==AB9->AB9_FILIAL+SUBSTR(AB9->AB9_NUMOS,0,6)
											
											IF AB9->AB9_CODTEC  >=  _CATINI .AND. AB9->AB9_CODTEC  <= _CATFIM
												_cAtend := POSICIONE( "AA1", 1, XFILIAL( "AA1" ) + AB9->AB9_CODTEC, "AA1_NOMTEC")			
												_cOcor 	:= 	POSICIONE( "AAG", 1, XFILIAL( "AAG" ) + AB9->AB9_CODPRB , "AAG_DESCRI")		
								
													//inicializo a primeira se��o
													oSection1:Init()
													oReport:IncMeter()
											
													IncProc("Imprimindo NCM "+alltrim(AB6->AB6_NUMOS))
								
													//imprimo a primeira se��o				
													oSection1:Cell("ADA_NUMCTR"):SetValue(ADA->ADA_NUMCTR)
													oSection1:Cell("AB6_NUMOS"):SetValue(AB6->AB6_NUMOS)				
													oSection1:Cell("AA1_NOMTEC"):SetValue(_cAtend)				
													oSection1:Cell("AB9_DTCHEG"):SetValue(Transform(AB9->AB9_DTCHEG,"@E",))				
													oSection1:Cell("AB9_DTSAID"):SetValue(Transform(AB9->AB9_DTSAID,"@E",))				
													oSection1:Cell("AB9_TOTFAT"):SetValue(Transform(AB9->AB9_TOTFAT,"@E",))	
													oSection1:Cell("AB6_UDTVIG"):SetValue(Transform(AB6->AB6_UDTVIG,"@E",))						
													oSection1:Cell("AB9_CODPRB"):SetValue(AB9->AB9_CODPRB)							
													oSection1:Cell("AAG_DESCRI"):SetValue(_cOcor)			
													
													U_TEC15A(oSection1)		
																	
													oSection1:Printline()
											
													AADD(_AITENS,{AB9->AB9_CODTEC})
													AADD(_AITENS2,{AB9->AB9_CODTEC})
											ENDIF
										dbselectarea("AB9")
										dbskip()
									enddo
								ENDIF
							
								dbselectarea("AB6")
								dbskip()
							enddo	
						endif	
					ENDIF
				ENDIF
				
			ENDIF //IF DO ADA
			
			dbselectarea("ADA")
			dbskip()	
		enddo
		//_AITENS2 := _AITENS
		dbselectarea("AB9")
		DBGoTop()
		dbsetorder(1)//AB9_FILIAL+AB9_NUMOS
		while !eof() 
											
			IF AB9->AB9_CODTEC  >=  _CATINI .AND. AB9->AB9_CODTEC  <= _CATFIM .AND. AB9_DTCHEG>=_DDTINI .AND. AB9_DTSAID<=_DDTFIM .AND. AB9->AB9_CODPRB$_cPgtOco
						_cAtend 	:= 	POSICIONE( "AA1", 1, XFILIAL( "AA1" ) + AB9->AB9_CODTEC, "AA1_NOMTEC")			
						_cIniVig 	:= 	POSICIONE( "AB6", 1, XFILIAL( "AB6" ) + SubStr(AB9->AB9_NUMOS,1,6) , "AB6_UDTVIG")			
						_cOcor 	:= 	POSICIONE( "AAG", 1, XFILIAL( "AAG" ) + AB9->AB9_CODPRB , "AAG_DESCRI")		
						
						//inicializo a primeira se��o
						oSection1:Init()
						oReport:IncMeter()
										
						IncProc("Imprimindo NCM "+alltrim(AB6->AB6_NUMOS))
							
						//imprimo a primeira se��o				
						oSection1:Cell("ADA_NUMCTR"):SetValue(ADA->ADA_NUMCTR)
						oSection1:Cell("AB6_NUMOS"):SetValue(AB9->AB9_NUMOS)				
						oSection1:Cell("AA1_NOMTEC"):SetValue(_cAtend)				
						oSection1:Cell("AB9_DTCHEG"):SetValue(Transform(AB9->AB9_DTCHEG,"@E",))				
						oSection1:Cell("AB9_DTSAID"):SetValue(Transform(AB9->AB9_DTSAID,"@E",))				
						oSection1:Cell("AB9_TOTFAT"):SetValue(Transform(AB9->AB9_TOTFAT,"@E",))
						oSection1:Cell("AB6_UDTVIG"):SetValue(Transform(_cIniVig,"@E",))												
						oSection1:Cell("AB9_CODPRB"):SetValue(AB9->AB9_CODPRB)							
						oSection1:Cell("AAG_DESCRI"):SetValue(_cOcor)		
						
						U_TEC15A(oSection1)	
						oSection1:Printline()
											
						AADD(_AITENS2,{AB9->AB9_CODTEC})
			endif
			
			dbselectarea("AB9")
			dbskip()
		enddo
		
		/*//inicializo a segunda se��o
		oSection2:init()*/
		aDados := {}
		DBSELECTAREA("AA1")
		DBSETORDER(1)
		DBGOTOP()
		WHILE !EOF()
			_NCount := 0
			FOR _I:=1 TO LEN(_AITENS)
				IF _AITENS[_I,1] == AA1->AA1_CODTEC
					_NCount := _NCount + 1
				ENDIF
			NEXT _I
			
			_NCount2 := 0
			FOR _I:=1 TO LEN(_AITENS2)
				IF _AITENS2[_I,1] == AA1->AA1_CODTEC
					_NCount2 := _NCount2 + 1
				ENDIF
			NEXT _I
			
			IF _NCount > 0
				IF AA1_FUNCAO == "00003"
					AADD(aDados,{ALLTRIM(AA1->AA1_NOMTEC),_NCount})
					AADD(aDados,{ALLTRIM(AA1->AA1_NOMTEC),_NCount2})
				ENDIF
				/*oReport:IncMeter()	
				IncProc("Imprimindo Atendente "+alltrim(AA1->AA1_NOMTEC))	
				
				oSection2:Cell("AA1_NOMTEC"):SetValue(AA1->AA1_NOMTEC)
				oSection2:Cell("AA1_TOTAL"):SetValue(Transform(_NCount,"@E 9,999,999.99",))*/
			ENDIF
			 
			dbselectarea("AA1")
			dbskip()
		enddo	
			
 		
 		//finalizo a segunda se��o para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira se��o
		oSection1:Finish()
		
		MatGraph("Total de Instala��o vs Ativa��o : " + Transform(_NTOTALFAT,"@E 9,999,999.99",),.F.,.T.,.F.,2,1,aDados)
//	Enddo
Return

User Function TEC15A(oSection1)
	DBSELECTAREA("AB7")
	DBSETORDER(1)
	DBSEEK( XFILIAL( "AB7" ) + AB9->AB9_NUMOS)
												
												
	DBSELECTAREA("SA1")
	DBSETORDER(1)
	IF DBSEEK(xFilial("SA1")+ AB9->AB9_CODCLI + AB9->AB9_LOJA)
												
		oSection1:Cell("A1_NOME"):SetValue(SA1->A1_NOME)
		oSection1:Cell("A1_CGC"):SetValue(SA1->A1_CGC)
		oSection1:Cell("A1_TEL"):SetValue(SA1->A1_TEL)
		
		dbselectarea("AA3")
		dbsetorder(1) //AGA_FILIAL+AGA_ENTIDA+AGA_CODENT
		if dbseek(XFILIAL("AA3")+AB7->AB7_CODCLI+AB7->AB7_LOJA+AB7->AB7_CODPRO+AB7->AB7_NUMSER)
													
			dbselectarea("AGA")
			dbsetorder(2) //AGA_FILIAL+AGA_ENTIDA+AGA_CODENT
			if dbseek(xFilial()+AA3->AA3_UIDAGA)
				oSection1:Cell("A1_END"):SetValue(AGA->AGA_END)
				oSection1:Cell("A1_MUN"):SetValue(AGA->AGA_MUNDES)
			ELSE
				oSection1:Cell("A1_END"):SetValue(SA1->A1_END)
				oSection1:Cell("A1_MUN"):SetValue(SA1->A1_MUN)
			endif
		ENDIF											
	ENDIF
Return

STATIC FUNCTION VALIDPERG
*********************************
_SALIAS := ALIAS()
AREGS := {}
robsor
DBSELECTAREA("SX1")
DBSETORDER(1)
_CPERG := PADR(_CPERG,10)

//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG

AADD(AREGS,{_CPERG,"01","Data Inicio  ?  "," ?"," ?","MV_CH01","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"02","Data Fim ?  "," ?"," ?","MV_CH02","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"03","ATENDENTE DE      ?","","","MV_CH3","C",06,0,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","AA1",""})
AADD(AREGS,{_CPERG,"04","ATENDENTE ATE     ?","","","MV_CH4","C",06,0,0, "G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","AA1",""})

FOR I:=1 TO LEN(AREGS)
	IF !DBSEEK(_CPERG+AREGS[I,2])
		RECLOCK("SX1",.T.)
		FOR J:=1 TO FCOUNT()
			IF J <= LEN(AREGS[I])
				FIELDPUT(J,AREGS[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
DBSELECTAREA(_SALIAS)
RETURN