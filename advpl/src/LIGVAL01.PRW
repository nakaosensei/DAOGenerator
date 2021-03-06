#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���PROGRAMA  �LIGVAL01  �AUTOR  �ROBSON ADRIANO      � DATA �  10/07/14   ���
�������������������������������������������������������������������������͹��
���DESC.     �PRENCHE CODIGO DO MUNICIPIO NA VALIDACAO DO CEP			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���USO       � LIG                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                         
USER FUNCTION LIGVAL01()       
	
	DBSELECTAREA("CC2")
	DBSETORDER(4)         
	DBGOTOP()
	IF DBSEEK(XFILIAL("CC2") + M->A2_EST + UPPER(NOACENTO(ALLTRIM(M->A2_MUN)))) 
   		M->A2_COD_MUN = CC2->CC2_CODMUN
	ENDIF

RETURN(.T.)  

static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "�����"+"�����"
Local cCircu := "�����"+"�����"
Local cTrema := "�����"+"�����"
Local cCrase := "�����"+"�����"
Local cTio   := "����"
Local cCecid := "��"
Local cMaior := "&lt;"
Local cMenor := "&gt;"
 
For nX:= 1 To Len(cString)
               cChar:=SubStr(cString, nX, 1)
               IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
                              nY:= At(cChar,cAgudo)
                              If nY > 0
                                            cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
                              EndIf
                              nY:= At(cChar,cCircu)
                              If nY > 0
                                            cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
                              EndIf
                              nY:= At(cChar,cTrema)
                              If nY > 0
                                            cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
                              EndIf
                              nY:= At(cChar,cCrase)
                              If nY > 0
                                            cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
                              EndIf                   
                              nY:= At(cChar,cTio)
                              If nY > 0         
                                            cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
                              EndIf                   
                              nY:= At(cChar,cCecid)
                              If nY > 0
                                            cString := StrTran(cString,cChar,SubStr("cC",nY,1))
                              EndIf
               Endif
Next
 
If cMaior$ cString
               cString := strTran( cString, cMaior, "" )
EndIf
If cMenor$ cString
               cString := strTran( cString, cMenor, "" )
EndIf
 
For nX:=1 To Len(cString)
               cChar:=SubStr(cString, nX, 1)
               If (Asc(cChar) < 32 .Or. Asc(cChar) > 123) .and. !cChar $ '|'
                              cString:=StrTran(cString,cChar,".")
               Endif
Next nX
Return cString

