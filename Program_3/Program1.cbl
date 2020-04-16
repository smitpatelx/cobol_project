       identification division.
       program-id. Program1.
       author.Smit Patel. Devansh Patel.
       
       environment division.
       input-output section.
       file-control.
           select input-file
               assign "../../../data/S&LRecords.dat"
               organization is line sequential.
      *
           select output-file
               assign "../../../data/S&LReport.out"
               organization is line sequential.
      *
       data division.
       file section.
       fd input-file
           data record is input-line
           record contains 36 characters.
      *
       01 input-line.
           05 il-trans-code      pic X.
           05 il-trans-amnt    pic 9(5)V99.
           05 il-type-of-payment          pic XX.
           05 il-num-of-store          pic 99.
           05 il-num-of-invoice        pic X(9).
           05 il-sku              pic X(15).
      *
       fd output-file
           record contains 73 characters
           data record is print-line.
      *
       01 print-line                   pic x(73).
      *
       working-storage section.

       01 ws-flags.
           05 WS-EOF-FLAGS             pic XX.

       01 ws-declaration.
           05 ws-pg-numbers              pic 99
               value 0.
           05 ws-c-for-lines            pic 99.
           05 ws-tax-for-each-person              pic 9(5)V99.
           05 ws-total-for-s               pic 99.
           05 ws-total-l               pic 99.
           05 ws-total-for-sl              pic 99.
           05 ws-total-for-cash            pic 99.
           05 ws-total-for-credit          pic 99.
           05 ws-total-for-debit           pic 99.
           05 ws-total-percentage-of-cash        pic 99V99.
           05 ws-total-percentage-of-credit      pic 99V99.
           05 ws-total-percentage-of-debit       pic 99V99.
           05 ws-tax-in-total             pic 9(9)V99.
           05 ws-total-number-of-stores      pic 99 value 06.
           05 ws-total-transaction-initially      pic 9(9)V99 value 
           0.
           05 ws-maximum-amount-of-transaction  pic 9(9)V99 value 
           0.
           05 ws-minimum-amount-of-transaction   pic 9(9)V99 value 
           0.
           05 ws-maximum-number-of-transaction-store   pic 99 value 00.
           05 ws-minimum-number-of-transaction-store    pic 99 value 00.
           05 ws-total-transaction-store-individually  occurs 6 times 
           indexed
               BY indx-for-store.
               10 ws-final-transaction-store  pic 9(9)V99 value 0.

       01 ws-num-for-stores.
           05 filler                   pic 99 value 01.
           05 filler                   pic 99 value 02.
           05 filler                   pic 99 value 03.
           05 filler                   pic 99 value 04.
           05 filler                   pic 99 value 05.
           05 filler                   pic 99 value 12.

       01 ws-store-num-const redefines ws-num-for-stores
           occurs 6 times indexed by index-const             pic 99.

       01 ws-constants.
           05 ws-tax-applicable        pic 99 value 13.

       01 ws-r-heading.
           05 filler                   pic x(10) value "Smit Patel".
           05 filler                   pic x(15) value spaces.
           05 filler                   pic x(13)  value "Devansh Patel".
           05 filler                   pic x(26) value spaces.
           05 filler                   pic x(8)  value " Group 6".

       01 ws-heding-for-page.
           05 filler                   pic x(31) value spaces.
           05 ws-heading-pg            pic x(12) value "S&L Result".
           05 filler                   pic x(22) value spaces.
           05 filler                   pic x(6)  value "PAGE#: ".
           05 ws-c-pg-number            pic Z9    value "00".

       01 ws-r-heading-for-line1.
           05 filler                   pic X(6)  value "Trnscn".
           05 filler                   pic X(3)  value spaces.
           05 filler                   pic X(6)  value "Trnscn".
           05 filler                   pic X(6)  value spaces.
           05 filler                   pic X(7)  value "Payment".
           05 filler                   pic X(2)  value spaces.
           05 filler                   pic X(5)  value "store".
           05 filler                   pic X(3)  value spaces.
           05 filler                   pic X(8)  value "invoice#".
           05 filler                   pic X(5)  value spaces.
           05 filler                   pic X(4)  value "SKU ".
           05 filler                   pic X(12) value spaces.
           05 filler                   pic X(3)  value "Tax".
           05 filler                   pic X(4)  value spaces.

       01 ws-r-heading-for-line2.
           05 filler                   pic X(4)  value "code".
           05 filler                   pic X(4)  value spaces.
           05 filler                   pic X(6)  value "Amount".
           05 filler                   pic X(5)  value spaces.
           05 filler                   pic X(4)  value "Type".
           05 filler                   pic X(5)  value spaces.
           05 filler                   pic X(6)  value "Number".
           05 filler                   pic X(2)  value spaces.
           05 filler                   pic X(6)  value "Number".
           05 filler                   pic X(9)  value spaces.
           05 filler                   pic X(4)  value "Code".
           05 filler                   pic X(13) value spaces.
           05 filler                   pic X(6)  value "Amount".
           05 filler                   pic X(2)  value spaces.

       01 ws-repo-info.
           05 filler                   pic X(2)  value spaces.
           05 ws-trans-code      pic X.
           05 filler                   pic X(4)  value spaces.
           05 ws-trans-amnt    pic $(4)9.99.
           05 filler                   pic X(4)  value spaces.
           05 ws-typ-of-paymnt          pic XX.
           05 filler                   pic X(7)  value spaces.
           05 ws-num-of-str          pic 99.
           05 filler                   pic X(6)  value spaces.
           05 ws-invc-num        pic X(9).
           05 filler                   pic X(3)  value spaces.
           05 ws-sku-c              pic X(15).
           05 filler                   pic X(2)  value spaces.
           05 ws-taxe                 pic $(4)9.99.
           05 filler                   pic X(1)  value spaces.

       01 ws-blank-lines.
           05 filler                   pic x(73) value spaces.

       01 ws-tno-s-and-l.
           05 filler                   pic x(35)
               value "  total number of S&L records    : ".
           05 ws-tno-s-and-l-val       pic z9.
           05 filler                   pic x(36) value spaces.

       01 ws-tno-s.
           05 filler                   pic x(35)
               value "  total number of S   records    : ".
           05 ws-tno-s-val             pic z9.
           05 filler                   pic x(36) value spaces.

       01 ws-tno-l.
           05 filler                   pic x(35)
               value "  total number of L   records    : ".
           05 ws-tno-l-val             pic x9.
           05 filler                   pic x(36) value spaces.

       01 ws-payment-t-per.
           05 filler                   pic x(34)
               value "  Payment Types Percentage: CASH- ".
           05 ws-tper-cash-val         pic z9.99.
           05 filler                   pic x(12) value '%   CREDIT- '.
           05 ws-tper-credit-val       pic z9.99.
           05 filler                   pic x(11) value '%   DEBIT- '.
           05 ws-tper-debit-val        pic z9.99.
           05 filler                   pic x(4) value '%'.

       01 ws-tax-in-total-owing.
           05 filler                   pic x(35)
               value "  total tax owing                : ".
           05 ws-tax-in-total-value       pic $(8)9.99.
           05 filler                   pic x(26) value spaces.

       01 ws-store-num-with-highest-sl.
           05 filler                   pic x(35)
               value "  StoRE NUMBER THAT HAS HIGHEST S&L".
           05 filler                   pic x(22)
               value " TRANSACTION AMOUNT - ".
           05 ws-snum-w-h-sl-val       pic 99.
           05 filler                   pic x(14) value spaces.

       01 ws-store-num-with-lowest-sl.
           05 filler                   pic x(35)
               value "  StoRE NUMBER THAT HAS LOWEST  S&L".
           05 filler                   pic x(22)
               value " TRANSACTION AMOUNT - ".
           05 ws-snum-w-l-sl-val       pic 99.
           05 filler                   pic x(14) value spaces.

       PROCEDURE DIVISION.
       0100-read-DATA.
      *
      *OPEN FILES
      *
           open input  input-file.
           open output output-file.
      *
      *write REPORT HEADING
      *
           write print-line from ws-r-heading.
      *START readING INPUT FILE
           read input-file
               AT END move 't'         to WS-EOF-FLAGS
           END-read.
      *PROCESS RECORDS
           PERFORM 0200-PROCESS-lineS until WS-EOF-FLAGS = 't'.

           PERFORM 0120-PRINT-FOOTER.

      *CLOSE FILES AND GO BACK
           CLOSE input-file output-file.
           GOBACK.
       0100-END.

       0200-PROCESS-lineS.

           PERFORM 0110-PRINT-HEADINGS.

           PERFORM 0210-line-ON-A-PAGE
               VARYING ws-c-for-lines from 1 BY 1
               until   ws-c-for-lines > 20
               OR      WS-EOF-FLAGS = "t".

       0200-END.

       0110-PRINT-HEADINGS.
           ADD 1                       to ws-pg-numbers.
           move ws-pg-numbers            to ws-c-pg-number.

      *write HEADER
           write print-line    from ws-heding-for-page
               after advancing 2 line.
           write print-line    from ws-r-heading-for-line1
               after advancing 2 line.
           write print-line    from ws-r-heading-for-line2
               after advancing 1 line.
           write print-line    from ws-blank-lines
               after advancing 1 line.

       0110-END.

       0120-PRINT-FOOTER.

           perform 0400-PROCESSING-VARIABLES.

           move ws-total-for-sl            to ws-tno-s-and-l-val
           write print-line from ws-tno-s-and-l
               after advancing 2 line.

           move ws-total-for-s             to ws-tno-s-val.
           write print-line from ws-tno-s
               after advancing 1 line.

           move ws-total-l             to ws-tno-l-val.
           write print-line from ws-tno-l
               after advancing 1 line.

           move ws-total-percentage-of-cash      to ws-tper-cash-val.
           move ws-total-percentage-of-credit    to ws-tper-credit-val.
           move ws-total-percentage-of-debit     to ws-tper-debit-val.
           write print-line from ws-payment-t-per
               after advancing 2 line.

           move ws-tax-in-total           to ws-tax-in-total-value.
           write print-line from ws-tax-in-total-owing
               after advancing 2 line.

           move ws-maximum-number-of-transaction-store to 
           ws-snum-w-h-sl-val.
           write print-line from ws-store-num-with-highest-sl
               after advancing 2 line.

           move ws-minimum-number-of-transaction-store  to 
           ws-snum-w-l-sl-val.
           write print-line from ws-store-num-with-lowest-sl
               after advancing 1 line.

       0120-END.

       0210-line-ON-A-PAGE.

           PERFORM 0300-PRINT-lineS.

           read input-file
               AT END move "t" to WS-EOF-FLAGS
               END-read.

       0210-END.

       0400-PROCESSING-VARIABLES.

           compute ws-total-for-sl = ws-total-for-s + ws-total-l.

           compute ws-total-percentage-of-cash rounded =
              ( ws-total-for-cash * 100 ) / ws-total-for-sl.

           compute ws-total-percentage-of-credit rounded =
              ( ws-total-for-credit * 100 ) / ws-total-for-sl.

           compute ws-total-percentage-of-debit rounded =
              ( ws-total-for-debit * 100 ) / ws-total-for-sl.



       0400-END.

       0300-PRINT-lineS.

           if(il-trans-code = "S") then
               add 1 to ws-total-for-s
           else if (il-trans-code = "L") then
               add 1 to ws-total-l
           end-if.

           if(il-type-of-payment = "CA") then
               add 1 to ws-total-for-cash
           else if (il-type-of-payment = "CR") then
               add 1 to ws-total-for-credit
           else if (il-type-of-payment = "DB") then
               add 1 to ws-total-for-debit
           end-if.

           SET indx-for-store             to 1
           PERFORM 410-PROCESS-StoRES VARYING indx-for-store from 1 BY 1
               until indx-for-store > ws-total-number-of-stores.

           compute ws-tax-for-each-person ROUNDED =
               (il-trans-amnt * ws-tax-applicable) / 100.

           add ws-tax-for-each-person             to ws-tax-in-total.

           move il-trans-code    to ws-trans-code.
           move il-trans-amnt  to ws-trans-amnt.
           move il-type-of-payment        to ws-typ-of-paymnt.
           move il-num-of-store        to ws-num-of-str.
           move il-num-of-invoice      to ws-invc-num.
           move il-sku            to ws-sku-c.
           move ws-tax-for-each-person            to ws-taxe.

           write print-line from ws-repo-info
               after advancing 1 line.

       0300-END.

       410-PROCESS-StoRES.
           SET index-const             to indx-for-store.
           if(il-num-of-store = ws-store-num-const(index-const)) then

               ADD il-trans-amnt
                                       to ws-final-transaction-store(
                                       indx-for-store)

               move ws-final-transaction-store(indx-for-store)
                                       to ws-total-transaction-initially

               if(ws-total-transaction-initially > 
               ws-maximum-amount-of-transaction) then
                   move ws-store-num-const(index-const)
                                       to 
       ws-maximum-number-of-transaction-store
                   move ws-total-transaction-initially
                                       to 
                                       ws-maximum-amount-of-transaction
               end-if
               move ws-maximum-amount-of-transaction
                                       to 
                                       ws-minimum-amount-of-transaction
               if (ws-total-transaction-initially < 
               ws-minimum-amount-of-transaction)
                   then

                   move ws-store-num-const(index-const)
                                       to 
       ws-minimum-number-of-transaction-store
                   move ws-total-transaction-initially
                                       to 
                                       ws-minimum-amount-of-transaction
               end-if

           end-if.

       410-END.

       END PROGRAM program1.
