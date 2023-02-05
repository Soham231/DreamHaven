IMPORT KMeans; IMPORT ML_Core;

Raw_data := $.File_knn.File;

ML_Core.AppendSeqId(raw_data, id, Raw_with_id);

ML_Core.ToField(Raw_with_id, ML_data);

OutPUT(RAw_data);

Centroids := ML_data(id IN [1, 2,3,4,5,6,7,8,9,10]);

Max_iterations := 200; Tolerance := 0.03;

Pre_Model := KMeans.KMeans(Max_iterations, Tolerance); 

Model := Pre_Model.Fit( ML_Data(number < 10), Centroids(number < 10));

Labels := KMeans.KMeans().Labels(Model);

Output(Labels);


// OUTPUT(Labels,,'Labs.csv',CSV(HEADING(SINGLE)));