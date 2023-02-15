
import numpy as fn
from sklearn.model_selection import train_test_split
from sklearn import datasets
from sklearn import svm
from sklearn import linear_model
from sklearn.feature_selection import f_regression
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import SelectFpr
from sklearn.model_selection import cross_val_predict
from sklearn.model_selection import cross_val_score
import numpy as np
import matplotlib.pyplot as plt

inputfile= 'd.txt'
brain=fn.loadtxt(inputfile)
inputfile= 'sans.txt'
sch=fn.loadtxt(inputfile)

reg = linear_model.LinearRegression()
F,pval=f_regression(brain,sch)
print(min(pval))
fn.savetxt('result2/sans_d_feature.dat', F)
coe1=[];
#for num in range(1,len(F),1):
xnew=SelectKBest(f_regression, k=44).fit_transform(brain, sch)
scores = cross_val_predict(reg, xnew, sch, cv=50)
cor=np.corrcoef(sch,scores)
coe1.append(cor[0,1])
print('age',max(coe1),coe1.index(max(coe1)))
fn.savetxt('result2/sans_d_predict.dat', scores)
###=====================weight
from sklearn.model_selection import LeaveOneOut
loo = LeaveOneOut()
coe2=[];
for train_index, test_index in loo.split(xnew):
     #print("TRAIN:", train_index, "TEST:", test_index)
     X_train, Y_train = xnew[train_index], sch[train_index]
     reg.fit(X_train, Y_train)
     coe2.append(reg.coef_)
fn.savetxt('result2/sans_d_coeff.dat', coe2)

fig, ax = plt.subplots()
ax.scatter(sch, scores, edgecolors=(0, 0, 0))
ax.set_xlabel('Measured')
ax.set_ylabel('Predicted')
plt.show()
