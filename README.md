# Prediction Model of Potential Road Crashes Bases on the Spatial and Temporal Factors
A Study by Gaurav Shahane, Kushal Thakkar and Mohana Bansal of University of Maryland College Park

<h2>Introduction</h2>
According to the National Safety Council report, approximately 38,300 people were killed and about 4.4 million injured in the road accidents United States in 2015. There are a variety of reasons that contribute to accidents. Some of the reasons are adverse Weather and Traffic conditions that cause accident prone situations. Predicting likelihood of vehicular crashes due to the effect of Weather and Traffic features would be a major step towards achieving better road safety. 

This paper attempts to create models that account for spatial and temporal features to determine likely vehicular crash conditions. It is expected that the findings from this paper would help civic authorities to take proactive actions on likely crash prone weather and traffic conditions. These models can also be distributed in form of an APIs and can be added as an additional safety layer on existing navigational applications for safer commutes.

<h2>Research Question</h2>
<i>Predicting the occurrences of vehicular crashes on roadways of the State of Iowa based on spatial and temporal features of weather and traffic data.</i>

<h2>Data Collection and Aggregation</h2>
The data is extracted from diverse sources to accommodate factors like weather, road conditions and crash details. 

<b>i. State of Iowa - Crash Data Set (https://catalog.data.gov/dataset/crash-data)</b><br>
This data is from the State of Iowa Open data for the vehicular crashes from 2006 to 2016. It includes data for date, time, location, weather and the road details for the crashes. 

<b>ii. Iowa Environmental Mesonet (https://mesonet.agron.iastate.edu/request/rwis/fe.phtml?network=IA_RWIS)</b><br>
This data is from the State of Iowa- Road Weather Information System’s archives. It includes data for average wind speed, maximum wind speed, humidity, visibility, wind direction, precipitation rate, and etc.

<b>iii. Iowa Environmental Mesonet (https://mesonet.agron.iastate.edu/request/rwis/traffic.phtml)</b><br>
This data is based on the State of Iowa’s Historic Traffic Data and is extracted from Iowa Environmental Mesonet (IEM). It includes data for average speed, average headway, occupancy, and other traffic related features.

<h2> Machine Learning Models</h2>
Machine Learning techniques used are: Linear Regression, Zero Inflated Bionomial Regression, and Random Forest.
We found Random Forest method with down-sampling of majority class works the best.

<h2>Result</h2>

<img src="https://github.com/gaurav-shahane/INFM750-DataToInsights/raw/master/images/result_randomForest.PNG" alt ="Confusion Matrix for Random Forest"> <br><b>Fig. Confusion Matrix for Random Forest</b>

As seen from the above confusion matrix, the model was able to predict the crash occurrences with an accuracy of approximately 65%. It was also observed that over 20% of the records were incorrectly predicted as crash occurrences (False positives). This however, was acceptable as it makes the model only more stringent in predicting crashes more accurately.

<h2>Conclusion</h2>
Radom Forest model predicts vehicular crashes with approximately 65% accuracy using Weather and Traffic Data available with the State of Iowa. The accuracy of the models can also be increased by including the data for previous years previous to 2015. With increase in prediction accuracy, as a potential use case, the developed models can be used with the real time Road Weather Information System data to predict the vehicular crash occurrences in real time. This will help Highway Authorities in taking precautionary actions towards avoiding crashes, and also caution the drivers to be more careful, and thereby making roads safer for everyone.

<h2>References</h2>
- Abdel-Aty, M. A., Pemmanaboina, R. (2006). Calibrating a Real- Time Traffic Crash-Prediction Model Using Archived Weather and ITS Traffic Data, vol. 7(2)
- Bin Islam, M. and Kanitpong, K (2008). Identification of factors in road accidents through in-depth accident analysis. In IATSS Research Vol.32 No.2, 58-67
- C. Oh, J. Oh, and S. Ritchie, “Real-time estimation of freeway accident likelihood,” presented at the 80th Annu. Meet. Transportation Research Board, Washington, DC, USA, 2001.

<h2> Links </h2>
- <a href=""
