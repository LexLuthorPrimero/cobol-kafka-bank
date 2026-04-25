       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENGINE-V2-TRANS.

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

           SELECT JOURNAL-FILE
               ASSIGN TO "accounts/JOURNAL.LOG"
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
           05 T-ID  PIC X(5).
           05 FILLER PIC X.
           05 T-AMT PIC 9(9).

       FD TEMP-FILE.
       01 TMP-REC.
           05 TMP-ID     PIC X(5).
           05 TMP-NAME   PIC X(20).
           05 TMP-SALDO  PIC 9(9).

       FD JOURNAL-FILE.
       01 JR-REC.
           05 JR-TXT PIC X(80).

       WORKING-STORAGE SECTION.

       01 WS-EOF       PIC X VALUE "N".
       01 WS-FOUND     PIC X VALUE "N".
       01 WS-JSTAT     PIC XX.

       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT ACCOUNTS-FILE
           OPEN INPUT TRANS-FILE
           OPEN OUTPUT TEMP-FILE
           OPEN OUTPUT JOURNAL-FILE

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END

                       MOVE "N" TO WS-FOUND

                       PERFORM LOOKUP-ACCOUNT

               END-READ

           END-PERFORM

           CLOSE ACCOUNTS-FILE
           CLOSE TRANS-FILE
           CLOSE TEMP-FILE
           CLOSE JOURNAL-FILE

           STOP RUN.

       LOOKUP-ACCOUNT.

           READ ACCOUNTS-FILE
               AT END
                   MOVE "N" TO WS-FOUND
               NOT AT END

                   IF AC-ID = T-ID
                       MOVE "Y" TO WS-FOUND

                       IF AC-SALDO >= T-AMT
                           SUBTRACT T-AMT FROM AC-SALDO
                           MOVE AC-ID TO TMP-ID
                           MOVE AC-NAME TO TMP-NAME
                           MOVE AC-SALDO TO TMP-SALDO
                           WRITE TMP-REC

                           MOVE "OK " TO JR-TXT
                           WRITE JR-REC
                       ELSE
                           MOVE "FAIL " TO JR-TXT
                           WRITE JR-REC
                       END-IF
                   END-IF
           END-READ.

