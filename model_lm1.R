#First model: LR
#No one hot encoding
#Categ var --> integers

setwd("/home/yoni/Documents/Data_Science/Projects/AllState")

cat(paste0(lapply(c("data.table","xgboost","randomForest","party","h2o"),
                  require,character.only=T)))

train<-fread("train.csv",showProgress=T,stringsAsFactors = T)
test<-fread("test.csv",showProgress=T,stringsAsFactors = T)

train<-train[,c("id"):=NULL]
test<-test[,c("id"):=NULL]
test$loss<-rep(NA,nrow(test))
n_train<-nrow(train)

#Categ var to integers
fact_var<-names(lapply(train,is.factor)[lapply(train,is.factor)==T])
for(col in fact_var)train[,(col):=as.integer(train[[col]])]
for(col in fact_var)test[,(col):=as.integer(test[[col]])]

data<-rbind(train,test)
rm(train,test)

localH2O <- h2o.init(nthreads = -1)
h2o.init()
data_h2o<-as.h2o(data)
model<-h2o.glm(y="loss",training_frame=data_h2o[1:n_train,],family="gaussian")
h2o.performance(model)

#MSE:  5351286
#RMSE:  2313.285
#MAE:  1476.685
#RMSLE:  0.6911547
#Mean Residual Deviance :  5351286
#R^2 :  0.3654856
#Null Deviance :1.588212e+12
#Null D.o.F. :188317
#Residual Deviance :1.007744e+12
#Residual D.o.F. :187880
#AIC :3452883

h2o.shutdown(prompt = TRUE)