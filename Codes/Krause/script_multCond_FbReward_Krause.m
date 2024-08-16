% Define parameters for 1st Level analysis - Feedback Reward - Krause

% Gustavo Pamplona, 05.10.2022

% Reviewed 21.12.2023

clear

n_subj=3;
n_sess=3;
% n_runs = 8; % number of runs changes for session in Amano and Krause's studies
n_valid_trials=15;
nVols = 600;
% min_fb_value = 0; % (Pamplona, Scheinost, Amano)
min_fb_value = -1; % (Krause)
max_fb_value = 1;
TR=1;

data_folder='D:\Feedback_reward\Data\Data_Krause\';
subject_folder=dir(data_folder);
subject_folder(1:2)=[];

analysisFolder='D:\Feedback_reward\Analysis\Analysis_Krause\';

data_file=['D:\Feedback_reward\Analysis\Distribution\Dist_Krause2021\fbvalues_krause.xlsx'];
data_mat=table2cell(readtable(data_file));

onset_file=[analysisFolder filesep 'Krause2021_task-nfb_events.csv']; % there are files for each run in Amano's study
onset_table=readtable(onset_file);
onset_cell=table2cell(onset_table);

% FBonset_file=[analysisFolder filesep 'feedback_onset_times.xlsx']; % not necessary in Amano and Krause's studies
% FBonset_table=readtable(FBonset_file);
% FBonset_cell=table2cell(FBonset_table);

for subj=3:n_subj % in Krause's study, it starts from subject 2 and it goes to subject 11
    
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
        
%         idx_cell=find([data_mat{:,1}]==subj & [data_mat{:,2}]==sess); % search for indexes of subj and session % Amano
        idx_cell=find([data_mat{:,1}]==subj+1 & [data_mat{:,2}]==sess); % search for indexes of subj and session % Krause

%         idx_cell=find([data_mat{:,1}]==subj); % search for indexes of subj and session
        
%         vec_fb_original=cell2mat(data_mat(idx_cell,4)); % vector of feedback values and censored trials for specific subj and session (Pamplona, Scheinost, Amano)
        vec_fb_original=cell2mat(data_mat(idx_cell,5)); % vector of feedback values and censored trials for specific subj and session (Krause)
        vec_fb_original(vec_fb_original>1)=1; % this line and the next is because the feedback shown couldn't be higher than 1 or lower than 0
%         vec_fb_original(vec_fb_original<0)=0; % (Pamplona, Scheinost, Amano)
        vec_fb_original(vec_fb_original<-1)=-1; % (Krause)
        vec_fb = (vec_fb_original-min_fb_value)/(max_fb_value-min_fb_value);
%         vec_censor=data_mat(idx_cell,5); % (Pamplona, Scheinost, Amano)
        vec_censor=data_mat(idx_cell,6); % (Krause)
        
        vec_direction = data_mat(idx_cell,4); % (Krause)
        
        if subj == 1 && sess == 1
            vec_fb = [vec_fb(1:15);NaN;vec_fb(16:30);NaN;vec_fb(31:end)]; % special case Krause
            vec_censor = [vec_censor(1:15);'censor';vec_censor(16:30);'censor';vec_censor(31:end)];
            vec_direction = [vec_direction(1:15);'none';vec_direction(16:30);'none';vec_direction(31:end)]; % (Krause)
        end
        
%         n_runs = length(dir(fullfile([data_folder filesep subject_folder(subj).name '\func\ses-' num2str(sess)], '*events.csv'))); % (Amano)
        mat_fb=[];
%         mat_fb=reshape(vec_fb,n_valid_trials,n_runs); % matrix of feedback values and censored trials for specific subj and session (Pamplona, Scheinost, Amano)
        mat_fb=reshape(vec_fb,n_valid_trials+1,length(vec_fb)/(n_valid_trials+1)); % matrix of feedback values and censored trials for specific subj and session (Krause)
        mat_censor=[];
%         mat_censor=reshape(vec_censor,n_valid_trials,n_runs); % (Scheinost, Amano)
        mat_censor=reshape(vec_censor,n_valid_trials+1,length(vec_fb)/(n_valid_trials+1)); % (Krause)
        mat_censor(end,:)={'censor'}; % special situation Pamplona 2020: last feedback not included
        if strcmp(subject_folder(subj).name,'sub-002') && sess == 1 % special case Krause
            mat_censor(end-1,1)={'censor'};
            mat_censor(end-1,2)={'censor'};
        end
        mat_direction=reshape(vec_direction,n_valid_trials+1,length(vec_fb)/(n_valid_trials+1)); % (Krause)


%         for i=1:size(mat_censor,2) % special situation Amano: if there's only one valid trial (not censored) in a run, the run is discarded
%             if nnz(strcmp(mat_censor(:,i),'no'))==1
%                 mat_censor(:,i)=repmat({'censor'},[n_valid_trials,1]);
%             end
%         end
        
        for run=1:length(vec_fb)/(n_valid_trials+1)
            
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
            m=1;n=1;o=1;p=1;q=1;
            
            for i=1:size(onset_cell,1)
