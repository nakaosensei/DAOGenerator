#include 'protheus.ch'
#include 'parmtype.ch'

user function DSD3Cad(FILIAL,COD,DLOCAL,TM,QUANT,CUSTO1,CUSTO2,CUSTO3,CC,CUSTO4,CUSTO5,DESCRI,UM,CF,CONTA,OP,USOLICI,GRUPO,DOC,EMISSAO,PARCTOT,ESTORNO,NUMSEQ,SEGUM,NIVEL,QTSEGUM,TIPO,USUARIO,REGWMS,PERDA,DTLANC,TRT,IDENT,SEQCALC,CHAVE,RATEIO,LOTECTL,DTVALID,NUMLOTE,LOCALIZ,NUMSERI,CUSFF1,CUSFF2,CUSFF3,CUSFF4,CUSFF5,ITEM,ITEMCTA,CLVL,OK,PROJPMS,TASKPMS,ORDEM,CODGRP,CODITE,SERVIC,STSERV,OSTEC,POTENCI,TPESTR,ITEMSWN,DOCSWN,ITEMGRD,REGATEN,STATUS,CUSRP1,CUSRP2,CUSRP3,CUSRP4,CUSRP5,CMRP,MOEDRP,MOEDA,REVISAO,CMFIXO,PMACNUT,PMICNUT,EMPOP,DIACTB,NODIA,GARANTI,QTGANHO,QTMAIOR,NRBPIMS,CODLAN,OKISS,CHAVEF1,PERIMP,VLRVI,VLRPD)
	if(FILIAL = nil, "", FILIAL)
	if(TM = nil, "", TM)
	if(COD = nil, "", COD)
	if(DESCRI = nil, "", DESCRI)
	if(QUANT = nil, "", QUANT)
	if(UM = nil, "", UM)
	if(CF = nil, "", CF)
	if(CONTA = nil, "", CONTA)
	if(OP = nil, "", OP)
	if(DLOCAL = nil, "", DLOCAL)
	if(USOLICI = nil, "", USOLICI)
	if(GRUPO = nil, "", GRUPO)
	if(DOC = nil, "", DOC)
	if(EMISSAO = nil, "", EMISSAO)
	if(CUSTO1 = nil, "", CUSTO1)
	if(CUSTO2 = nil, "", CUSTO2)
	if(CUSTO3 = nil, "", CUSTO3)
	if(CC = nil, "", CC)
	if(CUSTO4 = nil, "", CUSTO4)
	if(CUSTO5 = nil, "", CUSTO5)
	if(PARCTOT = nil, "", PARCTOT)
	if(ESTORNO = nil, "", ESTORNO)
	if(NUMSEQ = nil, "", NUMSEQ)
	if(SEGUM = nil, "", SEGUM)
	if(NIVEL = nil, "", NIVEL)
	if(QTSEGUM = nil, "", QTSEGUM)
	if(TIPO = nil, "", TIPO)
	if(USUARIO = nil, "", USUARIO)
	if(REGWMS = nil, "", REGWMS)
	if(PERDA = nil, "", PERDA)
	if(DTLANC = nil, "", DTLANC)
	if(TRT = nil, "", TRT)
	if(IDENT = nil, "", IDENT)
	if(SEQCALC = nil, "", SEQCALC)
	if(CHAVE = nil, "", CHAVE)
	if(RATEIO = nil, "", RATEIO)
	if(LOTECTL = nil, "", LOTECTL)
	if(DTVALID = nil, "", DTVALID)
	if(NUMLOTE = nil, "", NUMLOTE)
	if(LOCALIZ = nil, "", LOCALIZ)
	if(NUMSERI = nil, "", NUMSERI)
	if(CUSFF1 = nil, "", CUSFF1)
	if(CUSFF2 = nil, "", CUSFF2)
	if(CUSFF3 = nil, "", CUSFF3)
	if(CUSFF4 = nil, "", CUSFF4)
	if(CUSFF5 = nil, "", CUSFF5)
	if(ITEM = nil, "", ITEM)
	if(ITEMCTA = nil, "", ITEMCTA)
	if(CLVL = nil, "", CLVL)
	if(OK = nil, "", OK)
	if(PROJPMS = nil, "", PROJPMS)
	if(TASKPMS = nil, "", TASKPMS)
	if(ORDEM = nil, "", ORDEM)
	if(CODGRP = nil, "", CODGRP)
	if(CODITE = nil, "", CODITE)
	if(SERVIC = nil, "", SERVIC)
	if(STSERV = nil, "", STSERV)
	if(OSTEC = nil, "", OSTEC)
	if(POTENCI = nil, "", POTENCI)
	if(TPESTR = nil, "", TPESTR)
	if(ITEMSWN = nil, "", ITEMSWN)
	if(DOCSWN = nil, "", DOCSWN)
	if(ITEMGRD = nil, "", ITEMGRD)
	if(REGATEN = nil, "", REGATEN)
	if(STATUS = nil, "", STATUS)
	if(CUSRP1 = nil, "", CUSRP1)
	if(CUSRP2 = nil, "", CUSRP2)
	if(CUSRP3 = nil, "", CUSRP3)
	if(CUSRP4 = nil, "", CUSRP4)
	if(CUSRP5 = nil, "", CUSRP5)
	if(CMRP = nil, "", CMRP)
	if(MOEDRP = nil, "", MOEDRP)
	if(MOEDA = nil, "", MOEDA)
	if(REVISAO = nil, "", REVISAO)
	if(CMFIXO = nil, "", CMFIXO)
	if(PMACNUT = nil, "", PMACNUT)
	if(PMICNUT = nil, "", PMICNUT)
	if(EMPOP = nil, "", EMPOP)
	if(DIACTB = nil, "", DIACTB)
	if(NODIA = nil, "", NODIA)
	if(GARANTI = nil, "", GARANTI)
	if(QTGANHO = nil, "", QTGANHO)
	if(QTMAIOR = nil, "", QTMAIOR)
	if(NRBPIMS = nil, "", NRBPIMS)
	if(CODLAN = nil, "", CODLAN)
	if(OKISS = nil, "", OKISS)
	if(CHAVEF1 = nil, "", CHAVEF1)
	if(PERIMP = nil, "", PERIMP)
	if(VLRVI = nil, "", VLRVI)
	if(VLRPD = nil, "", VLRPD)

	FILIAL := ALLTRIM(FILIAL)
	TM := ALLTRIM(TM)
	COD := ALLTRIM(COD)
	DESCRI := ALLTRIM(DESCRI)
	QUANT := ALLTRIM(QUANT)
	UM := ALLTRIM(UM)
	CF := ALLTRIM(CF)
	CONTA := ALLTRIM(CONTA)
	OP := ALLTRIM(OP)
	DLOCAL := ALLTRIM(DLOCAL)
	USOLICI := ALLTRIM(USOLICI)
	GRUPO := ALLTRIM(GRUPO)
	DOC := ALLTRIM(DOC)
	EMISSAO := ALLTRIM(EMISSAO)
	CUSTO1 := ALLTRIM(CUSTO1)
	CUSTO2 := ALLTRIM(CUSTO2)
	CUSTO3 := ALLTRIM(CUSTO3)
	CC := ALLTRIM(CC)
	CUSTO4 := ALLTRIM(CUSTO4)
	CUSTO5 := ALLTRIM(CUSTO5)
	PARCTOT := ALLTRIM(PARCTOT)
	ESTORNO := ALLTRIM(ESTORNO)
	NUMSEQ := ALLTRIM(NUMSEQ)
	SEGUM := ALLTRIM(SEGUM)
	NIVEL := ALLTRIM(NIVEL)
	QTSEGUM := ALLTRIM(QTSEGUM)
	TIPO := ALLTRIM(TIPO)
	USUARIO := ALLTRIM(USUARIO)
	REGWMS := ALLTRIM(REGWMS)
	PERDA := ALLTRIM(PERDA)
	DTLANC := ALLTRIM(DTLANC)
	TRT := ALLTRIM(TRT)
	IDENT := ALLTRIM(IDENT)
	SEQCALC := ALLTRIM(SEQCALC)
	CHAVE := ALLTRIM(CHAVE)
	RATEIO := ALLTRIM(RATEIO)
	LOTECTL := ALLTRIM(LOTECTL)
	DTVALID := ALLTRIM(DTVALID)
	NUMLOTE := ALLTRIM(NUMLOTE)
	LOCALIZ := ALLTRIM(LOCALIZ)
	NUMSERI := ALLTRIM(NUMSERI)
	CUSFF1 := ALLTRIM(CUSFF1)
	CUSFF2 := ALLTRIM(CUSFF2)
	CUSFF3 := ALLTRIM(CUSFF3)
	CUSFF4 := ALLTRIM(CUSFF4)
	CUSFF5 := ALLTRIM(CUSFF5)
	ITEM := ALLTRIM(ITEM)
	ITEMCTA := ALLTRIM(ITEMCTA)
	CLVL := ALLTRIM(CLVL)
	OK := ALLTRIM(OK)
	PROJPMS := ALLTRIM(PROJPMS)
	TASKPMS := ALLTRIM(TASKPMS)
	ORDEM := ALLTRIM(ORDEM)
	CODGRP := ALLTRIM(CODGRP)
	CODITE := ALLTRIM(CODITE)
	SERVIC := ALLTRIM(SERVIC)
	STSERV := ALLTRIM(STSERV)
	OSTEC := ALLTRIM(OSTEC)
	POTENCI := ALLTRIM(POTENCI)
	TPESTR := ALLTRIM(TPESTR)
	ITEMSWN := ALLTRIM(ITEMSWN)
	DOCSWN := ALLTRIM(DOCSWN)
	ITEMGRD := ALLTRIM(ITEMGRD)
	REGATEN := ALLTRIM(REGATEN)
	STATUS := ALLTRIM(STATUS)
	CUSRP1 := ALLTRIM(CUSRP1)
	CUSRP2 := ALLTRIM(CUSRP2)
	CUSRP3 := ALLTRIM(CUSRP3)
	CUSRP4 := ALLTRIM(CUSRP4)
	CUSRP5 := ALLTRIM(CUSRP5)
	CMRP := ALLTRIM(CMRP)
	MOEDRP := ALLTRIM(MOEDRP)
	MOEDA := ALLTRIM(MOEDA)
	REVISAO := ALLTRIM(REVISAO)
	CMFIXO := ALLTRIM(CMFIXO)
	PMACNUT := ALLTRIM(PMACNUT)
	PMICNUT := ALLTRIM(PMICNUT)
	EMPOP := ALLTRIM(EMPOP)
	DIACTB := ALLTRIM(DIACTB)
	NODIA := ALLTRIM(NODIA)
	GARANTI := ALLTRIM(GARANTI)
	QTGANHO := ALLTRIM(QTGANHO)
	QTMAIOR := ALLTRIM(QTMAIOR)
	NRBPIMS := ALLTRIM(NRBPIMS)
	CODLAN := ALLTRIM(CODLAN)
	OKISS := ALLTRIM(OKISS)
	CHAVEF1 := ALLTRIM(CHAVEF1)
	PERIMP := ALLTRIM(PERIMP)
	VLRVI := ALLTRIM(VLRVI)
	VLRPD := ALLTRIM(VLRPD)


	DOC := UPPER(DOC)
	UM := UPPER(UM)

	exceptionList := {}
	exceptionList := u_DSD3Vld(FILIAL,COD,DLOCAL)
	if len(exceptionList)>0
		CONOUT("PROBLEMA DE VALIDACAO NA TABELA SD3")
		return "0"
	endif

	EMISSAO := u_strToDate(EMISSAO) //Funcao de conversao avancada no LIGDFILTER.prw
	DTLANC := u_strToDate(DTLANC) //Funcao de conversao avancada no LIGDFILTER.prw
	DTVALID := u_strToDate(DTVALID) //Funcao de conversao avancada no LIGDFILTER.prw

	DBSELECTAREA("SD3")
	RECLOCK("SD3",.T.)
	SD3->D3_FILIAL := FILIAL
	SD3->D3_TM := TM
	SD3->D3_COD := COD
	SD3->D3_DESCRI := DESCRI
	SD3->D3_QUANT := QUANT
	SD3->D3_UM := UM
	SD3->D3_CF := CF
	SD3->D3_CONTA := CONTA
	SD3->D3_OP := OP
	SD3->D3_LOCAL := DLOCAL
	SD3->D3_USOLICI := USOLICI
	SD3->D3_GRUPO := GRUPO
	SD3->D3_DOC := DOC
	SD3->D3_EMISSAO := EMISSAO
	SD3->D3_CUSTO1 := CUSTO1
	SD3->D3_CUSTO2 := CUSTO2
	SD3->D3_CUSTO3 := CUSTO3
	SD3->D3_CC := CC
	SD3->D3_CUSTO4 := CUSTO4
	SD3->D3_CUSTO5 := CUSTO5
	SD3->D3_PARCTOT := PARCTOT
	SD3->D3_ESTORNO := ESTORNO
	SD3->D3_NUMSEQ := NUMSEQ
	SD3->D3_SEGUM := SEGUM
	SD3->D3_NIVEL := NIVEL
	SD3->D3_QTSEGUM := QTSEGUM
	SD3->D3_TIPO := TIPO
	SD3->D3_USUARIO := USUARIO
	SD3->D3_REGWMS := REGWMS
	SD3->D3_PERDA := PERDA
	SD3->D3_DTLANC := DTLANC
	SD3->D3_TRT := TRT
	SD3->D3_IDENT := IDENT
	SD3->D3_SEQCALC := SEQCALC
	SD3->D3_CHAVE := CHAVE
	SD3->D3_RATEIO := RATEIO
	SD3->D3_LOTECTL := LOTECTL
	SD3->D3_DTVALID := DTVALID
	SD3->D3_NUMLOTE := NUMLOTE
	SD3->D3_LOCALIZ := LOCALIZ
	SD3->D3_NUMSERI := NUMSERI
	SD3->D3_CUSFF1 := CUSFF1
	SD3->D3_CUSFF2 := CUSFF2
	SD3->D3_CUSFF3 := CUSFF3
	SD3->D3_CUSFF4 := CUSFF4
	SD3->D3_CUSFF5 := CUSFF5
	SD3->D3_ITEM := ITEM
	SD3->D3_ITEMCTA := ITEMCTA
	SD3->D3_CLVL := CLVL
	SD3->D3_OK := OK
	SD3->D3_PROJPMS := PROJPMS
	SD3->D3_TASKPMS := TASKPMS
	SD3->D3_ORDEM := ORDEM
	SD3->D3_CODGRP := CODGRP
	SD3->D3_CODITE := CODITE
	SD3->D3_SERVIC := SERVIC
	SD3->D3_STSERV := STSERV
	SD3->D3_OSTEC := OSTEC
	SD3->D3_POTENCI := POTENCI
	SD3->D3_TPESTR := TPESTR
	SD3->D3_ITEMSWN := ITEMSWN
	SD3->D3_DOCSWN := DOCSWN
	SD3->D3_ITEMGRD := ITEMGRD
	SD3->D3_REGATEN := REGATEN
	SD3->D3_STATUS := STATUS
	SD3->D3_CUSRP1 := CUSRP1
	SD3->D3_CUSRP2 := CUSRP2
	SD3->D3_CUSRP3 := CUSRP3
	SD3->D3_CUSRP4 := CUSRP4
	SD3->D3_CUSRP5 := CUSRP5
	SD3->D3_CMRP := CMRP
	SD3->D3_MOEDRP := MOEDRP
	SD3->D3_MOEDA := MOEDA
	SD3->D3_REVISAO := REVISAO
	SD3->D3_CMFIXO := CMFIXO
	SD3->D3_PMACNUT := PMACNUT
	SD3->D3_PMICNUT := PMICNUT
	SD3->D3_EMPOP := EMPOP
	SD3->D3_DIACTB := DIACTB
	SD3->D3_NODIA := NODIA
	SD3->D3_GARANTI := GARANTI
	SD3->D3_QTGANHO := QTGANHO
	SD3->D3_QTMAIOR := QTMAIOR
	SD3->D3_NRBPIMS := NRBPIMS
	SD3->D3_CODLAN := CODLAN
	SD3->D3_OKISS := OKISS
	SD3->D3_CHAVEF1 := CHAVEF1
	SD3->D3_PERIMP := PERIMP
	SD3->D3_VLRVI := VLRVI
	SD3->D3_VLRPD := VLRPD
	MSUNLOCK()
