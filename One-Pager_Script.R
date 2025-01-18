
# Example of Chile

# 2 Test the Performance of the Large Language Model in R ###############################################

# Load Dataset
chile_PanelID <- read_csv("Downloads/chile_PanelID.csv")

library(dplyr)

# Filter rows which have more than 1 PanelID
df_filtered <- chile_PanelID %>%
  group_by(Panel_ID) %>%            
  filter(n() > 1) %>%               
  ungroup()                         

View(df_filtered)

# Filter candidate names, which are not exactly the same, but have the same PanelID
df_different_names <- df_filtered %>%
  group_by(Panel_ID) %>%                    
  filter(n_distinct(candidate) > 1) %>%     
  ungroup()                     

View(df_different_names)


# Compare different Thresholds

chile_PanelID_t2 <- read_csv("Downloads/chile_PanelID_t2.csv")
chile_PanelID_t1 <- read_csv("Downloads/chile_PanelID_t1.csv")

# Filter rows which have more than 1 PanelID
df_filtered_t2 <- chile_PanelID_t2 %>%
  group_by(Panel_ID) %>%            
  filter(n() > 1) %>%               
  ungroup()     

# Filter candidate names, which are not exactly the same, but have the same PanelID
df_different_names_t2 <- df_filtered_t2 %>%
  group_by(Panel_ID) %>%                    
  filter(n_distinct(candidate) > 1) %>%     
  ungroup()      


# Filter rows which have more than 1 PanelID
df_filtered_t1 <- chile_PanelID_t1 %>%
  group_by(Panel_ID) %>%            
  filter(n() > 1) %>%               
  ungroup()     

# Filter candidate names, which are not exactly the same, but have the same PanelID
df_different_names_t1 <- df_filtered_t1 %>%
  group_by(Panel_ID) %>%                    
  filter(n_distinct(candidate) > 1) %>%     
  ungroup()      


library(dplyr)

# Find candidates in t1 but not in t2
candidates_only_in_t1 <- df_different_names_t1 %>%
  filter(!candidate %in% df_different_names_t2$candidate)

# Find candidates in t2 but not in t1
candidates_only_in_t2 <- df_different_names_t2 %>%
  filter(!candidate %in% df_different_names_t1$candidate)

# Display results
print("Candidates in t1 but not in t2:")
print(candidates_only_in_t1)

print("Candidates in t2 but not in t1:")
print(candidates_only_in_t2)



# 3 Create an Excel File and Save #######################################################################

# Download Chile as Excel

library(openxlsx)

write.xlsx(chile_PanelID, "/your_storage_location/chile_panelID.xlsx", rowNames = FALSE)




