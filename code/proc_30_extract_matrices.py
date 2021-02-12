"""Computes 1/f-exponents for input segments of small length.

The EEG data is cut into segments of 10 s length, the power spectrum is
computed, power spectra are parametrized and exponent is saved in csv-files.
"""

import os
import mne
import numpy as np
import pandas as pd
from scipy.io import savemat

# parameters
df = pd.read_csv("../csv/sessions.csv")

duration_epochs = 10
rsquare_threshold = 0.95
bandwidth = 1
fmin = 1
fmax = 10

epochs_folder = "../working/epochs/"
raw_folder = "../working/ica/"
os.makedirs(epochs_folder, exist_ok=True)

# compute for all subjects
for subject in df.subject_id:

    npy_file_name = "%s/%s_epochsmat.npy" % (epochs_folder, subject)
    chname_file_name = "%s/%s_channels.npy" % (epochs_folder, subject)
    mat_file_name = "%s/%s_epochsmat.mat" % (epochs_folder, subject)
    ica_file_name = "%s/%s_raw.fif" % (raw_folder, subject)

    print(subject, end=" ")

    raw = mne.io.read_raw_fif(ica_file_name)
    raw.load_data()
    raw.set_eeg_reference("average")
    raw._data = raw.get_data(reject_by_annotation="NaN")

    # create segments
    events = mne.make_fixed_length_events(
        raw, start=0, stop=raw.times[-1], duration=duration_epochs
    )
    epochs = mne.Epochs(
        raw, events, tmin=0, tmax=duration_epochs, baseline=(None, None), preload=True
    )

    # check segments for NaNs, should be automatically rejected by mne.Epochs
    assert np.sum(np.isnan(epochs.get_data())) == 0

    # convert epochs to 3d matrix
    arr3d = epochs.get_data()

    # save as numpy array
    np.save(npy_file_name, arr3d)
    np.save(chname_file_name, epochs.ch_names)

    # save as mat filej
    savemat(
        mat_file_name, {"subject": subject, "data": arr3d, "channels": epochs.ch_names}
    )

    print("done!")
