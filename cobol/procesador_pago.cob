       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROCESADOR-PAGO.
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
       01  WS-NEW-BALANCE       PIC 9(9).
       01  ACCOUNTS-TABLE.
           05 ACCOUNT-ENTRY OCCURS 100 TIMES.
               10 AC-ID-TBL     PIC X(5).
               10 AC-NOMBRE-TBL PIC X(20).
               10 AC-SALDO-TBL  PIC 9(9).
       01  WS-TABLE-INDEX       PIC 99 VALUE 1.
       01  WS-MAX-ENTRIES       PIC 99 VALUE 100.
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
           MOVE 1 TO WS-TABLE-INDEX
           OPEN INPUT ACCOUNTS-FILE
           PERFORM UNTIL WS-EOF = 'Y' OR WS-TABLE-INDEX > WS-MAX-ENTRIES
               READ ACCOUNTS-FILE INTO ACCOUNTS-RECORD
               AT END MOVE 'Y' TO WS-EOF
               NOT AT END
                   MOVE AC-ID TO AC-ID-TBL(WS-TABLE-INDEX)
                   MOVE AC-NOMBRE TO AC-NOMBRE-TBL(WS-TABLE-INDEX)
                   MOVE AC-SALDO TO AC-SALDO-TBL(WS-TABLE-INDEX)
                   ADD 1 TO WS-TABLE-INDEX
               END-READ
           END-PERFORM
           CLOSE ACCOUNTS-FILE
           SUBTRACT 1 FROM WS-TABLE-INDEX
           MOVE WS-TABLE-INDEX TO WS-MAX-ENTRIES
           MOVE 1 TO WS-TABLE-INDEX
           PERFORM UNTIL WS-TABLE-INDEX > WS-MAX-ENTRIES
               IF AC-ID-TBL(WS-TABLE-INDEX) = TR-ID
                   MOVE 'Y' TO WS-FOUND
                   IF AC-SALDO-TBL(WS-TABLE-INDEX) >= TR-MONTO
                       COMPUTE WS-NEW-BALANCE = AC-SALDO-TBL(WS-TABLE-INDEX) - TR-MONTO
                       MOVE WS-NEW-BALANCE TO AC-SALDO-TBL(WS-TABLE-INDEX)
                       DISPLAY "OK"
                   ELSE
                       DISPLAY "ERROR"
                   END-IF
                   EXIT PERFORM
               END-IF
               ADD 1 TO WS-TABLE-INDEX
           END-PERFORM
           IF WS-FOUND = 'N'
               DISPLAY "ERROR"
           END-IF
           OPEN OUTPUT ACCOUNTS-FILE
           MOVE 1 TO WS-TABLE-INDEX
           PERFORM UNTIL WS-TABLE-INDEX > WS-MAX-ENTRIES
               MOVE AC-ID-TBL(WS-TABLE-INDEX) TO AC-ID
               MOVE AC-NOMBRE-TBL(WS-TABLE-INDEX) TO AC-NOMBRE
               MOVE AC-SALDO-TBL(WS-TABLE-INDEX) TO AC-SALDO
               WRITE ACCOUNTS-RECORD
               ADD 1 TO WS-TABLE-INDEX
           END-PERFORM
           CLOSE ACCOUNTS-FILE
           STOP RUN.
