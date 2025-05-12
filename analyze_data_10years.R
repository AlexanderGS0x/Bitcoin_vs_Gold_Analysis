# Load required packages
library(tidyverse)
library(lubridate)

# Read the processed data
data <- read.csv("bitcoin_vs_gold_processed_10years.csv")

# Convert Date to date format
data$Date <- as.Date(data$Date)

# --- 1. Calculate Cumulative Returns ---
# Replace NA returns with 0 for the first row
data$Bitcoin_Weekly_Return <- ifelse(is.na(data$Bitcoin_Weekly_Return), 0, data$Bitcoin_Weekly_Return)
data$Gold_Weekly_Return <- ifelse(is.na(data$Gold_Weekly_Return), 0, data$Gold_Weekly_Return)

# Calculate cumulative returns (as a percentage)
data$Bitcoin_Cumulative_Return <- cumprod(1 + data$Bitcoin_Weekly_Return / 100) * 100 - 100
data$Gold_Cumulative_Return <- cumprod(1 + data$Gold_Weekly_Return / 100) * 100 - 100

# --- 2. Calculate Volatility (Annualized Standard Deviation) ---
# Number of weeks in a year
weeks_per_year <- 52

# Annualized volatility = standard deviation of weekly returns * sqrt(weeks_per_year)
bitcoin_volatility <- sd(data$Bitcoin_Weekly_Return, na.rm = TRUE) * sqrt(weeks_per_year)
gold_volatility <- sd(data$Gold_Weekly_Return, na.rm = TRUE) * sqrt(weeks_per_year)

# Print volatility
cat("Annualized Volatility (Bitcoin):", round(bitcoin_volatility, 2), "%\n")
cat("Annualized Volatility (Gold):", round(gold_volatility, 2), "%\n")

# --- 3. Performance During Market Downturns ---
# Define a downturn as weeks where Bitcoin drops by more than 10%
downturn_threshold <- -10
downturns <- data[data$Bitcoin_Weekly_Return < downturn_threshold, ]

# Calculate average returns during downturns
bitcoin_downturn_avg <- mean(downturns$Bitcoin_Weekly_Return, na.rm = TRUE)
gold_downturn_avg <- mean(downturns$Gold_Weekly_Return, na.rm = TRUE)

# Print downturn performance
cat("Average Bitcoin Return During Downturns:", round(bitcoin_downturn_avg, 2), "%\n")
cat("Average Gold Return During Downturns:", round(gold_downturn_avg, 2), "%\n")

# --- 4. Save the Analyzed Data ---
write.csv(data, "bitcoin_vs_gold_analyzed_10years.csv", row.names = FALSE)

# --- 5. Plot Cumulative Returns ---
ggplot(data, aes(x = Date)) +
  geom_line(aes(y = Bitcoin_Cumulative_Return, color = "Bitcoin"), linewidth = 1) +  # Changed size to linewidth
  geom_line(aes(y = Gold_Cumulative_Return, color = "Gold"), linewidth = 1) +        # Changed size to linewidth
  labs(title = "Cumulative Returns: Bitcoin vs. Gold (2015-2025)",
       x = "Date",
       y = "Cumulative Return (%)",
       color = "Asset") +
  scale_color_manual(values = c("Bitcoin" = "orange", "Gold" = "gold")) +
  theme_minimal() +
  theme(legend.position = "top")