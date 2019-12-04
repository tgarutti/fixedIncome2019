import pandas as pd
import numpy as np

# read in data
df = pd.read_csv('FinalDataMonthly.csv')

# remove date column and maturities >10yr
df = df[df.columns[1:13]] 
df.columns = ['3', '6', '12', '24', '36', '48', '60', '72', '84', '96', '108', '120 (level)']
# add slope and curvature (according to Diebold and Li, 2006)
df['Slope'] = df['120 (level)'] - df['3']
df['Curvature'] = 2*df['24'] - (df['3'] + df['120 (level)'])

# Autocorrelation
def autocorr(x, t=1):
    return np.corrcoef(np.array([x[:-t], x[t:]]))

# Calculate autocorrelations
autocorrel = []
for term in df.columns: # Loop through all terms
    autocorrelTerm = []
    for t in [1, 12, 30]:
        autocorrelTerm.append(autocorr(df[term], t)[0,1])
    autocorrel.append(autocorrelTerm)
    
# create dataframe with summary statistics
summaryDf = pd.DataFrame(autocorrel, columns=['AC 1m', 'AC 12m', 'AC 30m'], index=[df.columns])
summaryDf['Mean'] = df.mean().to_list()
summaryDf['Std. dev.'] = df.std().to_list()
summaryDf['Minimum'] = df.min().to_list()
summaryDf['Maximum'] = df.max().to_list()
summaryDf = summaryDf[['Mean', 'Std. dev.', 'Minimum', 'Maximum', 'AC 1m', 'AC 12m', 'AC 30m']].round(3)
summaryDf.to_csv('SummaryStatisticsYieldCurve.csv')
print(summaryDf)

# create dataframe with cross-correlations
corrDf = df[['3', '6', '12', '24', '36', '48', '60', '72', '84', '96', '108', '120 (level)']].corr().round(3)
corrDf.to_csv('CorrelationYieldCurve.csv')
print(corrDf)
