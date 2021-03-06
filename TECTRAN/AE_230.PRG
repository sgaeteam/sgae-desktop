*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_230                           vrs 001 �
*� VRS 001        : Implantacao                              �
*� FINALIDADE     : Avalia��o de Dire��o Veicular - Simulado �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           �
*� DATA CRIACAO   : 20/08/1996                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

DBCLOSEALL()
/* Criar Arquivo Tempor�rio */
aDbf:={}
AADD(aDbf,{"DESCR","C", 70,0}) /* Descri�ao da Falta   */
AADD(aDbf,{"GRAU" ,"C", 01,0}) /* Grau da Falta        */
AADD(aDbf,{"ITEM" ,"C", 01,0}) /* Item da Falta        */
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
INDEX ON grau+item TO (cArq1)

SELECT 6
IF NetUse("DBFALT","INFRACAO")        /* Cadastro de Infra��es Veiculares */
   SET INDEX TO DBIFAL1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 5
IF NetUse("DBFERI","FERIADO")         /* Cadastro de Feriados */
   SET INDEX TO DBIFER1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("DBVEIC","VEICULO")        /* Cadastro de Ve�culos */
   SET INDEX TO DBIVEI1,DBIVEI2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNO")           /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("DBINST","INSTRUTOR")      /* Cadastro de Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBAVAL","AVALIACAO")      /* Cadastro de Avalia��o do Aluno */
   SET INDEX TO DBIAVA2,DBIAVA1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg:="AE230"; ProgName("AE230"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "30"
SET KEY -1 TO Mostra()
Telas(4,3,8,68,1,YCOREDIT,.T.,"Prova de Dire��o Veicular - Teste Simulado")
WHILE .T.
   SETCOLOR(YCOREDIT); LinhaMsg(2)
   wIns:=SPACE(4); wVei:=SPACE(2); wDat:=CTOD("")
   Mensagem("Preencha os dados corretamente")
   @ 05,05 SAY "     Data:" GET wDat PICT "@D"   WHEN TeclaFuncao() VALID !EMPTY(wDat).AND.TData(wDat)
   @ 06,05 SAY "  Ve�culo:" GET wVei PICT "99"   WHEN TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.EMPTY(wVei).OR.(TDescr(4,1,6,21,wVei,"MARCA",,"Ve�culo N�o Cadastrado").AND.;
           Let(wIns:=VEICULO->CODINST).AND.TDescr(2,1,7,21,wIns,"NOME",["@S40"]))
   @ 07,05 SAY "Instrutor:" GET wIns PICT "9999" WHEN wIns==SPACE(4);
     VALID TDescr(2,1,7,21,wIns,"NOME",["@S40"],"Instrutor N�o Localizado").AND.TVeic(wIns)
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   Telas(8,3,11,68,1,YCOREDIT,.T.)
   WHILE .T.
      wNom:=SPACE(4); wSN:=" "; SETCOLOR(YCOREDIT)
      @ 09,05 SAY "Matr�cula:" GET wNom PICT "9999" WHEN TeclaFuncao(.T.);
        VALID !EMPTY(wNom).AND.TDescr(3,1,9,21,wNom,"NOME",["@S40"],"Matr�cula N�o Localizada").AND.TAulaPend()
      @ 10,05 SAY " Aprovado:" GET wSN  PICT "!"    WHEN TeclaFuncao().AND.HTela(2) VALID VTela(2);
        .AND.Let(IF(wSN=="N",Infracao(),Avaliacao()))
      SETCURSOR(1); READ; SETCURSOR(0)
      SCROLL(9,5,10,67,0); SETCOLOR(YCOREDIT)
      IF LASTKEY()==K_ESC
         IF LEN(Telas)==5; Rest_Tela(); ENDIF
         EXIT
      ENDIF
   ENDDO
   Rest_Tela()
   SCROLL(5,5,7,67,0)
ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
*嬪様様様様様様様様様様様様様様邑
*� Registrar Infra��es          �
*塒様様様様様様様様様様様様様様余
FUNCTION Infracao(pLocal)
   LOCAL wFalta:=SPACE(70), wRef:=ALUNO->OBS, xTela:=SAVESCREEN(2,0,24,79), GetList:={}
   LinhaMsg(4)
   (cArq1)->(__dbzap())
   /* Alimentar com dados da Reprova��o */
   AVALIACAO->(DBSEEK(wNom))
   WHILE AVALIACAO->MATRIC==wNom.AND.!AVALIACAO->(EOF())
      (cArq1)->(DBAPPEND())
      REPLACE (cArq1)->GRAU WITH AVALIACAO->GRAU,;
              (cArq1)->ITEM WITH AVALIACAO->ITEM
      WHILE !AVALIACAO->(NetLReg()); ENDDO
      AVALIACAO->(DBDELETE())
      AVALIACAO->(DBSKIP())
   ENDDO

   SELECT (cArq1); DBGOTOP()
   SETCOLOR(YCOREDIT)
   Telas(11,3,19,68,1,YCOREDIT,.T.,"Resultado do Teste Simulado")
   msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

   oBr:=TBROWSEDB(12,4,18,67)
   oBr:headSep:="賃�"
   oBr:colSep:= " � "

   oCol:=TBCOLUMNNEW("Descri��o",{|| TRANSFORM(PegaInfra((cArq1)->GRAU+(cArq1)->ITEM),"@!S54")})
   oBr:addColumn(oCol)

   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         (cArq1)->(DBGOTOP())
         WHILE !(cArq1)->(EOF())
            /* Atualizar arquivo de Avalia��o */
            WHILE !AVALIACAO->(NetApp()); ENDDO
            REPLACE AVALIACAO->DATA    WITH wDat,;
                    AVALIACAO->CODINST WITH wIns,;
                    AVALIACAO->CODVEIC WITH wVei,;
                    AVALIACAO->MATRIC  WITH wNom,;
                    AVALIACAO->GRAU    WITH (cArq1)->GRAU,;
                    AVALIACAO->ITEM    WITH (cArq1)->ITEM
            AVALIACAO->(DBUNLOCK()); AVALIACAO->(DBCOMMIT())
            (cArq1)->(DBSKIP())
         ENDDO
         wRef:=""
         EditaMemo(@wRef,14,6,19,68,"Observa��es")
         WHILE !ALUNO->(NetLReg()); ENDDO
         REPLACE ALUNO->OBS     WITH wRef,;
                 ALUNO->DTAPROV WITH CTOD("") /* Data da Reprova��o no Simulado */
         ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())
         ProcOk("Registrado...",.T.)
         EXIT
      ELSEIF ( tecla == K_F1 )
         Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
      ELSEIF ( tecla == K_F2 )
         Ajuda()
      ELSEIF ( tecla == K_F6 )     /* Inclui */
         Telas(8,5,10,66,1,YCOREDIT,.T.,"Inclus�o")
         xDescr:=SPACE(70)
         @ 09,07 SAY "Descri��o:"GET xDescr PICT "@!S48" WHEN Consulta(6,1,"Infra��o","Grau","DESCR","GRAU","DESCR") VALID !EMPTY(xDescr)
         SETCURSOR(1); READ; SETCURSOR(0)
         IF LASTKEY()==K_ESC; EXIT; ENDIF
         IF Confirma("Confirma Infra��o ?")
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->GRAU  WITH INFRACAO->GRAU,;
                    (cArq1)->ITEM  WITH INFRACAO->ITEM,;
                    (cArq1)->DESCR WITH INFRACAO->DESCR
            (cArq1)->(DBCOMMIT())
         ENDIF
         Rest_Tela()
         oBr:Refreshall()
      ELSEIF ( tecla == K_ALT_E)   /* Exclui */
         IF !EMPTY((cArq1)->GRAU)
            (cArq1)->(DBDELETE()); (cArq1)->(__DBPACK())
            oBr:Refreshall()
         ELSE
            Aviso("N�o h� registro a ser Exclu�do...",,3)
         ENDIF
      ELSEIF ( tecla == K_ENTER)   /* Altera */
         Aviso("Op��o N�o Dispon�vel...",,3)
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
   ENDDO
   Rest_Tela(); SETCOLOR(YCOREDIT)
   RESTSCREEN(2,0,24,79,xTela)
