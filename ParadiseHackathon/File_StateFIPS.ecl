EXPORT File_StateFIPS := MODULE
 EXPORT Layout := RECORD
    STRING2    STATE;
    UNSIGNED1  StateCode;
    STRING3    FIPS;
    STRING33   County;
    STRING2    Class;
END;

 EXPORT File := DATASET('~uga::main::statefips',Layout,CSV(Heading(1)));
END;
