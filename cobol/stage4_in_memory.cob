       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANK-ENGINE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ACCOUNTS-FILE
               ASSIGN TO "accounts/ACCOUNTS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT TRANS-FILE
               ASSIGN TO "trans_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT OUTPUT-FILE
               ASSIGN TO "accounts/ACCOUNTS.DAT"
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
       01 WS-EOF-A PIC X VALUE "N".

       01 WS-SALDO PIC 9(9).
       01 WS-AMT   PIC 9(9).
       01 WS-NEW   PIC 9(9).

       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT ACCOUNTS-FILE
           OPEN INPUT TRANS-FILE
           OPEN OUTPUT JOURNAL-FILE

           PERFORM LOAD-AND-PROCESS

           CLOSE ACCOUNTS-FILE
           CLOSE TRANS-FILE
           CLOSE JOURNAL-FILE

           STOP RUN.

       LOAD-AND-PROCESS.

           PERFORM UNTIL WS-EOF-T = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF-T
                   NOT AT END
                       PERFORM PROCESS-ACCOUNTS
               END-READ

           END-PERFORM.

       PROCESS-ACCOUNTS.

           MOVE "N" TO WS-EOF-A

           PERFORM UNTIL WS-EOF-A = "Y"

               READ ACCOUNTS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF-A
                   NOT AT END

                       IF A-ID = T-ID

                           MOVE A-SALDO TO WS-SALDO
                           MOVE T-AMT   TO WS-AMT

                           IF WS-SALDO >= WS-AMT
                               COMPUTE WS-NEW = WS-SALDO - WS-AMT
                               MOVE WS-NEW TO A-SALDO

                               STRING "OK " A-ID
                                   DELIMITED BY SIZE
                                   INTO J-TXT
                               WRITE J-REC
                           ELSE
                               STRING "FAIL " A-ID
                                   DELIMITED BY SIZE
                                   INTO J-TXT
                               WRITE J-REC
                           END-IF

                       END-IF

               END-READ

           END-PERFORM.

