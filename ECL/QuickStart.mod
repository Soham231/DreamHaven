//Import:ecl:ParadiseHackathon.BWR_BrowseInputData
IMPORT $;
OUTPUT($.File_PublicSchools.File,NAMED('PublicSchools'));
OUTPUT(COUNT($.File_PublicSchools.File),NAMED('Cnt_Public'));

OUTPUT($.File_PrivateSchools.File,NAMED('PrivateSchools'));
OUTPUT(COUNT($.File_PrivateSchools.File),NAMED('CntPrivate'));

OUTPUT($.File_Crimes.File,NAMED('Crimes'));
OUTPUT(COUNT($.File_Crimes.File),NAMED('Cnt_AllCrimes'));

OUTPUT($.File_Crimes.File2,NAMED('VCrimes'));
OUTPUT(COUNT($.File_Crimes.File2),NAMED('Cnt_VCrimes'));

OUTPUT($.File_Mortality.File,NAMED('Mortality'));
OUTPUT(COUNT($.File_Mortality.File),NAMED('Cnt_Mortality'));

OUTPUT($.File_Mortality.File2,NAMED('Mortality_ByState'));
OUTPUT(COUNT($.File_Mortality.File2),NAMED('Cnt_Mortality_By_State'));

OUTPUT($.File_Weather.File,NAMED('Storms'));
OUTPUT(COUNT($.File_Weather.File),NAMED('Cnt_Storms'));

OUTPUT($.File_StateFIPS.File,NAMED('FIPSLookup'));
OUTPUT(COUNT($.File_StateFIPS.File),NAMED('Cnt_FIPS'));




//Import:ecl:ParadiseHackathon.DCT
EXPORT DCT := MODULE
//1=Dangerous,2=Cold,3=Hot,4=Wet,5=Dry,6=Other
EXPORT Severity :=
  DATASET([
    {'Thunderstorm Wind',4}, 
    {'Hail',1}, 
    {'Flash Flood',4}, 
    {'High Wind',1}, 
    {'Winter Weather',2}, 
    {'Drought',5}, 
    {'Winter Storm',2}, 
    {'Flood',1},
    {'Marine Thunderstorm Wind',4}, 
    {'Heavy Snow',1}, 
    {'Heavy Rain',4}, 
    {'Heat',3}, 
    {'Tornado',1}, 
    {'Strong Wind',1}, 
    {'Excessive Heat',1}, 
    {'Extreme Cold/Wind Chill',1}, 
    {'Dense Fog',6}, 
    {'Frost/Freeze',2}, 
    {'Cold/Wind Chill',2}, 
    {'Blizzard',1}, 
    {'High Surf',4}, 
    {'Wildfire',1}, 
    {'Tropical Storm',1}, 
    {'Lightning',1}, 
    {'Funnel Cloud',1}, 
    {'Ice Storm',1}, 
    {'Coastal Flood',4}, 
    {'Waterspout',4}, 
    {'Debris Flow',1}, 
    {'Dust Storm',1}, 
    {'Rip Current',1}, 
    {'Marine Tropical Storm',1}, 
    {'Marine High Wind',1}, 
    {'Storm Surge/Tide',1}, 
    {'Lake-Effect Snow',2}, 
    {'Hurricane',1}, 
    {'Lakeshore Flood',1}, 
    {'Sleet',2}, 
    {'Astronomical Low Tide',6}, 
    {'Tropical Depression ',4}, 
    {'Marine Hail',1}, 
    {'Avalanche',1}, 
    {'Volcanic Ashfall',1}, 
    {'Dense Smoke',6},
    {'Marine Hurricane/Typhoon',1}, 
    {'Freezing Fog',1}, 
    {'Dust Devil',1}, 
    {'Marine Strong Wind',1}, 
    {'Marine Tropical Depression',1}, 
    {'Tsunami',1}, 
    {'Marine Dense Fog',1}, 
    {'Seiche',1}, 
    {'Sneakerwave',1}    
    ], {STRING18 EventType,UNSIGNED1 SevCode});
