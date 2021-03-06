#include "rwmake.ch"
user function LIGCAL02()
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","U_LIGCAL2C",0,3} ,;
{"Televendas","U_LIGCAL2A",0,3},;
{"Chamado T�cnico","U_LIGCAL2B",0,3},;  
{"Renova��o","U_LIGCAL2F",0,3},; 
{"Legenda","U_LIGCAL2D",0,3},;  
{"Prospec","U_LIGCAL2E",0,3},; 
{"Tracker","U_LIGCAL04",0,3},; 
{"Mapa","U_ABREMAP",0,2},; 
{"Viabilidade","U_AB6AB7A_MV",0,2},; 
{"Contrato","U_mBrwADA",0,3}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ADE"

Private cCadastro := "Op��es de Teleatendimento"

aCORES := {}
AAdd(aCORES, {"ADE_USITUA == ' '", "BR_BRANCO"} )
AAdd(aCORES, {"ADE_USITUA == '1'", "BR_VERDE"  } )
AAdd(aCORES, {"ADE_USITUA == '2'", "BR_AMARELO"} )
AAdd(aCORES, {"ADE_USITUA == '3'", "BR_AZUL"} )
AAdd(aCORES, {"ADE_USITUA == '4'", "BR_MARROM"} )

dbSelectArea("ADE")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCORES)

Return

User Function LIGCAL2A()
//funcao pra chamar o call center
Local _area := getarea()

//trecho pra transformar o prospect em cliente, se necessario
if ADE->ADE_ENTIDA=='SUS' //se for prospect
	dbselectarea("SUS")
	dbsetorder(1)       //US_FILIAL+US_COD+US_LOJA
	if dbseek(xFilial()+SUBSTR(ADE->ADE_CHAVE,1,12))
		if empty(alltrim(SUS->US_CGC))
			alert("Prospect "+ALLTRIM(SUS->US_NOME)+" est� sem CNPJ/CPF, impossivel continuar. Atualize o contato e prossiga. Codigo do contato:"+SUS->US_COD+SUS->US_LOJA)
			restarea(_area)
			return
		endif
		
		dbselectarea("SA1")
		dbsetorder(3)
		if dbseek(xFilial()+SUS->US_CGC)
			reclock("SUS",.f.)
			SUS->US_STATUS  := "6"
			SUS->US_CODCLI  := SA1->A1_COD
			SUS->US_LOJACLI := SA1->A1_LOJA
			msunlock()
			reclock("ADE",.f.)
			ADE->ADE_ENTIDA := "SA1"
			ADE->ADE_CHAVE  := SA1->A1_COD+SA1->A1_LOJA
			msunlock()
		else
			reclock("SA1",.T.)
			SA1->A1_FILIAL := xFilial("SA1")
			SA1->A1_CGC    := SUS->US_CGC
			SA1->A1_COD    := SUBSTR(SUS->US_CGC,1,9)
			if LEN(alltrim(SUS->US_CGC))==11 //CPF
				SA1->A1_LOJA := "001"
				SA1->A1_PESSOA := "F"
			else
				SA1->A1_LOJA := SUBSTR(SUS->US_CGC,10,3)
				SA1->A1_PESSOA := "J"
			endif
			SA1->A1_NOME   := SUS->US_NOME
			SA1->A1_NREDUZ := SUS->US_NREDUZ
			SA1->A1_EMAIL  := SUS->US_EMAIL
			SA1->A1_END    := SUS->US_END
			SA1->A1_EST    := SUS->US_EST
			SA1->A1_BAIRRO := SUS->US_BAIRRO
			SA1->A1_CEP    := SUS->US_CEP
			SA1->A1_TIPO   := SUS->US_TIPO
			SA1->A1_DDD    := SUS->US_DDD
			SA1->A1_TEL    := SUS->US_TEL
			SA1->A1_FAX    := SUS->US_FAX
			SA1->A1_HPAGE  := SUS->US_URL
			SA1->A1_MUN    := SUS->US_MUN
			SA1->A1_NATUREZ:= "103001    "
			dbselectarea("CC2")
			dbsetorder(4) //CC2_FILIAL+CC2_EST+CC2_MUN
			if dbseek(xFilial()+SUS->US_EST+ALLTRIM(SUS->US_MUN))
				SA1->A1_COD_MUN := CC2->CC2_CODMUN
			endif
			msunlock()
			
			reclock("SUS",.f.)
			SUS->US_STATUS  := "6"
			SUS->US_CODCLI  := SA1->A1_COD
			SUS->US_LOJACLI := SA1->A1_LOJA
			msunlock()
			
			reclock("ADE",.f.)
			ADE->ADE_ENTIDA := "SA1"
			ADE->ADE_CHAVE  := SA1->A1_COD+SA1->A1_LOJA
			msunlock()
			
			msginfo("Prospect alterado pra cliente com sucesso.")
		endif //IF DO Dbseek do SA1
	else
		alert("Prospect "+ALLTRIM(SUS->US_NOME)+" n�o foi encontrado. Impossivel continuar. Codigo do contato:"+SUS->US_COD+SUS->US_LOJA)
		restarea(_area)
		return
	endif
endif                                   
           
dbselectarea("SU7")
dbsetorder(4)//U7_FILIAL+U7_CODUSU
if dbseek(xFilial()+__cUserID)
	reclock("SU7",.f.)
	SU7->U7_TIPOATE := "2" //SOMENTE TELEVENDAS
	msunlock()
