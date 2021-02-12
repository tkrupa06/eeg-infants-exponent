#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""


@author: Pranay S. Yadav
"""
import os
import numpy as np
import pandas as pd
import ETC

# parameters
df = pd.read_csv("../csv/sessions.csv")

causal_folder = "../results/causal/"
arr_folder = "../working/epochs/"
os.makedirs(causal_folder, exist_ok=True)

# compute for all subjects
for subject in df.subject_id:

    # init file names for IO
    npy_file_name = "%s/%s_epochsmat.npy" % (arr_folder, subject)
    chname_file_name = "%s/%s_channels.npy" % (arr_folder, subject)
    causal_file_name = "%s/%s_causal.csv" % (causal_folder, subject)

    print("#" * 60, subject, "\n", "-" * 60)

    # load numpy arrays
    arr3d = np.load(npy_file_name)
    channels = np.load(chname_file_name)

    # init aggregator for estimates
    results = []
    for n in range(arr3d.shape[0]):  # iterate over 1st dimension (epochs)

        print(f"\nEpoch: {n}\n")

        # get 2D matrix (nchan x samples), bin it and make row-pair generator
        data = ETC.get_rowpairs(ETC.partition_numpy(arr3d[n, :, :].squeeze(), 2))

        # compute CCM causal estimates and store as dataframe
        out = pd.DataFrame(ETC.CCM_causality_parallel(data))

        # add epoch identifier
        out["epoch"] = n

        # append dataframe to results aggregator
        results.append(out)

    # Merge estimates across all epochs for subject
    df = pd.concat(results).reset_index(drop=True)

    # Add channel identifiers
    df["channel_x"] = channels[df["index_x"]]
    df["channel_y"] = channels[df["index_y"]]
    df["channel_pair"] = df["channel_x"] + "-" + df["channel_y"]

    # Save file to disk
    df.to_csv(causal_file_name)

    print("-" * 60, "\ndone!", "#" * 60)

print("Finished!")
