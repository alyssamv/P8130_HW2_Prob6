## Load libraries, load and clean data

library(tidyverse)
load("~/Desktop/FALL 2018/Biostat I/Homework/Write ups/P8130_HW2_Prob6/migraine.RData")

migraine_data = migraine %>%
  janitor::clean_names() %>%  # brings colnames to lowercase, no white space
  mutate(migraine = recode(migraine, `0` = 'no', `1` = 'yes')) %>% # recode the 'migraine' variable as 0=no and 1=yes
  mutate(cesd_geq16 = ifelse(cesd >= 16, 'yes', 'no'),
         nddie_geq16 = ifelse(nddie >= 16, 'yes', 'no')) # create binary variables with the cutoff value of 16 for both CESD and NDDIE

rm(migraine) # remove the original data table

## Function to get the mode(s) of a given variables (column)
Modes <- function(x) {
  t = which(table(x) == max(table(x)))
  return(paste(names(t), collapse = ','))
}

##########################################################
# Summary statistics. All summary statistics values exclude missing values (NAs). 
# The number of missing values for the given variable are given in the last column of the table outputs.
##########################################################

### CESD ###
migraine_data %>%
  mutate(cesd_binary = recode(cesd_geq16, 'yes' = 1, 'no' = 0)) %>%  # recodes yes/no to 1/0 to allow for easy calculation of proportions
  group_by(migraine) %>%  # groups data by migraine status
  summarise( # produces table of the enclosed values
    'N' = table(migraine) - sum(is.na(cesd)),  # number of recorded values per group (excludes NA)
    'Mean' = mean(cesd, na.rm = T),  # average CESD
    'Mode' = Modes(cesd), # mode(s) of CESD responses
    '25th %' = quantile(cesd, na.rm = T)[2], # 1st quartile
    'Median' = median(cesd, na.rm = T), # median CESD
    '75th %' = quantile(cesd, na.rm = T)[4], # 3rd quartile
    'Std Dev' = sd(cesd, na.rm = T), # standard deviation
    'CESD >= 16' = sum(cesd_binary, na.rm = T)/table(migraine), # proportion of responders whose CESD was greater than or equal to 16
    'NAs' = sum(is.na(cesd))) # number of missing values

### NDDIE ###            
migraine_data %>%
  mutate(nddie_binary = recode(nddie_geq16, 'yes' = 1, 'no' = 0)) %>%
  group_by(migraine) %>%
  summarise(
    'N' = table(migraine) - sum(is.na(nddie)),
    'Mean' = mean(nddie, na.rm = T), 
    'Mode' = Modes(nddie),
    '25th %' = quantile(nddie, na.rm = T)[2],
    'Median' = median(nddie, na.rm = T),
    '75th %' = quantile(nddie, na.rm = T)[4],
    'Std Dev' = sd(nddie, na.rm = T),
    'NDDIE >= 16' = sum(nddie_binary, na.rm = T)/table(migraine),
    'NAs' = sum(is.na(nddie)))

### ABNAS ###
# summary stats for language scores
language = migraine_data %>%
  group_by(migraine) %>%
  summarise('Measure' = 'Language',
            'N' = table(migraine),  
            'Mean' = mean(abnas_language, na.rm = T),  
            'Mode' = Modes(abnas_language), 
            '25th %' = quantile(abnas_language, na.rm = T)[2],
            'Median' = median(abnas_language, na.rm = T),
            '75th %' = quantile(abnas_language, na.rm = T)[4],
            'Max' = max(abnas_language, na.rm = T),
            'Std Dev' = sd(abnas_language, na.rm = T),
            'NAs' = sum(is.na(abnas_language))) 

# summary stats for memory scores
memory = migraine_data %>%
  group_by(migraine) %>%
  summarise('Measure' = 'Memory',
            'N' = table(migraine),  
            'Mean' = mean(abnas_memory, na.rm = T),   
            'Mode' = Modes(abnas_memory),
            '25th %' = quantile(abnas_memory, na.rm = T)[2],
            'Median' = median(abnas_memory, na.rm = T),
            '75th %' = quantile(abnas_memory, na.rm = T)[4],
            'Max' = max(abnas_memory, na.rm = T),
            'Std Dev' = sd(abnas_memory, na.rm = T),
            'NAs' = sum(is.na(abnas_memory))) 

bind_rows(language, memory) # combine tables



##########################################################
# Visual representations (boxplots) of the distribution of values for each variable by migraine status. 
##########################################################

### CESD ###
ggplot(migraine_data, aes(x = migraine, y = cesd)) +
  geom_boxplot(aes(fill = migraine)) + # boxplots
  ggtitle(label = 'Distribution of CESD scores among patients') +
  ylab('CESD score (0-48)') +
  xlab('') +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

### NDDIE ###
ggplot(migraine_data, aes(x = migraine, y = nddie)) +
  geom_boxplot(aes(fill = migraine)) +
  ggtitle(label = 'Distribution of NDDIE scores among patients') +
  ylab('CESD score (6-24)') +
  xlab('') +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

### ABNAS Memory ###
ggplot(migraine_data, aes(x = migraine, y = abnas_memory)) +
  geom_boxplot(aes(fill = migraine)) +
  ggtitle(label = 'Distribution of ABNAS Memory scores among patients') +
  ylab('ABNAS memory score (0-12)') +
  xlab('') +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

### ABNAS Language ###
ggplot(migraine_data, aes(x = migraine, y = abnas_language)) +
  geom_boxplot(aes(fill = migraine)) +
  ggtitle(label = 'Distribution of ABNAS Language scores among patients') +
  ylab('ABNAS language score (0-9)') +
  xlab('') +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())