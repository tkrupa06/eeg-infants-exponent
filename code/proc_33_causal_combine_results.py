"""Compile 1/f-exponents across sessions for further computation in R."""

import os
import pandas as pd
import numpy as np
from scipy.stats import trim_mean

df = pd.read_csv("../csv/sessions.csv")
df = df[["age", "subject_id", "subject"]]
ccm_folder = "../results/causal/"
model_folder = "../results/model_complexities/"

# Initialize empty lists for aggregation
dfs_etcp = []
dfs_etce = []
dfs_lzp = []

for subject in df.subject_id:

    # read file
    df_file_name = "%s/%s_causal.csv" % (ccm_folder, subject)
    df_ccm = pd.read_csv(df_file_name, index_col=0)

    # get number of pairs to aggregate over for k=10% (32C2 = 496 pairs for 32 channels)
    k = round(0.1 * len(df_ccm["channel_pair"].unique()))

    ## NCA estimate: ETCP

    etcp = (
        df_ccm.melt(id_vars="epoch", value_vars=["ETCP_x_to_y", "ETCP_y_to_x"])
        .groupby(["epoch"])["value"]
        .nlargest(k)  # select k largest pairs
        .groupby("epoch")
        .apply(lambda x: trim_mean(x, 0.1))  # 10% trimmed means across top k pairs
        .to_frame()
        .reset_index()
    )

    ## NCA estimate: ETCE

    etce = (
        df_ccm.melt(id_vars="epoch", value_vars=["ETCE_x_to_y", "ETCE_y_to_x"])
        .groupby(["epoch"])["value"]
        .nlargest(k)  # select k largest pairs
        .groupby("epoch")
        .apply(lambda x: trim_mean(x, 0.1))  # 10% trimmed means across top k pairs
        .to_frame()
        .reset_index()
    )

    ## NCA estimate: LZP

    lzp = (
        df_ccm.melt(id_vars="epoch", value_vars=["LZP_x_to_y", "LZP_y_to_x"])
        .groupby(["epoch"])["value"]
        .nlargest(k)  # select k largest pairs
        .groupby("epoch")
        .apply(lambda x: trim_mean(x, 0.1))  # 10% trimmed means across top k pairs
        .to_frame()
        .reset_index()
    )

    ## Clean up and aggregate
    # add subject identifiers
    etcp["subject_id"] = subject
    etce["subject_id"] = subject
    lzp["subject_id"] = subject

    # accumulate estimates
    dfs_etcp.append(etcp)
    dfs_etce.append(etce)
    dfs_lzp.append(lzp)

# combine all dataframes, add ages and save
for label, dfx in zip(
    ["nca_etce", "nca_etcp", "nca_lzp"], [dfs_etce, dfs_etcp, dfs_lzp]
):

    # Concatenate and compute means across epochs
    dfo = pd.concat(dfx)
    dfo_mean = dfo.groupby("subject_id")["value"].mean().reset_index()

    # Add ages
    dfo = dfo.merge(df, on="subject_id")
    dfo_mean = dfo_mean.merge(df, on="subject_id")

    dfo.to_csv(f"%s/complexity_{label}.csv" % ccm_folder, index=False)
    dfo.to_csv(f"%s/complexity_{label}.csv" % model_folder, index=False)

    dfo_mean.to_csv(f"%s/complexity_{label}_mean.csv" % ccm_folder, index=False)
    dfo_mean.to_csv(f"%s/complexity_{label}_mean.csv" % model_folder, index=False)
