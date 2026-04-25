       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENGINE-REAL-V3-FIXED.

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

       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT TRANS-FILE
           OPEN OUTPUT TEMP-FILE

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END

                       OPEN INPUT ACCOUNTS-FILE

                       PERFORM PROCESS-ACCOUNTS

                       CLOSE ACCOUNTS-FILE

               END-READ

           END-PERFORM

           CLOSE TRANS-FILE
           CLOSE TEMP-FILE

           STOP RUN.

       PROCESS-ACCOUNTS.

           PERFORM UNTIL 1 = 2

               READ ACCOUNTS-FILE
                   AT END
                       EXIT PERFORM
                   NOT AT END

                       IF AC-ID = T-ID
                           IF AC-SALDO >= T-AMT
                               SUBTRACT T-AMT FROM AC-SALDO
                               DISPLAY "OK " AC-ID
                           ELSE
                               DISPLAY "FAIL " AC-ID
                           END-IF
                       END-IF

                       WRITE TMP-REC FROM ACC-REC

               END-READ

           END-PERFORM.

