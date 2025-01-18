
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


# 3 Create an Excel File and Save #######################################################################

# Download Chile as Excel

library(openxlsx)

write.xlsx(chile_PanelID, "/your_storage_location/chile_panelID.xlsx", rowNames = FALSE)




