       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANK-ROBUST-ENGINE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ACCOUNTS-FILE
               ASSIGN TO "accounts/ACCOUNTS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FS-ACC.

           SELECT TRANS-FILE
               ASSIGN TO "trans_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FS-TRANS.

           SELECT JOURNAL-FILE
               ASSIGN TO "accounts/JOURNAL.LOG"
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-JOURNAL.

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

       01 WS-FS-ACC     PIC XX.
       01 WS-FS-TRANS   PIC XX.
       01 WS-FS-JOURNAL PIC XX.

       01 WS-EOF PIC X VALUE "N".
       01 WS-ERROR PIC X VALUE "N".

       01 WS-SALDO PIC 9(9).
       01 WS-AMT   PIC 9(9).

       PROCEDURE DIVISION.

       MAIN.

           PERFORM OPEN-FILES
           IF WS-ERROR = "Y"
               STOP RUN
           END-IF

           PERFORM PROCESS-TRANS

           PERFORM CLOSE-FILES

           STOP RUN.

       OPEN-FILES.

           OPEN INPUT ACCOUNTS-FILE
           IF WS-FS-ACC NOT = "00"
               DISPLAY "ERROR ACCOUNTS OPEN: " WS-FS-ACC
               MOVE "Y" TO WS-ERROR
           END-IF

           OPEN INPUT TRANS-FILE
           IF WS-FS-TRANS NOT = "00"
               DISPLAY "ERROR TRANS OPEN: " WS-FS-TRANS
               MOVE "Y" TO WS-ERROR
           END-IF

           OPEN OUTPUT JOURNAL-FILE
           IF WS-FS-JOURNAL NOT = "00"
               DISPLAY "ERROR JOURNAL OPEN: " WS-FS-JOURNAL
               MOVE "Y" TO WS-ERROR
           END-IF.

       PROCESS-TRANS.

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       PERFORM PROCESS-ACCOUNT
               END-READ

               IF WS-FS-TRANS NOT = "00"
                   DISPLAY "ERROR READ TRANS: " WS-FS-TRANS
                   MOVE "Y" TO WS-ERROR
                   EXIT PERFORM
               END-IF

           END-PERFORM.

       PROCESS-ACCOUNT.

           IF WS-FS-ACC NOT = "00"
               DISPLAY "SKIP ACCOUNT ERROR"
           END-IF.

       CLOSE-FILES.

           CLOSE ACCOUNTS-FILE
           CLOSE TRANS-FILE
           CLOSE JOURNAL-FILE.

