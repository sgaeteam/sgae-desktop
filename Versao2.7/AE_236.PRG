*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_222                           vrs 001 �
*� VRS 001        : Implantacao                              �
*� FINALIDADE     : Remarcar Aulas Teoricas                  �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           �
*� DATA CRIACAO   : 08/01/1996                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"

DBCLOSEALL()

SELECT 6
IF NetUse("DBFREQ","TEORICA")         /* Arquivo de Frequencias Te�ricas */
   SET INDEX TO DBIFREQ2, DBIFREQ1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 5
IF NetUse("DBTURMA","TURMA")        /* Tabela de Turmas */
   SET INDEX TO DBITURM1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("DBDISC","DISCIPLINA")       /* Tabela de Disciplinas */
   SET INDEX TO DBIDISC1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBINST","INSTRUTOR")       /* Cadastro de Instrutores */
   SET INDEX TO DBINST1, DBINST2
ELSE
   DBCLOSEALL(); RETURN
ENDIF
SET FILTER TO TIPO1="2"

SELECT 2
IF NetUse("DBFERI","FERIADO")         /* Cadastro de Feriados */
   SET INDEX TO DBIFER1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
        
SELECT 1
IF NetUse("DBALU","ALUNOS")           /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("AE235"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "22"
SET KEY -1 TO Mostra()
wData:=cDtSys;wTurma:=SPACE(10)
wInst:=SPACE(4);wDisc:=SPACE(2)
wMatr := SPACE(Len(ALUNOS->MATRIC))
wDataNova:=cDtSys;wTurmaNova:=SPACE(10)
WHILE .T.
   SETCOLOR(YCOREDIT)
   Telas(4,3,8,75,1,YCOREDIT,.T.,"Remarca��o de Aulas Te�ricas")
   Mensagem("Informe c�digo da Turma, Data da Aula e Aluno")
   @ 05,05 SAY "      Turma:" GET wTurma PICT "@!" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wTurma).AND.Pesquisa(5,1,wTurma,"Turma N�o Cadastrada!")
   @ 06,05 SAY "       Data:" GET wData PICT "@D"  WHEN TeclaFuncao();
     VALID LASTKEY()==K_UP.OR.!EMPTY(wData).AND.TData(wData)
   @ 05,30 SAY "  Instrutor:" GET wInst PICT "@!"  WHEN TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.!EMPTY(wInst).AND.Pesquisa(3,1,wInst,"N�o � Instrutor T�orico!").AND.;
     TDescr(3,1,5,48,wInst,"NOME",["@S25"])
   @ 06,30 SAY " Disciplina:" GET wDisc PICT "@!" ; 
     VALID LASTKEY()==K_UP.OR.!EMPTY(wDisc).AND.Pesquisa(4,1,wDisc,"Disciplina N�o Cadastrada!").AND.;
     TDescr(4,1,6,46,wDisc,"DESCR",["@S25"])
   @ 07,05 SAY "      Aluno:" GET wMatr PICT "@!";
     VALID LASTKEY()==K_UP.OR.!EMPTY(wMatr).AND.Pesquisa(1,1,wMatr,"Aluno N�o Cadastrado!").AND.;
     TDescr(1,1,7,24,wMatr,"NOME")
     
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF
   
   IF TEORICA->(DBSEEK(wTurma+DTOS(wData)+wDisc+wInst+wMatr))
      
      IF !"CANCELADO" $ TEORICA->STATUS
         IF "DESMARCADA" $ TEORICA->STATUS
   
            Telas(8,3,11,75,1,YCOREDIT,.T.)
            @ 08,03 SAY "�"+REPL("�",71)+"�"
            @ 09,05 SAY " Nova Turma:" GET wTurmaNova PICT "@!" WHEN TeclaFuncao(.T.);
              VALID !EMPTY(wTurma).AND.Pesquisa(5,1,wTurma,"Turma N�o Cadastrada!")
            @ 10,05 SAY "  Nova Data:" GET wDataNova  PICT "@D"  WHEN TeclaFuncao();
              VALID LASTKEY()==K_UP.OR.!EMPTY(wDataNova).AND.TData(wDataNova)
            SETCURSOR(1); READ; SETCURSOR(0)
            IF LASTKEY()==K_ESC; Rest_Tela(2); EXIT; ENDIF
                     
            IF Confirma("Confirma Remarca��o da Aula?")
               
               WHILE !TEORICA->(NetLReg()); ENDDO
               REPLACE TEORICA->TURMA  with wTurmaNova
               REPLACE TEORICA->DATA   with wDataNova
               REPLACE TEORICA->STATUS with "REMARCADA      "
               
               TEORICA->(DBUNLOCK())
             
               WHILE !ALUNOS->(NetLReg()); ENDDO
               REPLACE ALUNOS->DESMARCT with ALUNOS->DESMARCT - 1
               ALUNOS->(DBUNLOCK())
               
               ProcOk("Remarcada",.T.)
               
            ENDIF
            Rest_Tela()
            
         ELSE
            Aviso("Aula n�o foi Desmarcada",,3)  
         ENDIF
       ELSE
         Aviso("Aula j� foi Cancelada",,3)  
      ENDIF
   ELSE
      Aviso("Aluno n�o est� nesta turma e disciplina nesta data..."+DTOC(wData),,3)
   ENDIF
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL)
DBCLOSEALL(); RETURN
