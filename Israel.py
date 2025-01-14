
# Use Python VSCode version 3.10.12
# python --version # in Terminal to check the version

# Ensure the following extensions: Python, Jupyter

# Install in Terminal:
# pip install torch==2.3.0
# pip install linktransformer==0.1.15
# pip install linktransformer numpy pandas torch
# pip install --upgrade torch transformers linktransformer


# Imports
import numpy as np
import pandas as pd
import os
from sklearn.metrics.pairwise import cosine_similarity
from scipy.spatial.distance import squareform
from scipy.cluster.hierarchy import fcluster, linkage
import linktransformer as lt

# Load the model
try:
    model = lt.load_model("sentence-transformers/multi-qa-MiniLM-L6-cos-v1")
    print("Model loaded successfully!")
except Exception as e:
    print(f"Error loading model: {e}")
    exit()

# Load the dataset
local_file_path = "/Users/quirinoettl/Documents/Arbeit/UniLu/Panel_ID/israel_master.csv"
try:
    country_df = pd.read_csv(local_file_path)
    print("Dataset loaded successfully!")
except Exception as e:
    print(f"Error loading dataset: {e}")
    exit()


# Generate semantic embeddings

def generate_embeddings(df, batch_size=500):
    embeddings = []
    for start in range(0, len(df), batch_size):
        end = min(start + batch_size, len(df))
        batch = df["candidate"].iloc[start:end].fillna('').tolist()
        batch_embeddings = model.encode(batch)
        embeddings.extend(batch_embeddings)
    return np.array(embeddings)


embeddings = generate_embeddings(country_df)

# Compute the full cosine similarity matrix
print("Computing cosine similarity matrix...")
similarity_matrix = cosine_similarity(embeddings)

# Convert similarity to distance (1 - similarity)
distance_matrix = 1 - similarity_matrix

# Clamp negative values to zero
distance_matrix = np.maximum(distance_matrix, 0)

# Convert full distance matrix to a condensed form (upper triangular part)
condensed_distance_matrix = squareform(
    distance_matrix, force="tovector", checks=False)

# Perform hierarchical clustering
print("Performing hierarchical clustering...")
linkage_matrix = linkage(condensed_distance_matrix, method="average")

# Generate cluster IDs
threshold = 0.2
cluster_ids = fcluster(linkage_matrix, t=threshold, criterion="distance")

# Assign cluster IDs to the DataFrame
country_df["Panel_ID"] = cluster_ids

# Save the results
output_path = os.path.join(os.path.expanduser(
    "~"), "Downloads", "israel_PanelID.csv")
country_df.to_csv(output_path, index=False)
print(f"Results saved to: {output_path}")
