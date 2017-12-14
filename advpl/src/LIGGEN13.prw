#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FILEIO.CH"
#include "topconn.ch"

user function LIGGEN13()
	PRIVATE _CFILE 	:= " "
	PRIVATE _AVETOR := {}
	PRIVATE _ADADOS := {}
	PRIVATE _CONT	:= 0
	PRIVATE _NIMPOK := 0
	PRIVATE _NIMPNO := 0
	PRIVATE _NIMSA1 := 0

	_CFILE := CGETFILE("*.CSV|*.CSV","ARQ.CSV",1,,.F.,GETF_LOCALHARD+GETF_LOCALFLOPPY,.F.)

	IF EMPTY(_CFILE) .OR. !FILE(_CFILE)
		RETURN
	ENDIF

	PROCESSA({|| GEN01A() },"CARREGANDO ARQUIVO...")
	PROCESSA({|| GEN01C() },"GRAVANDO TELEFONES...")

RETURN

STATIC FUNCTION GEN01A() //LE ARQUIVO
	*********************************
	PRIVATE OLETXT
	PRIVATE NTAMFILE, NTAMLIN, CBUFFER, NBTLIDOS
	PRIVATE NHDL
	PRIVATE CEOL    := CHR(13)+CHR(10)

	NHDL := FOPEN(_CFILE,68)

	IF NHDL == -1
		MSGALERT("O ARQUIVO "+_CFILE+" NAO PODE SER ABERTO! VERIFIQUE OS PARAMETROS.","ATENCAO!")
		RETURN
	ENDIF

	IF FILE(_CFILE)
		FT_FUSE(_CFILE)//abre o arquivo xxx
		FT_FGOTOP()// vai para o in�cio do arquivo
		FT_FSKIP() //PULA CABECALHO
		_ADADOS := {}
		_ALINHA := {}
		_CONT   := 0
		WHILE !FT_FEOF() //.AND. _CONT<150
			CLINHA := FT_FREADLN()
			_AUXINI := 1
			_AUXFIM := 1
			_CTEXTO	:= " "
			WHILE _AUXFIM<=LEN(CLINHA)
				IF SUBSTR(CLINHA,_AUXFIM,1) == ";"
					IF ALLTRIM(SUBSTR(CLINHA,_AUXINI,_AUXFIM-_AUXINI)) != ""
						AADD(_ALINHA,ALLTRIM(UPPER(SUBSTR(CLINHA,_AUXINI,_AUXFIM-_AUXINI))))
					ELSE
						AADD(_ALINHA,SPACE(1))
					ENDIF
					_AUXFIM++
					_AUXINI := _AUXFIM
				ELSE
					_AUXFIM++
				ENDIF
			ENDDO
			_CONT++
			AADD(_ALINHA,SUBSTR(CLINHA,_AUXINI,_AUXFIM-_AUXINI))

			FOR _I:=1 TO LEN(_ALINHA) //RETIRA ACENTOS
				_ALINHA[_I] := GEN01B(_ALINHA[_I])
			NEXT _I

			AADD(_ADADOS,_ALINHA)

			_ALINHA := {}
			FT_FSKIP()
		ENDDO
		FT_FUSE()
	ELSE
		MSGINFO("ARQUIVO NAO ENCONTRADO. FAVOR VERIFICAR OS PARAMETROS.")
	ENDIF

RETURN

