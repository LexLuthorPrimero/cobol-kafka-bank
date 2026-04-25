       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENGINE-V4.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT TRANS-FILE
               ASSIGN TO "trans_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD TRANS-FILE.
       01 TRANS-REC.
           05 T-ID   PIC X(5).
           05 FILLER PIC X.
           05 T-AMT  PIC 9(9).

       WORKING-STORAGE SECTION.

       01 WS-EOF   PIC X VALUE "N".
       01 WS-SALDO PIC 9(9) VALUE 10000.

       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT TRANS-FILE

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END

                       IF WS-SALDO >= T-AMT
                           SUBTRACT T-AMT FROM WS-SALDO
                           DISPLAY "OK " T-ID
                       ELSE
                           DISPLAY "FAIL " T-ID
                       END-IF

               END-READ

           END-PERFORM

           CLOSE TRANS-FILE
           STOP RUN.