%                 if ~isnan(cell2mat(onset_cell(i,4)))
                if ~isnan(cell2mat(onset_cell(i,5))) % (Krause)
                    if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<=n_valid_trials % only gets the uncensored trials
                        vec_fb_onset(m)=onset_cell{i,1};
%                         row_FBonset=find(cell2mat(FBonset_cell(:,1))==subj & cell2mat(FBonset_cell(:,2))==run); % the 4 following lines are specific to Scheinost's study, because the FB onset varied. Otherwise, the line above should be considered
%                         column_FBonset=onset_cell{i,4}+2;
%                         FBonset_value=str2num(FBonset_cell{row_FBonset,column_FBonset});
%                         vec_fb_onset(m)=onset_cell{i,1}-3+FBonset_value-8;
                        
                        vec_fb_duration(m)=onset_cell{i,2};
                        
                        if strcmp(mat_direction(cell2mat(onset_cell(i,4)),run),'up') % (Krause)
                            vec_fb_value(m)=mat_fb(cell2mat(onset_cell(i,4)),run);
                        elseif strcmp(mat_direction(cell2mat(onset_cell(i,4)),run),'down')
                            vec_fb_value(m)=1-mat_fb(cell2mat(onset_cell(i,4)),run);
                        end
                        m=m+1;
                    elseif strcmp(onset_cell(i,3),'regulation') % Pamplona, Scheinost, Krause
%                     elseif strcmp(onset_cell(i,3),'induction') % Amano
                        vec_reg_onset(n)=onset_cell{i,1}; % Pamplona, Amano, Krause
%                         vec_reg_onset(n)=onset_cell{i,1}-8; % Scheinost
                        vec_reg_duration(n)=onset_cell{i,2};
                        n=n+1;
                    end
                    
%                     if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<=n_valid_trials % only gets the uncensored trials %Pamplona
%                     if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<n_valid_trials % only gets the uncensored trials %Scheinost, Amano
                    if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<=n_valid_trials-1 % only gets the uncensored trials % Krause
%                         vec_reg2_onset(o)=onset_cell{i+2,1}; % Pamplona, Amano
                        if sess == 1 && run <= 2 % (Krause)
                            vec_reg2_onset(o)=onset_cell{i+2,1}; 
                        else
                            vec_reg2_onset(o)=onset_cell{i+6,1};
                        end
%                         vec_reg2_onset(o)=onset_cell{i+2,1}-8; % Scheinost
                        vec_reg2_duration(o)=4;
%                         vec_reg2_value(o)=mat_fb(cell2mat(onset_cell(i,4)),run); % only the feedback values of valid regulation blocks
                        if strcmp(mat_direction(cell2mat(onset_cell(i,4)),run),'up') % (Krause)
                            vec_reg2_value(o)=mat_fb(cell2mat(onset_cell(i,4)),run);
                        elseif strcmp(mat_direction(cell2mat(onset_cell(i,4)),run),'down')
                            vec_reg2_value(o)=1-mat_fb(cell2mat(onset_cell(i,4)),run);
                        end
                        o=o+1;
                    elseif strcmp(onset_cell(i,3),'regulation') % Pamplona, Scheinost, Krause
%                     elseif strcmp(onset_cell(i,3),'induction') % Amano
                        vec_reg2after_onset(q)=onset_cell{i,1}+4; % rest of the regulation block % Pamplona, Amano, Krause
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
    
%     if length(num2str(subj))==1
    if length(num2str(subj+1))==1 % (Krause)
%         save([data_folder filesep subject_folder(subj).name filesep 'conds_subj0' num2str(subj)],'vec_fb_onset_all','vec_fb_duration_all','vec_fb_value_all',...
        save([data_folder filesep subject_folder(subj).name filesep 'conds_subj0' num2str(subj+1)],'vec_fb_onset_all','vec_fb_duration_all','vec_fb_value_all',...
            'vec_reg_onset_all','vec_reg_duration_all','vec_reg2_onset_all','vec_reg2_duration_all','vec_reg2_value_all','vec_fb2_onset_all','vec_fb2_duration_all',...
            'vec_reg2after_onset_all','vec_reg2after_duration_all')
    else
%         save([data_folder filesep subject_folder(subj).name filesep 'conds_subj' num2str(subj)],'vec_fb_onset_all','vec_fb_duration_all','vec_fb_value_all',...
        save([data_folder filesep subject_folder(subj).name filesep 'conds_subj' num2str(subj+1)],'vec_fb_onset_all','vec_fb_duration_all','vec_fb_value_all',...
            'vec_reg_onset_all','vec_reg_duration_all','vec_reg2_onset_all','vec_reg2_duration_all','vec_reg2_value_all','vec_fb2_onset_all','vec_fb2_duration_all',...
            'vec_reg2after_onset_all','vec_reg2after_duration_all')
    end
end