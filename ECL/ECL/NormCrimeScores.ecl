// IMPORT $;

CrimeRec := RECORD
 STRING2 State;
 DECIMAL5_4   ViolentCrimeRatio;
 DECIMAL5_4   HomicideRat;
 DECIMAL5_4   RapeRat;
 DECIMAL5_4   Agg_AssaultRat;       
 DECIMAL5_4   ViolentCompRat; //Average of Homicide and Rape
 DECIMAL5_4   RobberyRat;    
 DECIMAL5_4   Prop_CrimeRat; 
 DECIMAL5_4   BurglaryRat;   
 DECIMAL5_4   LarcenyRat;    
 DECIMAL5_4   Veh_TheftRat;  
 DECIMAL5_4   PropCompRat;    //Average of all Property Crimes  
 
END;

Crime_DS := DATASET('~UGA::Main::Hacks::CrimeRates',CrimeRec,FLAT);  //Created in BWR_Analyze Crime

//Build Scores (higher score, better rating)
RankTbl := RECORD
 Crime_DS.State;
 Crime_DS.violentcomprat;
 Crime_DS.propcomprat;
 UNSIGNED1 ViolentScore := 0;
 UNSIGNED1 PropCrimeScore := 0;
END;

TempTbl := TABLE(Crime_DS,RankTbl);

AddViolentScore := ITERATE(SORT(TempTbl,-violentcomprat),TRANSFORM(RankTbl,
                                                                   SELF.ViolentScore := IF(LEFT.violentcomprat=RIGHT.violentcomprat,LEFT.ViolentScore,LEFT.ViolentScore+1),
                                                                   SELF := RIGHT));

AddPropScore    := ITERATE(SORT(AddViolentScore,-propcomprat),TRANSFORM(RankTbl,SELF.PropCrimeScore := IF(LEFT.propcomprat=RIGHT.propcomprat,LEFT.PropCrimeScore,LEFT.PropCrimeScore+1),SELF := RIGHT));

MyOutRec := RECORD
    Crime_DS.State;
    Crime_DS.violentcomprat;
    Crime_DS.propcomprat;
    DECIMAL5_4 NormalizedCrime;
END;

MyOutRec CatThem(Crime_DS L ) := TRANSFORM
    SELF.NormalizedCrime := -1 * ((L.violentcomprat - AVE(Crime_DS, violentcomprat) )/ SQRT(VARIANCE(Crime_DS, violentcomprat) ) + (L.propcomprat - AVE(Crime_DS, propcomprat) )/ SQRT(VARIANCE(Crime_DS, propcomprat) )) / 2;
    SELF := L;
END;

Export NormCrimeScores := PROJECT(Crime_DS,
                   CatThem(LEFT));

// OUTPUT(NormCrimeScores);

// OUTPUT(AddPropScore,,'~UGA::Main::Hacks::CrimeScores',NAMED('TopCrime'),OVERWRITE);
