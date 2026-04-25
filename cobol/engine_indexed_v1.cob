       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENGINE-INDEXED-V1.

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
       01 ACC-REC.
           05 AC-ID     PIC X(5).
           05 AC-NAME   PIC X(20).
           05 AC-SALDO  PIC 9(9).

       FD TRANS-FILE.
       01 TR-REC.
           05 T-ID   PIC X(5).
           05 FILLER PIC X.
           05 T-AMT  PIC 9(9).

       FD TEMP-FILE.
       01 TMP-REC.
           05 TMP-ID    PIC X(5).
           05 TMP-NAME  PIC X(20).
           05 TMP-SALDO PIC 9(9).

       WORKING-STORAGE SECTION.

       01 WS-EOF PIC X VALUE "N".
       01 IDX PIC 9(3) VALUE 0.

       01 WS-ACCOUNT-TABLE.
           05 WS-ACC OCCURS 100 TIMES INDEXED BY I.
               10 WS-ID     PIC X(5).
               10 WS-NAME   PIC X(20).
               10 WS-SALDO  PIC 9(9).

       01 WS-FOUND PIC X VALUE "N".

       PROCEDURE DIVISION.

       MAIN.

           PERFORM LOAD-ACCOUNTS

           OPEN INPUT TRANS-FILE
           OPEN OUTPUT TEMP-FILE

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END

                       PERFORM PROCESS-TRANS

               END-READ

           END-PERFORM

           PERFORM WRITE-BACK

           CLOSE TRANS-FILE
           CLOSE TEMP-FILE

           STOP RUN.

       LOAD-ACCOUNTS.

           OPEN INPUT ACCOUNTS-FILE

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 100

               READ ACCOUNTS-FILE
                   AT END
                       EXIT PERFORM
                   NOT AT END
                       MOVE AC-ID    TO WS-ID(I)
                       MOVE AC-NAME  TO WS-NAME(I)
                       MOVE AC-SALDO TO WS-SALDO(I)
               END-READ

           END-PERFORM

           CLOSE ACCOUNTS-FILE.

       PROCESS-TRANS.

           MOVE "N" TO WS-FOUND

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 100

               IF WS-ID(I) = T-ID

                   MOVE "Y" TO WS-FOUND

                   IF WS-SALDO(I) >= T-AMT
                       SUBTRACT T-AMT FROM WS-SALDO(I)
                       DISPLAY "OK " WS-ID(I)
                   ELSE
                       DISPLAY "FAIL " WS-ID(I)
                   END-IF

               END-IF

           END-PERFORM.

       WRITE-BACK.

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 100

               IF WS-ID(I) NOT = SPACES
                   MOVE WS-ID(I)    TO TMP-ID
                   MOVE WS-NAME(I)  TO TMP-NAME
                   MOVE WS-SALDO(I) TO TMP-SALDO
                   WRITE TMP-REC
               END-IF

           END-PERFORM.