STATIC FUNCTION GEN01B(CSTRING) //RETIRA ACENTOS
	*********************************
	LOCAL CCHAR  := ""
	LOCAL NX     := 0
	LOCAL NY     := 0
	LOCAL CVOGAL := "AEIOUAEIOU"
	LOCAL CAGUDO := "�����"+"�����"
	LOCAL CCIRCU := "�����"+"�����"
	LOCAL CTREMA := "�����"+"�����"
	LOCAL CCRASE := "�����"+"�����"
	LOCAL CTIO   := "��"
	LOCAL CCECID := "��"
	LOCAL CTRAT	 := " "

	FOR NX:= 1 TO LEN(CSTRING)

		CCHAR:=SUBSTR(CSTRING, NX, 1)

		IF CCHAR$CAGUDO+CCIRCU+CTREMA+CCECID+CTIO+CCRASE

			NY:= AT(CCHAR,CAGUDO)
			IF NY > 0
				CSTRING := STRTRAN(CSTRING,CCHAR,SUBSTR(CVOGAL,NY,1))
			ENDIF

			NY:= AT(CCHAR,CCIRCU)
			IF NY > 0
				CSTRING := STRTRAN(CSTRING,CCHAR,SUBSTR(CVOGAL,NY,1))
			ENDIF

			NY:= AT(CCHAR,CTREMA)
			IF NY > 0
				CSTRING := STRTRAN(CSTRING,CCHAR,SUBSTR(CVOGAL,NY,1))
			ENDIF

			NY:= AT(CCHAR,CCRASE)
			IF NY > 0
				CSTRING := STRTRAN(CSTRING,CCHAR,SUBSTR(CVOGAL,NY,1))
			ENDIF

			NY:= AT(CCHAR,CTIO)
			IF NY > 0
				CSTRING := STRTRAN(CSTRING,CCHAR,SUBSTR("AO",NY,1))
			ENDIF

			NY:= AT(CCHAR,CCECID)
			IF NY > 0
				CSTRING := STRTRAN(CSTRING,CCHAR,SUBSTR("CC",NY,1))
			ENDIF

		ENDIF

	NEXT

	//TRATAMENTO DE CARACTERES ESPECIAIS
	FOR NX:=1 TO LEN(CSTRING)
		CCHAR:=SUBSTR(CSTRING, NX, 1)
		IF ASC(CCHAR) < 32 .OR. ASC(CCHAR) > 123 .OR. CCHAR $ '&'
			DO CASE
				CASE ASC(CCHAR) == 38
				CCHAR := "E"
				CASE ASC(CCHAR) == 128
				CCHAR := "A"
				CASE ASC(CCHAR) == 181
				CCHAR := "A"
				CASE ASC(CCHAR) == 229
				CCHAR := "O"
				CASE ASC(CCHAR) == 144
				CCHAR := "E"
				CASE ASC(CCHAR) == 133
				CCHAR := "A"
				CASE ASC(CCHAR) == 248
				CCHAR := ""
				CASE ASC(CCHAR) == 152
				CCHAR := "Y"
				CASE ASC(CCHAR) == 208
				CCHAR := "O"
				CASE ASC(CCHAR) == 182
				CCHAR := "A"
				CASE ASC(CCHAR) == 167
				CCHAR := ""
				CASE ASC(CCHAR) == 166
				CCHAR := ""
				CASE ASC(CCHAR) == 126
				CCHAR := ""
				CASE ASC(CCHAR) == 221
				CCHAR := ":"
				CASE ASC(CCHAR) == 155
				CCHAR := ""
				CASE ASC(CCHAR) == 154
				CCHAR := "U"
			ENDCASE
			CSTRING := SUBSTR(CSTRING,1,NX-1)+CCHAR+SUBSTR(CSTRING,NX+1,LEN(CSTRING)-NX)
		ENDIF
	NEXT NX

	FOR NX:=1 TO LEN(CSTRING)

		CCHAR:=SUBSTR(CSTRING, NX, 1)

		IF ASC(CCHAR) < 32 .OR. ASC(CCHAR) > 123 .OR. CCHAR $ '&'

			IF STRTRAN(CTRAT, "("+ALLTRIM(STR(ASC(CCHAR)))+"-"+CCHAR+")  ") == CTRAT
				CTRAT += "("+ALLTRIM(STR(ASC(CCHAR)))+"-"+CCHAR+")  "
			ENDIF
			//CSTRING:=STRTRAN(CSTRING,CCHAR,"?")
		ENDIF

	NEXT NX

	CSTRING := _NOTAGS(CSTRING)

RETURN CSTRING

