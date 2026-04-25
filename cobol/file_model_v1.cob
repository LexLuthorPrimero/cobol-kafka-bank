       IDENTIFICATION DIVISION.
       PROGRAM-ID. FILE-MODEL-V1.

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
           05 TR-ID   PIC X(5).
           05 FILLER  PIC X.
           05 TR-AMT  PIC 9(9).

       FD TEMP-FILE.
       01 TMP-REC.
           05 TMP-ID     PIC X(5).
           05 TMP-NAME   PIC X(20).
           05 TMP-SALDO  PIC 9(9).

       FD JOURNAL-FILE.
       01 JR-REC.
           05 JR-TXT PIC X(80).

       WORKING-STORAGE SECTION.

       01 WS-EOF PIC X VALUE "N".

       PROCEDURE DIVISION.
       MAIN.

           OPEN INPUT ACCOUNTS-FILE
           OPEN INPUT TRANS-FILE
           OPEN OUTPUT TEMP-FILE
           OPEN OUTPUT JOURNAL-FILE

           DISPLAY "FILE MODEL OK - NO LOGIC YET"

           CLOSE ACCOUNTS-FILE
           CLOSE TRANS-FILE
           CLOSE TEMP-FILE
           CLOSE JOURNAL-FILE

           STOP RUN.
