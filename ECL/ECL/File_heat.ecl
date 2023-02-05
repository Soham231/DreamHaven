
EXPORT File_heat := MODULE
EXPORT Layout := RECORD
    STRING field1;
    STRING field2;
    STRING field3;
END;

// EXPORT File  := DATASET('~uga::main::public_schoolsUS',layout,CSV(HEADING(1)));
EXPORT File  := DATASET('~weather::weather',layout,CSV(HEADING(1)));


END;