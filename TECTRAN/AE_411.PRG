*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : EB_411                           vrs 001 �
*� VRS 001        : Desenvolvimento                          �
*� FINALIDADE     : Configura��o de Usu�rios do Sistema      �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            �
*� DATA CRIACAO   : 01/03/1994                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

LOCAL tela := SAVESCREEN(2,0,24,79), cCorant := SETCOLOR()

IF NetUse("USUARIO.SYS","USER")
   SET INDEX TO USUARIO
ELSE
   DBCLOSEALL(); RETURN
ENDIF
DBSEEK("NET4")

ProgName("EB411"); Area_Dados()
Quadro(7,13,12,65,1,YCOREDIT,.T.,"Usu�rio do Sistema",.T.)
SETCOLOR(YCOREDIT)
SET(_SET_CONFIRM,.T.)
WHILE .T.
   cUser := SPACE(30)
   @ 09,15 SAY "Usu�rio Anterior : "+USER->REGISTRO
   @ 10,15 SAY "Novo Usu�rio     :"GET cUser PICT "@!" VALID TUser(cUser)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY() == K_ESC; EXIT; ENDIF

   IF UPDATED()
      IF Confirma("Confirma Altera��o ? ")
         WHILE !(USER->(NetLReg())); ENDDO
         REPLACE USER->REGISTRO WITH cUser
         cUsuario := cUser
         UNLOCK; DBCOMMIT()
         ProcOk("Alterado",.F.)
         EXIT
      ENDIF
   ENDIF
ENDDO
SET(_SET_CONFIRM,.F.)
SETCOLOR(cCorant)
RESTSCREEN(2,0,24,79,tela)
DBCLOSEALL(); RETURN
*嬪様様様様様様様様様様様様様様邑
*� Testar Entrada do Usuario    �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION TUser(pUser)
   IF EMPTY(pUser)
      Aviso("Campo Obrigat�rio!",,2); RETURN .F.
   ENDIF
   RETURN .T.
