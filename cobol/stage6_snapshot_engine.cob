       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANK-SNAPSHOT-ENGINE.

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

       01 WS-IDX PIC 9(4) VALUE 0.
       01 WS-TIDX PIC 9(4) VALUE 0.

       01 WS-EOF PIC X VALUE "N".
       01 WS-FAIL PIC X VALUE "N".

       01 WS-TABLE.
           05 WS-ACC OCCURS 1000 TIMES.
               10 W-ID     PIC X(5).
               10 W-NAME   PIC X(20).
               10 W-SALDO  PIC 9(9).

       01 WS-SNAPSHOT.
           05 WS-ACC-S OCCURS 1000 TIMES.
               10 S-ID     PIC X(5).
               10 S-NAME   PIC X(20).
               10 S-SALDO  PIC 9(9).

       01 WS-SALDO PIC 9(9).
       01 WS-AMT   PIC 9(9).
       01 WS-NEW   PIC 9(9).

       PROCEDURE DIVISION.

       MAIN.

           PERFORM LOAD-ACCOUNTS
           PERFORM COPY-SNAPSHOT
           PERFORM PROCESS-TRANS
           PERFORM FINAL-CONTROL

           STOP RUN.

       LOAD-ACCOUNTS.

           OPEN INPUT ACCOUNTS-FILE

           PERFORM UNTIL WS-EOF = "Y"
               READ ACCOUNTS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-IDX
                       MOVE A-ID    TO W-ID(WS-IDX)
                       MOVE A-NAME  TO W-NAME(WS-IDX)
                       MOVE A-SALDO TO W-SALDO(WS-IDX)
               END-READ
           END-PERFORM

           CLOSE ACCOUNTS-FILE.

       COPY-SNAPSHOT.

           PERFORM VARYING WS-TIDX FROM 1 BY 1 UNTIL WS-TIDX > WS-IDX
               MOVE W-ID(WS-TIDX)    TO S-ID(WS-TIDX)
               MOVE W-NAME(WS-TIDX)  TO S-NAME(WS-TIDX)
               MOVE W-SALDO(WS-TIDX) TO S-SALDO(WS-TIDX)
           END-PERFORM.

       PROCESS-TRANS.

           OPEN INPUT TRANS-FILE
           OPEN OUTPUT JOURNAL-FILE

           MOVE "N" TO WS-EOF

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       PERFORM APPLY-LOGIC
               END-READ

           END-PERFORM.

           CLOSE TRANS-FILE
           CLOSE JOURNAL-FILE.

       APPLY-LOGIC.

           PERFORM VARYING WS-TIDX FROM 1 BY 1 UNTIL WS-TIDX > WS-IDX

               IF W-ID(WS-TIDX) = T-ID

                   IF W-SALDO(WS-TIDX) >= T-AMT
                       SUBTRACT T-AMT FROM W-SALDO(WS-TIDX)

                       STRING "OK " W-ID(WS-TIDX)
                           DELIMITED BY SIZE
                           INTO J-TXT
                       WRITE J-REC
                   ELSE
                       MOVE "Y" TO WS-FAIL

                       STRING "FAIL " W-ID(WS-TIDX)
                           DELIMITED BY SIZE
                           INTO J-TXT
                       WRITE J-REC
                   END-IF

               END-IF

           END-PERFORM.

       FINAL-CONTROL.

           IF WS-FAIL = "Y"
               PERFORM ROLLBACK
           ELSE
               PERFORM COMMIT
           END-IF.

       ROLLBACK.

           PERFORM VARYING WS-TIDX FROM 1 BY 1 UNTIL WS-TIDX > WS-IDX
               MOVE S-SALDO(WS-TIDX) TO W-SALDO(WS-TIDX)
           END-PERFORM.

       COMMIT.

           OPEN OUTPUT ACCOUNTS-FILE

           PERFORM VARYING WS-TIDX FROM 1 BY 1 UNTIL WS-TIDX > WS-IDX
               MOVE W-ID(WS-TIDX)    TO A-ID
               MOVE W-NAME(WS-TIDX)  TO A-NAME
               MOVE W-SALDO(WS-TIDX) TO A-SALDO
               WRITE ACC-REC
           END-PERFORM

           CLOSE ACCOUNTS-FILE.

