#model_lm2
#categ var --> group factors with freq (thr=0.01)

setwd("/home/yoni/Documents/Data Science/Projects/AllState")

cat(paste0(lapply(c("data.table","xgboost","randomForest","party","h2o"),
                  require,character.only=T)))

train<-fread("train.csv",showProgress=T,stringsAsFactors = T)
test<-fread("test.csv",showProgress=T,stringsAsFactors = T)

train<-train[,c("id"):=NULL]
test<-test[,c("id"):=NULL]
test$loss<-rep(NA,nrow(test))
n_train<-nrow(train)

fact_var<-names(lapply(train,is.factor)[lapply(train,is.factor)==T])
group_lev <- function(x, thr = 0.01){
  low_freq <- table(x) / length(x)
  low_freq <- names(low_freq[low_freq <= thr])
  levels(x)[levels(x) %in% low_freq] <- "Other"
  x
}
for(col in fact_var)train[,(col):=group_lev(train[[col]])]
for(col in fact_var)test[,(col):=group_lev(test[[col]])]
##mapply(function(x,y)identical(levels(x),
##levels(y)),train[,fact_var],test[,fact_var])

data<-rbind(train,test)

rm(train,test)

localH2O <- h2o.init(nthreads = -1)
h2o.init()
data_h2o<-as.h2o(data)
model<-h2o.glm(y="loss",training_frame=data_h2o[1:n_train,],family="gaussian")
h2o.performance(model)

#MSE:  5375562
#RMSE:  2318.526
#MAE:  1480.341
#RMSLE:  0.6922011
#Mean Residual Deviance :  5375562
#R^2 :  0.3626072
#Null Deviance :1.588212e+12
#Null D.o.F. :188317
#Residual Deviance :1.012315e+12
#Residual D.o.F. :187964
#AIC :3453568

h2o.shutdown(prompt = TRUE)