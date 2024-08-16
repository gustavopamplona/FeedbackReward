% Define parameters for 1st Level analysis - Feedback Reward - Amano

% Gustavo Pamplona, 05.10.2022

% Reviewed 05.12.2023

clear

n_subj=12;
n_sess=3;
% n_runs = 12; % number of runs changes for session in Amano's study
n_valid_trials=15;
nVols = 165;
min_fb_value = 0;
max_fb_value = 1;
TR=2;

data_folder='D:\Feedback_reward\Data\Data_Amano\';
subject_folder=dir(data_folder);
subject_folder(1:2)=[];

analysisFolder='D:\Feedback_reward\Analysis\Analysis_Amano\';

data_file=[analysisFolder filesep 'Dist_Amano2016\fbvalues_amano.xlsx'];
data_mat=table2cell(readtable(data_file));

% onset_file=[analysisFolder filesep 'Scheinost2020_task-nfb_events.csv']; % there are files for each run in Amano's study
% onset_table=readtable(onset_file);
% onset_cell=table2cell(onset_table);

% FBonset_file=[analysisFolder filesep 'feedback_onset_times.xlsx']; % not necessary in Amano's study
% FBonset_table=readtable(FBonset_file);
% FBonset_cell=table2cell(FBonset_table);

for subj=1:n_subj
    
    subject_folder(subj).name
    
    cumul_run=0;
    cumul_time=[];
	add_time=0;
    
    vec_fb_onset_all=[];
    vec_fb_duration_all=[];
    vec_fb_value_all=[];
    vec_reg_onset_all=[];
    vec_reg_duration_all=[];
    
    vec_reg2_onset_all=[];
    vec_reg2_duration_all=[];
    vec_reg2_value_all=[];
    vec_fb2_onset_all=[];
    vec_fb2_duration_all=[];
    
    vec_reg2after_onset_all=[];
    vec_reg2after_duration_all=[];

    for sess=1:n_sess
        
        idx_cell=find([data_mat{:,1}]==subj & [data_mat{:,2}]==sess); % search for indexes of subj and session % Amano
%         idx_cell=find([data_mat{:,1}]==subj); % search for indexes of subj and session
        
        vec_fb_original=cell2mat(data_mat(idx_cell,4)); % vector of feedback values and censored trials for specific subj and session
        vec_fb_original(vec_fb_original>1)=1; % this line and the next is because the feedback shown couldn't be higher than 1 or lower than 0
        vec_fb_original(vec_fb_original<0)=0;
        vec_fb = (vec_fb_original-min_fb_value)/(max_fb_value-min_fb_value);
        vec_censor=data_mat(idx_cell,5);
        
        n_runs = length(dir(fullfile([data_folder filesep subject_folder(subj).name '\func\ses-' num2str(sess)], '*events.csv')));
        mat_fb=[];
        mat_fb=reshape(vec_fb,n_valid_trials,n_runs); % matrix of feedback values and censored trials for specific subj and session
        mat_censor=[];
        mat_censor=reshape(vec_censor,n_valid_trials,n_runs); 
%         mat_censor(5,:)={'censor'}; % special situation Pamplona 2020: last feedback not included

        for i=1:size(mat_censor,2) % special situation Amano: if there's only one valid trial (not censored) in a run, the run is discarded
            if nnz(strcmp(mat_censor(:,i),'no'))==1
                mat_censor(:,i)=repmat({'censor'},[n_valid_trials,1]);
            end
        end
        
        for run=1:n_runs
            
            onset_file=[data_folder filesep subject_folder(subj).name filesep '\func\ses-' num2str(sess) filesep subject_folder(subj).name '_task-nfb_run-' num2str(run) '_events.csv']; % there are files for each run in Amano's study
            onset_table=readtable(onset_file);
            onset_cell=table2cell(onset_table);
            
            funcFolder=[data_folder filesep subject_folder(subj).name '\func\ses-' num2str(sess) filesep subject_folder(subj).name '_task-nfb_bold_run-' num2str(run) '.nii'];
            
            vec_fb_onset=[];
            vec_fb_duration=[];
            vec_fb_value=[];
            vec_reg_onset=[];
            vec_reg_duration=[];
            
            vec_reg2_onset=[];
            vec_reg2_duration=[];
            vec_reg2_value=[];
            vec_fb2_onset=[];
            vec_fb2_duration=[];
            vec_reg2after_onset=[];
            vec_reg2after_duration=[];
            m=1;n=1;o=1;p=1;q=1;
            
            for i=1:size(onset_cell,1)
                if ~isnan(cell2mat(onset_cell(i,4)))
                    if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<=n_valid_trials % only gets the uncensored trials
                        vec_fb_onset(m)=onset_cell{i,1};
