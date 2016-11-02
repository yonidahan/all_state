#model_lm3
#no 1-hot
#on very raw feat
#Not same levels train/test: implem just on train
#Same as model_lm1 !!

setwd("/home/yoni/Documents/Data Science/Projects/AllState")

cat(paste0(lapply(c("data.table","xgboost","randomForest","party","h2o"),
                  require,character.only=T)))

train<-fread("train.csv",showProgress=T,stringsAsFactors = T)

train<-train[,c("id"):=NULL]

#Categ var to integers
localH2O <- h2o.init(nthreads = -1)
h2o.init()
train_h2o<-as.h2o(train)
model<-h2o.glm(y="loss",training_frame=train_h2o,family="gaussian")
h2o.performance(model)

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