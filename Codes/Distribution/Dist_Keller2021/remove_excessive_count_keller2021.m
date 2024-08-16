function [censored_vals]=remove_excessive_count_keller2021(fb_val)

temp_fb_val=fb_val;
censored_vals=repelem({'no'},length(fb_val))';

max_fb_val=max(fb_val);
min_fb_val=min(fb_val);

binc = min_fb_val:max_fb_val;

while 1
    
    counts = hist(temp_fb_val,binc);
    val_count = [binc; counts];
    
    val_count(2,val_count(2,:)==0) = NaN;
    
    excess_vec=val_count>nanmean(val_count(2,:))+3*nanstd(val_count(2,:));
    
    if nnz(excess_vec(2,:))
        
        excess_fb_val=find(val_count(2,:)==max(val_count(2,:))); % looks for the bins where fb values are excessive
        shuffle_excess_fb_val=excess_fb_val(randperm(length(excess_fb_val))); % shuffles the vector of bins of excessive values
        excess_where=find(temp_fb_val==val_count(1,shuffle_excess_fb_val(1))); % looks for which trials the excessive values were shown (only one value, if there are more than one)
        shuffle_excess_where=excess_where(randperm(length(excess_where))); % shuffles the vector of trial indexes of excessive values
        temp_fb_val(shuffle_excess_where(1))=nan; % replaces the vector of fb vals with a nan in the first value of shuffle_excess_where
        censored_vals(shuffle_excess_where(1))={'censor'};
        
    else
        break
    end
end



return