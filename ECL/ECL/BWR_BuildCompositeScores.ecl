IMPORT $;
WeatherDS  := $.File_Composite.WeatherScoreDS;
CrimeDS    := $.File_Composite.CrimeScoreDS;
EdDS       := $.File_Composite.EduScoreDS;
HealthDS   := $.File_Composite.MortScoreDS;
CombLayout := $.File_Composite.Layout;
StateCodes := $.File_StateFIPS;
NormEdu    := $.NormEduScores;
NormCrime  := $.NormCrimeScores;
NormWeather:= $.NormWeatherScores;
NormHealth := $.NormHealthScores;
NormRent := $.NormRentScores;
NormHeat   := $.NormHeatScores;







MergeWeather := PROJECT(WeatherDS,TRANSFORM(CombLayout,SELF.StateName := $.DCT.MapST2Name(LEFT.State),SELF := LEFT,SELF := []));
OUTPUT(MergeWeather,NAMED('AddStateToWeather'));

// ViolentCompRat;
// PropCompRat;
// ViolentScore;
// PropCrimeScore;
MergeCrime := JOIN(MergeWeather,CrimeDS,
                   LEFT.State = Right.State,
                   TRANSFORM(CombLayout,
                             SELF.ViolentCompRat := RIGHT.ViolentCompRat,
                             SELF.PropCompRat    := RIGHT.PropCompRat,
                             SELF.ViolentScore   := RIGHT.ViolentScore,
                             SELF.PropCrimeScore := RIGHT.PropCrimeScore,
                             SELF := LEFT),LOOKUP);
OUTPUT(MergeCrime,NAMED('CrimeandWeather'));

Merger := PROJECT(NormEdu,TRANSFORM(CombLayout,SELF.StateName := $.DCT.MapST2Name(LEFT.State),SELF := LEFT,SELF := []));
Merger2 := JOIN(Merger, NormEdu, Left.State = Right.State);
MergeNormHealth := JOIN(Merger2, NormHealth, Left.State= Right.State);
MergeNormWeather := JOIN(MergeNormHealth, NormWeather, Left.State = Right.State);
FinalMerge := JOIN(MergeNormWeather, NormCrime, Left.State = Right.State);
FinalMerge2 := JOIN(FinalMerge, NormRent, Left.StateName = Right.field3);
FinalMerge3 := JOIN(FinalMerge2, NormHeat, Left.StateName=  Right.field1);

MyOutRec := RECORD
    FinalMerge3.State;
    FinalMerge3.normalizededucation;
    FinalMerge3.normalizedhealth;
    FinalMerge3.normalizedcrime;
    FinalMerge3.normalizedweather;
    FinalMerge3.normalizedsunlight;
    FinalMerge3.normalizedheat;
    DECIMAL5_4 totalScore;
END;

MyOutRec CatThem(FinalMerge3 L ) := TRANSFORM
    SELF.totalScore := L.normalizedcrime + L.normalizededucation + l.normalizedhealth + L.normalizedweather + L.normalizedsunlight + L.normalizedheat;
    SELF := L;
END;

NormCrimeScores := PROJECT(FinalMerge3,
                   CatThem(LEFT));
NormScrimeScores := SORT(NormCrimeScores, totalScore);
OUTPUT(NormCrimeScores);

IMPORT Visualizer;

state := TABLE(NormCrimeScores, {state, totalscore});
// Visualizer.Choropleth.USStates('ScoresTotal', , 'state_Scores', , , DATASET([{'paletteID', 'Blues'}], Visualizer.KeyValueDef));IMPORT Visualizer;
 data_exams := OUTPUT(state, NAMED('MultiD__test'));
 data_exams;

 viz_bar := Visualizer.MultiD.Bar('bar',, 'MultiD__test');
 viz_bar;

// OUTPUT(FinalMerge2,,'FinalData2.csv',CSV(HEADING(SINGLE)));





// pubcnt;
// prvcnt;
// avestratio;
// StudentTeacherScore;
// PrvSchoolScore;
// PublicSchoolScore;
MergeEducation := JOIN(MergeCrime,EdDS,
                       LEFT.State = Right.State,
                       TRANSFORM(CombLayout,
                                 SELF.pubcnt              := RIGHT.pubcnt,
                                 SELF.prvcnt              := RIGHT.prvcnt,
                                 SELF.avestratio          := RIGHT.avestratio,
                                 SELF.StudentTeacherScore := RIGHT.StudentTeacherScore,
                                 SELF.PrvSchoolScore      := RIGHT.PrvSchoolScore,
                                 SELF.PublicSchoolScore   := RIGHT.PublicSchoolScore,
                                 SELF := LEFT),LOOKUP);
OUTPUT(MergeEducation,NAMED('CrimeWeatherEducation'));

// sumcum;
// maxcum;
// mincum;
// MortalityScore;
MergeAll := JOIN(MergeEducation,HealthDS,
                    LEFT.State = Right.State,
                    TRANSFORM(CombLayout,
                    SELF.sumcum := RIGHT.sumcum,
                    SELF.maxcum := RIGHT.maxcum,
                    SELF.mincum := RIGHT.mincum,
                    SELF.MortalityScore := RIGHT.MortalityScore,
                    SELF := LEFT),LOOKUP);
                    
CombLayout CompTotal(CombLayout Le) := TRANSFORM
 SELF.ParadiseScore := Le.StudentTeacherScore + Le.PrvSchoolScore + Le.PublicSchoolScore + Le.ViolentScore + Le.PropCrimeScore +
                       Le.MortalityScore + Le.EvtScore + Le.InjScore + Le.FatScore;
 SELF := Le;
END;                    

ParadiseSummary := PROJECT(MergeAll,CompTotal(LEFT));

OUTPUT(ParadiseSummary,,'~UGA::Main::Hacks::ParadiseScores',NAMED('Final_Output'),OVERWRITE);
 