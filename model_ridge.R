#model_ridge
#on very raw feat

setwd("/yoni/home/Documents/Data Science/Projects/AllState")

lapply(c("h2o","data.table"),require, character.only=T)

train<-fread("train.csv",showProgress=T,stringsAsFactors = T)
test<-fread("test.csv",showProgress = T,stringsAsFactors = T)

train<-train[,("id"):=NULL]
test<-test[,("id"):=NULL]
test$loss<-rep(NA,nrow(test))
n_train<-nrow(train)

data<-rbind(train,test)

fact_var<-names(lapply(train,is.factor)[lapply(train,is.factor)==T])
for(col in fact_var)data[,(col):=as.integer(data[[col]])]

rm(train,test)

local_h2o<-h2o.init(nthreads=-1)
h2o.init()
data_h2o<-as.h2o(data)

model<-h2o.glm(y="loss",training_frame=data_h2o[1:n_train,],
               family="gaussian",lambda_search=T,
               nlambda = 30,alpha=c(0,0.25,0.5,0.75,1))

summary(model)

#MSE:  4390996
#RMSE:  2095.47
#MAE:  1323.405
#RMSLE:  NaN
#Mean Residual Deviance :  4390996
#R^2 :  0.4793494
#Null Deviance :1.588212e+12
#Null D.o.F. :188317
#Residual Deviance :826903589747
#Residual D.o.F. :188187
#AIC :3415024