EXPORT States := 
   DATASET([
    {'AK','Alaska'}, 
    {'AL','Alabama'}, 
    {'AR','Arkansas'}, 
    {'AZ','Arizona'}, 
    {'CA','California'}, 
    {'CO','Colorado'}, 
    {'CT','Connecticut'}, 
    {'DC','District of Columbia'}, 
    {'DE','Delaware'}, 
    {'FL','Florida'}, 
    {'GA','Georgia'}, 
    {'HI','Hawaii'}, 
    {'IA','Iowa'}, 
    {'ID','Idaho'}, 
    {'IL','Illinois'}, 
    {'IN','Indiana'}, 
    {'KS','Kansas'}, 
    {'KY','Kentucky'}, 
    {'LA','Louisiana'}, 
    {'MA','Massachusetts'}, 
    {'MD','Maryland'}, 
    {'ME','Maine'}, 
    {'MI','Michigan'}, 
    {'MN','Minnesota'}, 
    {'MO','Missouri'}, 
    {'MS','Mississippi'}, 
    {'MT','Montana'}, 
    {'NC','North Carolina'}, 
    {'ND','North Dakota'}, 
    {'NE','New England'}, 
    {'NH','New Hampshire'}, 
    {'NJ','New Jersey'}, 
    {'NM','New Mexico'}, 
    {'NV','Nevada'}, 
    {'NY','New York'}, 
    {'OH','Ohio'}, 
    {'OK','Oklahoma'}, 
    {'OR','Oregon'}, 
    {'PA','Pennsylvania'}, 
    {'RI','Rhode Island'}, 
    {'SC','South Carolina'}, 
    {'SD','South Dakota'}, 
    {'TN','Tennessee'}, 
    {'TX','Texas'}, 
    {'UT','Utah'}, 
    {'VA','Virginia'}, 
    {'VT','Vermont'}, 
    {'WA','Washington'}, 
    {'WI','Wisconsin'}, 
    {'WV','West Virginia'}, 
    {'WY','Wyoming'}], {string2 state,string20 name});    
 EXPORT SevDCT  := DICTIONARY(Severity,{EventType => SevCode});   
 EXPORT MapCodeToType(STRING EventType) := SevDCT[EventType].SevCode;
 EXPORT StDCT   := DICTIONARY(States,{state => name});
 EXPORT MapST2Name(STRING state) := StDCT[state].name;
END;
//Import:ecl:ParadiseHackathon.File_AllSchools
EXPORT File_AllSchools := MODULE
//Best layout from BWR_BuildSchools
EXPORT Layout := RECORD
    UNSIGNED8 RecID;
    BOOLEAN   Public;
    REAL8     x;
    REAL8     y;
    STRING6   fid;
    UNSIGNED4 districtid;
    UNSIGNED3 objectid;
    STRING12  ncesid;
    STRING60  name;
    STRING56  address;
    STRING26  city;
    STRING2   state;
    STRING5   zip;
    STRING13  zip4;
    STRING14  telephone;
    UNSIGNED1 type;
    UNSIGNED1 status;
    INTEGER3  population;
    STRING21  county;
    STRING5   countyfips;
    STRING3   country;
    REAL8     latitude;
    REAL8     longitude;
    UNSIGNED3 naics_code;
    STRING32  naics_desc;
    STRING79  source;
    STRING19  sourcedate;
    STRING13  val_method;
    STRING19  val_date;
    STRING80  website;
    STRING15  level;
    INTEGER3  enrollment;
    STRING2   start_grad;
    STRING2   end_grade;
    INTEGER2  ft_teacher;
    STRING13  shelter_id;
END;

EXPORT File := DATASET('~UGA::Main::OUT::AllUSSchools',Layout,THOR);