STATIC FUNCTION GEN01C() //IMPORTA DADOS
	***********************************

	LOCAL PA1_CGC       := 3
	LOCAL PA1_NOME      := 4
	LOCAL PA1_TEL       := 5
	LOCAL PA1_COMPLEM   := 6

	LOCAL CDIRLOG		:= GETSRVPROFSTRING("STARTPATH","")
	LOCAL CARQLOG		:= "IMPSA1LOG.LOG"
	LOCAL CARQERRO		:= "LOGIMPSA1.LOG"
	LOCAL CERROAUTO		:= ""

	LOCAL LERRO			:= .F.

	DBSELECTAREA("SA1")
	//ASORT(_ADADOS,,,{|X,Y| X[PA1_NOME]<Y[PA1_NOME]})

	BEGIN TRANSACTION

		PROCREGUA(LEN(_ADADOS))
		FOR I:=1 TO LEN(_ADADOS)
			INCPROC("AGUARDE...")

			//TRATA DADOS
			_CTEL := ALLTRIM(_ADADOS[I,PA1_TEL])
			_CTEL := STRTRAN(_CTEL,"-","")

			_CCGC := STRTRAN(_ADADOS[I,PA1_CGC],".","")
			_CCGC := STRTRAN(_CCGC,"/","")
			_CCGC := STRTRAN(_CCGC,"-","")

			DBSELECTAREA("SA1")
			DBSETORDER(3)
			IF DBSEEK(XFILIAL("SA1")+_CCGC)
			_NIMSA1++
				IF ALLTRIM(SA1->A1_TEL) == "38100000" .OR. ALLTRIM(SA1->A1_TEL) == "38100001" .OR. ALLTRIM(SA1->A1_TEL) == "38100002" .OR. ALLTRIM(SA1->A1_TEL) == ""
					reclock("SA1",.F.)
					SA1->A1_TEL := _CTEL
					msunlock()
				ENDIF
				//----------------------------------------------------------------------------
				cQuery := " SELECT * FROM "+RetSqlName("AGB")
				cQuery += " WHERE D_E_L_E_T_ = '' AND AGB_ENTIDA = 'SA1' AND
				cQuery += " AGB_TIPO = '2' AND AGB_PADRAO = '2' AND
				cQuery += " AGB_CODENT ='"+SA1->A1_COD+SA1->A1_LOJA +"' AND AGB_TELEFO like '%" + _CTEL+"%'"
				TCQUERY cQuery NEW ALIAS "TEMP"
				dbselectarea("TEMP")
				EXISTE := .F.
				While !EOF()
					EXISTE := .T.
					_NIMPNO++
					dbselectarea("TEMP")
					dbskip()
				enddo
				TEMP->(dbclosearea())
				//----------------------------------------------------------------------------
				if !EXISTE
					_cod := GETSXENUM("AGB","AGB_CODIGO",2)
					ConfirmSX8()

					reclock("AGB",.T.)
					AGB->AGB_CODIGO := _cod
					msunlock()

					reclock("AGB",.F.)

					AGB->AGB_FILIAL :=  xFilial("AGB")
					AGB->AGB_CODIGO := _cod
					AGB->AGB_ENTIDA := "SA1"
					AGB->AGB_CODENT := SA1->A1_COD+SA1->A1_LOJA
					AGB->AGB_TIPO := "2"
					AGB->AGB_PADRAO := "2"
					AGB->AGB_DDI := ""
					AGB->AGB_DDD := "44"
					AGB->AGB_TELEFO := _CTEL
					AGB->AGB_COMP := _ADADOS[I,PA1_COMPLEM]
					AGB->AGB_UCALLC := ""
					AGB->AGB_UNUMCT := ""
					AGB->AGB_UTIPO2 := ""
					AGB->AGB_UTITUL := ""
					AGB->AGB_UCGC  := ALLTRIM(_CCGC)

					msunlock()
					_NIMPOK++
				endif

			ENDIF

		NEXT

	END TRANSACTION
	MSGALERT("QT TELEFONES IMPORTADOS : "+ALLTRIM(STR(_NIMPOK))+"   -   QT TELEFONES QUE JA FORAM IMPORTADOS : "+ALLTRIM(STR(_NIMPNO)))
//	MSGALERT("QT TELEFONES IMPORTADOS : "+ALLTRIM(STR(LEN(_ADADOS))))
	MSGALERT("QT SA1 : "+ALLTRIM(STR(_NIMSA1)))

RETURN(.T.)