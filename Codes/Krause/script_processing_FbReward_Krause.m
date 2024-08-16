% fMRI preprocessing of Feedback Reward Study - Krause data

% Gustavo Pamplona, 14.06.2022

clear

data_folder='D:\Feedback_reward\Data\Data_Krause';

n_sess=3;
n_runs=8;

subject_folder=dir(data_folder);
subject_folder(1:3)=[];
n_subj=length(subject_folder);
first_subj=7;

for subj=6
%     for subj=first_subj:n_subj
    
    for sess=3:n_sess
        
        for run=1:5
            
            subject_folder(subj).name
            sess
            run
            
            anat_source=[data_folder filesep subject_folder(subj).name filesep 'ses-mri0' num2str(sess) '\anat'];
            func_source=[data_folder filesep subject_folder(subj).name filesep 'ses-mri0' num2str(sess) '\func\Run0' num2str(run)];
            
            func_path{1,:}=func_source;
            
            %anat
            anat_files=dir(anat_source);
            anatName=[anat_source '\' anat_files(3).name];
            anat_cell{1,1}=char(anatName);
            
            %func
            if exist(char(func_path))
                funcFiles=dir(char(func_path));
                funcfile=funcFiles(3).name;
                funcName=[func_source '\' funcfile];
                
                for j=1:length(spm_vol(funcName))
                    func_cell{1,1}{j,1}=char([funcName ',' num2str(j)]);
                end
                
                load('D:\Feedback_reward\Analysis\Analysis_Krause\batch_processing_FbReward_Krause.mat')
                
                % batch
                matlabbatch{1,1}.spm.temporal.st.scans{1,1}=func_cell{1,1};
                matlabbatch{1,3}.spm.spatial.coreg.estimate.source=anat_cell;
                
                spm_jobman('run',matlabbatch);
                
                clear func_cell
            end
        end
    end
end