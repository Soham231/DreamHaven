IMPORT $,STD;
HousePrices := $.File_HousePrices.File;

Layout := RECORD
  name := HousePrices.RegionName;
  lastYearprice := HousePrices._019_12;
END;
AveHouseTBL := TABLE(HousePrices(field1 <> ''),Layout,field1);

OUTPUT(AveHouseTBL);









