#INCLUDE "Protheus.ch"
#INCLUDE "COLORS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTB004   � Autor � Alvaro L Rocha     � Data �  21/07/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Imprimir Relat�rio Raz�o por Centro de Custo p.Dr.Antonio  ���
�������������������������������������������������������������������������͹��
���Uso       � CERATTI                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RCTB005()

Local oReport := ReportDef()
oReport:PrintDialog()

U_MCERLOG()
Return()

//������������������������������������������������������������������Ŀ
//� Function ReportDef                                               �
//��������������������������������������������������������������������
Static Function ReportDef()
Local oSection1	 := Nil
Local oDetalhes	 := Nil
Local cDescr	 := "Este programa ir� imprimir Relat�rio Despesas"
Local cTitulo	 := "Relat�rio Despesas"
Local cAliasRep	 := GetNextAlias()

Private cPerg := "RCTB05"
//Ajusta as Perguntas
CriaPerg(@cPerg)
Pergunte(cPerg,.F.)

oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport| ReportPrint(oReport,@cAliasRep)},cDescr)
oReport:SetLandscape()
oReport:nFontBody := 8
oReport:HideParamPage()

//��������������������������������������������������������������Ŀ
//� Sessao 1 (oSection1)                                         �
//����������������������������������������������������������������
oSection1 := TRSection():New(oReport,"Relat�rio Despesas",{("CT2")},,/*Campos do SX3*/,/*Campos do SIX*/)
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"EMPRESA"	,"CT2"	,"Empresa"		,/*Mascara*/,3	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"CT2_DATA"	,"CT2"	,"Data"			,/*Mascara*/,10	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"CONTA"		,"CT2"	,"Conta"		,/*Mascara*/,12	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"CT1_DESC01"	,"CT2"	,"Desc.Conta"	,/*Mascara*/,25	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"CC"			,"CT2"	,"Centro Custo"	,/*Mascara*/,12	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"DESC_CC"	,"CT2"	,"Desc.CC"		,/*Mascara*/,15	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"SUBCC"		,"CT2"	,"Sub.CC"		,/*Mascara*/,12	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"DESC_SUBCC"	,"CT2"	,"Desc.Sub.CC"	,/*Mascara*/,20	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"CT2_HIST"	,"CT2"	,"Hist�rico"	,/*Mascara*/,30	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"DEBITO"		,"CT2"	,"Vl.Debito"	,/*Mascara*/,18	,/*lPixel*/	,,"RIGHT",,,,,,,, )
TRCell():New(oSection1,"CREDITO"	,"CT2"	,"Vl.Credito"	,/*Mascara*/,18	,/*lPixel*/	,,"RIGHT",,,,,,,, )
TRCell():New(oSection1,"CT2_LOTE"	,"CT2"	,"Lote"			,/*Mascara*/,06	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"CT2_SBLOTE"	,"CT2"	,"SubLote"		,/*Mascara*/,03	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"CT2_DOC"	,"CT2"	,"Documento"	,/*Mascara*/,06	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"CT2_LINHA"	,"CT2"	,"Linha"		,/*Mascara*/,03	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"CT2_LP"		,"CT2"	,"LP"			,/*Mascara*/,06	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
TRCell():New(oSection1,"CT2_SEQLAN"	,"CT2"	,"Seq.Lanc."	,/*Mascara*/,03	,/*lPixel*/	,,"LEFT" ,,,,,,,, )
Return oReport

//������������������������������������������������������������������Ŀ
//� Function ReportPrint                                             �
//��������������������������������������������������������������������
Static Function ReportPrint(oReport,cAliasRep)

Local oSection1	:= oReport:Section(1)
Local _cQuery   := ""
Local _cQry01   := ""
Local _Enter    := chr(13) + chr(10)

Private nTotReg	:= 90000

&&Processa( {|| u_CntReg05()}, "Lendo Resgistros, Por favor aguarde..." )

_cQuery := " SELECT * FROM RAZAOCCJUR (nolock) " 
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

_cQuery += " UNION "

_cQuery += " SELECT * FROM RAZAOCCIMP (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

_cQuery += " UNION "

_cQuery += " SELECT * FROM RAZAOCCFRET (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

_cQuery += " UNION "

_cQuery += " SELECT * FROM RAZAOCCCOMIS (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " 
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

_cQuery += " UNION "

_cQuery += " SELECT * FROM RAZAOCCADM (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

_cQuery += " UNION "

_cQuery += " SELECT * FROM RAZAOCCCOM (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

_cQuery += " UNION "

_cQuery += " SELECT * FROM RAZAOCCPRO (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

_cQuery += " ORDER BY CC, SUBCC, DEBITO DESC ,  DESC_CC DESC, DESC_SUBCC "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTS", .F., .T.)
	
	dbSelectArea("TCTS")
	TCTS->(dbGoTop())
	oSection1:Init()
	oSection1:SetMeter(nTotReg)
	While TCTS->(!Eof())
		
		oReport:IncMeter()
				
		If oReport:Cancel()
			Exit
		EndIf
		
		oSection1:Cell("EMPRESA"):SetValue(TCTS->EMPRESA)
		oSection1:Cell("CT2_DATA"):SetValue(TCTS->CT2_DATA)
		oSection1:Cell("CONTA"):SetValue(TCTS->CONTA)
		oSection1:Cell("CT1_DESC01"):SetValue(TCTS->CT1_DESC01)
		oSection1:Cell("CC"):SetValue(TCTS->CC)
		oSection1:Cell("DESC_CC"):SetValue(TCTS->DESC_CC)
		oSection1:Cell("SUBCC"):SetValue(TCTS->SUBCC)
		oSection1:Cell("DESC_SUBCC"):SetValue(TCTS->DESC_SUBCC)
		oSection1:Cell("CT2_HIST"):SetValue(TCTS->CT2_HIST)
		oSection1:Cell("DEBITO"):SetValue(TRANSFORM (TCTS->DEBITO,"@E 99,999,999,999.99"))
		oSection1:Cell("CREDITO"):SetValue(TRANSFORM (TCTS->CREDITO,"@E 99,999,999,999.99"))
		oSection1:Cell("CT2_LOTE"):SetValue(TCTS->CT2_LOTE)
		oSection1:Cell("CT2_SBLOTE"):SetValue(TCTS->CT2_SBLOTE)
		oSection1:Cell("CT2_DOC"):SetValue(TCTS->CT2_DOC)
		oSection1:Cell("CT2_LINHA"):SetValue(TCTS->CT2_LINHA)
		oSection1:Cell("CT2_LP"):SetValue(TCTS->CT2_LP)
		oSection1:Cell("CT2_SEQLAN"):SetValue(TCTS->CT2_SEQLAN)
		
		oSection1:PrintLine()
		
		oReport:SkipLine()
		
		dbselectarea("TCTS")
		TCTS->(DbSkip())
		
	EndDo
	
	oSection1:Finish()
	oReport:endpage()
	TCTS->(DbCloseArea())

Return Nil

//������������������������������������������������������������������Ŀ
//� Function CriaPerg (Cria Perguntas no SX1)                        �
//��������������������������������������������������������������������
Static Function CriaPerg(cperg)
	
	PutSX1(cPerg,'01','Data Inicial','Data Inicial','Data Inicial','mv_ch1','D',8 ,0,0,'G','',''   ,'','S','mv_par01','','','','','','','','','','','','','','','','')
	PutSX1(cPerg,'02','Data Final  ','Data Final  ','Data Final  ','mv_ch2','D',8 ,0,0,'G','',''   ,'','S','mv_par02','','','','','','','','','','','','','','','','')
	
Return Nil

User Function CntReg05()
Local _cQuery := ""

ProcRegua(8)
IncProc("Tabela RAZAOCCJUR...")

_cQuery := " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCJUR (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
nTotReg:=nTotReg+TCTR->TOTREG
TCTR->(DbCloseArea())

IncProc("Tabela RAZAOCCIMP...")

_cQuery += " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCIMP (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
nTotReg:=nTotReg+TCTR->TOTREG
TCTR->(DbCloseArea())

IncProc("Tabela RAZAOCCFRET...")

_cQuery += " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCFRET (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
nTotReg:=nTotReg+TCTR->TOTREG
TCTR->(DbCloseArea())

IncProc("Tabela RAZAOCCCOMIS...")

_cQuery += " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCCOMIS (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
nTotReg:=nTotReg+TCTR->TOTREG
TCTR->(DbCloseArea())

IncProc("Tabela RAZAOCCADM...")

_cQuery += " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCADM (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
nTotReg:=nTotReg+TCTR->TOTREG
TCTR->(DbCloseArea())

IncProc("Tabela RAZAOCCCOM...")

_cQuery += " SELECT count(*) as TOTREG  "
_cQuery += " FROM RAZAOCCCOM (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
nTotReg:=nTotReg+TCTR->TOTREG
TCTR->(DbCloseArea())

IncProc("Tabela RAZAOCCPRO...")

_cQuery += " SELECT count(*) as TOTREG "
_cQuery += " FROM RAZAOCCPRO (nolock) "
_cQuery += " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND CT2_LOTE NOT IN ('008840','008841') "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TCTR", .F., .T.)
dbSelectArea("TCTR")
nTotReg:=nTotReg+TCTR->TOTREG
TCTR->(DbCloseArea())

IncProc("Encerrando Leitura...")

Return
