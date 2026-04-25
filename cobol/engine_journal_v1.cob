       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENGINE-JOURNAL-V1.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT TRANS-FILE
               ASSIGN TO "trans_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT ACCOUNTS-FILE
               ASSIGN TO "accounts/ACCOUNTS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT JOURNAL-FILE
               ASSIGN TO "accounts/JOURNAL.LOG"
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-JS.

       DATA DIVISION.

       FILE SECTION.

       FD TRANS-FILE.
       01 TRANS-REC.
           05 T-ID   PIC X(5).
           05 FILLER PIC X.
           05 T-AMT  PIC 9(9).

       FD ACCOUNTS-FILE.
       01 ACC-REC.
           05 A-ID    PIC X(5).
           05 A-NAME  PIC X(20).
           05 A-SALDO PIC 9(9).

       FD JOURNAL-FILE.
       01 J-REC.
           05 J-TXT PIC X(80).

       WORKING-STORAGE SECTION.

       01 WS-EOF PIC X VALUE "N".
       01 WS-JS  PIC XX.

       01 WS-AMT PIC 9(9).
       01 WS-SAL PIC 9(9).

       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT TRANS-FILE
           OPEN INPUT ACCOUNTS-FILE
           OPEN OUTPUT JOURNAL-FILE

           IF WS-JS NOT = "00"
               DISPLAY "JOURNAL OPEN ERROR " WS-JS
               STOP RUN
           END-IF

           READ TRANS-FILE
               AT END
                   MOVE "Y" TO WS-EOF
           END-READ

           PERFORM UNTIL WS-EOF = "Y"

               READ ACCOUNTS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END

                       IF A-ID = T-ID
                           MOVE A-SALDO TO WS-SAL
                           MOVE T-AMT TO WS-AMT

                           IF WS-SAL >= WS-AMT
                               SUBTRACT WS-AMT FROM WS-SAL
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

           END-PERFORM

           CLOSE TRANS-FILE
           CLOSE ACCOUNTS-FILE
           CLOSE JOURNAL-FILE

           STOP RUN.
