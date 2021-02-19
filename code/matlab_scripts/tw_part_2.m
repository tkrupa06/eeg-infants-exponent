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
%   Part 2 - Artefact reduction and filtering
%
% Instructions:
%   1. Use EEGLAB GUI to execute commands
%   2. Get equivalent MATLAB function calls using eegh
%   3. Insert the function calls in this script
%   4. Overwrite all data in memory, avoid making copies
%
% If needed, refer to the comprehensive set of scripting tutorials here:
%   https://eeglab.org/tutorials/11_Scripting/
%
% --------------------------------------------------------------------------------------

% Step 0: Clear environment and initialize path to .set file


% Step 1: Launch EEGLAB


% Step 2: Read .set file


% Step 3: Clean data using ASR with the following parameters
%   Remove channel drift
%        Linear filter transition band = [0.25, 0.75] 
%   Remove bad channels
%       channel flat for more than 5 seconds
%       maximum std of high frequency noise = 5
%       minimum correlation with nearby channels = 0.6
%   Perform ASR bad burst correction
%       maximum std of windows = 20
%       use Euclidean distance metric
%       don't remove bad data epochs, instead correct them
%   Additional removal of bad data periods = off


% Step 4: Update dataset comments with datetime stamp and details of step 3


% Step 5: Spherical interpolation of removed channels using stored copy of channel locs


% Step 6: Update dataset comments with details of step 5


% Step 7: Bandpass FIR filter 2-40Hz without plotting frequency response


% Step 8: Update dataset comments with details of step 7


% Step 9: Save .set file with new filename with ASR_FIR appended


% Step 10: Redraw EEGLAB GUI


