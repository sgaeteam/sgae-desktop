*嬪様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
*� PROGRAMA       : AE_PROC                          vrs 001 �
*� VRS 001        : Desenvolvimento                          �
*� FINALIDADE     : Procedimentos Auxiliares                 �
*� PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           �
*� DATA CRIACAO   : 09/08/1994                               �
*� ATUALIZACAO    : 22/02/1995                               �
*塒様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�
#include "INKEY.CH"
#include "COMMAND.CH"

*嬪様様様様様様様様様様様様様様邑
*� Programa��o Manual           �
*塒様様様様様様様様様様様様様様余
FUNCTION Incluir(msg)
   LOCAL nReg_Ant := RECNO(), lInc := .F.

   IF VALTYPE(cArq1)=="L"; cArq1:=""; ENDIF
   SETCOLOR(YCOREDIT)
   cArea := ALIAS()
   IF cArea=="USER"
      Telas(16,2,20,39,c_nBorda,YCOREDIT,.T.," Inclus�o ")
      @ 17,3 SAY "Chave   :"
      @ 18,3 SAY "Usu�rio :"
      @ 19,3 SAY "Senha   :"
   ENDIF

   DBGOBOTTOM()
   WHILE .T.
      IF cArea=="USER"
         cMsg_Aux := "Senha"
         cCod3    := SPACE(4)
         cSetor   := SPACE(30)
         cSenha   := ""
         Mensagem("Preencha com o N�mero da Chave")
         @ 17,13 GET cCod3 PICT "@!" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ENDIF
      SETCURSOR(1); READ; SETCURSOR(0)

      SELECT (cArea)
      IF LASTKEY() == K_ESC
         GO nReg_Ant; EXIT
      ENDIF

      IF !DBSEEK (cCod3)
         WHILE .T.
            IF cArea=="USER"
               Mensagem("Preencha com o Nome do Usu�rio")
               cMsg_Aux := "Usu�rio"
               @ 18,13 GET cSetor PICT "@!S25" VALID !EMPTY(cSetor) COLOR YCOREDIT
               SETCURSOR(1); READ; SETCURSOR(0)

               SET ORDER TO 1
               IF LASTKEY() == K_ESC
                  GO nReg_Ant
                  Rest_Tela(); Mensagem(msg)
                  RETURN(lInc)
               ENDIF

               LOCATE FOR ALLTRIM(USER->USUARIO) == ALLTRIM(cSetor)
               IF FOUND()
                  Aviso(cMsg_Aux+" j� Cadastrado",YCORAVISO,2)
                  LOOP
               ENDIF
            ENDIF
            EXIT
         ENDDO

         IF cArea=="USER"
            Mensagem("Informe a Senha com 6 d�gitos")
            cSenha := Test_Entry(19,13,6,cSenha,"PW",YCOREDIT)
            IF LASTKEY()==K_ESC .OR. LASTKEY()==K_TAB
               Rest_Tela()
               Mensagem(msg)
               SETCURSOR(0)
               RETURN(.F.)
            ENDIF
            IF Confirma("Confirma Inclus�o ?")
               IF NetApp()
                  lInc := .T.
                  REPLACE _FIELD->CHAVE    WITH cCod3 ,;
                          _FIELD->USUARIO  WITH cSetor,;
                          _FIELD->SENHA    WITH Codifica(cSenha)
                  UNLOCK
                  DBCOMMITALL()
                  ProcOk("Gravado",.T.)
               ENDIF
               EXIT
            ENDIF
         ENDIF
      ELSE
         Aviso(cMsg_Aux+" j� Existente",YCORAVISO,2)
         LOOP
      ENDIF
   ENDDO
   SET ORDER TO 1
   Rest_Tela()
   Mensagem(msg)
   SETCURSOR(0)
   RETURN(lInc)
