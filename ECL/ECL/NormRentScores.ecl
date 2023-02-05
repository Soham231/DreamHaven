// IMPORT $,STD;
HousePrices    := $.File_HousePrices.File;



MyOutRec := RECORD
    HousePrices.field3;
    HousePrices.field281;
    REAL NormalizedRent;
END;

MyOutRec CatThem(HousePrices L ) := TRANSFORM
    SELF.NormalizedRent := ((REAL)L.field281 - AVE(HousePrices, (REAL)field281) )/ SQRT(VARIANCE(HousePrices, (REAL)field281) );
    SELF := L;
END;

EXPORT NormRentScores := PROJECT(HousePrices,
                   CatThem(LEFT));












