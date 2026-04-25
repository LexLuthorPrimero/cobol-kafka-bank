       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANK-INDEX-ENGINE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ACCOUNTS-FILE
               ASSIGN TO "accounts/ACCOUNTS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT TRANS-FILE
               ASSIGN TO "trans_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT JOURNAL-FILE
               ASSIGN TO "accounts/JOURNAL.LOG"
               ORGANIZATION IS SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD ACCOUNTS-FILE.
       01 ACC-REC.
           05 A-ID     PIC X(5).
           05 A-NAME   PIC X(20).
           05 A-SALDO  PIC 9(9).

       FD TRANS-FILE.
       01 TR-REC.
           05 T-ID     PIC X(5).
           05 FILLER   PIC X.
           05 T-AMT    PIC 9(9).

       FD JOURNAL-FILE.
       01 J-REC.
           05 J-TXT PIC X(80).

       WORKING-STORAGE SECTION.

       01 WS-EOF-T PIC X VALUE "N".
       01 WS-IDX   PIC 9(4) VALUE 0.

       01 WS-TABLE.
           05 WS-ACC OCCURS 1000 TIMES INDEXED BY IDX.
               10 W-ID     PIC X(5).
               10 W-NAME   PIC X(20).
               10 W-SALDO  PIC 9(9).

       01 WS-SALDO PIC 9(9).
       01 WS-AMT   PIC 9(9).
       01 WS-NEW   PIC 9(9).

       PROCEDURE DIVISION.

       MAIN.

           PERFORM LOAD-ACCOUNTS
           PERFORM PROCESS-TRANS

           STOP RUN.

       LOAD-ACCOUNTS.

           OPEN INPUT ACCOUNTS-FILE

           PERFORM UNTIL WS-EOF-T = "Y"

               READ ACCOUNTS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF-T
                   NOT AT END
                       ADD 1 TO WS-IDX
                       MOVE A-ID    TO W-ID(WS-IDX)
                       MOVE A-NAME  TO W-NAME(WS-IDX)
                       MOVE A-SALDO TO W-SALDO(WS-IDX)
               END-READ

           END-PERFORM.

           CLOSE ACCOUNTS-FILE.

       PROCESS-TRANS.

           OPEN INPUT TRANS-FILE
           OPEN OUTPUT JOURNAL-FILE

           MOVE "N" TO WS-EOF-T

           PERFORM UNTIL WS-EOF-T = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF-T
                   NOT AT END

                       PERFORM LOOKUP-UPDATE
               END-READ

           END-PERFORM.

           CLOSE TRANS-FILE
           CLOSE JOURNAL-FILE.

       LOOKUP-UPDATE.

           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > WS-IDX

               IF W-ID(IDX) = T-ID

                   MOVE W-SALDO(IDX) TO WS-SALDO
                   MOVE T-AMT        TO WS-AMT

                   IF WS-SALDO >= WS-AMT
                       COMPUTE WS-NEW = WS-SALDO - WS-AMT
                       MOVE WS-NEW TO W-SALDO(IDX)

                       STRING "OK " W-ID(IDX)
                           DELIMITED BY SIZE
                           INTO J-TXT
                       WRITE J-REC
                   ELSE
                       STRING "FAIL " W-ID(IDX)
                           DELIMITED BY SIZE
                           INTO J-TXT
                       WRITE J-REC
                   END-IF

               END-IF

           END-PERFORM.

