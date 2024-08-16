% Define parameters for 1st Level analysis - Feedback Reward - Keller 2021

% Gustavo Pamplona, 05.10.2022

% Reviewed 03.01.2024

clear

n_subj=37;
n_sess=2;
n_runs = 4; % number of runs changes for session in Amano's study
n_valid_trials=9;
nVols = 230;
min_fb_value = 1;
max_fb_value = 100;
TR=2;

% data_folder='D:\Feedback_reward\Data\Data_Amano\'; % not necessary for the Aachen's studies
% subject_folder=dir(data_folder);
% subject_folder(1:2)=[];

analysisFolder='D:\Feedback_reward\Analysis\Analysis_Keller2021\';

data_file=[analysisFolder filesep 'Dist_Keller2021\fbvalues_Keller2021.xlsx'];
data_mat=table2cell(readtable(data_file));

onset_file=[analysisFolder filesep 'Keller2021_task-nfb_events.csv']; % there are files for each run in Amano's study
onset_table=readtable(onset_file);
onset_cell=table2cell(onset_table);

% FBonset_file=[analysisFolder filesep 'feedback_onset_times.xlsx']; % only necessary for Scheinost's study
% FBonset_table=readtable(FBonset_file);
% FBonset_cell=table2cell(FBonset_table);

for subj=1:n_subj
    
%     subject_folder(subj).name
    subj
    
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
    
    vec_training_onset_all=[];
    vec_training_duration_all=[];
    vec_view_onset_all=[];
    vec_view_duration_all=[];
    vec_percent_onset_all=[];
    vec_percent_duration_all=[];
    vec_emotion_onset_all=[];
    vec_emotion_duration_all=[];

    for sess=1:n_sess
        
        idx_cell=find([data_mat{:,1}]==subj & [data_mat{:,2}]==sess); % search for indexes of subj and session % Amano, Keller
%         idx_cell=find([data_mat{:,1}]==subj); % search for indexes of subj and session
        
        vec_fb_original=cell2mat(data_mat(idx_cell,5)); % vector of feedback values and censored trials for specific subj and session
%         vec_fb_original(vec_fb_original>1)=1; % this line and the next is because the feedback shown couldn't be higher than 1 or lower than 0
%         vec_fb_original(vec_fb_original<0)=0;
        vec_fb_original(vec_fb_original>100)=100; % this line and the next is because the feedback shown couldn't be higher than 1 or lower than 0 % Keller 2021
        vec_fb_original(vec_fb_original<1)=1;
        vec_fb = (vec_fb_original-min_fb_value)/(max_fb_value-min_fb_value);
        vec_censor=data_mat(idx_cell,6);
        
        %n_runs = length(dir(fullfile([data_folder filesep subject_folder(subj).name '\func\ses-' num2str(sess)], '*events.csv'))); % not necessary for Keller 2021
        mat_fb=[];
        mat_fb=reshape(vec_fb,n_valid_trials,n_runs); % matrix of feedback values and censored trials for specific subj and session
        mat_censor=[];
        mat_censor=reshape(vec_censor,n_valid_trials,n_runs); 
%         mat_censor(5,:)={'censor'}; % special situation Pamplona 2020: last feedback not included

%         for i=1:size(mat_censor,2) % special situation Amano: if there's only one valid trial (not censored) in a run, the run is discarded
%             if nnz(strcmp(mat_censor(:,i),'no'))==1
%                 mat_censor(:,i)=repmat({'censor'},[n_valid_trials,1]);
%             end
%         end
        
        for run=1:n_runs
            
%             onset_file=[data_folder filesep subject_folder(subj).name filesep '\func\ses-' num2str(sess) filesep subject_folder(subj).name '_task-nfb_run-' num2str(run) '_events.csv']; % there are files for each run in Amano's study
%             onset_table=readtable(onset_file);
%             onset_cell=table2cell(onset_table);
            
