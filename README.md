# Predicting the genotype of a mouse by behaviour

2023-06-08

**Background**<br>
My colleagues recently developed a mouse knockout model to decipher neuronal circuits involved in autism spectrum disorder development. In a battery of behavioural testings, potential differences between the wildtype and knockout animals were masked by large variances. Here’s a report on how I applied a supervised machine learning approach to predict the genotype of a mouse in the 3 Chamber Sociability test.

<blockquote>
<b>3 Chamber Sociability Test</b><br>
The arena consists of three chambers: an empty centre chamber, and two adjacent chambers with a small cage each, one containing a stranger mouse, one empty. The test mouse is allowed to freely run between the chambers and the measured parameters (e.g. time spent with the stranger mouse, number of visits or number of sniffs) are used as a marker for sociability.
<br>
All animal experiments were approved by the state of Berlin and followed the guidelines and recommendations of the European animal welfare law.
No animals were harmed by or during the behaviour testings.
</blockquote>

**Results**<br>
Wildtype and knockout animals showed slight but not significant differences in the measured parameters.
First inspection of the data revealed the existence of subgroups. I wondered which variables contributed most to the variance and whether they characterise the subgroups. Multiple Factor Analysis (MFA) conducted with the FactoMineR and factoextra packages revealed that several parameters measured in the empty chamber had a high contribution to the variance in the dataset. This finding was further confirmed by correlation analysis showing that the variables were more frequently negatively correlated in KO compared to WT animals. Some correlation coefficients were significantly different between genotypes as evaluated by Fisher Z-transformation and exemplarily shown for female mice. This suggested that the genotypes differ in behaviour, but that this cannot be described by single parameters.

<br>
![Fig3](https://github.com/SebaRade/Genotpye_Prediction/assets/156301448/e1b31143-21a6-4f2e-8298-c4b4b64a4928)
<br>

Thus, I generated a binomial logistic regression model to predict the genotype of a mouse given the dependent variables measured in the empty chamber. To analyse which of them were important and which could be removed without information loss, I applied the stepwise Akaike Information Criterion (AIC) algorithm from the MASS package. This algorithm retained the variables ‘Activity’, ‘Velocity’, ‘Number of sniffs’ and ‘Number of visits’ in the empty chamber. In comparison, the AIC algorithm did not predict a valuable model for the parameters measured in the chamber with a stranger mouse.

The next step was to train and evaluate the model. Since the dataset was fairly small and there was a chance of over-/underfitting, I decided not to randomly partition it into training and test datasets. I chose a k-fold cross validation approach included in the caret package instead.

The trained model had an accuracy of 0.77 and a moderate Cohen’s kappa of 0.53. I then applied the final model to all animals and plotted their probabilities of being a WT or KO animal using the ggplot2 and scatterplot3d packages. Given a cutoff of *p*=0.5, the model accuracy was even 0.85.

<br>
![Fig2-1](https://github.com/SebaRade/Genotpye_Prediction/assets/156301448/2eee578d-2a6f-46be-88ba-977ddfb760b8)
<br>

**Summary**<br>
One could say that a moderate Cohen’s kappa is not substantial or perfect and that an accuracy of 0.77/0.85 is not high. I find it still impressing given the small dataset of only 42 animals. More importantly, the animals show a different behaviour in the empty chamber. Given a certain velocity, number of sniffs and number of visits, knockout animals show a higher activty in the empty chamber compared to wildtype animals.
