*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_192                           vrs 001 �
*� VRS 001        : Desenvolvimento                          �
*� FINALIDADE     : Cadastrar Niveis de Acesso               �
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

cPrg := "AE192"; ProgName(cPrg)

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
AE192_0()
SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
DBCOMMITALL()
DBCLOSEALL(); RETURN
*嬪様様様様様様様様様様様様様様邑
*� Acesso Usuarios "Masters"    �
*塒様様様様様様様様様様様様様様余
PROCEDURE AE192_0()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   LOCAL aCab[3], aCam[3], aPic[3]

   Area_Dados(); LinhaMsg(4)

   aCab[1] := "Chave"
   aCab[2] := "Usu�rio"
   aCab[3] := "N�vel"
   *
   aCam[1] := "CHAVE"
   aCam[2] := "USUARIO"
   aCam[3] := "NIVEL"
   *
   aPic[1] := "@!"
   aPic[2] := "@!"
   aPic[3] := "9"
   msg     := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
   *
   Browser(1,1,6,3,16,75,aCab,aCam,aPic,.T.,.T.,"N�veis de Acesso",msg)
   RESTSCREEN(2,0,24,79,tela)
   RETURN