return 

user function DSD3Alter(FILIAL,COD,DLOCAL,TM,QUANT,CUSTO1,CUSTO2,CUSTO3,CC,CUSTO4,CUSTO5,DESCRI,UM,CF,CONTA,OP,USOLICI,GRUPO,DOC,EMISSAO,PARCTOT,ESTORNO,NUMSEQ,SEGUM,NIVEL,QTSEGUM,TIPO,USUARIO,REGWMS,PERDA,DTLANC,TRT,IDENT,SEQCALC,CHAVE,RATEIO,LOTECTL,DTVALID,NUMLOTE,LOCALIZ,NUMSERI,CUSFF1,CUSFF2,CUSFF3,CUSFF4,CUSFF5,ITEM,ITEMCTA,CLVL,OK,PROJPMS,TASKPMS,ORDEM,CODGRP,CODITE,SERVIC,STSERV,OSTEC,POTENCI,TPESTR,ITEMSWN,DOCSWN,ITEMGRD,REGATEN,STATUS,CUSRP1,CUSRP2,CUSRP3,CUSRP4,CUSRP5,CMRP,MOEDRP,MOEDA,REVISAO,CMFIXO,PMACNUT,PMICNUT,EMPOP,DIACTB,NODIA,GARANTI,QTGANHO,QTMAIOR,NRBPIMS,CODLAN,OKISS,CHAVEF1,PERIMP,VLRVI,VLRPD)
	if(FILIAL = nil, "", FILIAL)
	if(TM = nil, "", TM)
	if(COD = nil, "", COD)
	if(DESCRI = nil, "", DESCRI)
	if(QUANT = nil, "", QUANT)
	if(UM = nil, "", UM)
	if(CF = nil, "", CF)
	if(CONTA = nil, "", CONTA)
	if(OP = nil, "", OP)
	if(DLOCAL = nil, "", DLOCAL)
	if(USOLICI = nil, "", USOLICI)
	if(GRUPO = nil, "", GRUPO)
	if(DOC = nil, "", DOC)
	if(EMISSAO = nil, "", EMISSAO)
	if(CUSTO1 = nil, "", CUSTO1)
	if(CUSTO2 = nil, "", CUSTO2)
	if(CUSTO3 = nil, "", CUSTO3)
	if(CC = nil, "", CC)
	if(CUSTO4 = nil, "", CUSTO4)
	if(CUSTO5 = nil, "", CUSTO5)
	if(PARCTOT = nil, "", PARCTOT)
	if(ESTORNO = nil, "", ESTORNO)
	if(NUMSEQ = nil, "", NUMSEQ)
	if(SEGUM = nil, "", SEGUM)
	if(NIVEL = nil, "", NIVEL)
	if(QTSEGUM = nil, "", QTSEGUM)
	if(TIPO = nil, "", TIPO)
	if(USUARIO = nil, "", USUARIO)
	if(REGWMS = nil, "", REGWMS)
	if(PERDA = nil, "", PERDA)
	if(DTLANC = nil, "", DTLANC)
	if(TRT = nil, "", TRT)
	if(IDENT = nil, "", IDENT)
	if(SEQCALC = nil, "", SEQCALC)
	if(CHAVE = nil, "", CHAVE)
	if(RATEIO = nil, "", RATEIO)
	if(LOTECTL = nil, "", LOTECTL)
	if(DTVALID = nil, "", DTVALID)
	if(NUMLOTE = nil, "", NUMLOTE)
	if(LOCALIZ = nil, "", LOCALIZ)
	if(NUMSERI = nil, "", NUMSERI)
	if(CUSFF1 = nil, "", CUSFF1)
	if(CUSFF2 = nil, "", CUSFF2)
	if(CUSFF3 = nil, "", CUSFF3)
	if(CUSFF4 = nil, "", CUSFF4)
	if(CUSFF5 = nil, "", CUSFF5)
	if(ITEM = nil, "", ITEM)
	if(ITEMCTA = nil, "", ITEMCTA)
	if(CLVL = nil, "", CLVL)
	if(OK = nil, "", OK)
	if(PROJPMS = nil, "", PROJPMS)
	if(TASKPMS = nil, "", TASKPMS)
	if(ORDEM = nil, "", ORDEM)
	if(CODGRP = nil, "", CODGRP)
	if(CODITE = nil, "", CODITE)
	if(SERVIC = nil, "", SERVIC)
	if(STSERV = nil, "", STSERV)
	if(OSTEC = nil, "", OSTEC)
	if(POTENCI = nil, "", POTENCI)
	if(TPESTR = nil, "", TPESTR)
	if(ITEMSWN = nil, "", ITEMSWN)
	if(DOCSWN = nil, "", DOCSWN)
	if(ITEMGRD = nil, "", ITEMGRD)
	if(REGATEN = nil, "", REGATEN)
	if(STATUS = nil, "", STATUS)
	if(CUSRP1 = nil, "", CUSRP1)
	if(CUSRP2 = nil, "", CUSRP2)
	if(CUSRP3 = nil, "", CUSRP3)
	if(CUSRP4 = nil, "", CUSRP4)
	if(CUSRP5 = nil, "", CUSRP5)
	if(CMRP = nil, "", CMRP)
	if(MOEDRP = nil, "", MOEDRP)
	if(MOEDA = nil, "", MOEDA)
	if(REVISAO = nil, "", REVISAO)
	if(CMFIXO = nil, "", CMFIXO)
	if(PMACNUT = nil, "", PMACNUT)
	if(PMICNUT = nil, "", PMICNUT)
	if(EMPOP = nil, "", EMPOP)
	if(DIACTB = nil, "", DIACTB)
	if(NODIA = nil, "", NODIA)
	if(GARANTI = nil, "", GARANTI)
	if(QTGANHO = nil, "", QTGANHO)
	if(QTMAIOR = nil, "", QTMAIOR)
	if(NRBPIMS = nil, "", NRBPIMS)
	if(CODLAN = nil, "", CODLAN)
	if(OKISS = nil, "", OKISS)
	if(CHAVEF1 = nil, "", CHAVEF1)
	if(PERIMP = nil, "", PERIMP)
	if(VLRVI = nil, "", VLRVI)
	if(VLRPD = nil, "", VLRPD)

	FILIAL := ALLTRIM(FILIAL)
	TM := ALLTRIM(TM)
	COD := ALLTRIM(COD)
	DESCRI := ALLTRIM(DESCRI)
	QUANT := ALLTRIM(QUANT)
	UM := ALLTRIM(UM)
	CF := ALLTRIM(CF)
	CONTA := ALLTRIM(CONTA)
	OP := ALLTRIM(OP)
	DLOCAL := ALLTRIM(DLOCAL)
	USOLICI := ALLTRIM(USOLICI)
	GRUPO := ALLTRIM(GRUPO)
	DOC := ALLTRIM(DOC)
	EMISSAO := ALLTRIM(EMISSAO)
	CUSTO1 := ALLTRIM(CUSTO1)
	CUSTO2 := ALLTRIM(CUSTO2)
	CUSTO3 := ALLTRIM(CUSTO3)
	CC := ALLTRIM(CC)
	CUSTO4 := ALLTRIM(CUSTO4)
	CUSTO5 := ALLTRIM(CUSTO5)
	PARCTOT := ALLTRIM(PARCTOT)
	ESTORNO := ALLTRIM(ESTORNO)
	NUMSEQ := ALLTRIM(NUMSEQ)
	SEGUM := ALLTRIM(SEGUM)
	NIVEL := ALLTRIM(NIVEL)
	QTSEGUM := ALLTRIM(QTSEGUM)
	TIPO := ALLTRIM(TIPO)
	USUARIO := ALLTRIM(USUARIO)
	REGWMS := ALLTRIM(REGWMS)
	PERDA := ALLTRIM(PERDA)
	DTLANC := ALLTRIM(DTLANC)
	TRT := ALLTRIM(TRT)
	IDENT := ALLTRIM(IDENT)
	SEQCALC := ALLTRIM(SEQCALC)
	CHAVE := ALLTRIM(CHAVE)
	RATEIO := ALLTRIM(RATEIO)
	LOTECTL := ALLTRIM(LOTECTL)
	DTVALID := ALLTRIM(DTVALID)
	NUMLOTE := ALLTRIM(NUMLOTE)
	LOCALIZ := ALLTRIM(LOCALIZ)
	NUMSERI := ALLTRIM(NUMSERI)
	CUSFF1 := ALLTRIM(CUSFF1)
	CUSFF2 := ALLTRIM(CUSFF2)
	CUSFF3 := ALLTRIM(CUSFF3)
	CUSFF4 := ALLTRIM(CUSFF4)
	CUSFF5 := ALLTRIM(CUSFF5)
	ITEM := ALLTRIM(ITEM)
	ITEMCTA := ALLTRIM(ITEMCTA)
	CLVL := ALLTRIM(CLVL)
	OK := ALLTRIM(OK)
	PROJPMS := ALLTRIM(PROJPMS)
	TASKPMS := ALLTRIM(TASKPMS)
	ORDEM := ALLTRIM(ORDEM)
	CODGRP := ALLTRIM(CODGRP)
	CODITE := ALLTRIM(CODITE)
	SERVIC := ALLTRIM(SERVIC)
	STSERV := ALLTRIM(STSERV)
	OSTEC := ALLTRIM(OSTEC)
	POTENCI := ALLTRIM(POTENCI)
	TPESTR := ALLTRIM(TPESTR)
	ITEMSWN := ALLTRIM(ITEMSWN)
	DOCSWN := ALLTRIM(DOCSWN)
	ITEMGRD := ALLTRIM(ITEMGRD)
	REGATEN := ALLTRIM(REGATEN)
	STATUS := ALLTRIM(STATUS)
	CUSRP1 := ALLTRIM(CUSRP1)
	CUSRP2 := ALLTRIM(CUSRP2)
	CUSRP3 := ALLTRIM(CUSRP3)
	CUSRP4 := ALLTRIM(CUSRP4)
	CUSRP5 := ALLTRIM(CUSRP5)
	CMRP := ALLTRIM(CMRP)
	MOEDRP := ALLTRIM(MOEDRP)
	MOEDA := ALLTRIM(MOEDA)
	REVISAO := ALLTRIM(REVISAO)
	CMFIXO := ALLTRIM(CMFIXO)
	PMACNUT := ALLTRIM(PMACNUT)
	PMICNUT := ALLTRIM(PMICNUT)
	EMPOP := ALLTRIM(EMPOP)
	DIACTB := ALLTRIM(DIACTB)
	NODIA := ALLTRIM(NODIA)
	GARANTI := ALLTRIM(GARANTI)
	QTGANHO := ALLTRIM(QTGANHO)
	QTMAIOR := ALLTRIM(QTMAIOR)
	NRBPIMS := ALLTRIM(NRBPIMS)
	CODLAN := ALLTRIM(CODLAN)
	OKISS := ALLTRIM(OKISS)
	CHAVEF1 := ALLTRIM(CHAVEF1)
	PERIMP := ALLTRIM(PERIMP)
	VLRVI := ALLTRIM(VLRVI)
	VLRPD := ALLTRIM(VLRPD)


	DOC := UPPER(DOC)
	UM := UPPER(UM)

	exceptionList := {}
	exceptionList := u_DSD3Vld(FILIAL,COD,DLOCAL)
	if len(exceptionList)>0
		CONOUT("PROBLEMA DE VALIDACAO NA TABELA SD3")
		return "0"
	endif

	EMISSAO := u_strToDate(EMISSAO) //Funcao de conversao avancada no LIGDFILTER.prw
	DTLANC := u_strToDate(DTLANC) //Funcao de conversao avancada no LIGDFILTER.prw
	DTVALID := u_strToDate(DTVALID) //Funcao de conversao avancada no LIGDFILTER.prw

	DBSELECTAREA("SD3")
	DBSETORDER(INSIRA_MANUALMENTE)
	IF DBSEEK(INSIRA_MANUALMENTE)
		RECLOCK("SD3",.F.)
		SD3->D3_FILIAL := FILIAL
		SD3->D3_TM := TM
		SD3->D3_COD := COD
		SD3->D3_DESCRI := DESCRI
		SD3->D3_QUANT := QUANT
		SD3->D3_UM := UM
		SD3->D3_CF := CF
		SD3->D3_CONTA := CONTA
		SD3->D3_OP := OP
		SD3->D3_DLOCAL := DLOCAL
		SD3->D3_USOLICI := USOLICI
		SD3->D3_GRUPO := GRUPO
		SD3->D3_DOC := DOC
		SD3->D3_EMISSAO := EMISSAO
		SD3->D3_CUSTO1 := CUSTO1
		SD3->D3_CUSTO2 := CUSTO2
		SD3->D3_CUSTO3 := CUSTO3
		SD3->D3_CC := CC
		SD3->D3_CUSTO4 := CUSTO4
		SD3->D3_CUSTO5 := CUSTO5
		SD3->D3_PARCTOT := PARCTOT
		SD3->D3_ESTORNO := ESTORNO
		SD3->D3_NUMSEQ := NUMSEQ
		SD3->D3_SEGUM := SEGUM
		SD3->D3_NIVEL := NIVEL
		SD3->D3_QTSEGUM := QTSEGUM
		SD3->D3_TIPO := TIPO
		SD3->D3_USUARIO := USUARIO
		SD3->D3_REGWMS := REGWMS
		SD3->D3_PERDA := PERDA
		SD3->D3_DTLANC := DTLANC
		SD3->D3_TRT := TRT
		SD3->D3_IDENT := IDENT
		SD3->D3_SEQCALC := SEQCALC
		SD3->D3_CHAVE := CHAVE
		SD3->D3_RATEIO := RATEIO
		SD3->D3_LOTECTL := LOTECTL
		SD3->D3_DTVALID := DTVALID
		SD3->D3_NUMLOTE := NUMLOTE
		SD3->D3_LOCALIZ := LOCALIZ
		SD3->D3_NUMSERI := NUMSERI
		SD3->D3_CUSFF1 := CUSFF1
		SD3->D3_CUSFF2 := CUSFF2
		SD3->D3_CUSFF3 := CUSFF3
		SD3->D3_CUSFF4 := CUSFF4
		SD3->D3_CUSFF5 := CUSFF5
		SD3->D3_ITEM := ITEM
		SD3->D3_ITEMCTA := ITEMCTA
		SD3->D3_CLVL := CLVL
		SD3->D3_OK := OK
		SD3->D3_PROJPMS := PROJPMS
		SD3->D3_TASKPMS := TASKPMS
		SD3->D3_ORDEM := ORDEM
		SD3->D3_CODGRP := CODGRP
		SD3->D3_CODITE := CODITE
		SD3->D3_SERVIC := SERVIC
		SD3->D3_STSERV := STSERV
		SD3->D3_OSTEC := OSTEC
		SD3->D3_POTENCI := POTENCI
		SD3->D3_TPESTR := TPESTR
		SD3->D3_ITEMSWN := ITEMSWN
		SD3->D3_DOCSWN := DOCSWN
		SD3->D3_ITEMGRD := ITEMGRD
		SD3->D3_REGATEN := REGATEN
		SD3->D3_STATUS := STATUS
		SD3->D3_CUSRP1 := CUSRP1
		SD3->D3_CUSRP2 := CUSRP2
		SD3->D3_CUSRP3 := CUSRP3
		SD3->D3_CUSRP4 := CUSRP4
		SD3->D3_CUSRP5 := CUSRP5
		SD3->D3_CMRP := CMRP
		SD3->D3_MOEDRP := MOEDRP
		SD3->D3_MOEDA := MOEDA
		SD3->D3_REVISAO := REVISAO
		SD3->D3_CMFIXO := CMFIXO
		SD3->D3_PMACNUT := PMACNUT
		SD3->D3_PMICNUT := PMICNUT
		SD3->D3_EMPOP := EMPOP
		SD3->D3_DIACTB := DIACTB
		SD3->D3_NODIA := NODIA
		SD3->D3_GARANTI := GARANTI
		SD3->D3_QTGANHO := QTGANHO
		SD3->D3_QTMAIOR := QTMAIOR
		SD3->D3_NRBPIMS := NRBPIMS
		SD3->D3_CODLAN := CODLAN
		SD3->D3_OKISS := OKISS
		SD3->D3_CHAVEF1 := CHAVEF1
		SD3->D3_PERIMP := PERIMP
		SD3->D3_VLRVI := VLRVI
		SD3->D3_VLRPD := VLRPD
		MSUNLOCK()
	endif
