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
dfs_etc_wide = []
dfs_etc_long = []
dfs_etc_tm = []
dfs_lz_wide = []
dfs_lz_long = []
dfs_lz_tm = []

for subject in df.subject_id:

    # read file
    df_file_name = "%s/%s_causal.csv" % (ccm_folder, subject)
    df_ccm = pd.read_csv(df_file_name, index_col=0)

    ## Complexity estimate: ETC

    # extract for channel x
    etc_x = df_ccm.groupby(["channel_x", "epoch"])["ETC_x"].min().reset_index()
    etc_x = etc_x.rename(columns={"channel_x": "channel", "ETC_x": "ETC"})

    # extract for channel y
    etc_y = df_ccm.groupby(["channel_y", "epoch"])["ETC_y"].min().reset_index()
    etc_y = etc_y.rename(columns={"channel_y": "channel", "ETC_y": "ETC"})

    # combine (take union) of the above two
    etc_long = (
        pd.concat([etc_x, etc_y])  # pd.merge can be used with "outer" (union) join
        .groupby(["channel", "epoch"])["ETC"]
        .min()
        .reset_index()
    )

    # convert to wide form with one column per channel
    etc_wide = etc_long.pivot(index="epoch", columns="channel", values="ETC")

    # compute 20% trimmed means across epochs for per channel aggregation
    etc_tm = etc_long.groupby("channel")["ETC"].apply(lambda x: trim_mean(x, 0.2))

    ## Complexity estimate: LZ76

    # extract for channel x
    lz_x = df_ccm.groupby(["channel_x", "epoch"])["LZ_x"].min().reset_index()
    lz_x = lz_x.rename(columns={"channel_x": "channel", "LZ_x": "LZ"})

    # extract for channel y
    lz_y = df_ccm.groupby(["channel_y", "epoch"])["LZ_y"].min().reset_index()
    lz_y = lz_y.rename(columns={"channel_y": "channel", "LZ_y": "LZ"})

    # combine (take union) of the above two
    lz_long = (
        pd.concat([lz_x, lz_y])  # pd.merge can be used with "outer" (union) join
        .groupby(["channel", "epoch"])["LZ"]
        .min()
        .reset_index()
    )

    # convert to wide form with one column per channel
    lz_wide = lz_long.pivot(index="epoch", columns="channel", values="LZ")

    # compute 20% trimmed means across epochs for per channel aggregation
    lz_tm = lz_long.groupby("channel")["LZ"].apply(lambda x: trim_mean(x, 0.2))

    ## Clean up and aggregate
    # add subject identifiers
    etc_long["subject_id"] = subject
    etc_wide["subject_id"] = subject
    etc_tm["subject_id"] = subject
    lz_long["subject_id"] = subject
    lz_wide["subject_id"] = subject
    lz_tm["subject_id"] = subject

    # accumulate estimates
    dfs_etc_long.append(etc_long)
    dfs_etc_wide.append(etc_wide)
    dfs_etc_tm.append(etc_tm)
    dfs_lz_long.append(lz_long)
    dfs_lz_wide.append(lz_wide)
    dfs_lz_tm.append(lz_tm)

# combine all dataframes, add ages and save
for label, dfx in zip(
    ["etc_long", "etc_wide", "lz_long", "lz_wide"],
    [dfs_etc_long, dfs_etc_wide, dfs_lz_long, dfs_lz_wide],
):

    dfo = pd.concat(dfx, axis=0, sort=False)
    dfo = dfo.merge(df, on="subject_id")
    dfo.to_csv(f"%s/complexity_{label}.csv" % ccm_folder, index=False)

for label, dfx in zip(["etc_tm", "lz_tm"], [dfs_etc_tm, dfs_lz_tm]):

    dfo = pd.concat(dfx, axis=1, sort=False).T
    dfo = dfo.merge(df, on="subject_id")
    dfo.to_csv(f"%s/complexity_{label}.csv" % ccm_folder, index=False)
    dfo.to_csv(f"%s/complexity_{label}.csv" % model_folder, index=False)
