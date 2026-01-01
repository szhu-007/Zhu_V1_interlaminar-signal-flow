clear all
close all
%%
data_path='path_to_the_dataset';
load(fullfile(data_path,'data_ccg_nCRF.mat')); 
load(fullfile(data_path,'data_ccg_CRF.mat')); 
%%
color_bo=[238,42,123]/255;
cmap=brewermap(256,'*RdBu'); %% prefer
bin_edge_asym=-0.19:0.02:0.19;
bin_ccglag=-100:1:100;
%%
layer_label={'56','4C','4AB','23','WM'};
label_j=string(ccg_BO_sig.first_ref_neuron_layer);
label_k=string(ccg_BO_sig.second_tgt_neuron_layer);
label_j_ori=string(ccg_Ori_sig.first_ref_neuron_layer);
label_k_ori=string(ccg_Ori_sig.second_tgt_neuron_layer);
%% image plot of BO CCG, by layer, for example session 1
id_session=1;

ccg_BO_sig.CCG_smoothed_norm=ccg_BO_sig.CCG_smoothed./repmat(ccg_BO_sig.Peak,1,201);
ccg_Ori_sig.CCG_smoothed_norm=ccg_Ori_sig.CCG_smoothed./repmat(ccg_Ori_sig.Peak,1,201);

figure('Color',[1 1 1],'Position',[100,100,1000,800]);
tiledlayout(3,4,'TileSpacing','tight');
for k=[4,1] %% image plot of CRF CCG, by layercombo
    for j=[2,3]
        nexttile
        id_selected=ismember(label_j_ori,layer_label{j})&ismember(label_k_ori,layer_label{k})&ccg_Ori_sig.id_session==id_session;    
        ccgi=ccg_Ori_sig.CCG_smoothed_norm(id_selected,:);
        ccgi=ccgi(randperm(size(ccgi,1)),:);
        image(bin_ccglag,1:sum(id_selected),ccgi,"CDataMapping","scaled");colormap(cmap);hold on
        plot([0,0],[0,sum(id_selected)+0.5],'Color',[0 0 0 0.5],'LineWidth',1);hold on
        ax=gca;ax.CLim=[-1,1];ax.YDir='normal';ax.XLim=[-20,20];ax.YTick=[0, sum(id_selected)];
        ax.TickLength=[0.02,0.02];ax.FontSize=7;ax.LineWidth=1;
        title([layer_label{j},'-',layer_label{k}]);
    end
end
for k=[4,1] %% image plot of BO CCG, by layercombo
    for j=[2,3]
        nexttile
        id_selected=ismember(label_j,layer_label{j})&ismember(label_k,layer_label{k})&ccg_BO_sig.id_session==id_session;    
        ccgi=ccg_BO_sig.CCG_smoothed_norm(id_selected,:);
        ccgi=ccgi(randperm(size(ccgi,1)),:);
        image(bin_ccglag,1:sum(id_selected),ccgi,"CDataMapping","scaled");colormap(cmap);hold on
        plot([0,0],[0,sum(id_selected)+0.5],'Color',[0 0 0 0.5],'LineWidth',1);hold on
        ax=gca;ax.CLim=[-1,1];ax.YDir='normal';ax.XLim=[-20,20];ax.YTick=[0, sum(id_selected)];
        ax.TickLength=[0.02,0.02];ax.FontSize=7;ax.LineWidth=1;
        title([layer_label{j},'-',layer_label{k}]);
    end
end
for k=[4,1] %% histogram plot of asymmetry, BO vs ori, by layercombo
    for j=[2,3]
        nexttile
        id_selected=ismember(label_j,layer_label{j})&ismember(label_k,layer_label{k})&ccg_BO_sig.id_session==id_session;    
        id_selected_ori=ismember(label_j_ori,layer_label{j})&ismember(label_k_ori,layer_label{k})&ccg_Ori_sig.id_session==id_session;    
        ca=ccg_BO_sig.Asymmetry(id_selected);
        ca_ori=ccg_Ori_sig.Asymmetry(id_selected_ori);
        histogram(ca_ori,bin_edge_asym,'EdgeColor','none','FaceColor',[0.5 0.5 0.5],'Normalization','probability');hold on
        histogram(ca,bin_edge_asym,'EdgeColor','none','FaceColor',color_bo,'Normalization','probability');hold on
        plot([median(ca_ori),median(ca_ori)],[0.37,0.4],'Color',[0 0 0],'LineWidth',2);hold on;
        plot([median(ca),median(ca)],[0.37,0.4],'Color',color_bo,'LineWidth',2);hold on
        plot([0,0],get(gca,'ylim'),'Color',[0 0 0 0.5],'LineWidth',1); hold on;
        p_lag=ranksum(ca_ori,ca,'tail','both');             
        title(['p=',num2str(p_lag,2)])
        ax=gca;ax.TickLength=[0.02,0.02];ax.FontSize=7;ax.Box='off';ax.TickDir='out';ax.LineWidth=1;
    end
end
%% plot CA distribution, histogram
figure('Color',[1 1 1],'Position',[100,100,500,500]);
tiledlayout(2,2,'TileSpacing','tight');
for k=[4,1] %% histogram plot of asymmetry, BO vs ori, by layercombo
    for j=[2,3]
        nexttile
        id_selected=ismember(label_j,layer_label{j})&ismember(label_k,layer_label{k});    
        id_selected_ori=ismember(label_j_ori,layer_label{j})&ismember(label_k_ori,layer_label{k});           
        ca=ccg_BO_sig.Asymmetry(id_selected);
        ca_ori=ccg_Ori_sig.Asymmetry(id_selected_ori);
        histogram(ca_ori,bin_edge_asym,'EdgeColor','none','FaceColor',[0.5 0.5 0.5],'Normalization','probability');hold on
        histogram(ca,bin_edge_asym,'EdgeColor','none','FaceColor',color_bo,'Normalization','probability');hold on
        plot([median(ca_ori),median(ca_ori)],[0.27,0.3],'Color',[0 0 0],'LineWidth',2);hold on;
        plot([median(ca),median(ca)],[0.27,0.3],'Color',color_bo,'LineWidth',2);hold on
        plot([0,0],get(gca,'ylim'),'Color',[0 0 0 0.5],'LineWidth',1); hold on;
        p_lag=ranksum(ca_ori,ca,'tail','both');             
        title([layer_label{j},'-',layer_label{k},', p=',num2str(p_lag,2)])
        ax=gca;ax.TickLength=[0.02,0.02];ax.FontSize=7;ax.Box='off';ax.TickDir='out';ax.LineWidth=1;
    end
end