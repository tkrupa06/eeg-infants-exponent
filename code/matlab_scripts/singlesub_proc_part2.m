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
clear all; 
eeg_file = '/home/krupa/Projects/eeg-infants-exponent/data/infanteeg_processed/TD11v1.set';

% Step 1: Launch EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Step 2: Read .set file
EEG = pop_loadset('filename','TD11v1.set','filepath','/home/krupa/Projects/eeg-infants-exponent/data/infanteeg_processed/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
eeglab redraw;

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
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'retrieve',1,'study',0); 
EEG = eeg_checkset( EEG );
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.6,'LineNoiseCriterion',5,'Highpass','off','BurstCriterion',20,'WindowCriterion','off','BurstRejection','off','Distance','Riemannian');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% Step 4: Update dataset comments with datetime stamp and details of step 3
EEG = eeg_checkset( EEG );
EEG.comments = pop_comments('', '', strvcat('Original file:','/home/krupa/Projects/eeg-infants-exponent/data/infanteeg/TD11v1.bdf',' ','Date : 20210219','Time: 12:01:50','Step 4 helps to clean channel labels by removing','nubers and only keeping relevant channel label names.',' ','Step 8 makes a copy of channel locations and stores','it in the EEG struct for future reference for','interpolation.',' ','Step 5 helps to channel locations using default BESA','10-5 location file.',' ',' ','Dataset file is cleaned using ASR with following parameters: 1. Remove channel drift (Linear filter transition band = [0.25, 0.75]); 2. Remove bad channels (channel flat for more than 5 seconds, maximum std of high frequency noise = 5, minimum correlation with nearby channels = 0.6); 3. Perform ASR bad burst correction (maximum std of windows = 20,','use Euclidean distance metric, don''t remove bad data epochs, instead correct them); 4. Additional removal of bad data periods = off.'));
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% Step 5: Spherical interpolation of removed channels using stored copy of channel locs
EEGOUT = pop_interp(EEG, EEG.OGchanlocs,'spherical');


% Step 6: Update dataset comments with details of step 5
EEG = eeg_checkset( EEG );
EEG.comments = pop_comments('', '', strvcat('Original file:','/home/krupa/Projects/eeg-infants-exponent/data/infanteeg/TD11v1.bdf',' ','Date : 20210219','Time: 12:01:50','Step 4 helps to clean channel labels by removing','nubers and only keeping relevant channel label names.',' ','Step 8 makes a copy of channel locations and stores','it in the EEG struct for future reference for','interpolation.',' ','Step 5 helps to channel locations using default BESA','10-5 location file.',' ',' ','Dataset file is cleaned using ASR with following parameters: 1. Remove channel drift (Linear filter transition band = [0.25, 0.75]); 2. Remove bad channels (channel flat for more than 5 seconds, maximum std of high frequency noise = 5, minimum correlation with nearby channels = 0.6); 3. Perform ASR bad burst correction (maximum std of windows = 20,','use Euclidean distance metric, don''t remove bad data epochs, instead correct them); 4. Additional removal of bad data periods = off.', 'Step 5 helps with spherical interpolation of removed channels using stored copy of channel locs'));
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% Step 7: Bandpass FIR filter 2-40Hz without plotting frequency response
EEG = pop_eegfiltnew(EEG, 'locutoff',2,'hicutoff',40);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% Step 8: Update dataset comments with details of step 7
EEG = eeg_checkset( EEG );
EEG.comments = pop_comments('', '', strvcat('Original file:','/home/krupa/Projects/eeg-infants-exponent/data/infanteeg/TD11v1.bdf',' ','Date : 20210219','Time: 12:01:50','Step 4 helps to clean channel labels by removing','nubers and only keeping relevant channel label names.',' ','Step 8 makes a copy of channel locations and stores','it in the EEG struct for future reference for','interpolation.',' ','Step 5 helps to channel locations using default BESA','10-5 location file.',' ',' ','Dataset file is cleaned using ASR with following','parameters: 1. Remove channel drift (Linear filter','transition band = [0.25, 0.75]); 2. Remove bad','channels (channel flat for more than 5 seconds,','maximum std of high frequency noise = 5, minimum','correlation with nearby channels = 0.6); 3. Perform','ASR bad burst correction (maximum std of windows =','20,','use Euclidean distance metric, don''t remove bad data','epochs, instead correct them); 4. Additional removal','of bad data periods = off.','Step 5 helps with spherical interpolation of removed','channels using stored copy of channel locs','Step 7 is to run a bandpass FIR filter 2-40Hz without plotting frequency response and overwrite the result on the current dataset.'));
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% Step 9: Save .set file with new filename with ASR_FIR appended
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','TD11v1_ASR_FIR.set','filepath','/home/krupa/Projects/eeg-infants-exponent/data/infanteeg_processed/');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% Step 10: Redraw EEGLAB GUI
eeglab redraw;
