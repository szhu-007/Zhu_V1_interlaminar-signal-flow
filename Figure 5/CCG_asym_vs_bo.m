clear all
close all
%%
data_path='path_to_the_dataset';
load(fullfile(data_path,'data_ccg_nCRF.mat')); 
%% scatter plot of BO modulation index vs CCG asymmetry 
figure('Color',[1 1 1],'Position',[100,100,450,300]);
scatter(ccg_BO_sig.Asymmetry,ccg_BO_sig.MI_BO,10,'black','Marker','o','LineWidth',1);hold on
mdl=fitlm(ccg_BO_sig.Asymmetry,ccg_BO_sig.MI_BO);
[~,yci]=predict(mdl,ccg_BO_sig.Asymmetry);
plot(ccg_BO_sig.Asymmetry,mdl.Fitted,'r');hold on;
plot(ccg_BO_sig.Asymmetry,yci,'r.','LineWidth',0.2);hold on;
ax=gca;ax.XLim=[-0.55,0.35];ax.YLim=[-0.05,0.6];
ax.Box='off';ax.XTick=-0.4:0.2:0.4;ax.YTick=[0,0.2,0.4,0.6,0.8];ax.TickDir='out';ax.TickLength=[0.02,0.02];ax.FontSize=12;

%%%% scatter plot of LC modulation index vs CCG asymmetry 
figure('Color',[1 1 1],'Position',[100,100,450,300]);
scatter(ccg_BO_sig.Asymmetry,ccg_BO_sig.MI_LC,10,'black','Marker','o','LineWidth',1); hold on
mdl=fitlm(ccg_BO_sig.Asymmetry,ccg_BO_sig.MI_LC);
[~,yci]=predict(mdl,ccg_BO_sig.Asymmetry);
plot(ccg_BO_sig.Asymmetry,mdl.Fitted,'r');hold on;
plot(ccg_BO_sig.Asymmetry,yci,'r.','LineWidth',0.2);hold on;
ax=gca;ax.XLim=[-0.55,0.35];ax.YLim=[-0.05,0.8];
ax.Box='off';ax.XTick=-0.4:0.2:0.4;ax.YTick=[0,0.2,0.4,0.6,0.8];ax.TickDir='out';ax.TickLength=[0.02,0.02];ax.FontSize=12;
%% GLM model for dependence of BO/LC modulation index on CCG asymmetry
layer_label={'56','4C','4AB','23','WM'};
label_j=string(ccg_BO_sig.first_ref_neuron_layer);
label_k=string(ccg_BO_sig.second_tgt_neuron_layer);

layercombo_idx=nan(length(ccg_BO_sig.id_session),1);
idx_key=0;
for idx_pre_layer=[2,3]
    for idx_post_layer=[4,1]
        idx_key=idx_key+1;
        id_selected=ismember(label_j,layer_label{idx_pre_layer})&ismember(label_k,layer_label{idx_post_layer});                 
        layercombo_idx(id_selected)=idx_key;
    end
end
clc
modelmatrix0=[
    0,0,0,0;
    1,0,0,0;
    0,1,0,0;
    0,0,1,0];
md_bo_mean=fitlm([ccg_BO_sig.Asymmetry,layercombo_idx,ccg_BO_sig.id_session],ccg_BO_sig.MI_BO,modelmatrix0,'CategoricalVars',[2,3],'VarNames',{'Asym','LayerCombo','session','BO'}) 
md_LC_mean=fitlm([ccg_BO_sig.Asymmetry,layercombo_idx,ccg_BO_sig.id_session],ccg_BO_sig.MI_LC,modelmatrix0,'CategoricalVars',[2,3],'VarNames',{'Asym','LayerCombo','session','LC'})