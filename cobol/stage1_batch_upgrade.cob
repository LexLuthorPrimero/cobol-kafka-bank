       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROCESA-TRANSACCION.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ACCOUNTS-FILE
               ASSIGN TO "accounts/ACCOUNTS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT TRANS-FILE
               ASSIGN TO "trans_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT TEMP-FILE
               ASSIGN TO "accounts/TEMP.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

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

       01 WS-EOF-ACC PIC X VALUE 'N'.
       01 WS-EOF-TR  PIC X VALUE 'N'.

       01 WS-FOUND PIC X VALUE 'N'.

       01 WS-SALDO-NUM PIC 9(9).
       01 WS-MONTO-NUM PIC 9(9).
       01 WS-NEW-SALDO PIC 9(9).

       PROCEDURE DIVISION.

       MAIN.

       DISPLAY "=== STAGE 1: BATCH MULTI TRANS ==="

       OPEN INPUT TRANS-FILE
       OPEN INPUT ACCOUNTS-FILE
       OPEN OUTPUT TEMP-FILE

       PERFORM UNTIL WS-EOF-TR = 'Y'

           READ TRANS-FILE
               AT END
                   MOVE 'Y' TO WS-EOF-TR
               NOT AT END

                   MOVE 'N' TO WS-EOF-ACC
                   MOVE 'N' TO WS-FOUND

                   PERFORM UNTIL WS-EOF-ACC = 'Y'

                       READ ACCOUNTS-FILE
                           AT END
                               MOVE 'Y' TO WS-EOF-ACC
                           NOT AT END

                               IF AC-ID = TR-ID
                                   MOVE 'Y' TO WS-FOUND

                                   MOVE AC-SALDO TO WS-SALDO-NUM
                                   MOVE TR-MONTO TO WS-MONTO-NUM

                                   IF WS-SALDO-NUM >= WS-MONTO-NUM
                                       COMPUTE WS-NEW-SALDO =
                                           WS-SALDO-NUM - WS-MONTO-NUM
                                       MOVE WS-NEW-SALDO TO AC-SALDO
                                   END-IF
                               END-IF

                               WRITE TEMP-RECORD FROM ACCOUNTS-RECORD
                       END-READ

                   END-PERFORM

                   CLOSE ACCOUNTS-FILE
                   OPEN INPUT ACCOUNTS-FILE
                   MOVE 'N' TO WS-EOF-ACC

           END-READ

       END-PERFORM

       CLOSE ACCOUNTS-FILE
       CLOSE TRANS-FILE
       CLOSE TEMP-FILE

       DISPLAY "FIN BATCH"
       STOP RUN.
