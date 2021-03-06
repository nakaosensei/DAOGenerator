#include "TOTVS.CH"
#include 'protheus.ch'
#include 'parmtype.ch'

user function MT110CFM()
	
	Local ExpC1  := PARAMIXB[1] //N�MERO DA SOLICITA��O     
	Local ExpN1  := PARAMIXB[2] //STATUS DA SOLICITA��O

	dbSelectArea("SC1")
	dbsetorder(1)
	dbGoTop()

	if dbseek(xFilial() + ExpC1)
	
		//MsgInfo(UsrRetMail(C1_USER), 'Solicita��o de compras')
		
		IF ExpN1 == 1 // STATUS = APROVADO
		
			//MsgInfo("Aprova��o efetuada com sucesso!")
			_data := Dtoc(Date())
			
			_cMSG := "<p>A solicita��o de compra n�: <b>" +  SC1->C1_NUM + "</b>, foi aprovada na data : " + _data  +  ".</p>"
			_cMSG += "<p>Respons�vel pela aprova��o : <b>" + UsrRetName(RetCodUsr()) + ".</b></p>"
			_cMSG += "<p>PRODUTO : " + SC1->C1_DESCRI + " QTDE : " + STR(SC1->C1_QUANT) + ".</p>"
			_cMSG += "<p>OBS : " + SC1->C1_OBS + " QTDE : " + STR(SC1->C1_QUANT) + ".</p>"
			_cMSG += "<p>E-mail enviado automaticamente pelo Microsiga Protheus.</p>"
			
			//Envia o e-mail para o solicitante
			U_LIGGEN03(UsrRetMail(C1_USER),"","", "Liberado para Cotar", _cMSG,.T.,"")
			
			//Envia e-mail para o setor de compras
			//U_LIGGEN03("vinicius.dias@ligue.net","","","Solicita��o Aprovada", _cMSG,.T.,"")
					
/**********************************************************************************************************************************************************/

		ELSE // STATUS = REJEITADA OU BLOQUEADA
			
			//Desenha a tela de observa��o
			u_TGet()
			
			_data2 := Dtoc(Date())
			
			_cMSG2 := "<p>A solicita��o de compra n�: <b>" +  SC1->C1_NUM + "</b>, foi rejeitada/bloqueada na data : " + _data2  +  ".</p>"
			_cMSG2 += "<p>Respons�vel pela rejei��o/bloqueio : <b>" + UsrRetName(RetCodUsr()) + ".</b></p>"
			_cMSG2 += "<p>PRODUTO : " + SC1->C1_DESCRI + " QTDE : " + STR(SC1->C1_QUANT) + ".</p>"
			_cMSG2 += "<p>OBS : " + SC1->C1_OBS + " QTDE : " + STR(SC1->C1_QUANT) + ".</p>"
			_cMSG2 += "<p><b>OBSERVA��O REPROVA��O:</b> " + SC1->C1_UOBS1 + ".</p>"
			_cMSG2 += "<p>E-mail enviado automaticamente pelo Microsiga Protheus.</p>"			
			
			//Envia o e-mail para o solicitante
			U_LIGGEN03(UsrRetMail(C1_USER),"","", "Solicita��o Rejeitada/Bloqueada", _cMSG2,.T.,"")
			
			//U_LIGGEN03("vinicius.dias@ligue.net","","","Solicita��o Rejeitada/Bloqueada", _cMSG2,.T.,"")
			
		ENDIF
		
	else
		MsgInfo("Nao foi poss�vel localizar a solicita��o.")
		
	endif
return


User Function TGet()
  DEFINE DIALOG oDlg TITLE "Digite a observa��o da Rejei��o/Bloqueio" FROM 180,180 TO 350,500 PIXEL
  // Cria o TEXT BOX
  private oTGet1
  Private cTGet1 := SC1->C1_UOBS1
 // oTGet1 := TGet():New( 01,01,{||cTGet1},oDlg,162.1,050,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )
  @ 01,01 Get cTGet1 Size 161,050 MEMO of oDlg Pixel
  // Cria o bot�o "Confirmar"  
  @ 058,068 BUTTON "Confirmar" SIZE 030, 020 PIXEL OF oDlg ACTION (u_verifica(ALLTRIM(cTGet1)))
  
  ACTIVATE DIALOG oDlg CENTERED
Return

User Function confirma(_pTexto)
	RECLOCK("SC1",.F.)
		SC1->C1_UOBS1 := _pTexto
	MSUNLOCK()	
Return

User Function verifica(_ver)
	if EMPTY(_ver)
		MsgInfo("Digite uma observa��o")
	else
		oDlg:End()
		u_confirma(ALLTRIM(cTGet1))
	endif
Return