%                         row_FBonset=find(cell2mat(FBonset_cell(:,1))==subj & cell2mat(FBonset_cell(:,2))==run); % the 4 following lines are specific to Scheinost's study, because the FB onset varied. Otherwise, the line above should be considered
%                         column_FBonset=onset_cell{i,4}+2;
%                         FBonset_value=str2num(FBonset_cell{row_FBonset,column_FBonset});
%                         vec_fb_onset(m)=onset_cell{i,1}-3+FBonset_value-8;
                        
                        vec_fb_duration(m)=onset_cell{i,2};
                        vec_fb_value(m)=mat_fb(cell2mat(onset_cell(i,4)),run);
                        m=m+1;
%                     elseif strcmp(onset_cell(i,3),'regulation') % Pamplona, Scheinost
                    elseif strcmp(onset_cell(i,3),'induction') % Amano
                        vec_reg_onset(n)=onset_cell{i,1}; % Pamplona, Amano
%                         vec_reg_onset(n)=onset_cell{i,1}-8; % Scheinost
                        vec_reg_duration(n)=onset_cell{i,2};
                        n=n+1;
                    end
                    
%                     if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<=n_valid_trials % only gets the uncensored trials %Pamplona
                    if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<n_valid_trials % only gets the uncensored trials %Scheinost, Amano
                        vec_reg2_onset(o)=onset_cell{i+2,1}; % Pamplona, Amano
%                         vec_reg2_onset(o)=onset_cell{i+2,1}-8; % Scheinost
                        vec_reg2_duration(o)=4;
                        vec_reg2_value(o)=mat_fb(cell2mat(onset_cell(i,4)),run); % only the feedback values of valid regulation blocks
                        o=o+1;
%                     elseif strcmp(onset_cell(i,3),'regulation')
                    elseif strcmp(onset_cell(i,3),'induction') % Amano
                        vec_reg2after_onset(q)=onset_cell{i,1}+4; % rest of the regulation block % Pamplona, Amano
%                         vec_reg2after_onset(q)=onset_cell{i,1}+4-8; % rest of the regulation block % Scheinost
                        vec_reg2after_duration(q)=onset_cell{i,2}-4; % rest of the regulation block
                        q=q+1;
                    end
                    if strcmp(onset_cell(i,3),'feedback')
                        vec_fb2_onset(p)=onset_cell{i,1};
%                         row_FBonset=find(cell2mat(FBonset_cell(:,1))==subj & cell2mat(FBonset_cell(:,2))==run); % the 4 following lines are specific to Scheinost's study, because the FB onset varied. Otherwise, the line above should be considered
%                         column_FBonset=onset_cell{i,4}+2;
%                         FBonset_value=str2num(FBonset_cell{row_FBonset,column_FBonset});
%                         vec_fb2_onset(p)=onset_cell{i,1}-3+FBonset_value-8;

                        vec_fb2_duration(p)=onset_cell{i,2};
                        p=p+1;
                    end
                end
            end
            
            vec_fb_onset_all=[vec_fb_onset_all,vec_fb_onset+add_time];
            vec_fb_duration_all=[vec_fb_duration_all,vec_fb_duration];
            vec_fb_value_all=[vec_fb_value_all,vec_fb_value];
            vec_reg_onset_all=[vec_reg_onset_all,vec_reg_onset+add_time];
            vec_reg_duration_all=[vec_reg_duration_all,vec_reg_duration];
            
            vec_reg2_onset_all=[vec_reg2_onset_all,vec_reg2_onset+add_time];
            vec_reg2_duration_all=[vec_reg2_duration_all,vec_reg2_duration];
            vec_reg2_value_all=[vec_reg2_value_all,vec_reg2_value];
            vec_fb2_onset_all=[vec_fb2_onset_all,vec_fb2_onset+add_time];
            vec_fb2_duration_all=[vec_fb2_duration_all,vec_fb2_duration];
            vec_reg2after_onset_all=[vec_reg2after_onset_all,vec_reg2after_onset+add_time];
            vec_reg2after_duration_all=[vec_reg2after_duration_all,vec_reg2after_duration];
            
            cumul_time=[cumul_time TR*nVols]; % Pamplona, Amano
%             cumul_time=[cumul_time TR*nVols-8]; % Scheinost
            add_time=sum(cumul_time);
        end
    end
    
    if length(num2str(subj))==1
        save([data_folder filesep subject_folder(subj).name filesep 'conds_subj0' num2str(subj)],'vec_fb_onset_all','vec_fb_duration_all','vec_fb_value_all',...
            'vec_reg_onset_all','vec_reg_duration_all','vec_reg2_onset_all','vec_reg2_duration_all','vec_reg2_value_all','vec_fb2_onset_all','vec_fb2_duration_all',...
            'vec_reg2after_onset_all','vec_reg2after_duration_all')
    else
        save([data_folder filesep subject_folder(subj).name filesep 'conds_subj' num2str(subj)],'vec_fb_onset_all','vec_fb_duration_all','vec_fb_value_all',...
            'vec_reg_onset_all','vec_reg_duration_all','vec_reg2_onset_all','vec_reg2_duration_all','vec_reg2_value_all','vec_fb2_onset_all','vec_fb2_duration_all',...
            'vec_reg2after_onset_all','vec_reg2after_duration_all')
    end
end