END;
//Import:ecl:ParadiseHackathon.File_Crimes
EXPORT File_Crimes := MODULE
/* This dataset contains estimated data at the state and national level and was derived from the Summary Reporting System (SRS). 
   These data reflect the estimates the FBI has traditionally included in its annual publications. 
   Download this dataset to see the FBI's estimated crime totals for the nation and all 50 states, 1979 to current year available.
   Source: https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/downloads#nibrs-downloads
*/
 EXPORT Layout := RECORD
  UNSIGNED2 year;
  STRING2   state_abbr;
  STRING20  state_name;
  UNSIGNED5 population;
  UNSIGNED4 violent_crime;
  UNSIGNED3 homicide;
  UNSIGNED3 rape_legacy;
  UNSIGNED3 rape_revised;
  UNSIGNED3 robbery;
  UNSIGNED4 aggravated_assault;
  UNSIGNED4 property_crime;
  UNSIGNED4 burglary;
  UNSIGNED4 larceny;
  UNSIGNED4 motor_vehicle_theft;
  STRING577 caveats;
 END;

EXPORT File := DATASET('~uga::main::estimated_crimes_1979_2020',Layout,CSV(HEADING(1)));


/* This optional data set contains statistics, in arrests per 100,000 residents for assault, murder, and rape in each of the 50 US states in 1973. Also given is the percent of the population living in urban areas.
   A data frame with 50 observations on 4 variables.
   
   Murder is numeric and Murder arrests (per 100,000)
   Assault is numeric and Assault arrests (per 100,000)
   UrbanPop is numeric and UrbanPop arrests (per 100,000)
   Rape is numeric and Rape arrests (per 100,000)

Source: World Almanac and Book of facts 1975. (Crime rates).
Statistical Abstracts of the United States 1975. (Urban rates).

https://www.kaggle.com/datasets/mathchi/violent-crime-rates-by-us-state
*/
 EXPORT Layout2 := RECORD
    STRING State;
    STRING Murder;
    STRING Assault;
    STRING UrbanPop;
    STRING Rape;
 END;
 EXPORT File2 := DATASET('~uga::main::us_violent_crime_summary_by_state',layout2,CSV(HEADING(1)));

END;
//Import:ecl:ParadiseHackathon.File_Mortality
/* IHME United States Mortality Rates by County 1980-2014: National - All. (Deaths per 100,000 population)
   https://www.kaggle.com/datasets/IHME/us-countylevel-mortality
   License: 
   This Dataset was provided by IHME
   Institute for Health Metrics and Evaluation
   Data made available for download on IHME Websites can be used, shared, modified or built upon by non-commercial users in accordance with the IHME FREE-OF-CHARGE
*/

EXPORT File_Mortality := MODULE
EXPORT Layout := RECORD
    STRING42 Location;
    STRING5 FIPS;
    STRING65 Category;
    REAL4 Mortality_Rate__1980_;
    REAL4 Mortality_Rate__1980___Min_;
    REAL4 Mortality_Rate__1980___Max_;
    REAL4 Mortality_Rate__1985_;
    REAL4 Mortality_Rate__1985___Min_;
    REAL4 Mortality_Rate__1985___Max_;
    REAL4 Mortality_Rate__1990_;
    REAL4 Mortality_Rate__1990___Min_;
    REAL4 Mortality_Rate__1990___Max_;
    REAL4 Mortality_Rate__1995_;
    REAL4 Mortality_Rate__1995___Min_;
    REAL4 Mortality_Rate__1995___Max_;
    REAL4 Mortality_Rate__2000_;
    REAL4 Mortality_Rate__2000___Min_;
    REAL4 Mortality_Rate__2000___Max_;
    REAL4 Mortality_Rate__2005_;
    REAL4 Mortality_Rate__2005___Min_;
    REAL4 Mortality_Rate__2005___Max_;
    REAL4 Mortality_Rate__2010_;
    REAL4 Mortality_Rate__2010___Min_;
    REAL4 Mortality_Rate__2010___Max_;
    REAL4 Mortality_Rate__2014_;
    REAL4 Mortality_Rate__2014___Min_;
    REAL4 Mortality_Rate__2014___Max_;
    REAL4 Change_in_Mortality_Rate__1980_2014;
    REAL4 Change_in_Mortality_Rate__1980_2014__Min_;
    REAL4 Change_in_Mortality_Rate__1980_2014__Max_;