else
     alert("Usuario nao esta cadastrado como operador. Nao pode incluir televendas.")
     return
endif        
                 
BEGIN TRANSACTION
mafisini(SUBSTR(ADE->ADE_CHAVE,1,9),SUBSTR(ADE->ADE_CHAVE,10,3),"C","N")

dbselectarea("SUB")
dbselectarea("SUA")
TK271CallCenter("SUA",SUA->(RECNO()),3)
restarea(_area)

END TRANSACTION                 

if type('_lFechou')=="L"
	if !_lFechou
		reclock("ADE",.f.)
		if ADE->ADE_USITUA=="3"
			ADE->ADE_USITUA := "4"
		else
			ADE->ADE_USITUA := "2"
		endif
		msunlock()
	endif
endif
               /*
dbselectarea("SU7")
dbsetorder(4)//U7_FILIAL+U7_CODUSU
if dbseek(xFilial()+__cUserID)
	reclock("SU7",.f.)
	SU7->U7_TIPOATE := "4" //TODOS
	msunlock()
endif
                 */
return

User Function LIGCAL2B()
//funcao pra chamar o chamado tecnico
Local _area := getarea()
IF ADE->ADE_ENTIDA=="SA1"
	dbselectarea("AB1")
	_aret := At300Inclu("AB1",AB1->(RECNO()),3)
	
	if _aret[1]
		restarea(_area)
		reclock("ADE",.f.)
		if ADE->ADE_USITUA=="2"
			ADE->ADE_USITUA := "4"
		else
			ADE->ADE_USITUA := "3"
		endif
		msunlock()
	endif
else
	alert("Somente para clientes.")
endif
return

User Function LIGCAL2C()
//funcao pra incluir o teleatendimento
Local _area := getarea()

BEGIN TRANSACTION
dbselectarea("ADE")
_ret := TK503AOpc("ADE",ADE->(recno()),3)      
IF _ret
reclock("ADE",.f.)
if ADE->ADE_ENTIDA=="SUS" //PROSPECT
	ADE->ADE_USITUA := "1"
endif                            
msunlock()
endif                       
END TRANSACTION
restarea(_area)
return

User Function LIGCAL2D()
Local aLeg 		:= {}
Aadd(aLeg,{"BR_BRANCO"   , OemToAnsi( "Sem vinculo")})
Aadd(aLeg,{"BR_VERDE"   , OemToAnsi( "Atendimento")})
Aadd(aLeg,{"BR_AMARELO"   , OemToAnsi( "Venda")})
Aadd(aLeg,{"BR_AZUL"   , OemToAnsi( "Chamado T�cnico")})
Aadd(aLeg,{"BR_MARROM"   , OemToAnsi( "Venda e Chamado")})
BrwLegenda( cCadastro   , "Legendas",aLeg)
Return(Nil)     

User Function LIGCAL2E()
	//Atualizar Prospec ou Cliente
	_area := getarea()
	_aSUS := SUS->(getarea())
	
	
	dbSELECTAREA("SUS")
	dbSETORDER(1) //FILIAL + CODCLI + LOJA
	if dbSeek(xFilial("SUS") + SUBSTR(ADE->ADE_CHAVE, 0, 9) + SUBSTR(ADE->ADE_CHAVE, 10, 3))
			AxAltera('SUS',,4)
	ELSE
		dbSELECTAREA("SA1")
		dbSETORDER(1) //FILIAL + CODCLI + LOJA
		if dbSeek(xFilial("SA1") +SUBSTR(ADE->ADE_CHAVE, 0, 9) + SUBSTR(ADE->ADE_CHAVE, 10, 3))
			AxAltera('SA1',,4)
		ELSE
			MSGINFO("Prospec/Cliente n�o foi encontrado ! ","Informa��o")
		endif
	endif
		
	restarea(_aSUS)
	restarea(_area)
RETURN    

User Function LIGCAL2F()	
	Local _area := getarea()
	Local _CPERG 	:= PADR("CAL03A",10)  

	if msgyesno("Contrato para renova��o tem altera��o de valores ou itens ?") 
		U_LIGCAL2A()
	else                              
   		M->ADE_CHAVE := ADE->ADE_CHAVE 
		IF !PERGUNTE(_CPERG)
	  		RETURN
   		ENDIF
	
		U_LIGCAL06(MV_PAR01, MV_PAR02, MV_PAR03,MV_PAR04,ADE->ADE_CODIGO)   
			
		M->ADE_CHAVE := NIL     
		
		MSGINFO("A rotina foi executada ! ","Informa��o")
	endif
	
	restarea(_area)
RETURN

user function AbreMap()
local sURL
IF ADE->ADE_ENTIDA=="SA1"
	sURL = "http://maps.google.com.br/maps?f=q&source=s_q&hl=pt-BR&geocode=&q="+ALLTRIM(SA1->A1_END)+", "+ALLTRIM(SA1->A1_MUN)+", "+ALLTRIM(SA1->A1_EST)
ELSEIF ADE->ADE_ENTIDA=="SUS"
	sURL = "http://maps.google.com.br/maps?f=q&source=s_q&hl=pt-BR&geocode=&q="+ALLTRIM(SUS->US_END)+", "+ALLTRIM(SUS->US_MUN)+", "+ALLTRIM(SUS->US_EST)
ENDIF
SHELLEXECUTE("open",sURL,"","",5)
Return