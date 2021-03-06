*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_141                           vrs 001 �
*� VRS 001        : Implantacao                              �
*� FINALIDADE     : Cadastro de Cursos                       �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           �
*� DATA CRIACAO   : 20/02/1999                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 12
IF NetUse("DBCURSO","CURSO")       /* Cursos */
   SET INDEX TO DBICUR1
ELSE
   RETURN
ENDIF

LinhaMsg(2); ProgName("AE141")
msg:="^INS^-Inclui ^ENTER^-Altera"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,10,17,69,1,YCOREDIT,.T.,"Cadastro de Cursos")
Linha23(msg)
oBr:=TBROWSEDB(5,11,16,68)
oBr:headSep:="賃�"
oBr:colSep:= " � "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Cod."    ,{|| CODCUR})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Curso"   ,{|| DESCR})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Te�rica" ,{|| TEORICA})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Pr�tica" ,{|| PRATICA})
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
   Telas(15,10,18,69,c_nBorda,YCOREDIT,.T.," Inclus�o ")
   vCodigo:=SPACE(2);vDescr:=SPACE(25);vTeorica:=vPratica:=0
   @ 16,12 SAY "C�d. Descri��o do Curso        Qtde.Te�rica  Qtde.Pr�tica"
*               99   XXXXXXXXXXxxxxxxxxxxXXXXX     99            99
*               23456789012345678901234567890123456789012345678901234567890
*                       2         3         4         5         6
   @ 17,12 GET vCodigo  PICT "99"  VALID !EMPTY(vCodigo).AND.TCurso(vCodigo)
   @ 17,17 GET vDescr   PICT "@!"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   @ 17,47 GET vTeorica PICT "99"
   @ 17,61 GET vPratica PICT "99"
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      GO nReg_Ant
      Rest_Tela(); Linha23(msg)
      RETURN(.T.)
   ENDIF

   IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclus�o ?")
      WHILE !NetApp(); ENDDO
      CURSO->CODCUR  := vCodigo
      CURSO->DESCR   := vDescr
      CURSO->TEORICA := vTeorica
      CURSO->PRATICA := vPratica
      CURSO->(DBUNLOCK()); CURSO->(DBCOMMIT())
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
   Telas(15,10,18,69,1,YCOREDIT,.T.," Altera��o ")
   vCodigo  := CODCUR
   vDescr   := DESCR
   vTeorica := TEORICA
   vPratica := PRATICA

   @ 16,12 SAY "C�d. Descri��o do Curso        Qtde.Te�rica  Qtde.Pr�tica"
   @ 17,12 GET vCodigo  PICT "99"  WHEN .F.
   @ 17,17 GET vDescr   PICT "@!"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   @ 17,47 GET vTeorica PICT "99"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vTeorica)
   @ 17,61 GET vPratica PICT "99"
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Altera��o ?")
         GO nReg_Ant
         WHILE !CURSO->(NetLReg()); ENDDO
         REPLACE CURSO->CODCUR  WITH vCodigo  ,;
                 CURSO->DESCR   WITH vDescr   ,;
                 CURSO->TEORICA WITH vTeorica ,;
                 CURSO->PRATICA WITH vPratica
         CURSO->(DBUNLOCK()); CURSO->(DBCOMMIT())
         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   Rest_Tela(); GO nReg_Ant; Linha23(msg)
   RETURN(lAlt)
*嬪様様様様様様様様様様様様様様邑
*� Testar Existencia do Curso   �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION TCurso(pCod)
   IF (lRet:=DBSEEK(pCod))
      Aviso("Curso j� Existente...",,3)
   ENDIF
   RETURN(!lRet)
