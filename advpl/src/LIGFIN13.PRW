#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���PROGRAMA  �LIGFIN01 �AUTOR  �DANIEL GOUVEA          �DATA � 20/12/16   ���
�������������������������������������������������������������������������͹��
���DESC.     � ROTINA QUE DEFINE A REGRA PARA GERACAO DA PARCELA DAS CR   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���USO       � LIGUE                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                  
USER FUNCTION LIGFIN13()
************************************  
LOCAL _cParc := "1"
Local aArea := getarea()
Local _cli := GETMV("MV_UCLIPRF")

if SF2->F2_CLIENTE $ _cli
	cQuery := " SELECT MAX(E1_PARCELA) AS E1_PARC "
	cQuery += " WHERE E1_CLIENTE='"+SF2->F2_CLIENTE+"' AND D_E_L_E_T_=' '
	TCQUERY cQuery NEW ALIAS "TEMP"
	if !eof()
		_cParc := soma1(TEMP->E1_PARC,3)
	endif
	TEMP->(dbclosearea())
endif

restarea(_area)
RETURN(_cParc)