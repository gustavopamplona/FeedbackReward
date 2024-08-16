% Define parameters for 1st Level analysis - Feedback Reward - Pamplona 2020

% Gustavo Pamplona, 05.10.2022

% Reviewed 20.11.2023

clear

n_subj=15;
n_sess=2;
n_runs = 5;
n_valid_trials=4;
nVols = 190;
min_fb_value = 1;
max_fb_value = 21;

data_folder='D:\Feedback_reward\Data\Data_Pamplona';
subject_folder=dir(data_folder);
subject_folder(1:2)=[];

analysisFolder='D:\Feedback_reward\Analysis\Analysis_Pamplona\';

data_file=[analysisFolder filesep 'Dist_Pamplona2020\fbvalues_pamplona.xlsx'];
data_mat=table2cell(readtable(data_file));

onset_file=[analysisFolder filesep 'Pamplona2020_task-nfb_events.csv'];
onset_table=readtable(onset_file);
onset_cell=table2cell(onset_table);

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
        
        idx_cell=find([data_mat{:,1}]==subj & [data_mat{:,2}]==sess); % search for indexes of subj and session
        
        vec_fb_original=cell2mat(data_mat(idx_cell,4)); % vector of feedback values and censored trials for specific subj and session
        vec_fb = (vec_fb_original-min_fb_value)/(max_fb_value-min_fb_value);
        vec_censor=data_mat(idx_cell,5);
        
        mat_fb=reshape(vec_fb,n_valid_trials,n_runs); % matrix of feedback values and censored trials for specific subj and session
        mat_censor=reshape(vec_censor,n_valid_trials,n_runs);
        mat_censor(5,:)={'censor'}; % special situation Pamplona 2020: last feedback not included
        
        for run=1:n_runs
            
            if sess == 1
                funcFolder=[data_folder filesep subject_folder(subj).name '\Run0' num2str(run)];
            else
                if length(num2str(run+5))==1
                    funcFolder=[data_folder filesep subject_folder(subj).name '\Run0' num2str(run+5)];
                else
                    funcFolder=[data_folder filesep subject_folder(subj).name '\Run' num2str(run+5)];
                end
            end
            
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
                    if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<=4 % only gets the uncensored trials
                        vec_fb_onset(m)=onset_cell{i,1};
                        vec_fb_duration(m)=onset_cell{i,2};
                        vec_fb_value(m)=mat_fb(cell2mat(onset_cell(i,4)),run);
                        m=m+1;
                    elseif strcmp(onset_cell(i,3),'regulation')
                        vec_reg_onset(n)=onset_cell{i,1};
                        vec_reg_duration(n)=onset_cell{i,2};
                        n=n+1;
                    end
                    
                    if strcmp(onset_cell(i,3),'feedback') && strcmp(mat_censor(cell2mat(onset_cell(i,4)),run),'no') && cell2mat(onset_cell(i,4))<=4 % only gets the uncensored trials
                        vec_reg2_onset(o)=onset_cell{i+2,1};
                        vec_reg2_duration(o)=4;
                        vec_reg2_value(o)=mat_fb(cell2mat(onset_cell(i,4)),run); % only the feedback values of valid regulation blocks
                        o=o+1;
                    elseif strcmp(onset_cell(i,3),'regulation')
                        vec_reg2after_onset(q)=onset_cell{i,1}+4; % rest of the regulation block
                        vec_reg2after_duration(q)=onset_cell{i,2}-4; % rest of the regulation block
                        q=q+1;
                    end
                    if strcmp(onset_cell(i,3),'feedback')
                        vec_fb2_onset(p)=onset_cell{i,1};
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
            
            cumul_time=[cumul_time 2*nVols];
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