
% Single subject EEG data processing using EEGLAB
%   Part 1 - IO and basic cleaning
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

% Step 0: Clear environment and initialize path to .BDF data file
clear all;
eeg_file = '/home/krupa/Projects/eeg-infants-exponent/data/TD11v1.bdf';

% Step 1: Launch EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Step 2: Read .BDF file using the BIOSIG interface - only the first 32 channels
%   add subject identifier as file name
EEG = pop_biosig('/home/krupa/Projects/eeg-infants-exponent/data/infanteeg/TD11v1.bdf', 'channels',[1:32] );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','TD11v1','gui','off'); 

% Step 3: Update dataset comments with datetime stamp and relevant metadata
EEG = eeg_checkset( EEG );
EEG.comments = pop_comments(EEG.comments, '', strvcat(' ','Date : 20210219','Time: 12:01:50'), 1);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% Step 4: Fix channel labels
chan_names = split({EEG.chanlocs.labels}, "-"); % Split string based on hyphen
chan_names = squeeze(chan_names(:, :, 2)); % Take the right segments of the split
[EEG.chanlocs.labels] = chan_names{:}; % Assign to struct field

% Step 5: Update dataset comments decsribing step 4
EEG = eeg_checkset( EEG );
EEG.comments = pop_comments('', '', strvcat('Original file:','/home/krupa/Projects/eeg-infants-exponent/data/infanteeg/TD11v1.bdf',' ','Date : 20210219','Time: 12:01:50','Step 4 helps to clean channel labels by removing nubers and only keeping relevant channel label names.'));
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% Step 6: Add channel locations using default BESA 10-5 location file
EEG=pop_chanedit(EEG, 'lookup','/home/krupa/Applications/eeglab2021.0/plugins/dipfit/standard_BESA/standard-10-5-cap385.elp');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% Step 7: Update dataset comments decsribing step 6
EEG.comments = pop_comments('', '', strvcat('Original file:','/home/krupa/Projects/eeg-infants-exponent/data/infanteeg/TD11v1.bdf',' ','Date : 20210219','Time: 12:01:50','Step 4 helps to clean channel labels by removing','nubers and only keeping relevant channel label names.',' ','Step 5 helps to channel locations using default BESA 10-5 location file.'));
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% Step 8: Make a copy of channel locations and store separately inside EEG struct
%   This will be useful later on for interpolation
EEG.OGchanlocs = EEG.chanlocs(1,:);

% Step 9: Update dataset comments decsribing step 8
EEG.comments = pop_comments('', '', strvcat('Original file:','/home/krupa/Projects/eeg-infants-exponent/data/infanteeg/TD11v1.bdf',' ','Date : 20210219','Time: 12:01:50','Step 4 helps to clean channel labels by removing','nubers and only keeping relevant channel label names.',' ','Step 8 makes a copy of channel locations and stores it in the EEG struct for future reference for interpolation.',' ','Step 5 helps to channel locations using default BESA','10-5 location file.'));
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% Step 10: Save data as EEGLAB .set file
EEG = pop_saveset( EEG, 'filename','TD11v1.set','filepath','/home/krupa/Projects/eeg-infants-exponent/data/infanteeg_processed/');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% Step 11: Redraw EEGLAB GUI
eeglab redraw;
