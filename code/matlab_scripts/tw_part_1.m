% --------------------------------------------------------------------------------------
%
%   _______           _         _                           _                  _
%  |__   __|         (_)       (_)                         | |                | |
%     | | _ __  __ _  _  _ __   _  _ __    __ _  __      __| |__    ___   ___ | | ___
%     | || '__|/ _` || || '_ \ | || '_ \  / _` | \ \ /\ / /| '_ \  / _ \ / _ \| |/ __|
%     | || |  | (_| || || | | || || | | || (_| |  \ V  V / | | | ||  __/|  __/| |\__ \
%     |_||_|   \__,_||_||_| |_||_||_| |_| \__, |   \_/\_/  |_| |_| \___| \___||_||___/
%                                          __/ |
%                                         |___/
%
% --------------------------------------------------------------------------------------
%
% Single subject EEG data processing using EEGLAB
%   Part 1 - IO and basic cleaning
%
% Instructions:
%   1. Use EEGLAB GUI to execute commands
%   2. Get equivalent MATLAB function calls using eegh
%   3. Insert the function calls in this script
%
% If needed, refer to the comprehensive set of scripting tutorials here:
%   https://eeglab.org/tutorials/11_Scripting/
%
% --------------------------------------------------------------------------------------

% Step 0: Initialize path to .BDF data file


% Step 1: Launch EEGLAB


% Step 2: Read .BDF file using the BIOSIG interface - only the first 32 channels


% Step 3: Fix channel labels
chan_names = split({EEG.chanlocs.labels}, "-"); % Split string based on hyphen
chan_names = squeeze(chan_names(:, :, 2)); % Take the right segments of the split
[EEG.chanlocs.labels] = chan_names{:}; % Assign to struct field

% Step 4: Add channel locations using default BESA 10-5 location file


% Step 5: Make a copy of channel locations and store separately inside EEG struct
%   This will be useful later on for interpolation


% Step 6: Save data as EEGLAB .set file


% Step 7: Redraw EEGLAB GUI


