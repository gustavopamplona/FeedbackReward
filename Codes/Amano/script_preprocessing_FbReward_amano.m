% fMRI preprocessing of Feedback Reward Study - Amano data

% Gustavo Pamplona, 14.06.2022

clear

data_folder='D:\Feedback_reward\Data\Data_Amano';

n_sess=3;
n_runs=12;

subject_folder=dir(data_folder);
subject_folder(1:2)=[];
n_subj=length(subject_folder);
first_subj=7;

for subj=6
% for subj=first_subj:n_subj
    
    for sess=3
%     for sess=1:n_sess
        
        for run=11:12
%         for run=1:n_runs
            
            skip_preproc=0;
            
            subject_folder(subj).name
            sess
            run
            
            anat_source=[data_folder filesep subject_folder(subj).name filesep 'anat'];
            func_source=[data_folder filesep subject_folder(subj).name filesep 'func\ses-' num2str(sess) filesep subject_folder(subj).name '_task-nfb_bold_run-' num2str(run) '.nii'];
            
            func_file_list=dir(func_source);
            
            for i=3:length(func_file_list)
                if strcmp(func_file_list(i).name(1:4),'swra')
                    skip_preproc=1;
                end
            end
            
            if ~exist(func_source, 'dir')
                skip_preproc=1;
            end
            
            if skip_preproc==0
                
                func_path{1,:}=func_source;
                
                %anat
                anat_files=dir(anat_source);
                anatName=[anat_source '\defaced_mprage.nii'];
                anat_cell{1,1}=char(anatName);
                
                %func
                funcFiles=dir(char(func_path));
                funcfile=funcFiles(3).name;
                funcName=[func_source '\' funcfile];
                
                for j=1:length(spm_vol(funcName))
                    func_cell{1,1}{j,1}=char([funcName ',' num2str(j)]);
                end
                
                load('D:\Feedback_reward\Analysis\Analysis_Amano\batch_preprocessing_FbReward_amano.mat')
                
                % batch
                matlabbatch{1,1}.spm.temporal.st.scans{1,1}=func_cell{1,1};
                matlabbatch{1,3}.spm.spatial.coreg.estimate.source=anat_cell;
                
                spm_jobman('run',matlabbatch);
                
                clear func_cell
            end
        end
    end
end