*嬪様様様様様様様様様様様様様様邑
*� Alterar Dados no Browse      �
*塒様様様様様様様様様様様様様様余
FUNCTION Alterar(msg)
   LOCAL nReg_Ant := RECNO(), lAlt := .F.

   IF VALTYPE(cArq1)=="L"; cArq1:=""; ENDIF
   DBGOTOP()
   IF EOF()
      Aviso("N�o h� registro a ser alterado !",YCORAVISO,2)
      Mensagem(msg)
      RETURN(lAlt)
   ENDIF
   GO nReg_Ant

   cArea := ALIAS()
   SETCOLOR(YCOREDIT)
   IF cArea=="USER"
      IF cPrg=="AE192"
         IF CHAVE=="NET4"
            Aviso("Acesso Negado...",,1.5)
            Mensagem(msg)
            RETURN(lAlt)
         ENDIF
         cCod3  := _FIELD->NIVEL
         cSetor := ""

         IF nNivel==5
            IF cCod3 >= nNivel
               Aviso("Altera��o n�o Autorizada...",,1.5)
               Mensagem(msg)
               RETURN(lAlt)
            ENDIF
         ENDIF

         Telas(16,2,18,39,c_nBorda,YCOREDIT,.T.," Altera��o ")
         @ 17,3 SAY "N�vel   :"
      ELSE
         // Tentativa de alteracao de chave de outro usuario
         IF cChave # CHAVE
            Aviso("Acesso Negado...",,1.5)
            Mensagem(msg)
            RETURN(lAlt)
         ENDIF

         cCod3 := _FIELD->CHAVE
         IF cCod3=="NET4"
            Aviso("Este registro N�O pode ser alterado!. Tecle algo...")
            Mensagem(msg)
            RETURN(lAlt)
         ENDIF

         Telas(16,2,20,39,c_nBorda,YCOREDIT,.T.," Altera��o ")
         cSetor := _FIELD->USUARIO
         cSenha := ""
         @ 17,3 SAY "Chave   :"
         @ 18,3 SAY "Usu�rio :"
         @ 19,3 SAY "Senha   :"
      ENDIF
   ENDIF

   cCod3_Ant  := cCod3
   cSetor_Ant := cSetor
   lMudou     := .F.

   WHILE .T.
      IF cArea=="USER"
         IF cPrg=="AE192"
            Mensagem("Informe o N�vel de Acesso do Usu�rio")
            @ 17,13 GET cCod3 PICT "9" COLOR YCOREDIT VALID TNivel(cCod3)
         ELSE
            cMsg_Aux := "Chave"
            @ 17,13 GET cCod3  PICT "@!"
            @ 18,13 GET cSetor PICT "@!S25"
            CLEAR GETS
            Mensagem("Preencha com a Nova Chave do Usu�rio")
            @ 17,13 GET cCod3 PICT "@!" VALID !EMPTY(cCod3) COLOR YCOREDIT
         ENDIF
      ENDIF
      SETCURSOR(1); READ; SETCURSOR(0)
      SELECT (cArea)

      IF LASTKEY() == K_ESC; EXIT; ENDIF

      IF cCod3 # cCod3_Ant
         IF DBSEEK (cCod3)
            Aviso(cMsg_Aux+" j� Cadastrado.",YCORAVISO,2)
            GO nReg_Ant
            cCod3  := cCod3_Ant
            lMudou := .F.
            LOOP
         ELSE
            GO nReg_Ant
            lMudou := .T.
         ENDIF
      ENDIF

      WHILE .T.
        IF cArea=="USER"
           IF cPrg=="AE192"; EXIT; ENDIF
           Mensagem("Preencha com o Nome do Usu�rio")
           cMsg_Aux := "Usu�rio"
           @ 18,13 GET cSetor PICT "@!S25" VALID !EMPTY(cSetor) COLOR YCOREDIT
           SETCURSOR(1); READ; SETCURSOR(0)

           IF LASTKEY() == K_ESC
              SET ORDER TO 1
              GO nReg_Ant
              Rest_Tela(); Mensagem(msg)
              RETURN(lAlt)
           ENDIF

           IF cSetor # cSetor_Ant
              SET ORDER TO 1
              LOCATE FOR ALLTRIM(USER->USUARIO)==ALLTRIM(cSetor)
              IF FOUND()
                 Aviso(cMsg_Aux+" j� Cadastrado",YCORAVISO,2)
                 GO nReg_Ant
                 LOOP
              ELSE
                 GO nReg_Ant
                 lMudou := .T.
              ENDIF
           ENDIF
         ENDIF
         EXIT
      ENDDO

      IF cArea=="USER"
         IF cPrg=="AE192"
            IF UPDATED() .OR. lMudou
               IF Confirma("Confirma Altera��o ?")
                  IF NetLReg()
                     lAlt := .T.
                     REPLACE _FIELD->NIVEL WITH cCod3
                     UNLOCK
                     DBCOMMITALL()
                     ProcOk("Alterado",.T.)
                  ENDIF
                  EXIT
               ENDIF
            ELSEIF !UPDATED() .AND. !lMudou
               EXIT
            ENDIF
         ELSE
            Mensagem("Informe a Senha com 6 d�gitos")
            cPassAnt := Codifica(_FIELD->SENHA)
            cSenha   := Test_Entry(19,13,6,cSenha,"PW",YCOREDIT)
            IF LASTKEY()==K_ESC .OR. LASTKEY()==K_TAB
               Rest_Tela()
               Mensagem(msg)
               SETCURSOR(0)
               RETURN(.F.)
            ENDIF
            IF cSenha # cPassAnt ; lMudou := .T. ; ENDIF
            IF UPDATED() .OR. lMudou
               IF Confirma("Confirma Altera��o ?")
                  IF NetLReg()
                     lAlt := .T.
                     REPLACE _FIELD->CHAVE    WITH cCod3 ,;
                             _FIELD->USUARIO  WITH cSetor,;
                             _FIELD->SENHA    WITH Codifica(cSenha)
                     UNLOCK
                     DBCOMMITALL()
                     ProcOk("Alterado",.T.)
                  ENDIF
                  EXIT
               ENDIF
            ELSEIF !UPDATED() .AND. !lMudou
               EXIT
            ENDIF
         ENDIF
      ENDIF
   ENDDO
   SET ORDER TO 1
   Rest_Tela(); Mensagem(msg)
   GO nReg_Ant
   RETURN(lAlt)
