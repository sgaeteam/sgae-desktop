*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_420                           vrs 001 �
*� VRS 001        : Desenvolvimento                          �
*� FINALIDADE     : Copiar/Recuperar Arquivos do Sistema     �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            �
*� DATA CRIACAO   : 18/02/1995                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

Telas(7,52,10,71,1,YCORMENU,.T.)
WHILE .T.
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "4"
   cOpHelp2 := "20"
   ProgName("AE420")

   @ 08,53 PROMPT " C�pias Seguran�a " MESSAGE Msg("Realiza Backup dos Arquivos do Sistema")
   @ 09,53 PROMPT " Restaura��o      " MESSAGE Msg("Restaura C�pia de Seguran�a")
   MENU TO nMenu_5b

   IF nMenu_5b = 0
      Rest_Tela()
      RETURN
   ENDIF

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   IF nMenu_5b = 1
      IF Acesso(5); AE_421(); ENDIF
   ELSEIF nMenu_5b = 2
      IF Acesso(5); AE_422(); ENDIF
   ENDIF
ENDDO
