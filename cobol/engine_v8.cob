       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENGINE-V8.

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
               ORGANIZATION IS SEQUENTIAL.

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
       01 TMP-LINE PIC X(50).

       WORKING-STORAGE SECTION.

       01 WS-EOF PIC X VALUE "N".

       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT ACCOUNTS-FILE
           OPEN INPUT TRANS-FILE
           OPEN OUTPUT TEMP-FILE

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END

                       STRING ACC-REC DELIMITED BY SIZE
                       INTO TMP-LINE

                       WRITE TMP-LINE

               END-READ

           END-PERFORM

           CLOSE ACCOUNTS-FILE
           CLOSE TRANS-FILE
           CLOSE TEMP-FILE

           STOP RUN.
