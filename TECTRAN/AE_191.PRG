*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_191                           vrs 001 �
*� VRS 001        : Desenvolvimento                          �
*� FINALIDADE     : Cadastrar Senhas de Acesso               �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            �
*� DATA CRIACAO   : 18/02/1995                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

DBCLOSEALL()
SELECT 1
IF NetUse("USUARIO.SYS","USER")
   SET INDEX TO USUARIO
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg := "AE191"; ProgName(cPrg)

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
AE191_0()
SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
DBCOMMITALL()
DBCLOSEALL(); RETURN
*嬪様様様様様様様様様様様様様様邑
*� Senhas Usuario Comum         �
*塒様様様様様様様様様様様様様様余
PROCEDURE AE191_0()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   LOCAL aCab[2], aCam[2], aPic[2]

   Area_Dados(); LinhaMsg(4)

   aCab[1] := "Chave"
   aCab[2] := "Usu�rio"
   *
   aCam[1] := "CHAVE"
   aCam[2] := "USUARIO"
   *
   aPic[1] := "@!"
   aPic[2] := "@!"
   msg     := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
   *
   IF nNivel==1
      Browser(1,1,6,3,16,75,aCab,aCam,aPic,.F.,.T.,"Usu�rios/Senhas",msg)
   ELSE
      Browser(1,1,6,3,16,75,aCab,aCam,aPic,.T.,.T.,"Usu�rios/Senhas",msg)
   ENDIF
   RESTSCREEN(2,0,24,79,tela)
   RETURN