END;

EXPORT File := DATASET('~uga::main::mortalitybyuscounty',layout,CSV(HEADING(1)));

// From: https://ghdx.healthdata.org/record/ihme-data/united-states-life-expectancy-by-state-white-black-hispanic-race-ethnicity-1990-2019
// Mortality By State
/* Estimates were produced for mortality rates, life expectancy, and population at the state level in the United States, 
   and by racial/ethnic group, for each year between 1990-2019. 
   These estimates were produced using population and deaths data from the National Center for Health Statistics.
*/

EXPORT Layout2 := RECORD  //Best Record generated
    UNSIGNED1 measure_id;
    STRING24 measure_name;
    UNSIGNED3 location_id;
    STRING47 location_name;
    STRING20 state_name;
    STRING25 race_ethnicity_group;
    UNSIGNED1 sex_id;
    STRING6 sex_name;
    UNSIGNED2 age_group_id;
    STRING8 age_group_name;
    UNSIGNED2 year_id;
    UNSIGNED1 metric_id;
    STRING6 metric_name;
    STRING11 val;
    STRING11 upper;
    STRING11 lower;
END;

EXPORT File2 := DATASET('~uga::main::mortalitybyusstate2000to2019',Layout2,CSV(HEADING(1)));

END;
//Import:ecl:ParadiseHackathon.File_PrivateSchools
/* This dataset, taken from the US Department of Homeland Security, 
   contains information on all public and private schools with attributes regarding their geographical distribution.
   License: Public Domain
*/
EXPORT File_PrivateSchools := MODULE
EXPORT Layout := RECORD
    STRING X;
    STRING Y;
    STRING FID; //Unique to Private 
    STRING OBJECTID;
    STRING NCESID;
    STRING NAME;
    STRING ADDRESS;
    STRING CITY;
    STRING STATE;
    STRING ZIP;
    STRING ZIP4;
    STRING TELEPHONE;
    STRING TYPE;
    STRING STATUS;
    STRING POPULATION;
    STRING COUNTY;
    STRING COUNTYFIPS;
    STRING COUNTRY;
    STRING LATITUDE;
    STRING LONGITUDE;
    STRING NAICS_CODE;
    STRING NAICS_DESC;
    STRING SOURCE;
    STRING SOURCEDATE;
    STRING VAL_METHOD;
    STRING VAL_DATE;
    STRING WEBSITE;
    STRING LEVEL_;
    STRING ENROLLMENT;
    STRING START_GRAD;
    STRING END_GRADE;
    STRING FT_TEACHER;
    STRING SHELTER_ID;
END;

// EXPORT File := DATASET('~uga::main::private_schoolsUS',layout,CSV(HEADING(1)));
EXPORT File := DATASET('~uga::main::private_schoolsUSUpd',layout,CSV(HEADING(1)));

