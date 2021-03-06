#include "TOTVS.CH"
#include "TOPCONN.CH" 

User Function ligcal03()

DEFINE DIALOG OMAINWND TITLE "Relat�rio de Prospect por Data/cliente" FROM 180,180 TO 550,700 PIXEL

Private	CPERG       := "LIGCAL03  "
Private	OFONT1      := TFONT():NEW( "ARIAL",,10,,.T.,,,,,.F.)
Private	OFONT2      := TFONT():NEW( "ARIAL",,07,,.F.,,,,,.F.)
Private	nLin		:= 0100		// Linha que o sistema esta imprimindo.

validperg()   //Chama perguntas
If !pergunte(cPerg,.T.)
	Return()
Endif

oPrint := TMSPrinter():New("Relat�rio de Prospect por Data/Operador")// Monta objeto para impress�o

oPrint:SetPortrait()// Define orienta��o da p�gina para Retrato, pode ser usado oPrint:SetLandscape para Paisagem

oPrint:Setup()// Mostra janela de configura��o de impress�o

oPrint:StartPage()// Inicia p�gina

oPrint:setPaperSize( DMPAPER_A4 )
// Insere Linhas
oPrint:Box(0050,0050,3300,2380) //Area total

//���������������������������������Ŀ
//�Imprime o cabecalho da empresa. !�
//�����������������������������������

	nLin := 0080 //Lista Parametros

	oPrint:Say(nLin,0100,"Relat�rio de Inclus�o Prospect por Data/Operador",oFont1)
	oPrint:Say(nLin,1200,"De",oFont1)
	oPrint:Say(nLin,1450,"At�",oFont1)
	oPrint:Say(nLin,2000,"Operador",oFont1)
	nLin += 080
	oPrint:Say(nLin,1200,DTOC(MV_PAR01),oFont2)
	oPrint:Say(nLin,1450,DTOC(MV_PAR02),oFont2)
	oPrint:Say(nLin,2000,usrfullname(MV_PAR04),oFont2)

//Lista Itens QUERY

Query()

// Visualiza a impress�o
oPrint:EndPage()

// Mostra tela de visualiza��o de impress�o
oPrint:Preview()

Return                                                                                                                       

//___________________________________________________________________________________________________________________________                                                
//�������������������������������������Ŀ
//�Fun��o com Array para Imprime Itens !�
//���������������������������������������

Static Function Query()  
                     
Private nTota1 := 0
Private nTota2 := 0
Private nTota3 := 0
Private nTota4 := 0
Private nTota5 := 0
aDados	:= {}// Array

CQUERY := ""   
CQUERY += " SELECT US_COD, US_LOJA, US_NOME, US_END, US_MUN, US_BAIRRO, US_EST,US_DDD, US_TEL, US_EMAIL"
CQUERY += " FROM "+RETSQLNAME("SUS") + " SUS "
CQUERY += " WHERE US_UDTINCL >= '"+DTOS(MV_PAR01)+"' AND US_UDTINCL <= '"+DTOS(MV_PAR02)+"' AND US_UIDUSER >= '"+MV_PAR03+"' AND US_UIDUSER <= '"+MV_PAR04+"'"
CQUERY += " AND SUS.D_E_L_E_T_ = ''"
IF SELECT("STUDY")!=0
	STUDY->(DBCLOSEAREA())
ENDIF
TCQUERY CQUERY NEW ALIAS "STUDY"
dbSelectArea("STUDY") 
dbGoTop()

	nLin += 100
	oPrint:Say(nLin,0070,"Codigo",oFont1)
	oPrint:Say(nLin,0250,"Loja",oFont1)
	oPrint:Say(nLin,0350,"Nome",oFont1)
	oPrint:Say(nLin,0650,"Endere�o",oFont1)
	oPrint:Say(nLin,1050,"Munic�pio",oFont1)
	oPrint:Say(nLin,1300,"Bairro",oFont1)
	oPrint:Say(nLin,1500,"UF",oFont1)
	oPrint:Say(nLin,1600,"DDD",oFont1)
	oPrint:Say(nLin,1700,"Tel",oFont1)
	oPrint:Say(nLin,2000,"EMAIL",oFont1)

While ! STUDY->(EOF())	

	Aadd(aDados, 	{ STUDY->US_COD,;
					STUDY->US_LOJA ,;
					STUDY->US_NOME ,;
					STUDY->US_END ,;
					STUDY->US_MUN ,;
					STUDY->US_BAIRRO ,;
					STUDY->US_EST ,;
					STUDY->US_DDD ,;
					STUDY->US_TEL ,;
					STUDY->US_EMAIL } )



   
	If nLin > 3000
	oPrint:EndPage()	
	oPrint:StartPage()// Inicia p�gina
	nLin := 100
	EndIf

dbselectarea("STUDY") 		
dbSkip()
enddo	
	
	nLin := 300				
	for n:=1 to len(aDados) 
	nLin += 0070
	oPrint:Say(nLin,0070,aDados[n,1],oFont2)
	oPrint:Say(nLin,0250,aDados[n,2],oFont2)
	oPrint:Say(nLin,0350,aDados[n,3],oFont2) 
	oPrint:Say(nLin,0650,aDados[n,4],oFont2) 
	oPrint:Say(nLin,1050,aDados[n,5],oFont2) 
	oPrint:Say(nLin,1300,aDados[n,6],oFont2) 
	oPrint:Say(nLin,1500,aDados[n,7],oFont2) 
	oPrint:Say(nLin,1600,aDados[n,8],oFont2) 
	oPrint:Say(nLin,1700,aDados[n,9],oFont2) 
	oPrint:Say(nLin,2000,aDados[n,10],oFont2) 
	   
	If nLin > 3000
	oPrint:EndPage()	
	oPrint:StartPage()// Inicia p�gina
	OPRINT:BOX(0100,0050,3300,2380)
	nLin := 050
	oPrint:Say(nLin,0070,"Codigo",oFont1)
	oPrint:Say(nLin,0250,"Loja",oFont1)
	oPrint:Say(nLin,0350,"Nome",oFont1)
	oPrint:Say(nLin,0650,"Endere�o",oFont1)
	oPrint:Say(nLin,1050,"Munic�pio",oFont1)
	oPrint:Say(nLin,1300,"Bairro",oFont1)
	oPrint:Say(nLin,1500,"UF",oFont1)
	oPrint:Say(nLin,1600,"DDD",oFont1)
	oPrint:Say(nLin,1700,"Tel",oFont1)
	oPrint:Say(nLin,2000,"EMAIL",oFont1)
	nLin := 130
	EndIf	

	next n  
	
DBSELECTAREA("STUDY")
STUDY->(DBCLOSEAREA())
Return              
//_________________________________________________________________________________________________________________________________________________________________
Static Function ValidPerg
LOCAL _AREA := GETAREA()
LOCAL AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
CPERG 	:= PADR(CPERG,10)

AADD(AREGS,{CPERG,"01","De Emiss�o  ?  "," ?"," ?","MV_CH01","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{CPERG,"02","At� Emiss�o ?  "," ?"," ?","MV_CH02","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{CPERG,"03","De Usu�rio  ?  "," ?"," ?","MV_CH03","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{CPERG,"04","At� Usu�rio ?  "," ?"," ?","MV_CH04","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})


FOR I:=1 TO LEN(AREGS)
	IF !DBSEEK(CPERG+AREGS[I,2])
		RECLOCK("SX1",.T.)
		FOR J:=1 TO FCOUNT()
			IF J <= LEN(AREGS[I])
				FIELDPUT(J,AREGS[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
RESTAREA(_AREA)
RETURN