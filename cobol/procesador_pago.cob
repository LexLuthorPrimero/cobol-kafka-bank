       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROCESADOR-PAGO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 WS-STATUS PIC X(5) VALUE SPACES.

       PROCEDURE DIVISION.

       MAIN-PARA.

           IF 1 = 1
               MOVE "OK" TO WS-STATUS
           ELSE
               MOVE "ERROR" TO WS-STATUS
           END-IF

           DISPLAY WS-STATUS

           STOP RUN.
