       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROCESA-TRANSACCIONES.

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
               ORGANIZATION IS SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD ACCOUNTS-FILE.
       01 ACCOUNTS-RECORD.
           05 AC-ID     PIC X(5).
           05 AC-NOMBRE PIC X(20).
           05 AC-SALDO  PIC 9(9).

       FD TRANS-FILE.
       01 TRANS-RECORD.
           05 TR-ID    PIC X(5).
           05 FILLER   PIC X(1).
           05 TR-MONTO PIC 9(9).

       FD TEMP-FILE.
       01 TEMP-RECORD.
           05 TMP-ID     PIC X(5).
           05 TMP-NOMBRE PIC X(20).
           05 TMP-SALDO  PIC 9(9).

       FD JOURNAL-FILE.
       01 JOURNAL-RECORD.
           05 JR-TXT PIC X(80).

       WORKING-STORAGE SECTION.

       01 WS-EOF-TRANS PIC X VALUE "N".
       01 WS-EOF-ACCT  PIC X VALUE "N".

       01 WS-SALDO     PIC 9(9).
       01 WS-MONTO     PIC 9(9).
       01 WS-NEW       PIC 9(9).

       PROCEDURE DIVISION.

       MAIN.

           OPEN INPUT TRANS-FILE
           OPEN INPUT ACCOUNTS-FILE
           OPEN OUTPUT TEMP-FILE
           OPEN OUTPUT JOURNAL-FILE

           PERFORM UNTIL WS-EOF-TRANS = "Y"

               READ TRANS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF-TRANS
                   NOT AT END

                       PERFORM PROCESS-ALL-ACCOUNTS

               END-READ

           END-PERFORM

           CLOSE ACCOUNTS-FILE
           CLOSE TRANS-FILE
           CLOSE TEMP-FILE
           CLOSE JOURNAL-FILE

           STOP RUN.

       PROCESS-ALL-ACCOUNTS.

           MOVE "N" TO WS-EOF-ACCT

           PERFORM UNTIL WS-EOF-ACCT = "Y"

               READ ACCOUNTS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF-ACCT
                   NOT AT END

                       IF AC-ID = TR-ID

                           MOVE AC-SALDO TO WS-SALDO
                           MOVE TR-MONTO TO WS-MONTO

                           IF WS-SALDO >= WS-MONTO
                               COMPUTE WS-NEW = WS-SALDO - WS-MONTO
                               MOVE WS-NEW TO AC-SALDO

                               STRING "OK TX " AC-ID
                                   DELIMITED BY SIZE
                                   INTO JR-TXT
                               WRITE JOURNAL-RECORD
                           ELSE
                               STRING "FAIL TX " AC-ID
                                   DELIMITED BY SIZE
                                   INTO JR-TXT
                               WRITE JOURNAL-RECORD
                           END-IF

                       END-IF

                       WRITE TEMP-RECORD FROM ACCOUNTS-RECORD

               END-READ

           END-PERFORM.