*嬪様様様様様様様様様様様様様様邑
*� Excluir Dados no Browse      �
*塒様様様様様様様様様様様様様様余
FUNCTION Excluir(msg)
   LOCAL nReg_Ant := RECNO(), lExcl := .F.

   DBGOTOP()
   IF EOF()
      Aviso("N�o h� registro a ser eliminado !",YCORAVISO,2)
      Mensagem(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   IF ALIAS()=="USER"
      wChave := _FIELD->CHAVE
      IF nNivel < 5
         IF cChave==wChave
            Aviso("Usu�rio est� ativo! Registro Mantido.",YCORAVISO,3)
         ELSE
            Aviso("Usu�rio n�o Autorizado! Tecle algo...")
         ENDIF
      ELSEIF nNivel >= 5
         IF cChave==wChave
            Aviso("Usu�rio est� ativo! Registro Mantido.",YCORAVISO,3)
         ELSEIF cChave # wChave .AND. NIVEL > nNivel
            Aviso("Acesso Negado...",,1.5)
         ELSEIF cChave # wChave .AND. NIVEL == nNivel
            Aviso("Exclus�o Negada...",,1.5)
         ELSEIF cChave # wChave .AND. NIVEL < nNivel
            IF wChave=="NET4"
               Aviso("Usu�rio N�O pode ser Exclu�do! Tecle algo...")
            ELSE
               IF NetLReg()
                  lExcl := .T.
                  DBDELETE(); UNLOCK
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ELSE
      IF NetLReg()
         lExcl := .T.
         DBDELETE(); UNLOCK
      ENDIF
   ENDIF
   IF lExcl ; ProcOk("Eliminado",.T.) ; ENDIF
   Mensagem(msg)
   RETURN(lExcl)
*嬪様様様様様様様様様様様様様様邑
*� Localizar Registro no Browse �
*塒様様様様様様様様様様様様様様余
FUNCTION Localizar(msg)
   LOCAL nReg_Ant := RECNO(), lLoc := .F.

   DBGOTOP()
   IF EOF()
      Aviso("N�o h� registro a ser Localizado !",YCORAVISO,2)
      Mensagem(msg)
      RETURN(lLoc)
   ENDIF
   GO nReg_Ant

   cArea  := ALIAS()
   cOrdem := INDEXORD()
   SETCOLOR(YCOREDIT)
   Telas(16,8,19,60,c_nBorda,YCOREDIT,.T.)
   MsgTela(16,10," Localizar ")
   WHILE .T.
      pChave := SPACE(50)
      @ 18,10 SAY "T�tulo:" GET pChave PICT "@!S41"
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()==K_ESC.OR.EMPTY(pChave); EXIT; ENDIF

      lLoc:=Pesquisa(cArea,cOrdem,ALLTRIM(pChave),"Registro n�o Localizado!")
      IF !lLoc
         GO nReg_Ant
      ELSE
         EXIT
      ENDIF
   ENDDO
   Rest_Tela()
   RETURN(lLoc)
*嬪様様様様様様様様様様様様様様邑
*� Auxilio de Entrada de Dados  �
*塒様様様様様様様様様様様様様様余
FUNCTION HTela(nPar)
   SETCURSOR(0)
   IF nPar==1
      Telas(13,38,18,58,1,YCORAVISO,.T.)
      @ 14,39 SAY "S - Solteiro(a)"   COLOR YCORAVISO
      @ 15,39 SAY "C - Casado(a)"     COLOR YCORAVISO
      @ 16,39 SAY "D - Desquitado(a)" COLOR YCORAVISO
      @ 17,39 SAY "V - Vi�vo(a)"      COLOR YCORAVISO
   ELSEIF nPar==2
      Telas(12,51,15,62,1,YCORAVISO,.T.)
      @ 13,52 SAY "S - Sim "   COLOR YCORAVISO
      @ 14,52 SAY "N - N�o "   COLOR YCORAVISO
   ELSEIF nPar==3
      Telas(12,51,17,66,1,YCORAVISO,.T.)
      @ 13,52 SAY "E - Escola"     COLOR YCORAVISO
      @ 14,52 SAY "R - Resid�ncia" COLOR YCORAVISO
      @ 15,52 SAY "P - P�a.NS Luz" COLOR YCORAVISO
      @ 16,52 SAY "O - Outros"     COLOR YCORAVISO
   ELSEIF nPar==4
      Telas(14,25,18,39,1,YCORAVISO,.T.)
      @ 15,26 SAY "C - Carteira" COLOR YCORAVISO
      @ 16,26 SAY "B - Banco"    COLOR YCORAVISO
      @ 17,26 SAY "O - Outros"   COLOR YCORAVISO
   ELSEIF nPar==5
      Telas(18,25,21,41,1,YCORAVISO,.T.)
      @ 19,26 SAY "T - Tela"       COLOR YCORAVISO
      @ 20,26 SAY "I - Impressora" COLOR YCORAVISO
   ELSEIF nPar==6
      Telas(14,25,18,41,1,YCORAVISO,.T.)
      @ 15,26 SAY "D - Dinheiro"    COLOR YCORAVISO
      @ 16,26 SAY "C - Cheque"      COLOR YCORAVISO
      @ 17,26 SAY "A - Dinh/Cheque" COLOR YCORAVISO
   ELSEIF nPar==7
      Telas(14,25,17,41,1,YCORAVISO,.T.)
      @ 15,26 SAY "P - Pr�tico"     COLOR YCORAVISO
      @ 16,26 SAY "S - Sinais"      COLOR YCORAVISO
   ELSEIF nPar==8
      Telas(14,25,18,39,1,YCORAVISO,.T.)
      @ 15,26 SAY "1 - Pr�tico"     COLOR YCORAVISO
      @ 16,26 SAY "2 - Te�rico"     COLOR YCORAVISO
      @ 17,26 SAY "3 - Ambos"       COLOR YCORAVISO
   ELSEIF nPar==9
      Telas(14,25,19,39,1,YCORAVISO,.T.)
      @ 15,26 SAY "1 - Manh�"       COLOR YCORAVISO
      @ 16,26 SAY "2 - Tarde"       COLOR YCORAVISO
      @ 17,26 SAY "3 - Noite"       COLOR YCORAVISO
      @ 18,26 SAY "4 - Integral"    COLOR YCORAVISO
   ELSEIF nPar==10
      Telas(12,51,18,66,1,YCORAVISO,.T.)
      @ 13,52 SAY "1 - Apto"       COLOR YCORAVISO
      @ 14,52 SAY "2 - Inapto"     COLOR YCORAVISO
      @ 15,52 SAY "3 - Remarcado"  COLOR YCORAVISO
      @ 16,52 SAY "4 - Faltou"     COLOR YCORAVISO
      @ 17,52 SAY "9 - S/Exame"    COLOR YCORAVISO
   ELSEIF nPar==11
      Telas(15,10,18,25,1,YCORAVISO,.T.)
      @ 16,12 SAY "E - Exame"      COLOR YCORAVISO
      @ 17,12 SAY "R - Refor�o"    COLOR YCORAVISO
   ELSEIF nPar==12
      Telas(12,20,16,29,1,YCORAVISO,.T.)
      @ 13,22 SAY "1� Via"  COLOR YCORAVISO
      @ 14,22 SAY "2� Via"  COLOR YCORAVISO
      @ 15,22 SAY "Troca "  COLOR YCORAVISO
   ELSEIF nPar==13
      Telas(7,25,13,63,1,YCORAVISO,.T.)
      @ 08,26 SAY "1 - Tem carro com seguro"            COLOR YCORAVISO
      @ 09,26 SAY "2 - Tem carro sem seguro"            COLOR YCORAVISO
      @ 10,26 SAY "3 - N�o tem carro, quer comprar"     COLOR YCORAVISO
      @ 11,26 SAY "4 - N�o tem carro, n�o pode comprar" COLOR YCORAVISO
      @ 12,26 SAY "5 - Tem carro, mas quer trocar"      COLOR YCORAVISO
   ELSEIF nPar==14
      Telas(7,25,18,47,1,YCORAVISO,.T.,"Fonte Marketing")
      @ 08,26 SAY "1 - Indica��o"  COLOR YCORAVISO
      @ 09,26 SAY "2 - Panfleto"   COLOR YCORAVISO
      @ 10,26 SAY "3 - �nibus"     COLOR YCORAVISO
      @ 11,26 SAY "4 - Telelista"  COLOR YCORAVISO
      @ 12,26 SAY "5 - Editel"     COLOR YCORAVISO
      @ 13,26 SAY "6 - Outdoor"    COLOR YCORAVISO
      @ 14,26 SAY "7 - Internet"   COLOR YCORAVISO
      @ 15,26 SAY "8 - TV/R�dio"   COLOR YCORAVISO
      @ 16,26 SAY "9 - Jornal"     COLOR YCORAVISO
      @ 17,26 SAY "0 - Outro"      COLOR YCORAVISO
   ELSEIF nPar==15
      Telas(7,25,15,47,1,YCORAVISO,.T.,"Setor")
      @ 08,26 SAY "0 - Todos"      COLOR YCORAVISO
      @ 09,26 SAY "1 - Recep��o"   COLOR YCORAVISO
      @ 10,26 SAY "2 - Secretaria" COLOR YCORAVISO
      @ 11,26 SAY "3 - Financeiro" COLOR YCORAVISO
      @ 12,26 SAY "4 - Administ."  COLOR YCORAVISO
      @ 13,26 SAY "5 - Supervis�o" COLOR YCORAVISO
      @ 14,26 SAY "6 - Diretoria"  COLOR YCORAVISO
   ELSEIF nPar==16
      Telas(7,25,15,47,1,YCORAVISO,.T.,"Setor")
      @ 08,26 SAY "1 - Resolvido"     COLOR YCORAVISO
      @ 09,26 SAY "2 - N�o Resolvido" COLOR YCORAVISO
      @ 10,26 SAY "3 - Pendente"      COLOR YCORAVISO
   ENDIF
   SETCURSOR(1)
   RETURN .T.
*嬪様様様様様様様様様様様様様様邑
*� Testar tecla digitada Auxilio�
*塒様様様様様様様様様様様様様様余
FUNCTION VTela(nPar)
  LOCAL lOk:=.F.
  IF nPar==1
     lOk:=IF(wCivil $ "SCDV",.T.,.F.)
  ELSEIF nPar==2
     lOk:=IF(wSN $ "SN",.T.,.F.)
  ELSEIF nPar==3
     lOk:=IF(wEmbarq $ "ERPO",.T.,.F.)
  ELSEIF nPar==4
     lOk:=IF(wCobranca $ "CBO",.T.,.F.)
  ELSEIF nPar==5
     lOk:=IF(wDevice $ "TI",.T.,.F.)
  ELSEIF nPar==6
     lOk:=IF(wForma $ "DCA",.T.,.F.)
  ELSEIF nPar==7
     lOk:=IF(wTipo $ "PS",.T.,.F.)
  ELSEIF nPar==8
     lOk:=IF(wCateg $ "123",.T.,.F.)
  ELSEIF nPar==9
     lOk:=IF(vTurno $ "1234",.T.,.F.)
  ELSEIF nPar==10
     lOk:=IF(wResultado $ "12349",.T.,.F.)
  ELSEIF nPar==11
     lOk:=IF(wTipo $ "ER",.T.,.F.)
  ELSEIF nPar==12
     lOk:=IF(wSit $ "12T",.T.,.F.)
  ELSEIF nPar==13
     lOk:=IF(wAuto $ "12345",.T.,.F.)
  ELSEIF nPar==14
     lOk:=IF(wPesq $ "1234567890",.T.,.F.)
  ELSEIF nPar==15
     IF SUBS(xSetor,1,1) $ "0123456" .OR. SUBS(xSetor,2,1) $ "0123456" .OR. SUBS(xSetor,3,1) $ "0123456"
        lOk:=.T.
     ELSE
        lOk:=.F.
     ENDIF
  ELSEIF nPar==16
     lOk:=IF(xPrazo $ "123",.T.,.F.)
  ENDIF
  IF lOk;Rest_Tela();ENDIF
  RETURN lOk
*嬪様様様様様様様様様様様様様様邑
*� Excluir Arquivo Temporario   �
*塒様様様様様様様様様様様様様様余
FUNCTION DelDbfNtx()
   DBCLOSEALL()
   fDbf1:=cArq1+".DBF"
   fNtx1:=cArq1+".NTX"
   ERASE (fDbf1); ERASE (fNtx1)
   RETURN
*嬪様様様様様様様様様様様様様様邑
*� Excluir Arquivo Temporario   �
*塒様様様様様様様様様様様様様様余
FUNCTION DelDbfNtx2()
   DBCLOSEALL()
   fDbf2:=cArq2+".DBF"
   fNtx2:=cArq2+".NTX"
   ERASE (fDbf2); ERASE (fNtx2)
   RETURN
*嬪様様様様様様様様様様様様様様邑
*� Nome do Programa em Execu��o �
*塒様様様様様様様様様様様様様様余
PROCEDURE ProgName(prg)
   @ 01,00 SAY prg COLOR "W/R"
   RETURN
*嬪様様様様様様様様様様様様様様邑
*� Exibe linha Msg p/teclas func�
*塒様様様様様様様様様様様様様様余
FUNCTION LinhaMsg(modo)
   LOCAL corant := SETCOLOR()
   DEFAULT modo TO 1
   IF modo == 1
      Linha23("^ESC^-Sa�da ^F4^-Calculadora ^F5^-Calend�rio",24)
   ELSEIF modo==2
      Linha23("^ESC^-Retorna ^F4^-Calculadora ^F5^-Calend�rio",24)
   ELSEIF modo==3
      Linha23("^ESC^-Finaliza ^^-Movimenta��o ^ENTER^-Altera",24)
   ELSEIF modo==4
      Linha23("^ESC^-Retorna  ^F2^-Altera ^F6^-Inclui ^ALT+E^-Exclui",24)
   ELSEIF modo==5
      Linha23("^ESC^-Abandona ^^-Cor da Letra  ^<- ->^-Cor do Fundo  ^ENTER^-Confirma",24)
   ELSEIF modo==6
      Linha23("^ESC^-Cancela",24)
   ELSEIF modo==7
      Linha23("^ESC^-Retorna ^F4^-Calculadora ^F5^-Calend�rio ^F9^-Imprime",24)
   ELSEIF modo==8
      Linha23("^ESC^-Volta ^F6^-Marca ^F8^-Vende+Aulas  ^F9^-Imprime ^F11^-Pesquisa Vagas",24)
   ELSEIF modo==9
      Linha23("^ESC^-Retorna  ^ENTER^-Efetua Pagamento  ^INS^-Inclui Pagamento",24)
   ELSEIF modo==10
      Linha23("^ESC^-Retorna ^F9^-Imprimir",24)
   ELSEIF modo==11
      Linha23("^ESC^-Retorna ^ENTER^-Registra Aula",24)
   ELSEIF modo==12
      Linha23("^ESC^-Retorna ^F2^-Ajuda ^F6^-Inclui ^ALT+E^-Exclui ^F9^-Imprime",24)
   ELSEIF modo==13
      Linha23("^ESC^-Retorna ^ENTER^-Marca/Desmarca ^F6^-Todos Canc ^F7^-Todos Ok",24)
   ENDIF
   SETCOLOR(corant)
   RETURN NIL
*嬪様様様様様様様様様様様様様様邑
*� Cabe�alho de Relatorios      �
*塒様様様様様様様様様様様様様様余
PROCEDURE CabRel(pTexto,lPg)
   DEFAULT lPg TO .T.
   IF lPg; xpg++; ENDIF
   @ PROW()+1,05 SAY UPPER(cRazao1)
   @ PROW()+2,05 SAY pTexto
   @ PROW()+1,05 SAY "Data..: "+DTOC(DATE())
   IF lPg
      @ PROW()+1,05 SAY "Pagina:"+STRZERO(xpg,4)
   ENDIF
   @ PROW()+1,05 SAY ""
   RETURN
*嬪様様様様様様様様様様様様�
*� Pegar Nome do Aluno     �
*塒様様様様様様様様様様様様�
FUNCTION PegaAluno(pCod)
   ALUNO->(DBSEEK(pCod))
   RETURN(ALUNO->NOME)
*嬪様様様様様様様様様様様様�
*� Pegar Nome do Instrutor �
*塒様様様様様様様様様様様様�
FUNCTION PegaInst(pCod)
   INSTRUTOR->(DBSEEK(pCod))
   RETURN(INSTRUTOR->NOME)
*嬪様様様様様様様様様様様様�
*� Pegar Nome da Escala    �
*塒様様様様様様様様様様様様�
FUNCTION PegaEscala(pCod)
   ESCALA->(DBSEEK(pCod))
   RETURN(ESCALA->DESCR)
*嬪様様様様様様様様様様様様�
*� Pegar Nome do Curso     �
*塒様様様様様様様様様様様様�
FUNCTION PegaCurso(pCod)
   CURSO->(DBSEEK(pCod))
   RETURN(CURSO->DESCR)
*嬪様様様様様様様様様様様様�
*� Pegar Nome da Disciplina�
*塒様様様様様様様様様様様様�
FUNCTION PegaDisc(pCod)
   DISCIPLINA->(DBSEEK(pCod))
   RETURN(DISCIPLINA->DESCR)
*嬪様様様様様様様様様様様様様様様邑
*� Capturar Codigo do Instrutor   �
*塒様様様様様様様様様様様様様様様余
FUNCTION TCodInst(pCod)
   VEICULO->(DBSETORDER(1))
   VEICULO->(DBSEEK(pCod))
   RETURN(VEICULO->CODINST)
*嬪様様様様様様様様様様様様様様様邑
*� Capturar Marca do Veiculo      �
*塒様様様様様様様様様様様様様様様余
FUNCTION TNomVeic(pCod)
   VEICULO->(DBSETORDER(1))
   VEICULO->(DBSEEK(pCod))
   RETURN(VEICULO->MARCA)
*嬪様様様様様様様様様様様様様様様邑
*� Capturar Placa do Veiculo      �
*塒様様様様様様様様様様様様様様様余
FUNCTION PegaPlaca(pCod)
   VEICULO->(DBSETORDER(1))
   VEICULO->(DBSEEK(pCod))
   RETURN(VEICULO->PLACA)
*嬪様様様様様様様様様様様様様様様邑
*� Capturar Nome do Instrutor     �
*塒様様様様様様様様様様様様様様様余
FUNCTION TNomInst(pCod)
   INSTRUTOR->(DBSETORDER(1))
   INSTRUTOR->(DBSEEK(pCod))
   RETURN(INSTRUTOR->NOME)
*嬪様様様様様様様様様様様様�
*� Verifica Exist. do Item �
*塒様様様様様様様様様様様様�
FUNCTION TItem(pCod,lCond)
   DEFAULT lCond TO .T.
   ITEM->(DBSETORDER(1))
   IF lCond
      IF !ITEM->(DBSEEK(pCod))
         Aviso("Item N�o Cadastrado...",,3); RETURN .F.
      ENDIF
   ELSE
      IF ITEM->(DBSEEK(pCod))
         Aviso("Item j� Cadastrado...",,3); RETURN .F.
      ENDIF
   ENDIF
   RETURN(.T.)
*嬪様様様様様様様様様様様様�
*� Pega Descr. do Item     �
*塒様様様様様様様様様様様様�
FUNCTION PegaItem(pCod)
   ITEM->(DBSETORDER(1))
   ITEM->(DBSEEK(pCod))
   RETURN(ITEM->DESCR)
*嬪様様様様様様様様様様様様様様様邑
*� Verificar No da Fatura         �
*塒様様様様様様様様様様様様様様様余
FUNCTION ChkFatura()
   IF l_f2
      cNF:= (carq1)->NF
      KEYBOARD CHR(K_ENTER)
      RETURN .T.
   ELSE
      RETURN Pesquisa(1,1,cCodEmp+cNFat,"Fatura N�o Cadastrada!")
   ENDIF
*嬪様様様様様様様様様様様様様様様邑
*� Testar se F2 foi pressionada   �
*塒様様様様様様様様様様様様様様様余
FUNCTION TF2()
   IF l_f2
      cNF:= (carq1)->NF
      KEYBOARD CHR(K_ENTER)
   ENDIF
   RETURN .T.
*嬪様様様様様様様様様様様様様様様邑
*� Verificar Existencia de Movim. �
*塒様様様様様様様様様様様様様様様余
FUNCTION ChkMov()
   IF CONTA->(DBSEEK(wConta+wNumDoc))
      Aviso("Documento j� Lan�ado no Movimento...",,3); RETURN .F.
   ENDIF
   RETURN .T.
*嬪様様様様様様様様様様様様�
*� Pegar Nome do Fornecedor�
*塒様様様様様様様様様様様様�
FUNCTION PegaForn(pCod)
   FORNECEDOR->(DBSEEK(pCod))
   RETURN(FORNECEDOR->RAZAO)
*嬪様様様様様様様様様様様様�
*� Pegar Infra��o          �
*塒様様様様様様様様様様様様�
FUNCTION PegaInfra(pCod)
   INFRACAO->(DBSEEK(pCod))
   RETURN(INFRACAO->DESCR)
*嬪様様様様様様様様様様様様様様邑
*� Checar se h� aulas pendentes �
*塒様様様様様様様様様様様様様様余
FUNCTION TAulaPend()
  IF ALUNO->PENDENTE>0
     Aviso("Aluno tem aula(s) pendente(s)...",,3); RETURN .F.
  ENDIF
  RETURN .T.
*嬪様様様様様様様様様様様様様様様様様様邑
*� Pegar Nome do Veiculo                �
*塒様様様様様様様様様様様様様様様様様様余
FUNCTION PegaVeic(pVar)
  VEICULO->(DBSEEK(pVar))
  RETURN(VEICULO->MARCA)
*敖陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
*�                       PEDIR CONFIRMACAO DE OPCOES DE PAGAMENTO            �
*青陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳�
FUNCTION ConfPgto(texto)
   LOCAL les,ces,largjan,telavelha

   confirm := .F.
   IF LASTKEY() = K_DEL
      Opcao := 2
   ENDIF

   largjan := LEN(texto)+8
   IF largjan < 16
      largjan := 16
   ENDIF

   ces       := (80-largjan)/2-5
   les       := 19
   telavelha := SAVESCREEN(les,0,les+4,79)
   corant    := SETCOLOR()
   cornova   := "N/W,W+/N"

   Sombra( les, ces, les+3, ces+LargJan, c_nLado )
   SETCOLOR(cornova)
   @ les,ces CLEAR TO les+3,ces+largjan
   @ les,ces TO les+3,ces+largjan DOUBLE
   @ les+1,ces+5 SAY texto
   coluna := (largjan-21)/2

   @ les+2,ces+coluna    PROMPT " Parcelado "
   @ les+2,ces+coluna+13 PROMPT "  A Vista  "
   MENU TO Opcao
   IF Opcao == 1
      confirm := .T.
   ENDIF
   SETCOLOR(corant)
   RESTSCREEN(les,0,les+4,79,telavelha)
   RETURN(confirm)
*嬪様様様様様様様様様様様様様様様様様様邑
*� Pegar Nome do Operador/Usuario       �
*塒様様様様様様様様様様様様様様様様様様余
FUNCTION PegaUser(pVar)
  nCompl:=SPACE(20-LEN(SUBS(USER,1,AT(" ",USER)-1)))
  cNomUs:=SUBS(pVar,1,AT(" ",pVar)-1)+nCompl
  RETURN(cNomUs)
*嬪様様様様様様様様様様様様様様様様様様邑
*� Identificar se Aluno � Ativo         �
*塒様様様様様様様様様様様様様様様様様様余
FUNCTION AlunoAtivo(pMatr)
   AULAS->(DBSEEK(pMatr))
   WHILE AULAS->MATRIC==pMatr.AND.AULAS->(!EOF())
      IF !AULAS->COBRADA.AND.!AULAS->STATUS
         RETURN(.T.)
      ENDIF
      AULAS->(DBSKIP())
   ENDDO
   RETURN(.F.)
*嬪様様様様様様様様様様様様様様様様様様邑
*� Verificar prazo do Contrato          �
*塒様様様様様様様様様様様様様様様様様様余
FUNCTION ChkPrazo(pMatr)
   LOCAL xPrazo:=90; xTempo:=xNovoPrazo:=0; xLib:="N"

   ALUNO->(DBSEEK(pMatr))
   IF ALUNO->MARCADA=0
      IF ALUNO->LIB#"S"
         xTempo := DATE() - ALUNO->DTINSCR
         IF xTempo > (xPrazo+ALUNO->PRAZO)
            Aviso("Prazo para marca��o de aulas pr�ticas expirado em "+ALLTRIM(STR(xTempo-(90+ALUNO->PRAZO)))+" dias",,3)
            IF nNivel=9
               Telas(13,15,16,55,1,YCOREDIT,.T.)
               xNovoPrazo:=ALUNO->PRAZO
               @ 14,17 SAY "Prazo prorrogado por (dias):" GET xNovoPrazo PICT "999"
               @ 15,17 SAY "Liberado - Taxa Paga (S/N) :" GET xLib       PICT "!" VALID LASTKEY()=K_UP.OR.xLib$"SN"
               SETCURSOR(1); READ; SETCURSOR(0)
               WHILE !ALUNO->(NetLReg()); ENDDO
               REPLACE ALUNO->PRAZO WITH xNovoPrazo,;
                       ALUNO->LIB   WITH xLib
               ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())
               Rest_Tela()
               IF xLib="N".OR.xNovoPrazo=0
                  RETURN(.F.)
               ENDIF
               RETURN(.T.)
            ENDIF
            RETURN(.F.)
         ENDIF
      ENDIF
   ENDIF
   RETURN(.T.)
