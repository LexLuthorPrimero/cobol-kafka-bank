       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENGINE-V1-SAFE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT TRANS-FILE
               ASSIGN TO "trans_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT JOURNAL-FILE
               ASSIGN TO "accounts/JOURNAL.LOG"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-J-STAT.

       DATA DIVISION.

       FILE SECTION.

       FD TRANS-FILE.
       01 TR-REC.
           05 T-ID  PIC X(5).
           05 FILLER PIC X.
           05 T-AMT PIC 9(9).

       FD JOURNAL-FILE.
       01 JR-REC.
           05 JR-TXT PIC X(80).

       WORKING-STORAGE SECTION.

       01 WS-EOF    PIC X VALUE "N".
       01 WS-J-STAT PIC XX.

       PROCEDURE DIVISION.

       MAIN.

           OPEN OUTPUT JOURNAL-FILE
           IF WS-J-STAT NOT = "00"
               DISPLAY "ERROR JOURNAL OPEN: " WS-J-STAT
               STOP RUN
           END-IF
           CLOSE JOURNAL-FILE

           OPEN INPUT TRANS-FILE
           OPEN OUTPUT JOURNAL-FILE

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       MOVE "OK " TO JR-TXT
                       WRITE JR-REC
               END-READ

           END-PERFORM

           CLOSE TRANS-FILE
           CLOSE JOURNAL-FILE

           STOP RUN.
