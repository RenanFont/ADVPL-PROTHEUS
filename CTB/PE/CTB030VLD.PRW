#include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  MAURICIO LIMA DE SOUZA                  � Data � 19/06/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada Validacao cadastro Centro de Custo        ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CTB030VLD

Local   _aArea	 := GetArea()
PRIVATE _cRET    :=.T.
PRIVATE cUSRLOJI :=GetMV("OM_USRCTB ")
Private cUserSys := RetCodUsr()

IF cUserSys $ cUSRLOJI
	_cRET :=.T.
else
	_cRET :=.F.
	MSGALERT('Usuario: '+alltrim(UsrFullName(RetCodUsr()))+' N�o permitido altera��o no cadastro de Centro de Custo ')
ENDIF

U_MCERLOG()
RestArea(_aArea)
Return _cRET