*嬪様様様様様様様様様様様様様様邑
*� Calcular Idade               �
*塒様様様様様様様様様様様様様様余
FUNCTION CalcIdade(pHoje,pDtNas)
   IF MONTH(pDtNas) = MONTH(pHoje)
      IF DAY(pDtNas) <= DAY(pHoje)
         pIdade := YEAR(pHoje) - YEAR(pDtNas)
      ELSE
         pIdade := YEAR(pHoje) - YEAR(pDtNas)-1
      ENDIF
   ELSE
      IF MONTH(pDtNas) < MONTH(pHoje)
         pIdade := YEAR(pHoje) - YEAR(pDtNas)
      ELSE
         pIdade := YEAR(pHoje) - YEAR(pDtNas)-1
      ENDIF
   ENDIF
   RETURN(pIdade)
*嬪様様様様様様様様様様様様様様邑
*� Calcular Horario             �
*塒様様様様様様様様様様様様様様余
FUNCTION CalcHora(pTempo)
   LOCAL pHora:=pMin:=pHoraFim:=pAdic:=0
   IF VAL(LEFT(pTempo,2))>=18
      // Horario noturno
      pAdic:=45
   ELSE
      // Horario diurno
      pAdic:=50
   ENDIF
   pHora := VAL(LEFT(pTempo,2))
   pMin  := VAL(RIGHT(pTempo,2))
   IF (pAdic+pMin) >=60
      pHora := pHora+1
      pMin  := (pAdic+pMin)-60
   ELSE
      pMin := pMin + pAdic
   ENDIF
   pHoraFim := STRZERO(pHora,2)+":"+STRZERO(pMin,2)
   RETURN(pHoraFim)
