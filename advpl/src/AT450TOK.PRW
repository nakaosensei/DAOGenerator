#include 'protheus.ch'
#include 'parmtype.ch'

user function AT450TOK()
Local _cAssunOS := getmv("MV_UASSUNT")
Local _nCtr := M->AB6_UNUMCT
Local lRet := .T.
LOCAL _item    := ASCAN(AHEADER,{|X|ALLTRIM(X[2])=="AB7_ITEM"})
LOCAL _produto := ASCAN(AHEADER,{|X|ALLTRIM(X[2])=="AB7_CODPRO"})
Local _i
Local _aDel := {}
if AB6->AB6_USITU1 == _cAssunOS //Verifica o Assunto == "Ret. Equip" e se a O.S est� encerrada
	
	if EMPTY(_nCtr) // Antes de criar a O.S, verifica se o CONTRATO est� vazio
		MSGALERT("O n�mero do contrato est� em branco. � necess�rio preenche-lo.","N�mero do contrato est� vazio")
		lRet := .F.
	endif
endif
 
/*
//TRATAMENTO PRA EXCLUIR DO ADB O QUE FOR DELETADO PELO AB7, PERGUNTANDO PRO USUARIO
if lRet
	for _n:=1 to len(aCols)
		if aCols[_n,len(aHeader)+1] //SOMENTE SE ESTIVER DELETADO
			dbselectarea("SZ2")
			dbsetorder(2)//Z2_FILIAL+Z2_NUMOS+Z2_PRODUTO+Z2_ITEMOS
			if dbseek(xFilial()+M->AB6_NUMOS+aCols[_n,_produto]+aCols[_n,_item])
				if msgyesno("Deseja realmente prosseguir, mesmo sabendo que o produto "+ALLTRIM(aCols[_n,_produto])+" esta no contrato "+;
					SZ2->Z2_NUMCTR+" item "+SZ2->Z2_ITEMCTR+" e sera excluido do contrato?","")
					aadd(_aDel,_n)
				else
					lRet := .F.
				endif
			endif
		endif
	next
	if lRet .and. len(_aDel)>0
		for _n := 1 to len(_aDel)
			dbselectarea("SZ2")
			dbsetorder(2)//Z2_FILIAL+Z2_NUMOS+Z2_PRODUTO+Z2_ITEMOS
			if dbseek(xFilial()+M->AB6_NUMOS+aCols[_aDel[_n],_produto]+aCols[_aDel[_n],_item])
				dbselectarea("ADB")
				dbsetorder(1)//ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
				if dbseek(xFilial()+SZ2->Z2_NUMCTR+SZ2->Z2_ITEMCTR)
					reclock("ADB",.F.)
					dbdelete()
					msunlock()
				endif
			endif
		next
	endif
endif
*/   

return lRet
