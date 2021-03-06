*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_152                           vrs 001 �
*� VRS 001        : Implantacao                              �
*� FINALIDADE     : Tabela de Categorias                     �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           �
*� DATA CRIACAO   : 03/02/2001                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 1
IF NetUse("DBCATEG","CATEGORIA")       /* Tabela de Categorias          */
   SET INDEX TO DBICAT1
ELSE
   RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "52"
cPrg:="AE152"; LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,5,19,75,1,YCOREDIT,.T.,"Tabela de Categorias")
Linha23(msg)
PRIVATE cBuffer:=""
oBr:=TBROWSEDB(5,6,18,74)
oBr:headSep:="賃�"
oBr:colSep:= " � "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("C�d."         ,{|| IDCAT})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Descri��o"    ,{|| TRANSFORM(DESCR,"@S30")})
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
      IF Acesso(9)
         Exclui(msg); oBr:refreshAll(); oBr:gotop()
      ENDIF
   ELSEIF ( tecla == K_ENTER )
      Altera(msg); oBr:refreshAll()
   ELSEIF tecla>=32.AND.tecla<=127.OR.tecla==K_BS.OR.tecla==K_CTRL_L
      SmartSeek(UPPER(CHR(tecla)),18,6,60)
      oBr:refreshall()
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
   LOCAL nReg_Ant := CATEGORIA->(RECNO())

   SET KEY -1 TO Mostra()
   Mensagem("Informe os campos necess�rios")

   Telas(16,5,19,75,1,YCOREDIT,.T.,"Inclus�o de Categoria")
   WHILE .T.
      CATEGORIA->(DBGOBOTTOM()); CATEGORIA->(DBSKIP())
      FOR a = 1 TO CATEGORIA->(FCOUNT())
          xVar  := "w"+CATEGORIA->(FIELDNAME(a))
          &xVar := CATEGORIA->(FIELDGET(a))
      NEXT

      EditaGet("I")
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclus�o ?")
         // Gravar no arquivo de Categorias
         WHILE !CATEGORIA->(NetApp()); ENDDO
         FOR a = 1 TO CATEGORIA->(FCOUNT())
             xVar  := "w"+CATEGORIA->(FIELDNAME(a))
             CATEGORIA->(FIELDPUT(a,&xVar))
         NEXT
         CATEGORIA->(DBUNLOCK()); CATEGORIA->(DBCOMMIT())

         ProcOk("Incluido",.T.)
         IF !Confirma("Deseja Cadastrar outra Categoria ?"); EXIT; ENDIF
         SCROLL(17,6,18,74,0)
      ELSE
         GO nReg_Ant; EXIT
      ENDIF
   ENDDO
   Rest_Tela(); Linha23(msg); SETKEY(K_F2,NIL)
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

   SET KEY -1 TO Mostra()
   Mensagem("Altere os campos necess�rios")
   SETCOLOR(YCOREDIT)
   Telas(16,5,19,75,1,YCOREDIT,.T.,"Altera��o Dados da Categoria")

   FOR a = 1 TO CATEGORIA->(FCOUNT())
       xVar  := "w"+CATEGORIA->(FIELDNAME(a))
       &xVar := CATEGORIA->(FIELDGET(a))
   NEXT

   EditaGet("A")
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Altera��o ?")
         GO nReg_Ant
         WHILE !CATEGORIA->(NetLReg()); ENDDO
         FOR a = 1 TO CATEGORIA->(FCOUNT())
             xVar  := "w"+CATEGORIA->(FIELDNAME(a))
             CATEGORIA->(FIELDPUT(a,&xVar))
         NEXT
         CATEGORIA->(DBUNLOCK()); CATEGORIA->(DBCOMMIT())

         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   Rest_Tela(); GO nReg_Ant; Linha23(msg); SETKEY(K_F2,NIL)
   RETURN(lAlt)
*嬪様様様様様様様様様様様様様様邑
*� Excluir Dados no Browse      �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION Exclui(msg)
   LOCAL nReg_Ant := CATEGORIA->(RECNO()), lExcl := .F.

   CATEGORIA->(DBGOTOP())
   IF EOF()
      Aviso("N�o h� registro a ser Eliminado !",,2)
      Linha23(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   IF Confirma("Confirma Exclus�o da Categoria ?")
      Aguarde("Eliminando...")

      WHILE !CATEGORIA->(NetLReg()); ENDDO
      CATEGORIA->(DBDELETE()); CATEGORIA->(DBUNLOCK()); CATEGORIA->(DBCOMMIT())
      Aguarde(); Linha23(msg)
   ENDIF
   RETURN(.T.)
*嬪様様様様様様様様様様様様様様邑
*� Editar campos de dados       �
*塒様様様様様様様様様様様様様様余
STATIC PROCEDURE EditaGet(pOp)
   @ 17,07 SAY "Categoria:"  GET wIDCat  PICT "@!" WHEN pOp=="I" VALID !EMPTY(wIDCat).AND.TExist(wIDCat)
   @ 18,07 SAY "Descri��o:"  GET wDescr  PICT "@!"               VALID LASTKEY()==K_UP.OR.!EMPTY(wDescr)
   RETURN
*嬪様様様様様様様様様様様様様様邑
*� Testar Codigo j� Existe      �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION TExist(pVar)
  LOCAL nReg:=CATEGORIA->(RECNO()); lRet:=.F.
  CATEGORIA->(DBSETORDER(2))
  IF (lRet:=CATEGORIA->(DBSEEK(pVar)))
     Aviso("Categoria j� Cadastrada!")
  ENDIF
  CATEGORIA->(DBSETORDER(1))
  RETURN(!lRet)
