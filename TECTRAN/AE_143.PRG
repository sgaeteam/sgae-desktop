*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_143                           vrs 001 �
*� VRS 001        : Implantacao                              �
*� FINALIDADE     : Tabela de Escalas                        �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           �
*� DATA CRIACAO   : 20/02/1999                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 14
IF NetUse("DBESCA","ESCALA")       /* Escalas */
   SET INDEX TO DBIESCA1
ELSE
   RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "43"
LinhaMsg(2); ProgName("AE143")
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,7,17,72,1,YCOREDIT,.T.,"Cadastro de Escalas")
Linha23(msg)
oBr:=TBROWSEDB(5,8,16,71)
oBr:headSep:="賃�"
oBr:colSep:= " � "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("C�d"        ,{|| ESCALA})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Escala"     ,{|| DESCR})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Seg"        ,{|| SEG})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Ter"        ,{|| TER})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Qua"        ,{|| QUA})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Qui"        ,{|| QUI})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Sex"        ,{|| SEX})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("S�b"        ,{|| SAB})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Dom"        ,{|| DOM})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Hor�rio"    ,{|| HORARIO})
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
DBCLOSEALL(); RETURN
*嬪様様様様様様様様様様様様様様邑
*� Incluir Dados no Browse      �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := RECNO()
   Telas(14,7,19,72,c_nBorda,YCOREDIT,.T.," Inclus�o ")
   vCodigo:=SPACE(2);vDescr:=SPACE(15);vHor:=SPACE(13)
   vSeg:=vTer:=vQua:=vQui:=vSex:=vSab:=vDom:=" "
   @ 15,12 SAY "C�digo:" GET vCodigo  PICT "99"  VALID !EMPTY(vCodigo).AND.TCurso(vCodigo)
   @ 16,12 SAY "Escala:" GET vDescr   PICT "@!"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   @ 17,12 SAY "( )Seg ( )Ter ( )Qua ( )Qui ( )Sex ( )S�b ( )Dom"
   @ 17,13 GET vSeg PICT "!"                     VALID (LASTKEY()==K_UP).OR.vSeg$"X "
   @ 17,20 GET vTer PICT "!"                     VALID (LASTKEY()==K_UP).OR.vTer$"X "
   @ 17,27 GET vQua PICT "!"                     VALID (LASTKEY()==K_UP).OR.vQua$"X "
   @ 17,34 GET vQui PICT "!"                     VALID (LASTKEY()==K_UP).OR.vQui$"X "
   @ 17,41 GET vSex PICT "!"                     VALID (LASTKEY()==K_UP).OR.vSex$"X "
   @ 17,48 GET vSab PICT "!"                     VALID (LASTKEY()==K_UP).OR.vSab$"X "
   @ 17,55 GET vDom PICT "!"                     VALID (LASTKEY()==K_UP).OR.vDom$"X "
   @ 18,12 SAY "Hor�rio:" GET vHor
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      GO nReg_Ant
      Rest_Tela(); Linha23(msg)
      RETURN(.T.)
   ENDIF

   IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclus�o ?")
      WHILE !NetApp(); ENDDO
      ESCALA->ESCALA  := vCodigo
      ESCALA->DESCR   := vDescr
      ESCALA->SEG     := vSeg
      ESCALA->TER     := vTer
      ESCALA->QUA     := vQua
      ESCALA->QUI     := vQui
      ESCALA->SEX     := vSex
      ESCALA->SAB     := vSab
      ESCALA->DOM     := vDom
      ESCALA->HORARIO := vHor
      ESCALA->(DBUNLOCK()); ESCALA->(DBCOMMIT())
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
   Telas(14,7,19,72,1,YCOREDIT,.T.," Altera��o ")
   vCodigo  := ESCALA
   vDescr   := DESCR
   vSeg     := SEG
   vTer     := TER
   vQua     := QUA
   vQui     := QUI
   vSex     := SEX
   vSab     := SAB
   vDom     := DOM
   vHor     := HORARIO

   @ 15,12 SAY "C�digo:" GET vCodigo  PICT "99"  WHEN .F.
   @ 16,12 SAY "Escala:" GET vDescr   PICT "@!"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   @ 17,12 SAY "( )Seg ( )Ter ( )Qua ( )Qui ( )Sex ( )S�b ( )Dom"
   @ 17,13 GET vSeg PICT "!"                     VALID (LASTKEY()==K_UP).OR.vSeg$"X "
   @ 17,20 GET vTer PICT "!"                     VALID (LASTKEY()==K_UP).OR.vTer$"X "
   @ 17,27 GET vQua PICT "!"                     VALID (LASTKEY()==K_UP).OR.vQua$"X "
   @ 17,34 GET vQui PICT "!"                     VALID (LASTKEY()==K_UP).OR.vQui$"X "
   @ 17,41 GET vSex PICT "!"                     VALID (LASTKEY()==K_UP).OR.vSex$"X "
   @ 17,48 GET vSab PICT "!"                     VALID (LASTKEY()==K_UP).OR.vSab$"X "
   @ 17,55 GET vDom PICT "!"                     VALID (LASTKEY()==K_UP).OR.vDom$"X "
   @ 18,12 SAY "Hor�rio:" GET vHor
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Altera��o ?")
         GO nReg_Ant
         WHILE !ESCALA->(NetLReg()); ENDDO
         REPLACE ESCALA->ESCALA  WITH vCodigo,;
                 ESCALA->DESCR   WITH vDescr ,;
                 ESCALA->SEG     WITH vSeg   ,;
                 ESCALA->TER     WITH vTer   ,;
                 ESCALA->QUA     WITH vQua   ,;
                 ESCALA->QUI     WITH vQui   ,;
                 ESCALA->SEX     WITH vSex   ,;
                 ESCALA->SAB     WITH vSab   ,;
                 ESCALA->DOM     WITH vDom   ,;
                 ESCALA->HORARIO WITH vHor
         ESCALA->(DBUNLOCK()); ESCALA->(DBCOMMIT())
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
   WHILE !NetLReg(); ENDDO
   DBDELETE(); DBUNLOCK(); DBCOMMIT()
   Aguarde(); Linha23(msg)
   RETURN(.T.)
*嬪様様様様様様様様様様様様様様邑
*� Testar Existencia da Escala  �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION TCurso(pCod)
   IF (lRet:=DBSEEK(pCod))
      Aviso("Escala j� Existente...",,3)
   ENDIF
   RETURN(!lRet)
