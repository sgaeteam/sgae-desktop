*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_302                           vrs 001 �
*� FINALIDADE     : Estatisticos Aulas por professor         �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           �
*� DATA CRIACAO   : 31/01/2001                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* C�digo do Instrutor        */
AADD(aDbf,{"NOME"     ,"C",   50,0}) /* Nome do Instrutor         */
AADD(aDbf,{"HH"       ,"N",   05,0}) /* Qtde de Horas / Aulas      */
WHILE .T.
   sHour:=TIME()
   cArq1:="AT"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf)
      RELEASE aDbf
      EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")

SELECT 1
IF NetUse("DBALU","ALUNOS")         /* Cadastro de Alunos */
   SET INDEX TO DBIALU3
ELSE
   DelDbfNtx(); RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Alunos Vazio!",,3); DBCLOSEALL(); RETURN
ENDIF
ProgName("AE302"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "01"

Quadro(13,20,17,55,1,YCOREDIT,.T.,,.T.)
wDtInic:=wDtFim:=CTOD(""); wDevice:=" "
SETCOLOR(YCOREDIT)
@ 14,22 SAY "Per�odo:            a"
@ 15,20 SAY "�"+REPLI("�",34)+"�"

WHILE .T.
   nMatric:=nAprov1:=nAprov2:=nCertif1:=nCertif2:=nReprov:=nDesiste:=0
   @ 14,31 GET wDtInic PICT "@D" VALID !EMPTY(wDtInic)
   @ 14,44 GET wDtFim  PICT "@D" VALID (LASTKEY()==K_UP).OR.wDtFim>=wDtInic
   @ 16,22 SAY "Sa�da:" GET wDevice PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC
      IF LEN(Telas)==3; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   SET SOFTSEEK ON
   ALUNOS->(DBSEEK(DTOS(wDtInic),.T.))
   SET SOFTSEEK OFF
   IF ALUNOS->(EOF())
      Aviso("N�o h� alunos matriculados neste per�odo!"); LOOP
   ENDIF

   Aguarde("Calculando...")
   WHILE ALUNOS->DTINSCR>=wDtInic.AND.ALUNOS->DTINSCR<=wDtFim.AND.!ALUNOS->(EOF())
      nMatric++
      IF !EMPTY(ALUNOS->DTAPROV1)
         nAprov1++
      ENDIF
      IF !EMPTY(ALUNOS->DTAPROV2)
         nAprov2++
      ENDIF
      IF !EMPTY(ALUNOS->DTAPROV1).AND.!EMPTY(ALUNOS->DTAPROV2)
         nReprov++
      ENDIF
      IF !EMPTY(ALUNOS->CERTIF1)
         nCertif1++
      ENDIF
      IF !EMPTY(ALUNOS->CERTIF2)
         nCertif2++
      ENDIF
      ALUNOS->(DBSKIP())
   ENDDO
   Aguarde()

   (cArq1)->(DBAPPEND())
   REPLACE (cArq1)->MATRIC   WITH nMatric,;
           (cArq1)->APROV1   WITH nAprov1,;
           (cArq1)->APROV2   WITH nAprov2,;
           (cArq1)->CERTIF1  WITH nCertif1,;
           (cArq1)->CERTIF2  WITH nCertif2,;
           (cArq1)->REPROV   WITH nReprov,;
           (cArq1)->DESISTE  WITH nDesiste

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
   (cArq1)->(__DBZAP())
ENDDO
RELEASE continua, nPg
DelDbfNtx(); RETURN
*嬪様様様様様様様様様様様様様様邑
*� Relatorio                    �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION ImpRel()
   Gera_TXT("AULAPROF.TXT"); SETPRC(0,0)
   @ PROW()+16,05 SAY PADC("RELATORIO MENSAL DE ATIVIDADES",75)
   @ PROW()+4,05 SAY PADC("MES/ANO",75)
   @ PROW()+1,05 SAY PADC(UPPER(ExtMes(wDtInic))+"/"+STR(YEAR(wDtInic),4)+" a "+UPPER(ExtMes(wDtFim))+"/"+STR(YEAR(wDtFim),4),75)
   @ PROW()+4,15 SAY "敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳堕陳陳陳陳陳陳朕"
   @ PROW()+1,15 SAY "�        N  O  M  E             �  QTDE. H/AULA�"
   @ PROW()+1,15 SAY "団陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳田陳陳陳陳陳陳調"
   @ PROW()+1,15 SAY "� Alunos Matriculados           �              �"
   @ PROW()  ,52 SAY nMatric PICT "@E 99,999"
   @ PROW()+1,15 SAY "団陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳田陳陳陳陳陳陳調"
   @ PROW()+1,15 SAY "� Alunos Aprovados (Teorica)    �              �"
   @ PROW()  ,52 SAY nAprov1 PICT "@E 99,999"
   @ PROW()+1,15 SAY "� Alunos Aprovados (Pratica)    �              �"
   @ PROW()  ,52 SAY nAprov2 PICT "@E 99,999"
   @ PROW()+1,15 SAY "団陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳田陳陳陳陳陳陳調"
   @ PROW()+1,15 SAY "� Alunos Reprovados             �              �"
   @ PROW()  ,52 SAY nReprov PICT "@E 99,999"
   @ PROW()+1,15 SAY "団陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳田陳陳陳陳陳陳調"
   @ PROW()+1,15 SAY "� Alunos Desistentes            �              �"
   @ PROW()  ,52 SAY nDesiste PICT "@E 99,999"
   @ PROW()+1,15 SAY "団陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳田陳陳陳陳陳陳調"
   @ PROW()+1,15 SAY "� Alunos Transferidos           �              �"
   @ PROW()  ,52 SAY nDesiste-nDesiste PICT "@E 99,999"
   @ PROW()+1,15 SAY "団陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳田陳陳陳陳陳陳調"
   @ PROW()+1,15 SAY "� Certificados Emitidos(Teorico)�              �"
   @ PROW()  ,52 SAY nCertif1 PICT "@E 99,999"
   @ PROW()+1,15 SAY "� Certificados Emitidos(Pratico)�              �"
   @ PROW()  ,52 SAY nCertif2 PICT "@E 99,999"
   @ PROW()+1,15 SAY "青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳祖陳陳陳陳陳陳潰"
   @ PROW()+3,05 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),75)
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp aulaprof.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE AULAPROF.TXT
   RETURN
