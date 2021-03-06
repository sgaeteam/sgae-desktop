*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_312                           vrs 001 �
*� FINALIDADE     : Lista de Ve�culos                        �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            �
*� DATA CRIACAO   : 21/01/1996                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

DBCLOSEALL()
SELECT 2
IF NetUse("DBINST","INSTRUTOR")         /* Cadastro de Instrutores */
   SET INDEX TO DBINST1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBVEIC","VEICULOS")         /* Cadastro de Ve�culos */
   SET INDEX TO DBIVEI1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Ve�culos Vazio!",,3); DBCLOSEALL(); RETURN
ENDIF
ProgName("AE312"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "12"; wDevice:=" "

Quadro(15,20,17,35,1,YCOREDIT,.T.,,.T.)
WHILE .T.
   SETCOLOR(YCOREDIT)
   @ 16,22 SAY "Sa�da:" GET wDevice PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC
      IF LEN(Telas)==3; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   DBGOTOP()
   IF wDevice=="I"
      IF ChkImpr()
         cAviso := MsgImp()
         ImpRel()
         TiraMsgImp(cAviso)
         WaitMsg("Fim de Impress�o, tecle algo...")
      ENDIF
   ELSE
      Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar"); LimpaLinhaMsg(24)
      BrowCad()
   ENDIF
ENDDO
RELEASE continua, nPg
DBCLOSEALL(); RETURN
*嬪様様様様様様様様様様様様様様邑
*� Relatorio                    �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION ImpRel()
   Gera_TXT("VEICULOS.TXT"); SETPRC(0,0)
   pg := 0; continua := .T.
   CabRel311()
   WHILE continua.AND.!EOF()
      Compr_On()
      Cab_ESC(01,02,CODVEIC)
      Cab_ESC(00,06,PLACA,"[@R XXX-9999]")
      Cab_ESC(00,15,MARCA)
      Cab_ESC(00,46,TInst(CODINST),"[@S30]")
      DBSKIP()
   ENDDO
   Compr_Off()

   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp veiculos.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE VEICULOS.TXT
   RETURN
*嬪様様様様様様様様様様様様様様邑
*� Localizar Nome do Instrutor  �
*塒様様様様様様様様様様様様様様余
FUNCTION TInst(pVar)
  INSTRUTOR->(DBSEEK(pVar))
  RETURN(INSTRUTOR->NOME)
*嬪様様様様様様様様様様様様様様邑
*� Cabe�alho                    �
*塒様様様様様様様様様様様様様様余
STATIC PROCEDURE CabRel311()
   pg++
   Compr_Off()
   @ PROW()+1,002 SAY cRazao
   @ PROW()+1,070 SAY DATE()
   @ PROW()+1,069 SAY "Pag.:"+STRZERO(pg,4)
   @ PROW()+1,002 SAY "LISTA DE VEICULOS"
   @ PROW()  ,002 SAY "LISTA DE VEICULOS"
   @ PROW()+1,002 SAY REPLICATE("�",78)
   @ PROW()+1,002 SAY "COD PLACA    MARCA                          INSTRUTOR"
*                      99  XXX-9999 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX
*                      234567890123456789012345678901234567890123456789012345678901234567890123456789
*                              1         2         3         4         5         6         7
   @ PROW()+1,002 SAY REPLICATE("�",78)
   RETURN
*嬪様様様様様様様様様様様様様様様邑
*� Browse do Cadastro             �
*塒様様様様様様様様様様様様様様様余
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol
   SETCOLOR(YCORGERAL)
   Telas(2,0,22,79,1,YCORGERAL,.F.)
   oBr:=TBROWSEDB(3,1,21,78)
   oBr:headSep:="賃�"
   oBr:colSep:= " � "
   oBr:colorspec:=YCORGERAL

   oCol:=TBCOLUMNNEW("Placa",{|| TRANSFORM(PLACA,"@R XXX-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Marca",{|| TRANSFORM(MARCA,"@S20")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Instrutor",{|| TRANSFORM(TInst(CODINST),"@S30")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("C�digo",{|| CODVEIC})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Capacidade",{|| CAPACID })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Utilizado",{|| UTILIZA })
   oBr:addColumn(oCol)

   oBr:freeze:=1
   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL
