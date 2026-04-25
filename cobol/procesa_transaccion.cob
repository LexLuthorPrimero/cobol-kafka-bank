       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROCESA-TRANSACCION.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ACCOUNTS-FILE
               ASSIGN TO "accounts/ACCOUNTS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-ACC-STATUS.

           SELECT TRANS-FILE
               ASSIGN TO "trans_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-TR-STATUS.

           SELECT TEMP-FILE
               ASSIGN TO "accounts/TEMP.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-TMP-STATUS.

       DATA DIVISION.

       FILE SECTION.

       FD ACCOUNTS-FILE.
       01 ACCOUNTS-RECORD.
           05 AC-ID     PIC X(5).
           05 AC-NOMBRE PIC X(20).
           05 AC-SALDO  PIC 9(9).

       FD TRANS-FILE.
       01 TRANS-RECORD.
           05 TR-ID    PIC X(5).
           05 FILLER   PIC X(1).
           05 TR-MONTO PIC 9(9).

       FD TEMP-FILE.
       01 TEMP-RECORD.
           05 TMP-ID     PIC X(5).
           05 TMP-NOMBRE PIC X(20).
           05 TMP-SALDO  PIC 9(9).

       WORKING-STORAGE SECTION.

       01 WS-ACC-STATUS PIC XX.
       01 WS-TR-STATUS  PIC XX.
       01 WS-TMP-STATUS PIC XX.

       01 WS-EOF-ACC PIC X VALUE 'N'.
       01 WS-FOUND   PIC X VALUE 'N'.

       01 WS-SALDO-NUM PIC 9(9).
       01 WS-MONTO-NUM PIC 9(9).
       01 WS-NEW-SALDO PIC 9(9).

       01 WS-TR-ID PIC X(5).
       01 WS-TR-MONTO PIC 9(9).

       PROCEDURE DIVISION.

       MAIN.

       DISPLAY "=== FLOW ==="
       DISPLAY "READ TRANS -> SCAN ACCOUNTS -> UPDATE -> WRITE TEMP"

       OPEN INPUT TRANS-FILE
       IF WS-TR-STATUS NOT = "00"
           DISPLAY "ERROR TRANS OPEN"
           STOP RUN
       END-IF

       READ TRANS-FILE
           AT END
               DISPLAY "ERROR TRANS EMPTY"
               STOP RUN
           NOT AT END
               MOVE TR-ID TO WS-TR-ID
               MOVE TR-MONTO TO WS-TR-MONTO
       END-READ
       CLOSE TRANS-FILE

       OPEN INPUT ACCOUNTS-FILE
       OPEN OUTPUT TEMP-FILE

       PERFORM UNTIL WS-EOF-ACC = 'Y'

           READ ACCOUNTS-FILE
               AT END
                   MOVE 'Y' TO WS-EOF-ACC
               NOT AT END

                   IF AC-ID = WS-TR-ID
                       MOVE 'Y' TO WS-FOUND

                       MOVE AC-SALDO TO WS-SALDO-NUM

                       IF WS-SALDO-NUM >= WS-TR-MONTO
                           COMPUTE WS-NEW-SALDO =
                               WS-SALDO-NUM - WS-TR-MONTO
                           MOVE WS-NEW-SALDO TO AC-SALDO
                           DISPLAY "OK TRANSACCION"
                       ELSE
                           DISPLAY "SALDO INSUFICIENTE"
                       END-IF
                   END-IF

                   MOVE AC-ID TO TMP-ID
                   MOVE AC-NOMBRE TO TMP-NOMBRE
                   MOVE AC-SALDO TO TMP-SALDO

                   WRITE TEMP-RECORD
           END-READ

       END-PERFORM

       CLOSE ACCOUNTS-FILE
       CLOSE TEMP-FILE

       IF WS-FOUND NOT = 'Y'
           DISPLAY "CUENTA NO ENCONTRADA"
       END-IF

       DISPLAY "FIN OK"
       STOP RUN.
