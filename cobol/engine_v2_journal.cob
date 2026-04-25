       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENGINE-V2-JOURNAL.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT TRANS-FILE
               ASSIGN TO "trans_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT JOURNAL-FILE
               ASSIGN TO "accounts/JOURNAL.LOG"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD TRANS-FILE.
       01 TR-REC.
           05 T-ID   PIC X(5).
           05 FILLER PIC X.
           05 T-AMT  PIC 9(9).

       FD JOURNAL-FILE.
       01 JR-REC.
           05 JR-TXT PIC X(80).

       WORKING-STORAGE SECTION.

       01 WS-EOF   PIC X VALUE "N".
       01 WS-SALDO PIC 9(9) VALUE 10000.
       01 WS-LOG   PIC X(80).

       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT TRANS-FILE
           OPEN OUTPUT JOURNAL-FILE

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END

                       IF WS-SALDO >= T-AMT
                           SUBTRACT T-AMT FROM WS-SALDO

                           STRING
                               "OK " DELIMITED BY SIZE
                               T-ID DELIMITED BY SIZE
                               " AMT=" DELIMITED BY SIZE
                               T-AMT DELIMITED BY SIZE
                               " BAL=" DELIMITED BY SIZE
                               WS-SALDO DELIMITED BY SIZE
                               INTO WS-LOG

                           MOVE WS-LOG TO JR-TXT
                           WRITE JR-REC
                       ELSE
                           STRING
                               "FAIL " DELIMITED BY SIZE
                               T-ID DELIMITED BY SIZE
                               " INSUFFICIENT" DELIMITED BY SIZE
                               INTO WS-LOG

                           MOVE WS-LOG TO JR-TXT
                           WRITE JR-REC
                       END-IF

               END-READ

           END-PERFORM

           CLOSE TRANS-FILE
           CLOSE JOURNAL-FILE

           STOP RUN.
