index = 6200

for repeat in range(1,20):

    import overpy
    import pandas
    import numpy
    import time
    import math

    from scipy.stats._continuous_distns import wald_gen

    time.sleep(20)

    api = overpy.Overpass()
    Crash_Data = pandas.read_csv('C:/Users/gaura/Documents/MIM - UMCP/3rd Sem/INFM750/Project Data/highwayData/Crash_Data_HighwayType.csv', header=0, sep=',', dtype='unicode', error_bad_lines=False)
    #Crash_Data['HighwayType'] = ''
    columns = ['HighwayType','Count']
    #print(pandas.to_datetime(Crash_Data["CRASH_DATE"]))
    #Crash_Data["CRASH_DATE"] = pandas.to_datetime(Crash_Data["CRASH_DATE"])
    #print("a")
    #Crash_Data = Crash_Data[(Crash_Data['CRASH_DATE'] > '2015-12-31') & (Crash_Data['CRASH_DATE'] < '2016-08-01')]
    #Crash_Data.to_csv('D:\Classes\INFM750\DataCollection\Crash_Data_2016.csv', sep=',')


    #Crash_Data_5000 = Crash_Data.iloc[:100]
    #Crash_Data_5000 = Crash_Data.iloc[401:500]
    #j=0
    #while j<22550:



    try:

        for index, record in Crash_Data.iloc[(index):(22558)].iterrows():

            if (index % 100) == 0:
                print("Index: " + str(index) + "...")
                time.sleep(20)

            if not pandas.isnull(record['HighwayType']):
                #print(record["HighwayType"])
                continue
            for i in range(25, 1000, 25):
                #print("a")
                lat = record["Latitude"]
                lon = record["Longitude"]
                temp_df = pandas.DataFrame(columns=columns)
                result = api.query("""way["highway"~"."](around:"""+str(i)+""","""+str(lat)+""", """+str(lon)+"""); out body; """)
                for way in result.ways:
                    temp_df = temp_df.append(pandas.DataFrame([[way.tags.get("highway", "n/a"), 1]], columns=columns),ignore_index=True)
                temp_df = temp_df.groupby(["HighwayType"]).agg(
                {'Count': numpy.sum}).sort_values(by = "Count", ascending=False).reset_index()


                if len(temp_df)> 0:
                    Crash_Data.ix[index,"HighwayType"] = temp_df.ix[0,'HighwayType']
                    if len(temp_df)> 1:
                        if temp_df.ix[0, 'Count'] == temp_df.ix[1, 'Count']:
                            Crash_Data.ix[index, "EqualCount"] = 1
                            #print("EqualCount"+temp_df.ix[0,'HighwayType'])
                    break

                # if len(temp_df)>1:
                #     if len(temp_df[temp_df['Count'] == temp_df.ix[0,'Count']]) > 1:
                #         print(temp_df)




        Crash_Data.to_csv('C:/Users/gaura/Documents/MIM - UMCP/3rd Sem/INFM750/Project Data/highwayData/Crash_Data_HighwayType.csv', sep=',',index=False)

    except:
        print("ExceptionHadOccured")
        Crash_Data.to_csv('C:/Users/gaura/Documents/MIM - UMCP/3rd Sem/INFM750/Project Data/highwayData/Crash_Data_HighwayType.csv', sep=',',index=False)

    repeat = repeat + 1