END;
//Import:ecl:ParadiseHackathon.File_PublicSchools
/* This dataset was downloaded from: https://hifld-geoplatform.opendata.arcgis.com/datasets/87376bdb0cb3490cbda39935626f6604_0
   This dataset is provided by the Homeland Infrastructure Foundation-Level Data (HIFLD) without a license and for Public Use.
   
   HIFLD Open GP - Education
   Shared By: jrayer_geoplatform
   Data Source: services1.arcgis.com
   Users are advised to read the data set's metadata thoroughly to understand appropriate use and data limitations.
*/
EXPORT File_PublicSchools := MODULE
EXPORT Layout := RECORD
    STRING X;
    STRING Y;
    STRING OBJECTID;
    STRING NCESID;
    STRING NAME;
    STRING ADDRESS;
    STRING CITY;
    STRING STATE;
    STRING ZIP;
    STRING ZIP4;
    STRING TELEPHONE;
    STRING TYPE;
    STRING STATUS;
    STRING POPULATION;
    STRING COUNTY;
    STRING COUNTYFIPS;
    STRING COUNTRY;
    STRING LATITUDE;
    STRING LONGITUDE;
    STRING NAICS_CODE;
    STRING NAICS_DESC;
    STRING SOURCE;
    STRING SOURCEDATE;
    STRING VAL_METHOD;
    STRING VAL_DATE;
    STRING WEBSITE;
    STRING LEVEL_;
    STRING ENROLLMENT;
    STRING START_GRAD;
    STRING END_GRADE;
    STRING DISTRICTID; //Unique to Public
    STRING FT_TEACHER;
    STRING SHELTER_ID;
END;

// EXPORT File  := DATASET('~uga::main::public_schoolsUS',layout,CSV(HEADING(1)));
EXPORT File  := DATASET('~uga::main::public_schoolsUSUpd',layout,CSV(HEADING(1)));


END;
//Import:ecl:ParadiseHackathon.File_StateFIPS
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

//Import:ecl:ParadiseHackathon.File_Weather
/* The Storm Events Database contains the records used to create the official NOAA Storm Data publication, documenting:
   
   The occurrence of storms and other significant weather phenomena having sufficient intensity to cause loss of life, injuries, significant property damage, and/or disruption to commerce;
   Rare, unusual, weather phenomena that generate media attention, such as snow flurries in South Florida or the San Diego coastal area; and
   Other significant meteorological events, such as record maximum or minimum temperatures or precipitation that occur in connection with another event.
   
   The database currently contains data from January 1950 to October 2022, as entered by NOAA's National Weather Service (NWS).
   https://www.ncdc.noaa.gov/stormevents/
*/


EXPORT File_Weather := MODULE
EXPORT Layout := RECORD //RECORD Optimized using BestRecord function (See BWR_AnalyzeWeather)
    UNSIGNED3 begin_yearmonth;
    UNSIGNED3 begin_day;
    UNSIGNED3 begin_time;
    UNSIGNED3 end_yearmonth;
    REAL4     end_day;
    STRING4   end_time;
    STRING45  episode_id;
    REAL8     event_id;
    STRING20  state;
    INTEGER4  state_fips;
    UNSIGNED4 year;
    STRING9   month_name;
    STRING    event_type;
    STRING1   cz_type;
    UNSIGNED2 cz_fips;
    STRING109 cz_name;
    STRING3   wfo;
    STRING18  begin_date_time;
    STRING6   cz_timezone;
    STRING18  end_date_time;
    UNSIGNED2 injuries_direct;
    UNSIGNED2 injuries_indirect;
    UNSIGNED1 deaths_direct;
    UNSIGNED1 deaths_indirect;
    STRING8   damage_property;
    STRING8   damage_crops;
    STRING25  source;
    REAL4     magnitude;
    STRING2   magnitude_type;
    STRING28  flood_cause;
    UNSIGNED1 category;
    STRING3   tor_f_scale;
    REAL4     tor_length;
    REAL4     tor_width;
    STRING3   tor_other_wfo;
    STRING2   tor_other_cz_state;
    STRING3   tor_other_cz_fips;
    STRING20  tor_other_cz_name;
    UNSIGNED2 begin_range;
    STRING3   begin_azimuth;
    STRING45  begin_location;
    UNSIGNED2 end_range;
    STRING3   end_azimuth;
    STRING45  end_location;
    REAL8     begin_lat;
    REAL8     begin_lon;
    REAL8     end_lat;
    REAL8     end_lon;
    STRING15323 episode_narrative;
    STRING8942  event_narrative;
    STRING3   data_source;
END;

EXPORT File := DATASET('~UGA::noaa::SF::StormEvents',layout,CSV(HEADING(1)));
END;
