# Load required packages
library(FactoMineR)
library(factoextra)
library(MASS)
library(tidyverse)
library(caret)
library(corr)
library(ggplot2)
library(ggcorrplot)
libaray(psych)
 
# Run Multiple Factor Analysis
mfa_all<-MFA(df,
   group=c(1,1,1,1,2,2,2,2,2,2,2,2),
   type=c("n","n","n","n","s","s","s","s","s","s","s","s"),
   name.group=c("Genotype", "Cage", "Sex", "Cohort", "Sniff",
   "Duration","Velocity", "Length", "Visit", "Activity",
   "Ambulation", "Latency"),
 graph=F)
fviz_contrib(mfa_all, choice="quanti.var", axes=1, top=20)
 
# Generate correlation matrices
df_wt<-df[df$Genotype=="WT",]
df_ko<-df[df$Genotype=="KO",]
df_wt<-df_wt[-1:-5]
df_ko<-df_ko[-1:-5]
corr_wt<-cor(df_wt, method="spearman")
pmat_wt<-cor_pmat(df_wt)
ggcorrplot(corr_wt, type="upper", p.mat=pmat_wt, insig="blank")
corr_ko<-cor(df_ko, method="spearman")
pmat_ko<-cor_pmat(df_ko)
ggcorrplot(corr_ko, type="upper", p.mat=pmat_ko, insig="blank")
 
# Compare correlation coefficients
cor_wt_fisher<-fisherz(cor_wt)
cor_ko_fisher<-fisherz(cor_ko)
cor_p<-2*pnorm(-abs((cor_wt_fisher-cor_ko_fisher)/sqrt(1/(n1-3)/(n2-3))))

# Change dummy variables to factors
df$Genotype<-as.factor(df$Genotype)
 
# Generate initial model
model_init<-glm(Genotype~Dure+Acte+Vise+Lene+Vele+Sniffe+Ambe+Late, data=df, method="binomial")
model_init
 
# Apply Akaike Information Criterion algorithm
model_step<-stepAIC(model_init, direction="both")

# Define training dataset and run training
set.seed(1)
train<-trainControl(method="cv", number=10)
model_cv<-train(Genotype~Acte+Vele+Vise+Sniffe, data=df, method="glm", family="binomial", trControl=train)
print(model_cv) # Get information about model
summary(model_cv) # Get information about variables
varImp(model_cv) # Get variable importance
model_cv$finalModel # Get model coefficients
summary(model_step)