*嬪様様様様様様様様様様様様様様様様様邑
*� Checar Baixa de Pendencia de Aluno �
*塒様様様様様様様様様様様様様様様様様余
PROCEDURE ChkPend(pMatr)
  Aguarde("Verificando Pend�ncias...")
  PENDENCIA->(DBSEEK(pMatr))
  WHILE PENDENCIA->MATRIC==pMatr.AND.!PENDENCIA->(EOF())
     IF !PENDENCIA->BAIXA
        Aguarde()
        Aviso("Aluno possui pend�ncia para provid�ncia.")
        RETURN
     ENDIF
     PENDENCIA->(DBSKIP())
  ENDDO
  Aguarde()
  RETURN
*嬪様様様様様様様様様様様様様様様様様邑
*� Checar Pendencia de requerimento   �
*塒様様様様様様様様様様様様様様様様様余
PROCEDURE ChkPReq(pMatr)
  Aguarde("Verificando Pend�ncias...")
  REQ->(DBSEEK(pMatr))
  WHILE REQ->MATRIC==pMatr.AND.!REQ->(EOF())
     IF !REQ->SITUACAO#"1"
        Aguarde()
        Aviso("Aluno possui pend�ncia de requerimento.")
        RETURN
     ENDIF
     REQ->(DBSKIP())
  ENDDO
  Aguarde()
  RETURN
