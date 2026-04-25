       IDENTIFICATION DIVISION.
       PROGRAM-ID. PATCH-LOGIC.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01 WS-IDX PIC 9(2) VALUE 0.
       01 WS-MATCH-FOUND PIC X VALUE "N".

       01 WS-ID-TABLE.
           05 W-ID     OCCURS 10 TIMES PIC X(5)
               VALUE "001970000".

       01 WS-SALDO-TABLE.
           05 W-SALDO  OCCURS 10 TIMES PIC 9(9)
               VALUE 10000.

       01 T-ID     PIC X(5) VALUE "001970000".
       01 T-AMT    PIC 9(9) VALUE 70.

       01 J-TXT    PIC X(80).
       01 J-REC.
           05 FILLER PIC X(80).

       PROCEDURE DIVISION.

       MAIN.

           MOVE "N" TO WS-MATCH-FOUND

           PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > 10

               IF W-ID(WS-IDX) = T-ID

                   MOVE "Y" TO WS-MATCH-FOUND

                   IF W-SALDO(WS-IDX) >= T-AMT
                       SUBTRACT T-AMT FROM W-SALDO(WS-IDX)

                       STRING "OK " W-ID(WS-IDX)
                           DELIMITED BY SIZE
                           INTO J-TXT
                       END-STRING

                       DISPLAY J-TXT
                   ELSE
                       STRING "FAIL " W-ID(WS-IDX)
                           DELIMITED BY SIZE
                           INTO J-TXT
                       END-STRING

                       DISPLAY J-TXT
                   END-IF

               END-IF

           END-PERFORM

           IF WS-MATCH-FOUND = "N"
               MOVE "NO MATCH TX" TO J-TXT
               DISPLAY J-TXT
           END-IF

           STOP RUN.
