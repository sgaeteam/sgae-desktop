*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_180                           vrs 001 �
*� VRS 001        : Implantacao                              �
*� FINALIDADE     : Cadastrar Bancos/Agencias/Contas         �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE                     �
*� DATA CRIACAO   : 21/06/1995                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 2
IF NetUse("DBMOVBCO","MOVBANCO")   /* Cadastro de Movimentacao Bancaria */
   SET INDEX TO DBIMOVB1,DBIMOVB2,DBIMOVB3,DBIMOVB4,DBIMOVB5
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBBANCO","BANCO")       /* Cadastro de Bancos */
   SET INDEX TO DBIBCC1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "80"
cPrg:="AE180";LinhaMsg(2); ProgName(cPrg)
msg:="Op��es � (^INS^) Inclui  (^ENTER^) Altera  (^DEL^) Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,10,11,69,1,YCOREDIT,.T.,"Cadastro de Contas")
Linha23(msg)
oBr:=TBROWSEDB(5,11,10,68)
oBr:headSep:="賃�"
oBr:colSep:= " � "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Banco",{|| LEFT(CONTA,3)})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Ag�ncia",{|| SUBS(CONTA,4,7)})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Conta",{|| RIGHT(CONTA,13)})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Titular",{|| TRANSFORM(TITULAR,"@S20")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Saldo",{|| TRANSFORM(SALDO,"@E 99,999,999,999.99")})
oBr:addColumn(oCol)

WHILE .T.
   WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      EXIT
   ELSEIF ( tecla == K_F1 )   // Ajuda
      Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
   ELSEIF ( tecla == K_F4 )   // Calculadora
      Calculadora(calc_lin,calc_col,YCORMENU)
   ELSEIF ( tecla == K_F5 )   // Calendario
      Calendary(@cale_lin,@cale_col,@m_date)
   ELSEIF ( tecla == K_INS )
      Inclui(msg); oBr:refreshAll()
   ELSEIF ( tecla == K_DEL )
      Exclui(msg); oBr:refreshAll(); oBr:gotop()
   ELSEIF ( tecla == K_ENTER )
      Altera(msg); oBr:refreshAll()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela()
RESTSCREEN(2,0,24,79,vTela)
RETURN NIL
*嬪様様様様様様様様様様様様様様邑
*� Incluir Dados no Browse      �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := RECNO()
   Telas(14,1,17,78,c_nBorda,YCOREDIT,.T.," Inclus�o ")
   @ 15,3 SAY "Banco  Ag�ncia  Conta         Titular              Saldo             Senha"
   vBanco:=SPACE(3);vAgencia:=SPACE(7);vConta:=SPACE(13);vTitular:=SPACE(30);vSaldo:=0.00
   @ 16,03 GET vBanco   PICT "999"    VALID !EMPTY(vBanco)
   @ 16,10 GET vAgencia PICT "@!"     VALID (LASTKEY()==K_UP).OR.!EMPTY(vAgencia)
   @ 16,19 GET vConta   PICT "@!"     VALID (LASTKEY()==K_UP).OR.TConta(vBanco+vAgencia+vConta)
   @ 16,33 GET vTitular PICT "@!S20"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vTitular)
   @ 16,54 GET vSaldo   PICT "@KE 99,999,999,999.99"
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      GO nReg_Ant
      Rest_Tela(); Linha23(msg)
      RETURN(.T.)
   ENDIF

   SET CONFIRM ON
   Mensagem("Informe a Senha com 4 d�gitos"); xSenha:=""
   SETCURSOR(2)
   xSenha := Test_Entry(16,72,4,xSenha,"PW",YCOREDIT)
   SETCURSOR(0)
   Mensagem()
   SET CONFIRM OFF

   IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclus�o ?")
      WHILE !NetApp(); ENDDO
      BANCO->CONTA   := vBanco+vAgencia+vConta
      BANCO->TITULAR := vTitular
      BANCO->SALDO   := vSaldo
      BANCO->SENHA   := Codifica(xSenha)
      BANCO->(DBUNLOCK()); BANCO->(DBCOMMIT())
      ProcOk("Incluido",.T.)
   ELSE
      GO nReg_Ant
   ENDIF
   Rest_Tela(); Linha23(msg)
   RETURN NIL
