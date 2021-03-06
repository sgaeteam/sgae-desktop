*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_290                           vrs 001 �
*� VRS 001        : Implantacao                              �
*� FINALIDADE     : Lancamento em Conta Corrente             �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE                     �
*� DATA CRIACAO   : 07/11/1995                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 3
IF NetUse("DBITEM","ITEM")         /* Tabela de Itens */
   SET INDEX TO DBITEM1,DBITEM2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("DBMOVBCO","MOVBANCO")   /* Cadastro de Movimentacao Bancaria */
   SET INDEX TO DBIMOVB1,DBIMOVB2,DBIMOVB3,DBIMOVB4,DBIMOVB5
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBBANCO","BANCO")       /* Cadastro de Bancos */
   SET INDEX TO DBIBCO1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
DBGOTOP()
IF EOF()
   Aviso("N�o h� contas cadastradas...",,3); DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "2"; cOpHelp2 := "90"
LinhaMsg(2); cPrg:="AE290"; ProgName(cPrg)
SET KEY -1 TO Mostra()
WHILE .T.
   cPrg:="AE290"
   SETCOLOR(YCOREDIT)
   Mensagem("Informe o N�mero da Conta")
   Mostra()
   vConta:=BANCO->CONTA
   Mensagem()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   Mensagem("Informe a Senha de Acesso")
   SET CONFIRM ON
   Telas(19,3,21,10,1,YCOREDIT,.T.,"Senha"); nVezes:=1; lOk:=.F.
   WHILE nVezes<4
      xSenha:=""
      xSenha:=Test_Entry(20,5,4,xSenha,"PW","N/W")
      IF LASTKEY()==K_ESC; EXIT; ENDIF
      IF BANCO->SENHA#Codifica(xSenha)
         Aviso("Senha Inv�lida...")
      ELSEIF BANCO->SENHA==Codifica(xSenha)
         Rest_Tela(); lOk:=.T.; EXIT
      ENDIF
      @ 20,5 SAY SPACE(4) COLOR "N/W"
      nVezes++
   ENDDO
   Mensagem()
   SET CONFIRM OFF
   IF LASTKEY()==K_ESC; Rest_Tela(); LOOP; ENDIF
   IF !lOk
      Aviso("Usu�rio n�o Autorizado...",,3)
      Rest_Tela(); EXIT
   ENDIF

   Telas(08,07,18,68,1,YCOREDIT,.T.,"Lan�amento em Conta Corrente")
   @ 09,09 SAY "Conta Corrente:" GET vConta PICT "@R 999/XXXXXXX/XXXXXXXXXXXXX" WHEN .F.
   @ 10,09 SAY "  N� Documento:"
   @ 11,07 SAY "�"+REPL("�",60)+"�"
   SETKEY(K_F9,{||Teste()})
   WHILE .T.
      SETCOLOR(YCOREDIT); cPrg:="AE290"
      lNovo := lDeleta := lAchou := .F.
      vNumDoc:=SPACE(6); nSaldo:=BANCO->SALDO; vDatMov:=CTOD("")
      SELECT MOVBANCO; DBGOBOTTOM(); DBSKIP()
      FOR a = 1 TO FCOUNT()
          xVar  := "w"+FIELDNAME(a)
          &xVar := FIELDGET(a)
      NEXT

      @ 12,09 SAY "Data Documento:" GET wDatDoc  PICT "@D"
      @ 13,09 SAY "     Hist�rico:" GET wItem_cx PICT "9999"
      @ 14,09 SAY "    Favorecido:" GET wFavor   PICT "@!"
      @ 15,09 SAY "    Tipo (D/C):" GET wTipolan PICT "!"
      @ 16,09 SAY "      Valor R$:" GET wValor   PICT "@E 99,999,999.99"
      @ 17,09 SAY "     Descri��o:" GET wDscLan  PICT "@!"
      GetList:={}

      @ 10,09 SAY "  N� Documento:" GET vNumDoc  PICT "999999" WHEN TeclaServ(.T.,"Gera N�","F9") VALID !EMPTY(vNumDoc)
      @ 10,35 SAY "Data Movimento:" GET vDatMov  PICT "@D"     WHEN TeclaServ() VALID LASTKEY()==K_UP.OR.!EMPTY(vDatMov).AND.vDatMov<=cDtSys
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF

      lAchou:=DBSEEK(vConta+vNumDoc+DESCEND(DTOS(vDatMov)))
      FOR a = 1 TO FCOUNT()
          xVar  := "w"+FIELDNAME(a)
          &xVar := FIELDGET(a)
      NEXT
      wDatMov := vDatMov
      
      IF lAchou
         TDescr(3,1,13,30,wItem_cx,"DESCR",["@S35"])
         IF wTipoLan=="C"
            nSaldo:=BANCO->SALDO - wValor
         ELSEIF wTipoLan=="D"
            nSaldo:=BANCO->SALDO + wValor
         ENDIF
      ENDIF
   
      @ 12,09 SAY "Data Documento:" GET wDatDoc  PICT "@D"   WHEN TeclaFuncao()    VALID LASTKEY()==K_UP.OR.!EMPTY(wDatDoc)
      @ 13,09 SAY "     Hist�rico:" GET wItem_cx PICT "9999" WHEN TeclaFuncao(.T.) VALID LASTKEY()==K_UP.OR.!EMPTY(wItem_cx);
        .AND.TDescr(3,1,13,30,wItem_cx,"DESCR",["@S35"])
      @ 14,09 SAY "    Favorecido:" GET wFavor   PICT "@!"   WHEN TeclaFuncao()    VALID LASTKEY()==K_UP.OR.!EMPTY(wFavor)
      @ 15,09 SAY "    Tipo (D/C):" GET wTipolan PICT "!"    VALID LASTKEY()==K_UP.OR.wTipoLan$"DC"
      @ 16,09 SAY "      Valor R$:" GET wValor   PICT "@E 99,999,999.99" VALID LASTKEY()==K_UP.OR.wValor>0.00
      @ 17,09 SAY "     Descri��o:" GET wDscLan  PICT "@!"

      IF EOF()
         IF Acesso(3)
            SETCURSOR(1); READ; SETCURSOR(0)
            msg   := "Confirma os Dados ? "
            lNovo := .T.
         ELSE
            CLEAR GETS; Rest_Tela(); EXIT
         ENDIF
      ELSE
         IF nNivel==1
            WaitMsg("Tecle algo para continuar...",.F.)
            CLEAR GETS; Rest_Tela(); EXIT
         ENDIF
         DeleAltera()
         IF LASTKEY()==K_ENTER
            IF Acesso(3)
               SETCURSOR(1); READ; SETCURSOR(0)
               msg     := "Confirma Altera��o ? "
               lAltera := .T.
            ELSE
               KEYBOARD CHR(27); READ
            ENDIF
         ELSEIF LASTKEY()==K_DEL
            IF Acesso(5)
               CLEAR GETS
               msg     := "Confirma a Exclus�o ? "
               lDeleta := .T.
            ELSE
               KEYBOARD CHR(27); READ
            ENDIF
         ENDIF
      ENDIF
      IF LASTKEY() <> K_ESC
         IF Confirma(msg)
            IF lDeleta
               WHILE !NetLReg(); ENDDO
               DBDELETE(); DBCOMMIT()

               /* Atualizar o Saldo */
               WHILE !BANCO->(NetLReg()); ENDDO
               REPLACE BANCO->SALDO WITH nSaldo
               BANCO->(DBUNLOCK())
            ELSE
               IF lNovo
                  ProcOk("Incluindo...")
                  WHILE !NetApp(); ENDDO
               ELSE
                  ProcOk("Alterando...")
               ENDIF
               wNumDoc:=vNumDoc; wConta:=vConta
               WHILE !NetLReg(); ENDDO
               FOR a = 1 TO FCOUNT()
                   xVar  := "w"+FIELDNAME(a)
                   FIELDPUT(a,&xVar)
               NEXT
               DBUNLOCK(); DBCOMMITALL()

               /* Atualizar o Saldo */
               WHILE !BANCO->(NetLReg()); ENDDO
               IF wTipoLan=="C"
                  REPLACE BANCO->SALDO WITH nSaldo + wValor
               ELSE
                  REPLACE BANCO->SALDO WITH nSaldo - wValor
               ENDIF
               BANCO->(DBUNLOCK())
               ProcOk()
            ENDIF
         ENDIF
         SETCOLOR(YCOREDIT); SCROLL(12,9,16,67)
      ELSE
         CLEAR GETS; SETCOLOR(YCOREDIT); SCROLL(12,8,17,67)
      ENDIF
   ENDDO
   SETKEY(K_F9,NIL)
ENDDO
SETKEY(K_F2,NIL)
DBCLOSEALL(); RETURN
*嬪様様様様様様様様様様様様様様邑
*� Testar Existencia da Conta   �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION TConta(pConta)
   IF !(lRet:=BANCO->(DBSEEK(pConta)))
      Aviso("Conta N�o Localizada...",,3)
   ENDIF
   RETURN(lRet)
*嬪様様様様様様様様様様様様様様邑
*� Gerar Numero de Documento    �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION Teste()
   pVar  := READVAR()
   &pVar := SUBSTR(DTOC(cDtSys),1,2)+SUBSTR(TIME(),4,2)+SUBSTR(TIME(),7,2)
   KEYBOARD (&pVar)
   KEYBOARD CHR(13)
   RETURN .T.
