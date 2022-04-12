from tkinter import *
import scipy.optimize as opt
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns; sns.set();
import pandas_datareader.data as web

data=pd.DataFrame()
for code in ['005930','036570','000660','035720','035420']:
    data=pd.concat([data,web.DataReader(code,'naver',start='2019-01-01',end='2020-01-01')['Close'].apply(int)], axis=1)



# 삼성전자, 엔씨소프트, SK하이닉스, 카카오, 네이버
data.columns=['se','nc','skh','kk','nvr']

ret=data.pct_change().dropna()
ret=ret.reset_index(drop=True)
noa=len(ret.columns)
weights=np.array([0.6])
other=np.random.random(noa-1)
other=(other/other.sum())*0.4
weights=np.concatenate((weights,other),axis=0)




port_rets=[]
port_std=[]
weights=np.random.random(noa)
weights/=sum(weights)
def statistics(weights,rf=0):
    weights=np.array(weights)
    pret=np.sum(ret.mean()*weights)*252-rf
    pvol=np.sqrt(np.dot(weights.T,np.dot(ret.cov()*252,weights)))
    return np.array([pret,pvol,pret/pvol])

def min_func_port(weights):
    return statistics(weights)[1]

def min_func_sharpe(weights,rf=0.02):
    return -statistics(weights,rf)[2]

def min_func_volatility(weights):
    return statistics(weights)[1]**2


def ret_std(weight, ret):
    port_mean=np.sum(weight*ret.mean()*252)
    port_var=np.dot(weight.T,np.dot(ret.cov()*252,weight))
    port_std=np.sqrt(port_var)
    return port_mean,port_std

for w in range(2500):
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


trets=np.linspace(0.33,0.44,30)
tvols=[]

bnds=tuple([(0.6,0.6+1e-100)]+[(0,1) for x in range(noa-1)])

for tret in trets:
    cons=({'type':'eq','fun':lambda x:statistics(x)[0]-tret},
        {'type':'eq','fun':lambda x : np.sum(x)-1})
    res=opt.minimize(min_func_port,noa*[1./noa,],method='SLSQP',
        bounds=bnds,constraints=cons)
    tvols.append(res['fun'])
tvols=np.array(tvols)

cons=({'type':'eq','fun':lambda x : np.sum(x)-1})
opts=opt.minimize(min_func_sharpe,noa*[1./noa,],method='SLSQP',bounds=bnds,constraints=cons)

# optv=opt.minimize(min_func_volatility,noa*[1./noa],method='SLSQP',bounds=bnds,constraints=cons)

rf=0.02
slope=( (statistics(opts['x'])[0]-rf)/statistics(opts['x'])[1] )
var_list=[x*slope+rf for x in np.linspace(0.16,0.30,2500)]

x=np.linspace(0.16,0.30,2500)
y=var_list

plt.style.use('seaborn')
plt.figure(figsize=(12,8))
plt.scatter(port_std,port_rets,c=sr,marker='.',cmap='RdGy')
plt.plot(statistics(opts['x'])[1],statistics(opts['x'])[0],'r*',markersize=15.0,label='Portfolio with highest Sharpe Ratio')
# plt.plot(statistics(optv['x'])[1],statistics(optv['x'])[0],'y*',markersize=15.0,label='Minimum Variance portfolio')
plt.plot(x,y,label='mean-variance frontier with riskfree asset')
plt.plot(tvols,trets)
plt.legend()
plt.grid(True)
plt.colorbar(label='Sharpe Ratio')
plt.xlabel('variance')
plt.ylabel('expected return')




plt.show()

