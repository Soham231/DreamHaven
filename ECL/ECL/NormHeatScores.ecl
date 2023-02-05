Heat    := $.File_heat.File;
MyOutRec := RECORD
    Heat.field1;
    HEat.field2;
    Heat.field3;
    REAL NormalizedSunlight;
    REAL NormalizedHeat;
END;



MyOutRec CatThem( Heat L ) := TRANSFORM
    SELF.NormalizedSunlight := ((REAL)L.field2 - AVE(Heat, (REAL)field2) )/ SQRT(VARIANCE(Heat, (REAL)field2) );
    SELF.NormalizedHeat := ((REAL)L.field3 - AVE(Heat, (REAL)field3) )/ SQRT(VARIANCE(Heat, (REAL)field3) );
    SELF := L;
END;

EXPORT NormHeatScores := PROJECT(Heat,
                   CatThem(LEFT));

// Output(NormHeatScores);
// OUTPUT(NormHeatScores,,'HeatData2.csv',CSV(HEADING(SINGLE)));