return 

user function DSD3Vld(FILIAL,COD,DLOCAL)
	_area := getArea()
	exceptionList := {}
	FILIAL := ALLTRIM(FILIAL)
	COD := ALLTRIM(COD)
	DLOCAL := ALLTRIM(DLOCAL)

	if((FILIAL = nil .or. FILIAL==""), aAdd(exceptionList,"FILIAL"), .F.)
	if((COD = nil .or. COD==""), aAdd(exceptionList,"COD"), .F.)
	if((DLOCAL = nil .or. DLOCAL==""), aAdd(exceptionList,"DLOCAL"), .F.)

	DBSELECTAREA("SB1")
	DBSETORDER(1)
	if (DBSEEK(XFILIAL("SB1")+COD)) = .F.
		aAdd(exceptionList,"COD " + COD+" NAO EXISTE EM SB1")
	end
	
	DBSELECTAREA("NNR")
	DBSETORDER(1)
	IF (DBSEEK(XFILIAL("NNR")+DLOCAL)) = .F.
		aAdd(exceptionList,"ARMAZEM "+DLOCAL+" NAO EXISTEM EM NNR")
	ENDIF
	
	if(len(exceptionList)>0)
		CONOUT("PROBLEMA DE VALIDACAO NA TABELA SD3, CAMPOS:")
		for i:=1 to len(exceptionList)
		 	CONOUT(exceptionList[i])
		next        
	endif	
	restarea(_area)
return exceptionList