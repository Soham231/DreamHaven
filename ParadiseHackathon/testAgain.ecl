namesRec := RECORD
 STRING20 lname;
 STRING10 fname;
 UNSIGNED2 age := 25;
 UNSIGNED2 ctr := 0;
END;
namesTable := DATASET([{'Flintstone','Fred',35},
 {'Flintstone','Wilma',43},
 {'Jetson','Georgie',10},
 {'Mr. T','Z-man'}], namesRec);
BodyFunc(DATASET(namesRec) ds, UNSIGNED4 c) :=
 PROJECT(ds,
 TRANSFORM(namesRec,
 SELF.age := LEFT.age*c;
 SELF.ctr := COUNTER ;
 SELF := LEFT));
/* Form 1 -- LOOP(ds, loopcount, loopbody)
 Processes loopcount times, basically a "for loop" construct.
 This example also demonstrates the two possible scopes of the COUNTER
 keyword within a LOOP:
 * The COUNTER in the LOOP function (passed to BodyFunc) is the number
 of iterations the LOOP has done.
 * The COUNTER in the TRANSFORM for the PROJECT in the BodyFunc counts
 the number of records processed by the current iteration of PROJECT.
*/
Form1 := LOOP(namesTable,
 2, //iterate 2 times
 ROWS(LEFT) & BodyFunc(ROWS(LEFT),COUNTER)); //16 rows
OUTPUT(Form1,NAMED('Form1_example'));
/* Form 2 -- LOOP(ds, loopfilter, loopbody)
 Continues processing while the loopfilter expression is TRUE for any
 records in ROWS(LEFT). This is basically a "while loop" construct. The
 loopfilter expression is evaluated on the entire set of ROWS(LEFT)
 records prior to each iteration.
 */
Form2 := LOOP(namesTable,
 LEFT.age < 100, //process only recs where TRUE
 PROJECT(ROWS(LEFT),
 TRANSFORM(namesRec,
 SELF.age := LEFT.age*2;
 SELF := LEFT)));
OUTPUT(Form2,NAMED('Form2_example'));
/* Form 3 -- LOOP(ds, loopcondition, loopbody)
 Continues processing while the loopcondition expression is TRUE.
 This is basically a "while loop" construct. The loopcondition expression
 is evaluated on the entire set of ROWS(LEFT) records prior to each
 iteration.
 */
Form3 := LOOP(namesTable,
 SUM(ROWS(LEFT), age) < 1000 * COUNTER,
 PROJECT(ROWS(LEFT),
 TRANSFORM(namesRec,
 SELF.age := LEFT.age*2;
 SELF := LEFT)));
OUTPUT(Form3,NAMED('Form3_example'));
/* Form 4 -- LOOP(ds, loopcount, loopfilter, loopbody)
 Processes loopcount times, with the loopfilter expression
 defining when each record continues to process through the loopbody
 expression. This is basically a "for loop" construct with a filter
 specifying which records are processed each iteration.
 */
Form4 := LOOP(namesTable,
 10,
 LEFT.age < 100, //process only recs where TRUE
 BodyFunc(ROWS(LEFT), COUNTER));
OUTPUT(Form4,NAMED('Form4_example'));
/* Form 5 -- LOOP(ds, loopcount, loopcondition, loopbody)
 Processes loopcount times, with the loopcondition expression
 defining the set of records that continue to process through the loopbody
© 2021 HPCC Systems®. All rights reserved. Except where otherwise noted, ECL
Language Reference content licensed under Creative Commons public license.
258
ECL Language Reference
Built-in Functions and Actions
 expression. This is basically a "for loop" construct with a filter
 specifying the record set processed for each iteration.
 This example also demonstrates the two possible scopes of the COUNTER
 keyword within a LOOP:
 * The COUNTER in the LOOP function's loopfilter expression is the number
 of recursive iterations the LOOP has done.
 * The COUNTER in the TRANSFORM for the PROJECT counts the number of records
 processed by the current iteration of PROJECT.
*/
Form5 := LOOP(namesTable,
 10, //iterate 10 times
 LEFT.age * COUNTER <= 200, //process only recs where TRUE
 PROJECT(ROWS(LEFT),
 TRANSFORM(namesRec,
 SELF.age := LEFT.age*2,
 SELF.ctr := COUNTER,
 SELF := LEFT)));
OUTPUT(Form5,NAMED('Form5_example'));
/* Form 6 -- LOOP(ds, loopfilter, loopcondition, loopbody)
 Continues processing while the loopcondition expression is TRUE.
 Records where the loopfilter expression is TRUE continue processing.
 This is basically a "while loop" construct with individual record
 processing continuation logic.
 */
Form6 := LOOP(namesTable,
 LEFT.age < 100,
 EXISTS(ROWS(LEFT)) and SUM(ROWS(LEFT), age) < 1000,
 BodyFunc(ROWS(LEFT), COUNTER));
OUTPUT(Form6,NAMED('Form6_example'));
/* Form 7 -- LOOP(ds, loopcount, loopfilter, loopcondition, loopbody)
 Continues processing while the loopcondition expression is TRUE.
 Records where the loopfilter expression is TRUE continue processing.
 This is basically a "while loop" construct with individual record
 processing continuation logic.
 */
Form7 := LOOP(namesTable,
 10,
 LEFT.age < 100,
 EXISTS(ROWS(LEFT)) and SUM(ROWS(LEFT), age) < 1000,
 BodyFunc(ROWS(LEFT), COUNTER));
OUTPUT(Form7,NAMED('Form7_example'));