library(purrr)
library(readxl)
library(stringr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plyr)
library(magrittr)
library(forcats)
data <- read_excel('C:\\Users\\phoga\\Desktop\\googleplaystore.xlsx')
View(data)
summary(data)


#########DATA CLEANING#############


#taking unique data only
gpdata <- unique(data)
View(gpdata)
#removing rows with Nan values
gpdata<-gpdata %>% drop_na()
sum(is.na(gpdata))
# Remove "M"  
gpdata$Size <- str_replace_all(gpdata$Size, "M", "")
#Removeing ‘,’ from installs column.
gpdata$Installs <- str_replace_all(gpdata$Installs,"\\,","")
gpdata$Installs <- as.numeric(gpdata$Installs)
gpdata$Size <- as.numeric(gpdata$Size)
gpdata$Rating = as.numeric(gpdata$Rating)
gpdata$Reviews <- as.numeric(gpdata$Reviews)
str(gpdata)
summary(gpdata)



##############   FREE APPS VS PAID APPS

gpdata %>%
  ggplot(aes(x = "", fill = Type)) +
  stat_count(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Apps by Type (Paid/Free)", x = NULL, y = NULL, fill = "Type") +
  theme_void() +
  geom_text(aes(label = paste0(round((..count.. / sum(..count..)) * 100, 1), "%")),
            stat = "count", position = position_stack(vjust = 0.5))



##################  NUMBER OF APPS INSTALLED PER CATEGORY

options(scipen = 999)
ggplot(gpdata, aes(x = Category, y = Installs)) +
  geom_bar(stat = "identity", width = 0.7, fill = "skyblue") +
  coord_flip() +
  labs(title = "Total App Installation for Each Category") +
  theme(axis.text.x = element_text(angle = 90))


####################  #TOP 15 CATEGORIES 

ggplot(gpdata %>%
         mutate(Category = fct_lump(Category, n = 15)),
       aes(x = Category, y = Installs)) +
  geom_bar(stat = "identity", width = 0.7, fill = "skyblue") +
  coord_flip() +
  labs(title = "Top 15  App Installation Categories") +
  theme(axis.text.x = element_text(angle = 90))


###################  Top 15 Apps according to Installation 

top_15_apps <- gpdata %>%
  arrange(desc(Installs)) %>%
  top_n(15)
ggplot(top_15_apps, aes(x = reorder(App, Installs), y = Installs)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  labs(title = "Top 15 Apps by Installation",
       x = "App",
       y = "Installation")


##################### Average Rating Per category 

ggplot(gpdata, aes(x = Category, y = Rating)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Average Rating per Category",
       x = "Category",
       y = "Rating") +
  theme(axis.text.x = element_text(angle = 90))



########################    AVERAGE RATING PAID VS FREE

gpdata %>%
  ggplot(aes(Rating))+
  geom_histogram(binwidth = .1, aes(y=..density..))+
  scale_x_continuous(limits = c(0, 5.1))+
  labs(title = "Type vs Rating",
       x = "Rating", 
       y = "")+
  facet_grid(Type~.)


##################  App pricing per category 

ggplot(gpdata, aes(x = Price, y = Category, fill= Price)) +
  geom_point() +
  labs(title = "App Pricing per Category",
       x = "Price",
       y = "Category") +
  theme(axis.text.x = element_text(angle = 90))


#################Number of Paid Apps category vise

paid_apps_counts <- table(gpdata$Category)[order(table(gpdata$Category), decreasing = TRUE)]
top_10_paid_apps <- data.frame(Category = names(paid_apps_counts)[1:10], Count = as.vector(paid_apps_counts)[1:10])
ggplot(top_10_paid_apps, aes(x = reorder(Category, -Count), y = Count)) +
  geom_bar(stat = "identity", fill = "blue") +
  xlab("Category") +
  ylab("Number of Paid Apps") +
  ggtitle("Top 10 Categories with the Highest Number of Paid Apps") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


################## TOP 15 PAID APPS BAR CHART

paid_apps <- subset(gpdata, Type == "Paid")
top_15_paid_apps <- head(paid_apps[order(paid_apps$Reviews, decreasing = TRUE), ], 15)
ggplot(top_15_paid_apps, aes(x = App, y = Reviews)) +
  geom_bar(stat = "identity", fill = "blue") +
  xlab("App") +
  ylab("Number of Reviews") +
  ggtitle("Top 15 Paid Apps by Number of Reviews") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


################# MEDIAN PRICE OF PAID APPS

paid_apps <- subset(gpdata, Type == "Paid")
top_15_paid_apps <- head(paid_apps[order(paid_apps$Reviews, decreasing = FALSE), ], 40)
median_price <- median(as.numeric(paid_apps$Price))
ggplot(top_15_paid_apps, aes(x = App, y = Reviews)) +
  geom_bar(stat = "identity", fill =   "#FFC0CB") +
  geom_hline(yintercept = median_price, linetype = "solid", color = "red") +
  xlab("App") +
  ylab("Number of Reviews") +
  ggtitle("Median Price of All paid apps ") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
median_price


###################### RATING VS CATEGORY SCATTERPLOT

ggplot(gpdata, aes(x = Category, y = Rating)) +
  geom_point() +
  labs(title = "Category vs Rating Scatterplot",
       x = "Category",
       y = "Rating") +
  theme(axis.text.x = element_text(angle = 90))


################ APPS IN BEAUTY CATEGORY

app_counts <- table(gpdata$Category)
app_counts_df <- data.frame(Category = names(app_counts), Count = as.numeric(app_counts))
ggplot(app_counts_df, aes(x = Category, y = Count)) +
  geom_point() +
  labs(title = "Number of Apps in Each Category",
       x = "Category",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 90))


#################   INSATLLATINg TREND FOR PAID VS FREE APPS 

paid_apps <- subset(gpdata, Type == "Paid")
free_apps <- subset(gpdata, Type == "Free")
total_installs_paid <- sum(paid_apps$Installs)
total_installs_free <- sum(free_apps$Installs)
install_data <- data.frame(Type = c("Paid", "Free"),
                           Total_Installs = c(total_installs_paid, total_installs_free))
ggplot(install_data, aes(x = Type, y = Total_Installs, fill = Type)) +
  geom_bar(stat = "identity", width = 0.5) +
  labs(title = "Number of Installations for Paid vs Free Apps",
       x = "App Type",
       y = "Total Installations") +
  scale_fill_manual(values = c("Paid" = "skyblue", "Free" = "lightgreen")) +
  theme_minimal()



################### NO. OF INSTALLATION FOR PAID CATEGORY ACCORDING TO PRICE

paid_apps <- subset(gpdata, Type == "Paid")
ggplot(paid_apps, aes(x = Price, y = Installs)) +
  geom_point() +
  labs(title = "Price vs Number of Installs for Paid Apps",
       x = "Price",
       y = "Number of Installs") +
  theme_minimal()


#####################  CATEGORY WISE PAID APP PRICE 

paid_apps <- subset(gpdata, Type == "Paid")
category_median_price <- aggregate(Price ~ Category, paid_apps, median)
sorted_categories <- category_median_price[order(category_median_price$Price, decreasing = TRUE), ]
top_categories <- head(sorted_categories, 6)
ggplot(top_categories, aes(x = Category, y = Price)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Top 6 Categories: Paid App Prices",
       x = "Category",
       y = "Price (Median)") +
  theme(axis.text.x = element_text(angle = 90))



##################### Calculate the average rating for each category (COLOURFUL)

avg_rating <- data.frame(Category = unique(gpdata$Category),
                         AvgRating = sapply(unique(gpdata$Category),
                                            function(cat) mean(gpdata$Rating[gpdata$Category == cat])))
avg_rating <- avg_rating[order(avg_rating$AvgRating, decreasing = TRUE), ]
ggplot(avg_rating, aes(x = reorder(Category, -AvgRating), y = AvgRating)) +
  geom_bar(stat = "identity", fill = rainbow(nrow(avg_rating))) +
  xlab("Category") +
  ylab("Average Rating") +
  ggtitle("Average Rating by Category") +
  theme(axis.text.x = element_text(angle = 50, hjust = 1))



############################# LOWEST APPS CATEGORIES (LOWEST 10)

category_counts <- table(gpdata$Category)
sorted_categories <- names(category_counts)[order(category_counts)]
lowest_categories <- sorted_categories[1:10]
lowest_categories_data <- gpdata[gpdata$Category %in% lowest_categories, ]
ggplot(lowest_categories_data, aes(x = Category)) +
  geom_bar(fill = "skyblue") +
  xlab("Category") +
  ylab("Number of Apps") +
  ggtitle("Lowest 10 Categories with the Lowest Number of Apps") +
  theme(axis.text.x = element_text(angle = 90))



######################## MEDICAL APPS PRICES (LOWEST 45 APPS )

medical_paid_apps <- gpdata[gpdata$Category == "MEDICAL" & gpdata$Type == "Paid", ]
medical_paid_apps$Price <- as.numeric(gsub("[$]", "", medical_paid_apps$Price))
medical_paid_apps <- medical_paid_apps[order(medical_paid_apps$Price), ]
lowest_45_apps <- head(medical_paid_apps, 45)
ggplot(lowest_45_apps, aes(x = Price, y = App)) +
  geom_bar(stat = "identity", width = 0.8, fill = "lightgreen") +
  xlab("App") +
  ylab("Price") +
  ggtitle("Paid Apps in the MEDICAL Category") +
  theme(axis.text.x = element_text(angle = 0, hjust = 1))


##################### Scam Apps identigying using Prices of Finance category 
finance_paid_apps <- gpdata[gpdata$Type == "Paid" & gpdata$Category == "FINANCE", ]
# Create a bar plot of prices for paid apps in the FINANCE category
ggplot(finance_paid_apps, aes(x = App, y = Price)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  xlab("App") +
  ylab("Price") +
  ggtitle("Top Prices of Paid Apps in the Finance Category") +
  theme(axis.text.x = element_text(angle = 50, hjust = 1))