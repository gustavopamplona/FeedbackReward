%%% Run 1st level analysis for all models together for Feedback Appraisal Study - Scheinost data

% Gustavo Pamplona, 09.09.2022

% Reviewed 30.11.2023

clear

folderName='D:\Feedback_reward';
analysisFolder='D:\Feedback_reward\Analysis\Analysis_Scheinost\';
data_folder='D:\Feedback_reward\Data\Data_Scheinost\MRI';

addpath(analysisFolder)

nsubjs=20;
n_sess=1;
nruns=3;
len=428;

subject_folder=dir(data_folder);
subject_folder(1:2)=[];
first_subj=7;

for subj=first_subj:2:nsubjs
% for subj=first_subj
    
%     n_runs_sess1=[];n_runs_sess2=[];n_runs_sess3=[];
    
    %     %% Preprocessing
    %
    %     for sess=1:n_sess
    %
    %         for run=1:nruns
    %
    %             subject_folder(subj).name
    %             sess
    %             run
    %
    %             anat_source=[data_folder filesep subject_folder(subj).name '\anat'];
    %             if length(num2str(run))==1
    %                 func_source=[data_folder filesep subject_folder(subj).name '\Run0' num2str(run)];
    %             else
    %                 func_source=[data_folder filesep subject_folder(subj).name '\Run' num2str(run)];
    %             end
    %
    %             func_path{1,:}=func_source;
    %
    %             %anat
    % %             anat_files=dir(anat_source);
    % %             anatName=[anat_source '\' anat_files(3).name];
    % %             anat_cell{1,1}=char(anatName);
    %
    %             %func
    %             if exist(char(func_path))
    %                 funcFiles=dir(char(func_path));
    %                 funcfile=funcFiles(4).name;
    %                 funcName=[func_source '\' funcfile];
    %
    %                 for j=1:length(spm_vol(funcName))
    %                     func_cell{1,1}{j,1}=char([funcName ',' num2str(j)]);
    %                 end
    %
    %                 load('D:\Feedback_reward\Analysis\Analysis_Krause\batch_processing_FbReward_Krause.mat')
    %
    %                 % batch
    %                 matlabbatch{1,1}.spm.temporal.st.scans{1,1}=func_cell{1,1};
    %                 matlabbatch{1,3}.spm.spatial.coreg.estimate.source=anat_cell;
    %
    %                 spm_jobman('run',matlabbatch);
    %
    %                 clear func_cell
    %             end
    %         end
    %     end
%     
%         %% Concatenate realignment parameters
%         if length(num2str(subj))==1
%             subjFolder=[data_folder filesep 'Sub0' num2str(subj)];
%         else
%             subjFolder=[data_folder filesep 'Sub' num2str(subj)];
%         end
%     
%         cumul_c=[];
%         for run = 1:nruns
%             rpFolder=[subjFolder filesep 'func\Run' num2str(run)'];
%             
%             rpStructure=dir([rpFolder filesep 'rp*.txt']);
%             rpFile=[rpFolder filesep rpStructure.name];
%     
%             fid = fopen(rpFile);
%             c=cell2mat(textscan(fid,'%f%f%f%f%f%f'));
%             fclose(fid);
%             
%             c(1:4,:)=[];
%     
%             cumul_c=[cumul_c;c];
%     
%             clear c
%         end
%     
%         if length(num2str(subj))==1
%             filename=['mult_reg_subj0' num2str(subj)];
%         else
%             filename=['mult_reg_subj' num2str(subj)];
%         end
%     
%         dlmwrite([subjFolder filesep filename '.txt'],cumul_c,'delimiter','\t','precision','%.10f')
    
    
    %% 1st level specification - Model 1
    
    subj
    
    load([analysisFolder 'batch_1stLevel_Feedback_spec_model1_scheinost.mat'])
    
    if length(num2str(subj))==1
        directory1=[data_folder '\Sub0' num2str(subj) '\1stLevel_1']; % directory
        subj_folder=[data_folder '\Sub0' num2str(subj)]; % subject folder
        load([subj_folder filesep 'conds_subj0' num2str(subj) '.mat']) % conditions specs
        multi_reg_file=[subj_folder '\mult_reg_subj0' num2str(subj) '.txt']; % multiple regressors file
    else
        directory1=[data_folder '\Sub' num2str(subj) '\1stLevel_1']; % directory
        subj_folder=[data_folder '\Sub' num2str(subj)]; % subject folder
        load([subj_folder filesep 'conds_subj' num2str(subj) '.mat']) % conditions specs
        multi_reg_file=[subj_folder '\mult_reg_subj' num2str(subj) '.txt']; % multiple regressors file
    end
    
    func_cell{1,1}={};
    
    for sess=1:n_sess
        
        for run=1:nruns
            
%             if length(num2str(run))==1 % Scheinost: those lines are not necessary
%                 func_source=[subj_folder '\func\Run0' num2str(run)]; % functional images folder
%             else
                func_source=[subj_folder '\func\Run' num2str(run)]; % functional images folder
%             end
            func_path{1,:}=func_source;
            
            funcFiles=dir(char(func_path)); % including all functional images in a cell
            for j=1:length(funcFiles)
                if length(funcFiles(j).name)>2
                    if strcmp(funcFiles(j).name(1,1:4),'swra')
                        funcName=[func_source '\' funcFiles(j).name];
                    end
                end
            end
            for j=1:len-4 % Scheinost: first 4 volumes are treated as dummy scans
                func_cell_temp{1,1}{j,1}=char([funcName ',' num2str(j+4)]);
            end
            func_cell{1,1}=[func_cell{1,1};func_cell_temp{1,1}];

        end
    end
    
    matlabbatch{1,1}.spm.stats.fmri_spec.dir{1,1}=directory1;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.scans=func_cell{1,1};
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(1).onset = vec_fb_onset_all;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(1).duration = vec_fb_duration_all;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(1).pmod.param = vec_fb_value_all;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(2).onset = vec_reg_onset_all;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(2).duration = vec_reg_duration_all; 
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.multi_reg{1}=multi_reg_file;
    
    spm_jobman('run',matlabbatch);
    
    %% Concatenation - Model 1
    
    scans=[ones(1,nruns)*(len-4)];
    
    subj
    
    spmFile1=[directory1 '\SPM.mat'];
    
    spm_fmri_concatenate(spmFile1, scans);
    
    %% 1st level estimation - Model 1
    
    subj
    
    load([analysisFolder 'batch_1stLevel_Feedback_estim_model1_scheinost.mat'])
    
    matlabbatch{1,1}.spm.stats.fmri_est.spmmat{1}=spmFile1;
    
    spm_jobman('run',matlabbatch);
    
    %% F-contrast - Model 1
    
    load([analysisFolder 'batch_createFcontrast_model1_scheinost.mat'])
    
    matlabbatch{1,1}.spm.stats.con.spmmat{1}=spmFile1;
    
    spm_jobman('run',matlabbatch);

    %% Extract VOI - Model 1
    
    cfg.target_dir=directory1;
    if length(num2str(subj))==1
        cfg.name=['NAcc_sub-0' num2str(subj)];
    else
        cfg.name=['NAcc_sub-' num2str(subj)];
    end
    
    cfg.adjust=2; % 0 = regressors of no-interest (realignment parameters, etc) are not regressed out; index of contrast (F contrast that includes only parameters of interest) = variance explained by covariates will be subtracted out from signal
    cfg.contrast=1; % index of the contrast of interest
    cfg.threshold=1; % 1 = no voxels are excluded; <1 = voxels with p-value > that the value are excluded
    cfg.threshdesc = 'none'; % correct for multiple comparisons?
    cfg.extent = 0;
    cfg.mask='D:\Feedback_reward\Analysis\ROI_analysis\nAcc_wfu.nii';
    cfg.session = 1;
    
    extract_anatomical_rois(cfg)
    
    clear cfg

    %% 1st level specification - Model 2
    
    subj
    
    load([analysisFolder 'batch_1stLevel_Feedback_spec_model2_scheinost.mat'])
    
    if length(num2str(subj))==1
        directory2=[data_folder '\Sub0' num2str(subj) '\1stLevel_2']; % directory
    else
        directory2=[data_folder '\Sub' num2str(subj) '\1stLevel_2']; % directory
    end
    
    matlabbatch{1,1}.spm.stats.fmri_spec.dir=[];
    matlabbatch{1,1}.spm.stats.fmri_spec.dir{1}=directory2;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.scans=func_cell{1,1};
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(1).onset = vec_fb2_onset_all;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(1).duration = vec_fb2_duration_all;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(2).onset = vec_reg2_onset_all;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(2).duration = vec_reg2_duration_all; 
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(2).pmod.param = vec_reg2_value_all;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(3).onset = vec_reg2after_onset_all;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.cond(3).duration = vec_reg2after_duration_all;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.multi_reg=[];
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.multi_reg{1}=multi_reg_file;
    
    spm_jobman('run',matlabbatch);
    
    %% Concatenation - Model 2
    
    subj
    
    spmFile2=[directory2 '\SPM.mat'];
    
    spm_fmri_concatenate(spmFile2, scans);
    
    %% 1st level estimation - Model 2
    
    subj
    
    load([analysisFolder 'batch_1stLevel_Feedback_estim_model2_scheinost.mat'])
    
    matlabbatch{1,1}.spm.stats.fmri_est.spmmat{1}=spmFile2;
    
    spm_jobman('run',matlabbatch);
    
    %% F-contrast - Model 2
    
    load([analysisFolder 'batch_createFcontrast_model2_scheinost.mat'])
    
    matlabbatch{1,1}.spm.stats.con.spmmat{1}=spmFile2;
    
    spm_jobman('run',matlabbatch);
    
    %% Extract VOI - Model 2
    
    cfg.target_dir=directory2;
    if length(num2str(subj))==1
        cfg.name=['dlPFC_sub-0' num2str(subj)];
    else
        cfg.name=['dlPFC_sub-' num2str(subj)];
    end
    
    cfg.adjust=2; % 0 = regressors of no-interest (realignment parameters, etc) are not regressed out; index of contrast (F contrast that includes only parameters of interest) = variance explained by covariates will be subtracted out from signal
    cfg.contrast=1; % index of the contrast of interest
    cfg.threshold=1; % 1 = no voxels are excluded; <1 = voxels with p-value > that the value are excluded
    cfg.threshdesc = 'none'; % correct for multiple comparisons?
    cfg.extent = 0;
    cfg.mask='D:\Feedback_reward\Analysis\ROI_analysis\mask_dlPFC.nii';
    cfg.session = 1;
    
    extract_anatomical_rois(cfg)
    
    clear cfg
    
    %% Create PPI - Model 3
    
    subj
    
    load([analysisFolder 'batch_createPPI_pmod-base_model3_scheinost.mat'])
    
    if length(num2str(subj))==1
        VOIfile1=[directory1 '\VOI_NAcc_sub-0' num2str(subj) '_1.mat'];
        PPIname1=['PPI_sub0' num2str(subj) '_FB_model3_Nacc'];
    else
        VOIfile1=[directory1 '\VOI_NAcc_sub-' num2str(subj) '_1.mat'];
        PPIname1=['PPI_sub' num2str(subj) '_FB_model3_Nacc'];
    end
    
    matlabbatch{1,1}.spm.stats.ppi.spmmat{1}=spmFile1;
    matlabbatch{1,1}.spm.stats.ppi.type.ppi.voi{1}=VOIfile1;
    matlabbatch{1,1}.spm.stats.ppi.name=PPIname1;
    
    spm_jobman('run',matlabbatch);
    
    %% Compute GLM PPI - Model 3
    subj
    
    directory3=[directory1 '\PPI'];
    
    cd(directory1)
    mkdir 'PPI'
    cd(directory3)
    copyfile([directory1 filesep 'PPI_' PPIname1 '.mat'], directory3, 'f')
    load(['PPI_' PPIname1 '.mat'])
    
    load([analysisFolder 'batch_GLM_PPI_FB_pmod_model3_scheinost.mat'])
    
    matlabbatch{1,1}.spm.stats.fmri_spec.dir{1,1}=directory3;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.scans=func_cell{1,1};
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.regress(1).val=PPI.ppi;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.regress(2).val=PPI.Y;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.regress(3).val=PPI.P;
    
    spm_jobman('run',matlabbatch);
    
    clear PPI
    
    %% Create PPI - Model 4
    subj
    
    load([analysisFolder 'batch_createPPI_pmod-base_model4_scheinost.mat'])
    
    if length(num2str(subj))==1
        VOIfile2=[directory2 '\VOI_dlPFC_sub-0' num2str(subj) '_1.mat'];
        PPIname2=['PPI_sub0' num2str(subj) '_FB_model4_dlPFC'];
    else
        VOIfile2=[directory2 '\VOI_dlPFC_sub-' num2str(subj) '_1.mat'];
        PPIname2=['PPI_sub' num2str(subj) '_FB_model4_dlPFC'];
    end
    
    matlabbatch{1,1}.spm.stats.ppi.spmmat{1}=spmFile2;
    matlabbatch{1,1}.spm.stats.ppi.type.ppi.voi{1}=VOIfile2;
    matlabbatch{1,1}.spm.stats.ppi.name=PPIname2;
    
    spm_jobman('run',matlabbatch);
    
    %% Compute GLM PPI - Model 4
    subj
    
    directory4=[directory2 '\PPI'];
    
    cd(directory2)
    mkdir 'PPI'
    cd(directory4)
    copyfile([directory2 filesep 'PPI_' PPIname2 '.mat'], directory4, 'f')
    load(['PPI_' PPIname2 '.mat'])
    
    load([analysisFolder 'batch_GLM_PPI_FB_pmod_model4_scheinost.mat'])
    
    matlabbatch{1,1}.spm.stats.fmri_spec.dir{1,1}=directory4;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.scans=func_cell{1,1};
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.regress(1).val=PPI.ppi;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.regress(2).val=PPI.Y;
    matlabbatch{1,1}.spm.stats.fmri_spec.sess.regress(3).val=PPI.P;
    
    spm_jobman('run',matlabbatch);
    
    clear PPI xY matlabbatch func_cell func_cell_temp Y S cumul_c
    
end