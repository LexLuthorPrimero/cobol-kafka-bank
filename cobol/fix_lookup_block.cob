
       01 WS-PROCESSED PIC X VALUE "N".

       ...

       MOVE "N" TO WS-PROCESSED

       PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > WS-IDX

           IF W-ID(IDX) = T-ID

               IF WS-PROCESSED = "N"

                   MOVE "Y" TO WS-PROCESSED

                   IF W-SALDO(IDX) >= T-AMT
                       SUBTRACT T-AMT FROM W-SALDO(IDX)

                       STRING "OK " W-ID(IDX)
                           DELIMITED BY SIZE
                           INTO J-TXT
                       WRITE J-REC
                   ELSE
                       STRING "FAIL " W-ID(IDX)
                           DELIMITED BY SIZE
                           INTO J-TXT
                       WRITE J-REC
                   END-IF

               END-IF

           END-IF

       END-PERFORM

