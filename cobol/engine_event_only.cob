       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENGINE-EVENT-ONLY.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT TRANS-FILE
               ASSIGN TO "trans_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT JOURNAL-FILE
               ASSIGN TO "accounts/JOURNAL.LOG"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-JSTAT.

       DATA DIVISION.

       FILE SECTION.

       FD TRANS-FILE.
       01 TRANS-REC.
           05 T-ID   PIC X(5).
           05 FILLER PIC X.
           05 T-AMT  PIC 9(9).

       FD JOURNAL-FILE.
       01 JOURNAL-REC.
           05 JR-VERSION PIC X(2).
           05 FILLER     PIC X VALUE "|".
           05 JR-STATUS  PIC X(4).
           05 FILLER     PIC X VALUE "|".
           05 JR-ID      PIC X(5).
           05 FILLER     PIC X VALUE "|".
           05 JR-AMOUNT  PIC 9(9).

       WORKING-STORAGE SECTION.

       01 WS-EOF    PIC X VALUE "N".
       01 WS-JSTAT  PIC XX.

       PROCEDURE DIVISION.

       MAIN.

           OPEN OUTPUT JOURNAL-FILE

           OPEN INPUT TRANS-FILE

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END

                       MOVE "V1" TO JR-VERSION
                       MOVE "OK" TO JR-STATUS
                       MOVE T-ID TO JR-ID
                       MOVE T-AMT TO JR-AMOUNT

                       WRITE JOURNAL-REC

               END-READ

           END-PERFORM

           CLOSE TRANS-FILE
           CLOSE JOURNAL-FILE

           STOP RUN.
