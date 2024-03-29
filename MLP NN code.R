setwd("C:\\Users\\dell\\Desktop\\AITS")

train <- read.csv("train.csv",stringsAsFactors =F)
test <- read.csv("test.csv",stringsAsFactors = F)
head(train)
head(test)

# columns not required
train$PassengerId <- NULL
train$Name<- NULL
train$Cabin<- NULL

test$PassengerId <- NULL
test$Name<- NULL
test$Cabin<- NULL


sapply(train, function(x) sum(is.na(x)))
sapply(train, function(x) sum(is.na(x))/length(x))


sapply(test, function(x) sum(is.na(x)))
sapply(test, function(x) sum(is.na(x))/length(x))


sapply(train, function(x) length(unique(x)))
sapply(test, function(x) length(unique(x)))

# taking only the required variables

head(train)
head(test)

train = subset(train, select = c(1:6,8,9))
test = subset(test, select = c(1:6,8,9))

train[is.na(train$Age)==TRUE,"Age"] <- mean(train$Age,na.rm=TRUE)
test[is.na(test$Age)==TRUE,"Age"] <- mean(test$Age,na.rm=TRUE)

train <- na.omit(train)

test <- na.omit(test)

##############

head(train)
head(test)

train$Sex <- ifelse(train$Sex == "male",0,1)
train$Embarked <- ifelse(train$Embarked == "C",1,ifelse(train$Embarked == "Q",2,3))

test$Sex <- ifelse(test$Sex == "male",0,1)
test$Embarked <- ifelse(test$Embarked == "C",1,ifelse(test$Embarked == "Q",2,3))

#####################

train$SibSp <- (train$SibSp - min(train$SibSp))/(max(train$SibSp) - min(train$SibSp))
train$Parch<- (train$Parch- min(train$Parch))/(max(train$Parch) - min(train$Parch))
train$Pclass<- (train$Pclass- min(train$Pclass))/(max(train$Pclass) - min(train$Pclass))
train$Sex<- (train$Sex- min(train$Sex))/(max(train$Sex) - min(train$Sex))
train$Age <- (train$Age- min(train$Age))/(max(train$Age) - min(train$Age))
train$Fare <- (train$Fare- min(train$Fare))/(max(train$Fare) - min(train$Fare))
train$Embarked <- (train$Embarked - min(train$Embarked ))/(max(train$Embarked ) - min(train$Embarked ))



test$SibSp <- (test$SibSp - min(test$SibSp))/(max(test$SibSp) - min(test$SibSp))
test$Parch<- (test$Parch- min(test$Parch))/(max(test$Parch) - min(test$Parch))
test$Pclass<- (test$Pclass- min(test$Pclass))/(max(test$Pclass) - min(test$Pclass))
test$Sex<- (test$Sex- min(test$Sex))/(max(test$Sex) - min(test$Sex))
test$Age <- (test$Age- min(test$Age))/(max(test$Age) - min(test$Age))
test$Fare <- (test$Fare- min(test$Fare))/(max(test$Fare) - min(test$Fare))
test$Embarked <- (test$Embarked - min(test$Embarked ))/(max(test$Embarked ) - min(test$Embarked ))

head(test)
head(train)
#Fitting Neural Network

set.seed(123)
install.packages("neuralnet")
library(neuralnet)

nn <- neuralnet(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked
,data=train,hidden=4,act.fct = "logistic",linear.output=FALSE)

plot(nn)

#prediction on test data

output_test <- compute(nn, test[,-1])
predicted_test <- ifelse(output_test$net.result>0.5,1,0)
cm_test <- table(predicted_test,test$Survived)
cm_test

accuracy_test <- sum(diag(cm_test))/sum(cm_test)
accuracy_test

#prediction on train data

output_train <- compute(nn, train[,-1])
predicted_train <- ifelse(output_train$net.result>0.5,1,0)
cm_train <- table(predicted_train,train$Survived)
cm_train

accuracy_train <- sum(diag(cm_train))/sum(cm_train)
accuracy_train

