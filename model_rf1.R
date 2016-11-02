#rf_model1
#raw feat, just to assess feat importance

setwd("/home/yoni/Documents/Data Science/Projects/AllState")

lapply(c("h2o","data.table"),require,character.only=T)

train<-fread("train.csv",showProgress=T,stringsAsFactors = T)
test<-fread("test.csv",showProgress=T,stringsAsFactors = T)

train<-train[,("id"):=NULL]
test<-test[,("id"):=NULL]
test$loss<-rep(NA,nrow(test))
n_train<-nrow(train)
data<-rbind(train,test)

rm(train,test)

fact_var<-names(lapply(train,is.factor)[lapply(train,is.factor)==T])
for(col in fact_var)data[,(col):=as.integer(train[[col]])]

local_h2o<-h2o.init(nthreads=-1)
h2o.init()
data_h2o<-as.h2o(data)

model<-h2o.randomForest(y="loss",training_frame = data_h2o[1:n_train,],ntrees=1000,
                        mtries=3,max_depth=4,seed=2008)
h2o.performance(model)

#MSE:  6444351
#RMSE:  2538.573
#MAE:  1673.29
#RMSLE:  0.7740115
#Mean Residual Deviance :  6444351