*嬪様様様様様様様様様様様様様様邑
*� Registrar Avalia��o          �
*塒様様様様様様様様様様様様様様余
FUNCTION Avaliacao(pLocal)
   LOCAL wRef:=ALUNO->OBS, xTela:=SAVESCREEN(2,0,24,79)
   EditaMemo(@wRef,14,6,19,68,"Observa��es")
   IF pLocal=="D".AND.Confirma("Confirma Aprova��o ?")
      WHILE !ALUNO->(NetLReg()); ENDDO
      REPLACE ALUNO->DTAPROV WITH wDat,;
              ALUNO->OBS     WITH wRef
      ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())
   ENDIF
   RESTSCREEN(2,0,24,79,xTela)
   RETURN NIL
*嬪様様様様様様様様様様様様様様様邑
*� Localizar Ve�culo do Instrutor �
*塒様様様様様様様様様様様様様様様余
FUNCTION TVeic(pVar)
  VEICULO->(DBSETORDER(2)); VEICULO->(DBSEEK(pVar))
  wVei:=VEICULO->CODVEIC
  @ 06,16 SAY wVei PICT "99" COLOR YCORGET
  VEICULO->(DBSETORDER(1))
  TDescr(4,1,6,21,wVei,"MARCA")
  RETURN .T.
*嬪様様様様様様様様様様様様様様邑
*� Testar Item j� Cadastrado    �
*塒様様様様様様様様様様様様様様余
STATIC FUNCTION TInfra(pVar)
  LOCAL nReg:=RECNO()
  IF FALTAS->(DBSEEK(pVar))
     Aviso("Infra��o j� Cadastrada...",,3); GO nReg; RETURN .F.
  ENDIF
  GO nReg
  RETURN .T.