*嬪様様様様様様様様様様様様様様邑
*� Alterar Dados no Browse      �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION Altera(msg)
   LOCAL nReg_Ant := RECNO(), lAlt := .F.

   DBGOTOP()
   IF EOF()
      Aviso("N�o h� registro a ser Alterado !",,2)
      Linha23(msg)
      RETURN(lAlt)
   ENDIF
   GO nReg_Ant

   SETCOLOR(YCOREDIT)
   Telas(14,1,17,78,1,YCOREDIT,.T.," Altera��o ")
   @ 15,3 SAY "Banco  Ag�ncia  Conta         Titular              Saldo             Senha"
   vBanco   := wBanco   := LEFT(CONTA,3)
   vAgencia := wAgencia := SUBS(CONTA,4,7)
   vConta   := RIGHT(CONTA,13)
   vTitular := TITULAR
   vSaldo   := SALDO
   xSenha   := Codifica(SENHA)

   @ 16,03 GET vBanco   PICT "999"                   WHEN .F.
   @ 16,10 GET vAgencia PICT "@!"                    WHEN .F.
   @ 16,19 GET vConta   PICT "@!"                    WHEN .F.
   @ 16,33 GET vTitular PICT "@!S20"                 VALID !EMPTY(vTitular)
   @ 16,54 GET vSaldo   PICT "@KE 99,999,999,999.99" WHEN .F.
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Altera Senha ?")
         SET CONFIRM ON
         Mensagem("Informe a Senha com 4 d�gitos"); xSenha:=""
         SETCURSOR(2)
         xSenha := Test_Entry(16,72,4,xSenha,"PW",YCOREDIT)
         SETCURSOR(0)
         Mensagem()
         SET CONFIRM OFF
      ENDIF
      IF Confirma("Confirma Altera��o ?")
         GO nReg_Ant
         WHILE !BANCO->(NetLReg()); ENDDO
         REPLACE BANCO->CONTA   WITH vBanco+vAgencia+vConta,;
                 BANCO->TITULAR WITH vTitular,;
                 BANCO->SENHA   WITH Codifica(xSenha)
         BANCO->(DBUNLOCK()); BANCO->(DBCOMMIT())
         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   Rest_Tela(); GO nReg_Ant; Linha23(msg)
   RETURN(lAlt)
*嬪様様様様様様様様様様様様様様邑
*� Excluir Dados no Browse      �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION Exclui(msg)
   LOCAL nReg_Ant := RECNO(), lExcl := .F.

   DBGOTOP()
   IF EOF()
      Aviso("N�o h� registro a ser Eliminado !",,2)
      Linha23(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   IF BANCO->SALDO#0.00
      Aviso("Conta n�o est� zerada...",,3)
      Linha23(msg); RETURN(lExcl)
   ENDIF

   IF Confirma("Confirma Exclus�o ?")
      Aguarde("Eliminando...")

      /* Eliminar a movimentacao da conta corrente */
      MOVBANCO->(DBSEEK(BANCO->CONTA))
      WHILE MOVBANCO->CONTA==BANCO->CONTA.AND.!EOF()
         WHILE !MOVBANCO->(NetLReg()); ENDDO
         MOVBANCO->(DBDELETE()); MOVBANCO->(DBUNLOCK()); MOVBANCO->(DBCOMMIT())
         MOVBANCO->(DBSKIP())
      ENDDO

      /* Eliminar Conta */
      WHILE !NetLReg(); ENDDO
      DBDELETE(); DBUNLOCK(); DBCOMMIT()

      Aguarde(); Linha23(msg)
   ENDIF
   RETURN(.T.)
*嬪様様様様様様様様様様様様様様邑
*� Testar Existencia da Conta   �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION TConta(pConta)
   IF (lRet:=DBSEEK(pConta))
      Aviso("Conta j� Existente...",,3)
   ENDIF
   RETURN(!lRet)
