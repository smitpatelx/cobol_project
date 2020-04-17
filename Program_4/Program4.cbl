       identification division.
       program-id. program4.
       author. Smit Patel. Devansh Patel.
       date-written. 10/04/2020.
      *
       environment division.
       input-output section.
       file-control.
           select in-file
               assign "../../../data/returns_records.dat"
               organization is line sequential.
      *
           select print-file
               assign "../../../data/returns_report.out"
               organization is line sequential.
      *
       data division.
       file section.
       fd in-file
           data record is in-rec
           record contains 36 characters.
      *
       01 in-rec.
         05 in-transaction-code pic X.
         05 in-transaction-amount pic 9(5)V99.
         05 in-payment-type pic XX.
         05 in-store-number pic x(2).
         05 in-invoice-number pic X(9).
         05 in-sku-code pic X(15).
      *
       fd print-file
           record contains 73 characters
           data record is print-line.
      *
       01 print-line pic x(73).
      *
       working-storage section.

       01 ws-flags.
         05 WS-EOF-FLAGS pic XX.

       01 ws-variables.
         05 ws-page-num pic 99 value 0.
         05 ws-line-count pic 99.
         05 ws-tax-indi pic 9(5)V99.

         05 ws-total-R pic 99 value 0.
         05 ws-total-cash pic 99 value 0.
         05 ws-total-credit pic 99 value 0.
         05 ws-total-debit pic 99 value 0.
         05 ws-total-cash-per pic 99V99 value 0.
         05 ws-total-credit-per pic 99V99 value 0.
         05 ws-total-debit-per pic 99V99.
         05 ws-total-tax pic 9(9)V99.
         05 ws-total-num-stores pic 99 value 06.
         05 ws-highest-trans-amount pic 9(9)V99 value ZEROES.
         05 ws-lowest-trans-amount pic 9(9)V99 value ZEROES.
         05 ws-highest-trans-store pic 99 value 00.
         05 ws-lowest-trans-store pic 99 value 00.
         05 ws-temp-total-trans pic 9(9)V99 value ZEROES.
         05 ws-total-tran-per-store OCCURS 6 TIMES INDEXED BY
                                    index-store.
           10 ws-total-tran-store pic 9(9)V99 value ZEROES.
       01 ws-store-numbers.
         05 filler pic 99 value 01.
         05 filler pic 99 value 02.
         05 filler pic 99 value 03.
         05 filler pic 99 value 04.
         05 filler pic 99 value 05.
         05 filler pic 99 value 12.

       01 ws-store-num-const REDEFINES ws-store-numbers OCCURS 6 TIMES
                             INDEXED BY index-const pic 99.

       01 ws-constants.
         05 ws-tax-applicable pic 99 value 13.

       01 ws-report-heading.
         05 filler pic x(25) value "FINAL PROJECT - PROGRAM 4".
         05 filler pic x(28) value spaces.
         05 filler pic x(20) value "Group 6 : Smit Patel".

       01 ws-report-heading-2.
         05 ws-rh-date pic 9(6) value zeroes.
         05 filler pic x(4) value spaces.
         05 ws-rh-time pic 9(7) value zeroes.
         05 filler pic x(43) value spaces.
         05 filler pic x(13) value "Devansh Patel".

       01 ws-page-heading.
         05 filler pic x(27) value spaces.
         05 filler pic x(14) value "Returns Report".
         05 filler pic x(24) value spaces.
         05 filler pic x(6) value "PAGE: ".
         05 WS-CH-PAGE-NO pic Z9 value "00".

       01 WS-REPORT-HEADING-L1.
         05 filler PIC X(5) value "Trans".
         05 filler PIC X(3) value SPACES.
         05 filler PIC X(5) value "Trans".
         05 filler PIC X(6) value SPACES.
         05 filler PIC X(7) value "Payment".
         05 filler PIC X(2) value SPACES.
         05 filler PIC X(5) value "Store".
         05 filler PIC X(3) value SPACES.
         05 filler PIC X(7) value "Invoice".
         05 filler PIC X(5) value SPACES.
         05 filler PIC X(3) value "SKU".
         05 filler PIC X(16) value SPACES.
         05 filler PIC X(3) value "Tax".
         05 filler PIC X(4) value SPACES.

       01 WS-REPORT-HEADING-L2.
         05 filler PIC X(4) value "Code".
         05 filler PIC X(4) value SPACES.
         05 filler PIC X(6) value "Amount".
         05 filler PIC X(5) value SPACES.
         05 filler PIC X(4) value "Type".
         05 filler PIC X(5) value SPACES.
         05 filler PIC X(6) value "Number".
         05 filler PIC X(2) value SPACES.
         05 filler PIC X(6) value "Number".
         05 filler PIC X(6) value SPACES.
         05 filler PIC X(4) value "Code".
         05 filler PIC X(15) value SPACES.
         05 filler PIC X(6) value "Amount".

       01 WS-REPORT-HEADING-L3.
         05 filler PIC X(4) value "----".
         05 filler PIC X(4) value SPACES.
         05 filler PIC X(6) value "------".
         05 filler PIC X(5) value SPACES.
         05 filler PIC X(4) value "----".
         05 filler PIC X(5) value SPACES.
         05 filler PIC X(6) value "------".
         05 filler PIC X(2) value SPACES.
         05 filler PIC X(6) value "------".
         05 filler PIC X(6) value SPACES.
         05 filler PIC X(4) value "----".
         05 filler PIC X(15) value SPACES.
         05 filler PIC X(6) value "------".

       01 ws-report-details.
         05 filler PIC X(2) value SPACES.
         05 ws-transaction-code PIC X.
         05 filler PIC X(2) value SPACES.
         05 ws-transaction-amount PIC Z(4)9.99.
         05 filler PIC X(1) value '$'.
         05 filler PIC X(5) value SPACES.
         05 ws-payment-type PIC XX.
         05 filler PIC X(7) value SPACES.
         05 ws-store-number PIC 99.
         05 filler PIC X(6) value SPACES.
         05 ws-invoice-number PIC X(9).
         05 filler PIC X(3) value SPACES.
         05 ws-sku-code PIC X(15).
         05 filler PIC X(1) value SPACES.
         05 ws-taxes PIC Z(4)9.99.
         05 filler PIC X(1) value '$'.

       01 ws-empty-line.
         05 filler pic x(73) value spaces.

       01 ws-tno-R.
         05 filler pic x(35) value "Total number of R records    : ".
         05 ws-tno-R-val pic z9.
         05 filler pic x(36) value spaces.



       01 ws-payment-t-per.
         05 filler pic x(34) value "Payment Types Percentage: CASH- ".
         05 ws-tper-cash-val pic z9.99.
         05 filler pic x(12) value '%   CREDIT- '.
         05 ws-tper-credit-val pic z9.99.
         05 filler pic x(11) value '%   DEBIT- '.
         05 ws-tper-debit-val pic z9.99.
         05 filler pic x(4) value '%'.

       01 ws-total-tax-owing.
           05 filler                           pic x(33) value
               "Total tax owing              :".
           05 ws-total-tax-value               pic $$,$$9.99.

       01 ws-store-num-with-highest-R.
         05 filler pic x(35) value "STORE NUMBER THAT HAS HIGHEST R".
         05 filler pic x(15) value " TRANSACTION - ".
         05 ws-snum-w-h-R-val pic 99.
         05 filler pic x(21) value spaces.

       01 ws-store-num-with-lowest-R.
         05 filler pic x(35) value "STORE NUMBER THAT HAS LOWEST  R".
         05 filler pic x(15) value " TRANSACTION - ".
         05 ws-snum-w-l-R-val pic 99.
         05 filler pic x(21) value spaces.
       77 ws-sub pic 99 value 1.
       PROCEDURE DIVISION.
       0100-READ-EMPLOYEES.
      *
      *OPEN FILES
      *
           OPEN INPUT in-file.
           OPEN OUTPUT print-file.
      *
      *WRITE REPORT HEADING
      *
           write print-line from ws-report-heading.
           write print-line from ws-report-heading-2.
      *START READING INPUT FILE
           READ in-file
               AT END
                   MOVE 't' TO WS-EOF-FLAGS
           END-READ.
      *PROCESS RECORDS
           PERFORM 0200-PROCESS-LINES UNTIL WS-EOF-FLAGS = 't'.

           PERFORM 0120-PRINT-FOOTER.

      *CLOSE FILES AND GO BACK
           CLOSE in-file print-file.
           GOBACK.
       0100-END.

       0200-PROCESS-LINES.

           PERFORM 0110-PRINT-HEADINGS.

           PERFORM 0210-LINE-ON-A-PAGE
             VARYING ws-line-count FROM 1 BY 1
             UNTIL ws-line-count > 20
             OR WS-EOF-FLAGS = "t".

       0200-END.

       0110-PRINT-HEADINGS.
           ADD 1 TO ws-page-num.
           MOVE ws-page-num TO WS-CH-PAGE-NO.

      *WRITE HEADER
           WRITE print-line FROM ws-page-heading
             AFTER ADVANCING 1 LINE.
           WRITE print-line FROM WS-REPORT-HEADING-L1
             AFTER ADVANCING 2 LINE.
           WRITE print-line FROM WS-REPORT-HEADING-L2
             AFTER ADVANCING 1 LINE.
           WRITE print-line FROM WS-REPORT-HEADING-L3
             AFTER ADVANCING 1 LINE.
           WRITE print-line FROM ws-empty-line
             AFTER ADVANCING 1 LINE.

       0110-END.

       0120-PRINT-FOOTER.

           perform 0400-PROCESSING-VARIABLES.

           move ws-total-R to ws-tno-R-val
           write print-line from ws-tno-R
             AFTER ADVANCING 2 LINE.


           move ws-total-cash-per to ws-tper-cash-val.
           move ws-total-credit-per to ws-tper-credit-val.
           move ws-total-debit-per to ws-tper-debit-val.
           write print-line from ws-payment-t-per
             AFTER ADVANCING 2 LINE.

           move ws-total-tax to ws-total-tax-value.
           write print-line from ws-total-tax-owing
             AFTER ADVANCING 2 LINE.

           move ws-highest-trans-store to ws-snum-w-h-R-val.
           write print-line from ws-store-num-with-highest-R
             AFTER ADVANCING 2 LINE.

           move ws-lowest-trans-store to ws-snum-w-l-R-val.
           write print-line from ws-store-num-with-lowest-R
             AFTER ADVANCING 1 LINE.

       0120-END.

       0210-LINE-ON-A-PAGE.
           ADD 1 TO ws-total-R.
           PERFORM 0300-PRINT-LINES.

           READ in-file
               AT END
                   MOVE "t" TO WS-EOF-FLAGS
           END-READ.

       0210-END.

       0400-PROCESSING-VARIABLES.



           compute ws-total-cash-per rounded =
             (ws-total-cash * 100) / ws-total-R.

           compute ws-total-credit-per rounded =
             (ws-total-credit * 100) / ws-total-R.

           compute ws-total-debit-per rounded =
             (ws-total-debit * 100) / ws-total-R.

       0400-END.

       0300-PRINT-LINES.



           if (in-payment-type = "CA") then
               add 1 to ws-total-cash
           else
               if (in-payment-type = "CR") THEN
                   add 1 to ws-total-credit
               else
                   if (in-payment-type = "DB") THEN
                       add 1 to ws-total-debit
                   end-if.
      *    chnage

           SET index-store to 1
           PERFORM 410-PROCESS-STORES VARYING index-store FROM 1 BY 1
             UNTIL index-store > ws-total-num-stores.

           COMPUTE ws-tax-indi ROUNDED =
             (in-transaction-amount * ws-tax-applicable) / 100.

           add ws-tax-indi to ws-total-tax.

           MOVE in-transaction-code TO ws-transaction-code.
           MOVE in-transaction-amount TO ws-transaction-amount.
           MOVE in-payment-type TO ws-payment-type.
           MOVE in-store-number TO ws-store-number.
           MOVE in-invoice-number TO ws-invoice-number.
           MOVE in-sku-code TO ws-sku-code.
           MOVE ws-tax-indi TO ws-taxes.

           WRITE print-line FROM ws-report-details
             AFTER ADVANCING 1 LINE.

       0300-END.
       410-PROCESS-STORES.
           SET index-const TO index-store.
           IF (in-store-number = ws-store-num-const(index-const)) THEN

               ADD in-transaction-amount
                 TO ws-total-tran-store(index-store)

               MOVE ws-total-tran-store(index-store)
                 TO ws-temp-total-trans

               IF (ws-temp-total-trans > ws-highest-trans-amount) THEN
                   MOVE ws-store-num-const(index-const)
                     TO ws-highest-trans-store
                   MOVE ws-temp-total-trans
                     TO ws-highest-trans-amount
               END-IF
               MOVE ws-highest-trans-amount
                 TO ws-lowest-trans-amount
               IF (ws-temp-total-trans < ws-lowest-trans-amount)
                 THEN

                   MOVE ws-store-num-const(index-const)
                     TO ws-lowest-trans-store
                   MOVE ws-temp-total-trans
                     TO ws-lowest-trans-amount
               END-IF

           END-IF.

       410-END.

       END PROGRAM program4.