*嬪様様様様様様様様様様様様様様邑
*� Pegar Categoria do Instrutor �
*塒様様様様様様様様様様様様様様余
FUNCTION PegaCategInst(pCod)
   LOCAL cRet:=""
   IF INSTRUTOR->CATEG=="1"
      cRet := "Pr�tico"
   ELSEIF INSTRUTOR->CATEG=="2"
      cRet := "Te�rico"
   ELSEIF INSTRUTOR->CATEG=="3"
      cRet := "Ambos  "
   ENDIF
   RETURN(cRet)
*嬪様様様様様様様様様様様様様様邑
*� Calcula tam. do nome+sobrenom�
*塒様様様様様様様様様様様様様様余
FUNCTION TamNome(pNome)
   LOCAL pos1:=pos2:=nTam:=0,xTexto

   pos1   := AT(" ",pNome)
   xTexto := SUBS(pNome,pos1+1)
   pos2   := AT(" ",xTexto)
   nTam   := pos1+pos2-1
   RETURN(nTam)
*嬪様様様様様様様様様様様様様様邑
*� Testar se � feriado          �
*塒様様様様様様様様様様様様様様余
FUNCTION TFeriado(pData)
   LOCAL lRet:=.F.
   lRet:=FERIADO->(DBSEEK(SUBS(DTOC(pData),4,2)+LEFT(DTOC(pData),2)))
   RETURN(lRet)
