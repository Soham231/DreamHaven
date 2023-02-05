IMPORT Visualizer;
HealthDS   := $.File_Composite.MortScoreDS;


state := TABLE(HealthDS, {state, Mortalityscore}, FEW);
OUTPUT(state, NAMED('state_mort'));
Visualizer.Choropleth.USStates('Demo123', , 'state_mort', , , DATASET([{'paletteID', 'Blues'}], Visualizer.KeyValueDef));IMPORT Visualizer;
