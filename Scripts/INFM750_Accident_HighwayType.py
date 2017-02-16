import overpy
import pandas
import numpy
import time

try:

    api = overpy.Overpass()
    Crash_Data= pandas.DataFrame.from_csv('C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Crash Data\\crash_data1.csv', header=0, sep=',')
    Crash_Data['HighwayType'] = ''
    columns = ['HighwayType','Count']
    Crash_Data["CRASH_DATE"] = pandas.to_datetime(Crash_Data["CRASH_DATE"])
    Crash_Data = Crash_Data[(Crash_Data['CRASH_DATE'] > '2015-12-31') & (Crash_Data['CRASH_DATE'] < '2016-08-01')]



    #Crash_Data_5000 = Crash_Data.iloc[:100]
    #Crash_Data_5000 = Crash_Data.iloc[401:500]
    i=0
    while i<22000:

        for i in range(0,1000,25):
            for index, record in Crash_Data.iloc[(i+1):(i+100)].iterrows():
                if record['HighwayType'] != "":
                    break
                lat = record["Latitude"]
                lon = record["Longitude"]
                temp_df = pandas.DataFrame(columns=columns)
                result = api.query("""way["highway"~"."](around:"""+str(i)+""","""+str(lat)+""", """+str(lon)+"""); (._;>;); out body; """)

                for way in result.ways:
                    temp_df = temp_df.append(pandas.DataFrame([[way.tags.get("highway", "n/a"), 1]], columns=columns),ignore_index=True)

                temp_df = temp_df.groupby(["HighwayType"]).agg(
                {'Count': numpy.sum}).sort_values(by = "Count", ascending=False).reset_index()


                if len(temp_df)> 0:
                    Crash_Data.ix[index,"HighwayType"] = temp_df.ix[0,'HighwayType']

                # if len(temp_df)>1:
                #     if len(temp_df[temp_df['Count'] == temp_df.ix[0,'Count']]) > 1:
                #         print(temp_df)


        i=i+100
        print(i, "...")
        time.sleep(30)

except:
    Crash_Data.to_csv('C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\CrashData\\crash_data_highway1.csv', sep=',')