%             funcFolder=[data_folder filesep subject_folder(subj).name '\func\ses-' num2str(sess) filesep subject_folder(subj).name '_task-nfb_bold_run-' num2str(run) '.nii'];
            
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
            m=1;n=1;o=1;p=1;q=1;r=1;s=1;t=1;u=1;
            
            vec_training_onset=[];
            vec_training_duration=[];
            vec_view_onset=[];
            vec_view_duration=[];
            vec_percent_onset=[];
            vec_percent_duration=[];
            vec_emotion_onset=[];
            vec_emotion_duration=[];
            
            for i=1:size(onset_cell,1)
                if ~isnan(cell2mat(onset_cell(i,4)))
                    if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<=n_valid_trials % only gets the uncensored trials
%                         vec_fb_onset(m)=onset_cell{i,1};
                        vec_fb_onset(m)=onset_cell{i,1}-20; % Keller 2021
%                         row_FBonset=find(cell2mat(FBonset_cell(:,1))==subj & cell2mat(FBonset_cell(:,2))==run); % the 4 following lines are specific to Scheinost's study, because the FB onset varied. Otherwise, the line above should be considered
%                         column_FBonset=onset_cell{i,4}+2;
%                         FBonset_value=str2num(FBonset_cell{row_FBonset,column_FBonset});
%                         vec_fb_onset(m)=onset_cell{i,1}-3+FBonset_value-8;
                        
                        vec_fb_duration(m)=onset_cell{i,2};
                        vec_fb_value(m)=mat_fb(cell2mat(onset_cell(i,4)),run);
                        m=m+1;
                    elseif strcmp(onset_cell(i,3),'regulation') % Pamplona, Scheinost
%                     elseif strcmp(onset_cell(i,3),'induction') % Amano
%                         vec_reg_onset(n)=onset_cell{i,1}; % Pamplona, Amano
                        vec_reg_onset(n)=onset_cell{i,1}-20; % Keller
%                         vec_reg_onset(n)=onset_cell{i,1}-8; % Scheinost
                        vec_reg_duration(n)=onset_cell{i,2};
                        n=n+1;
                    end
                    
%                     if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<=n_valid_trials % only gets the uncensored trials %Pamplona
                    if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<n_valid_trials % only gets the uncensored trials %Scheinost, Amano
%                         vec_reg2_onset(o)=onset_cell{i+2,1}; % Pamplona, Amano
%                         vec_reg2_onset(o)=onset_cell{i+2,1}-8; % Scheinost
                        vec_reg2_onset(o)=onset_cell{i+4,1}-20; % Keller
                        vec_reg2_duration(o)=4;
                        vec_reg2_value(o)=mat_fb(cell2mat(onset_cell(i,4)),run); % only the feedback values of valid regulation blocks
                        o=o+1;
                    elseif strcmp(onset_cell(i,3),'regulation')
%                     elseif strcmp(onset_cell(i,3),'induction') % Amano
%                         vec_reg2after_onset(q)=onset_cell{i,1}+4; % rest of the regulation block % Pamplona, Amano
%                         vec_reg2after_onset(q)=onset_cell{i,1}+4-8; % rest of the regulation block % Scheinost
                        vec_reg2after_onset(q)=onset_cell{i,1}+4-20; % rest of the regulation block % Keller
                        vec_reg2after_duration(q)=onset_cell{i,2}-4; % rest of the regulation block
                        q=q+1;
                    end
                    if strcmp(onset_cell(i,3),'feedback')
%                         vec_fb2_onset(p)=onset_cell{i,1};
                        vec_fb2_onset(p)=onset_cell{i,1}-20;
