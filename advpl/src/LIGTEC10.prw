#Include 'Protheus.ch'

/*
LIGTEC10 - ALOCA��O DE T�CNICOS E ASSUNTO NA ORDEM DE SERVI�O
AUTOR    - ROBSON ADRIANO
DATA     - 15/12/14
*/

User Function LIGTEC10(_pNumOS)
Local _area := getarea()
Local _aAB6 := AB6->(getarea())

Private oDlg
Private oButton1
Private oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
Private oGet1
Private cGet1 := SPACE(10) //SERIAL, VAI GRAVAR NO AA3_NUMSER
Private oGet2
Private cGet2 := SPACE(40) //SERIAL, VAI GRAVAR NO AA3_NUMSER
Private oSay1
Private oSay2
Private oCombo
Private cCombo


	IF AB2->AB2_CLASSI == "005"
		cGet1 := ALLTRIM(getmv("MV_UATGEO"))
		cGet2 := POSICIONE("AA1",1,XFILIAL("AA1")+cGet1,"AA1_NOMTEC") 
		cCombo := "6"
	ELSE
		cCombo := "0" //- Variavel que receber� o conte�do
		aItem := {"0=Padrao","1=Instalacao","2=Manutencao","3=Ativacao","4=Suporte Tecnico","5=Ampliacao","6=Viabilidade","7=Boas Vindas"} // array com os itens
									
		DEFINE MSDIALOG oDlg TITLE "INFOMAR T�CNICO / ASSUNTO " FROM 000, 000  TO 190, 400 COLORS 0, 16777215 PIXEL
				@ 010, 002 SAY oSay1 PROMPT "T�cnico: " SIZE 028, 007 OF oDlg COLORS 0, 16777215 PIXEL
				@ 010, 030 MSGET oGet1 VAR cGet1 SIZE 029, 010 OF oDlg F3 "A11" VALID vldAA1() COLORS 0, 16777215 PIXEL
				@ 010, 063 MSGET oGet2 VAR cGet2 SIZE 082, 010 OF oDlg WHEN .F. COLORS 0, 16777215 PIXEL
		 		
		 		@ 025, 004 SAY oSay2 PROMPT "Assunto: " SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
				@ 025, 030 ComboBox oCombo Var cCombo Items aItem Size 085,09 Of oDlg Pixel 
				
				@ 062, 101 BUTTON oButton1 PROMPT "OK" action oDlg:End() SIZE 037, 012 OF oDlg PIXEL
				@ 062, 151 BUTTON oButton2 PROMPT "Cancelar" ACTION oDlg:End() SIZE 037, 012 OF oDlg PIXEL //WHEN botaoCan() PIXEL
			
		ACTIVATE MSDIALOG oDlg					
	 ENDIF
	 
	dbselectarea("AB6")
	dbsetorder(1)
	if dbseek(xFilial()+ _pNumOS)
		reclock("AB6",.F.)
			AB6->AB6_UCODAT	:= cGet1
			AB6->AB6_ATEND	:= cGet2
			AB6->AB6_USITU1	:= cCombo
		msunlock()		
	endif
	
				
restarea(_aAB6)	  	
restarea(_area)		  		  	
Return

static function vldAA1()
Local lRet := .f.
Local _area := getarea()
	
	dbselectarea("AA1")
	dbsetorder(1)
	if dbseek(xFilial()+cGet1)
		cGet12 := AA1->AA1_NOMTEC
		//oDlg1:oGet11:refresh()
		lRet := .t.
	else
		alert("Favor informar um t�cnico v�lido.")
	endif
restarea(_area)
return lRet


