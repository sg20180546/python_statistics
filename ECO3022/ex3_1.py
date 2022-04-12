from tkinter import *
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns 
sns.set()
import scipy.optimize as opt


import pandas_datareader.data as web
# pd_Dataframe=pd.read_excel("./data1.xls")
data=pd.DataFrame()
for code in ['005930','036570','000660','035720','035420']:
    data=pd.concat([data,web.DataReader(code,'naver',start='2019-01-01',end='2020-01-01')['Close'].apply(int)], axis=1)

# 삼성전자, 엔씨소프트, SK하이닉스, 카카오, 네이버
data.columns=['se','nc','skh','kk','nvr']

noa=len(data.columns)

weights=np.array([0.6])
other=np.random.random(noa-1)
other=(other/other.sum())*0.4
weights=np.concatenate((weights,other),axis=0)

ret=data.pct_change().dropna()

port_rets=[]
port_std=[]
def statistics(weights,rf=0):
    weights=np.array(weights)
    pret=np.sum(ret.mean()*weights)*252-rf
    pvol=np.sqrt(np.dot(weights.T,np.dot(ret.cov()*252,weights)))
    return np.array([pret,pvol,pret/pvol])

def min_func_port(weights):
    return statistics(weights)[1]


def ret_std(weight, ret):
    port_mean=np.sum(weight*ret.mean()*250)
    port_var=np.dot(weight.T,np.dot(ret.cov()*250,weight))
    port_std=np.sqrt(port_var)
    return port_mean,port_std

for w in range(5000):

    # weight=np.array([0.6])
    weight=np.random.random(noa-1)
    weight/=np.sum(weight)
    weight*=0.4
    weight=np.array([0.6]+list(weight))
    # other=( other/other.sum() )*0.4
    # weight=np.concatenate((weight,other),axis=0)
    # weight/=np.sum(weight)
    mu,sig=ret_std(weight,ret)

    port_rets.append(mu)
    port_std.append(sig)

sr=np.array(port_rets)/np.array(port_std)

bnds=tuple([(0.6,0.6+1e-100)]+[(0,1) for x in range(noa-1)])
trets=np.linspace(0.33,0.44,30)
tvols=[]
for tret in trets:
    cons = ({'type':'eq','fun':lambda x : statistics(x)[0]-tret},
            {'type':'eq','fun':lambda x : np.sum(x)-1})
    res=opt.minimize(min_func_port,noa*[1./noa,],method='SLSQP',
        bounds=bnds,constraints=cons)
    tvols.append(res['fun'])
tvols=np.array(tvols)

plt.style.use('seaborn')
plt.figure(figsize=(12,8))
plt.plot(tvols,trets)
plt.scatter(port_std,port_rets,c=sr,marker='.')
plt.colorbar(label='Sharpe Ratio')
plt.xlabel('expected returns$(μ)$')
plt.ylabel('expected std $(σ)$')
plt.grid(True)



plt.show()

