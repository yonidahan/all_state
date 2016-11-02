##model_nn
#specif in model

setwd("C:/Users/Sarah/Documents/Data Science/Projects/AllState")

cat(paste0(lapply(c("data.table","xgboost","randomForest","party","h2o"),
                  require,character.only=T)))

train<-fread("train.csv",showProgress=T,stringsAsFactors = T)

train<-train[,c("id"):=NULL]

#Categ var to integers
localH2O <- h2o.init(nthreads = -1)
h2o.init()
train_h2o<-as.h2o(train)

model<-h2o.deeplearning(y="loss",training_frame=train_h2o,standardize = T,
                        #l1=1,
                        loss="Absolute",
                        distribution="laplace"
                        )
h2o.performance(model)

h2o.shutdown(prompt = TRUE)

#'MSE:  3645890
#RMSE:  1909.421
#MAE:  1160.062
#RMSLE:  0.5499033
#Mean Residual Deviance :  1160.062