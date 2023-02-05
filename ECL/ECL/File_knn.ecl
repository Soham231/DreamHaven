EXPORT File_knn := MODULE
EXPORT Layout := RECORD
    STRING field1;
    DECIMAL5_4 field2;
    DECIMAL5_4  field3;
    DECIMAL5_4  field4;
    DECIMAL5_4 field5;
    DECIMAL5_4 field6;
    DECIMAL5_4 field7;
    DECIMAL5_4 field8;
    DECIMAL5_4 field9;
END;

// EXPORT File  := DATASET('~uga::main::public_schoolsUS',layout,CSV(HEADING(1)));
EXPORT File  := DATASET('~knn2_data::knn2_data',layout,CSV(HEADING(1)));


END;