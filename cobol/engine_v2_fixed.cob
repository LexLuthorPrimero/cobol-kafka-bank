       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENGINE-V2-FIXED.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT TRANS-FILE
               ASSIGN TO "trans_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD TRANS-FILE.
       01 TR-LINE PIC X(20).

       WORKING-STORAGE SECTION.

       01 WS-EOF   PIC X VALUE "N".
       01 WS-ID    PIC X(5).
       01 WS-AMT   PIC 9(9).

       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT TRANS-FILE

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END

                       MOVE TR-LINE(1:5) TO WS-ID
                       MOVE TR-LINE(7:9) TO WS-AMT

                       DISPLAY "TX -> " WS-ID " AMT " WS-AMT

           END-PERFORM

           CLOSE TRANS-FILE

           STOP RUN.
