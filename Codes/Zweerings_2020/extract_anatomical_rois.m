function extract_anatomical_rois(cfg)

spm('defaults', 'FMRI');
spm_jobman('initcfg');

% spm_regions needs to be in SPM.mat directory.
starting_dir = pwd;
cd(cfg(1).target_dir);

for ii = 1 : numel(cfg)
    jobs{ii}.spm.util.voi.spmmat = {fullfile(...
        cfg(1).target_dir, 'SPM.mat')};
    jobs{ii}.spm.util.voi.adjust = cfg(ii).adjust;
    jobs{ii}.spm.util.voi.session = cfg(ii).session;
    jobs{ii}.spm.util.voi.name = cfg(ii).name;
    
    % The image data
    jobs{ii}.spm.util.voi.roi{1}.spm.spmmat = {''};
    jobs{ii}.spm.util.voi.roi{1}.spm.contrast = cfg(ii).contrast;
    jobs{ii}.spm.util.voi.roi{1}.spm.threshdesc = cfg(ii).threshdesc;
    jobs{ii}.spm.util.voi.roi{1}.spm.thresh = cfg(ii).threshold;
    jobs{ii}.spm.util.voi.roi{1}.spm.extent = cfg(ii).extent;
    
    % The anatomical ROI mask
    jobs{ii}.spm.util.voi.roi{2}.mask.image = {cfg(ii).mask};
    
    % The logical expression combining images.
    jobs{ii}.spm.util.voi.expression = 'i1 & i2';
end

try
    spm_jobman('run', jobs);
catch ME
    cd(starting_dir);
    rethrow(ME);
end
cd(starting_dir)

return