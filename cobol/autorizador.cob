       IDENTIFICATION DIVISION.
       PROGRAM-ID. AUTORIZADOR.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNTS-FILE
               ASSIGN TO DYNAMIC WS-ACCOUNTS-PATH
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.
           SELECT TRANS-FILE
               ASSIGN TO DYNAMIC WS-TRANS-PATH
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-TRANS-STATUS.
       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNTS-FILE.
       01  ACCOUNTS-RECORD.
           05 AC-ID             PIC X(5).
           05 AC-NOMBRE         PIC X(20).
           05 AC-SALDO          PIC 9(9).
       FD  TRANS-FILE.
       01  TRANS-RECORD.
           05 TR-ID             PIC X(5).
           05 FILLER            PIC X(1).
           05 TR-MONTO          PIC 9(9).
       WORKING-STORAGE SECTION.
       01  WS-ACCOUNTS-PATH     PIC X(200).
       01  WS-TRANS-PATH        PIC X(200).
       01  WS-FILE-STATUS       PIC XX.
       01  WS-TRANS-STATUS      PIC XX.
       01  WS-FOUND             PIC X VALUE 'N'.
       01  WS-EOF               PIC X VALUE 'N'.
       PROCEDURE DIVISION.
       MAIN-PARA.
           MOVE SPACES TO WS-ACCOUNTS-PATH
           ACCEPT WS-ACCOUNTS-PATH FROM ENVIRONMENT "ACCOUNTS_PATH"
           IF WS-ACCOUNTS-PATH = SPACES
               MOVE "/app/accounts/ACCOUNTS.DAT" TO WS-ACCOUNTS-PATH
           END-IF
           MOVE SPACES TO WS-TRANS-PATH
           ACCEPT WS-TRANS-PATH FROM ENVIRONMENT "TRANS_INPUT"
           IF WS-TRANS-PATH = SPACES
               MOVE "/app/trans_input.txt" TO WS-TRANS-PATH
           END-IF
           OPEN INPUT TRANS-FILE
           READ TRANS-FILE INTO TRANS-RECORD
           CLOSE TRANS-FILE
           MOVE 'N' TO WS-FOUND
           MOVE 'N' TO WS-EOF
           OPEN INPUT ACCOUNTS-FILE
           PERFORM UNTIL WS-EOF = 'Y'
               READ ACCOUNTS-FILE INTO ACCOUNTS-RECORD
               AT END MOVE 'Y' TO WS-EOF
               NOT AT END
                   IF AC-ID = TR-ID
                       MOVE 'Y' TO WS-FOUND
                       IF AC-SALDO >= TR-MONTO
                           DISPLAY "AUTORIZADO"
                       ELSE
                           DISPLAY "RECHAZADO"
                       END-IF
                   END-IF
               END-READ
           END-PERFORM
           CLOSE ACCOUNTS-FILE
           IF WS-FOUND = 'N'
               DISPLAY "RECHAZADO"
           END-IF
           STOP RUN.