*嬪様様様様様様様様様様様様様様邑
*� Testar se dia � o da escala  �
*塒様様様様様様様様様様様様様様余
FUNCTION TEscala(pData,pEscala)
   LOCAL lRet:=.F.

   ESCALA->(DBSEEK(pEscala))
   IF DOW(pData)==1       // Domingo
      IF !EMPTY(ESCALA->DOM); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==2   // Segunda
      IF !EMPTY(ESCALA->SEG); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==3   // Ter�a
      IF !EMPTY(ESCALA->TER); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==4   // Quarta
      IF !EMPTY(ESCALA->QUA); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==5   // Quinta
      IF !EMPTY(ESCALA->QUI); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==6   // Sexta
      IF !EMPTY(ESCALA->SEX); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==7   // S�bado
      IF !EMPTY(ESCALA->SAB); lRet:=.T.; ENDIF
   ENDIF
   RETURN(lRet)
*嬪様様様様様様様様様様様様様様様様様様邑
*� Gravar Numero do Lancamento          �
*塒様様様様様様様様様様様様様様様様様様余
FUNCTION GravaLan()
  zNLan := STRZERO(VAL(DBPARM->NLAN)+1,12)
  WHILE !DBPARM->(NetLReg()); ENDDO
  IF DBPARM->NLAN == zNLan
     zNLan := STRZERO(VAL(zNLan)+1,12)
  ENDIF
  REPLACE DBPARM->NLAN WITH zNLan
  DBPARM->(DBUNLOCK())
  RETURN(zNLan)
*嬪様様様様様様様様様様様様様様様様様様邑
*� Gravar Numero da Turma               �
*塒様様様様様様様様様様様様様様様様様様余
FUNCTION GravaTurma()
  zNTurma := STRZERO(VAL(DBPARM->NTURMA)+1,6)
  WHILE !DBPARM->(NetLReg()); ENDDO
  IF DBPARM->NTURMA == zNTurma
     zNTurma := STRZERO(VAL(zNTurma)+1,6)
  ENDIF
  REPLACE DBPARM->NTURMA WITH zNTurma
  DBPARM->(DBUNLOCK())
  RETURN(zNTurma)
*嬪様様様様様様様様様様様様様様様様様様邑
*� Gravar Controle de recibos           �
*塒様様様様様様様様様様様様様様様様様様余
PROCEDURE Controle()
  zCR := STRZERO(VAL(DBPARM->CR)+1,5)
  WHILE !DBPARM->(NetLReg()); ENDDO
  IF DBPARM->CR == zCR
     zCR := STRZERO(VAL(zCR)+1,5)
  ENDIF
  REPLACE DBPARM->CR WITH zCR
  DBPARM->(DBUNLOCK())
  RETURN
*嬪様様様様様様様様様様様様様様様様様様邑
*� Gravar Numero do Requerimento        �
*塒様様様様様様様様様様様様様様様様様様余
FUNCTION GravaReq()
  zReq := LEFT(DBPARM->REQ,2)+STRZERO(VAL(RIGHT(DBPARM->REQ,5))+1,5)
  WHILE !DBPARM->(NetLReg()); ENDDO
  IF DBPARM->REQ == zReq
     zReq := LEFT(DBPARM->REQ,2)+STRZERO(VAL(RIGHT(DBPARM->REQ,5))+1,5)
  ENDIF
  REPLACE DBPARM->REQ WITH zReq
  DBPARM->(DBUNLOCK())
  RETURN(zReq)
*嬪様様様様様様様様様様様様様様様邑
*� Gravar Requerimentos - temp.   �
*塒様様様様様様様様様様様様様様様余
PROCEDURE GrvReq()
   (cArq1)->(DBAPPEND())
   REPLACE (cArq1)->REQ      WITH REQ->REQ     ,;
           (cArq1)->DATA     WITH REQ->DATA    ,;
           (cArq1)->HORA     WITH REQ->HORA    ,;
           (cArq1)->USER     WITH REQ->USER    ,;
           (cArq1)->NOME     WITH REQ->NOME    ,;
           (cArq1)->PRAZO    WITH REQ->PRAZO   ,;
           (cArq1)->MATRIC   WITH REQ->MATRIC  ,;
           (cArq1)->ASS1     WITH REQ->ASS1    ,;
           (cArq1)->ASS2     WITH REQ->ASS2    ,;
           (cArq1)->ASS3     WITH REQ->ASS3    ,;
           (cArq1)->RECOM1   WITH REQ->RECOM1  ,;
           (cArq1)->RECOM2   WITH REQ->RECOM2  ,;
           (cArq1)->SITUACAO WITH REQ->SITUACAO,;
           (cArq1)->SETOR1   WITH REQ->SETOR1  ,;
           (cArq1)->SETOR2   WITH REQ->SETOR2  ,;
           (cArq1)->SETOR3   WITH REQ->SETOR3
   RETURN
*嬪様様様様様様様様様様様様様様様邑
*� Gravar Requerimentos - Aux.    �
*塒様様様様様様様様様様様様様様様余
PROCEDURE GrvReqD()
   (cArq2)->(DBAPPEND())
   REPLACE (cArq2)->REQ      WITH REQD->REQ     ,;
           (cArq2)->DATA     WITH REQD->DATA    ,;
           (cArq2)->HORA     WITH REQD->HORA    ,;
           (cArq2)->USER     WITH REQD->USER    ,;
           (cArq2)->PRAZO    WITH REQD->PRAZO   ,;
           (cArq2)->RESULT1  WITH REQD->RESULT1 ,;
           (cArq2)->RESULT2  WITH REQD->RESULT2 ,;
           (cArq2)->RESULT3  WITH REQD->RESULT3 ,;
           (cArq2)->SETOR    WITH REQD->SETOR   ,;
           (cArq2)->ENCAM1   WITH REQD->ENCAM1  ,;
           (cArq2)->ENCAM2   WITH REQD->ENCAM2  ,;
           (cArq2)->ENCAM3   WITH REQD->ENCAM3
   RETURN
*嬪様様様様様様様様様様様様様様様様様様邑
*� Identificar o Sexo do Aluno          �
*塒様様様様様様様様様様様様様様様様様様余
PROCEDURE Sexo(pVar)
   xIDSexo:=RIGHT(SUBS(pVar,1,AT(" ",pVar)-1),1)
   IF xIDSexo=="A".OR.xIDSexo=="E"
      RETURN("F")
   ELSE
      RETURN("M")
   ENDIF