%                         row_FBonset=find(cell2mat(FBonset_cell(:,1))==subj & cell2mat(FBonset_cell(:,2))==run); % the 4 following lines are specific to Scheinost's study, because the FB onset varied. Otherwise, the line above should be considered
%                         column_FBonset=onset_cell{i,4}+2;
%                         FBonset_value=str2num(FBonset_cell{row_FBonset,column_FBonset});
%                         vec_fb2_onset(p)=onset_cell{i,1}-3+FBonset_value-8;

                        vec_fb2_duration(p)=onset_cell{i,2};
                        p=p+1;
                    end
                    if strcmp(onset_cell(i,3),'training')
                        vec_training_onset(r)=onset_cell{i,1}-20;
                        vec_training_duration(r)=onset_cell{i,2};
                        r=r+1;
                    end
                    if strcmp(onset_cell(i,3),'view')
                        vec_view_onset(s)=onset_cell{i,1}-20;
                        vec_view_duration(s)=onset_cell{i,2};
                        s=s+1;
                    end
                    if strcmp(onset_cell(i,3),'percentsign')
                        vec_percent_onset(t)=onset_cell{i,1}-20;
                        vec_percent_duration(t)=onset_cell{i,2};
                        t=t+1;
                    end
                    if strcmp(onset_cell(i,3),'emotion')
                        vec_emotion_onset(u)=onset_cell{i,1}-20;
                        vec_emotion_duration(u)=onset_cell{i,2};
                        u=u+1;
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
            
            vec_training_onset_all=[vec_training_onset_all,vec_training_onset+add_time];
            vec_training_duration_all=[vec_training_duration_all,vec_training_duration];
            vec_view_onset_all=[vec_view_onset_all,vec_view_onset+add_time];
            vec_view_duration_all=[vec_view_duration_all,vec_view_duration];
            vec_percent_onset_all=[vec_percent_onset_all,vec_percent_onset+add_time];
            vec_percent_duration_all=[vec_percent_duration_all,vec_percent_duration];
            vec_emotion_onset_all=[vec_emotion_onset_all,vec_emotion_onset+add_time];
            vec_emotion_duration_all=[vec_emotion_duration_all,vec_emotion_duration];
            
%             cumul_time=[cumul_time TR*nVols]; % Pamplona, Amano
%             cumul_time=[cumul_time TR*nVols-8]; % Scheinost
            cumul_time=[cumul_time TR*nVols-20]; % Keller
            add_time=sum(cumul_time);
        end
    end
    
    if length(num2str(subj))==1
%         save([data_folder filesep subject_folder(subj).name filesep 'conds_subj0' num2str(subj)],'vec_fb_onset_all','vec_fb_duration_all','vec_fb_value_all',...
        save([analysisFolder filesep 'Cond_files' filesep 'conds_subj0' num2str(subj)],'vec_fb_onset_all','vec_fb_duration_all','vec_fb_value_all',...
            'vec_reg_onset_all','vec_reg_duration_all','vec_reg2_onset_all','vec_reg2_duration_all','vec_reg2_value_all','vec_fb2_onset_all','vec_fb2_duration_all',...
            'vec_reg2after_onset_all','vec_reg2after_duration_all', 'vec_training_onset_all', 'vec_training_duration_all', 'vec_view_onset_all', 'vec_view_duration_all', 'vec_percent_onset_all', 'vec_percent_duration_all', 'vec_emotion_onset_all', 'vec_emotion_duration_all')
    else
%         save([data_folder filesep subject_folder(subj).name filesep 'conds_subj' num2str(subj)],'vec_fb_onset_all','vec_fb_duration_all','vec_fb_value_all',...
        save([analysisFolder filesep 'Cond_files' filesep 'conds_subj' num2str(subj)],'vec_fb_onset_all','vec_fb_duration_all','vec_fb_value_all',...
            'vec_reg_onset_all','vec_reg_duration_all','vec_reg2_onset_all','vec_reg2_duration_all','vec_reg2_value_all','vec_fb2_onset_all','vec_fb2_duration_all',...
            'vec_reg2after_onset_all','vec_reg2after_duration_all', 'vec_training_onset_all', 'vec_training_duration_all', 'vec_view_onset_all', 'vec_view_duration_all', 'vec_percent_onset_all', 'vec_percent_duration_all', 'vec_emotion_onset_all', 'vec_emotion_duration_all')
    end
end