*嬪様様様様様様様様様様様様様様様邑
*� Browse do Cadastro             �
*塒様様様様様様様様様様様様様様様余
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol
   SELECT (cArq1)
   SETCOLOR(YCORGERAL)
   Telas(2,0,22,79,1,YCORGERAL,.F.,"ATIVIDADES EM "+DTOC(wDtInic)+" a "+DTOC(wDtFim))
   oBr:=TBROWSEDB(3,1,21,78)
   oBr:headSep:="賃�"
   oBr:colSep:= " � "
   oBr:colorspec:=YCORGERAL

   oCol:=TBCOLUMNNEW("Matr�culas"   ,{|| TRANSFORM(MATRIC,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Aprovados (Teorico)",{|| TRANSFORM(APROV1,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Aprovados (Pratico)",{|| TRANSFORM(APROV2,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Reprovados"   ,{|| TRANSFORM(REPROV,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Certif. (Teorico)" ,{|| TRANSFORM(CERTIF1,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Certif. (Pratico)" ,{|| TRANSFORM(CERTIF2,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Desistentes"  ,{|| TRANSFORM(DESISTE,"@E 99,999")})
   oBr:addColumn(oCol)

   oBr:freeze:=1
   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F9 )  // Imprime
         IF ChkImpr()
            cAviso := MsgImp(.F.)
            ImpRel()
            WHILE Confirma("Outra C�pia ?")
               ImpRel()
            ENDDO
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impress�o, tecle algo...")
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL
