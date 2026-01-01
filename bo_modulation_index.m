clear all
close all
clc

data_path='path_to_the_dataset';
colorlabel_layer=brewermap(12,'Paired');
colorlabel_layer=colorlabel_layer([10,4,3,8,2],:);
%%
for idx=1:4
    load(fullfile(data_path,['data_BO_session',num2str(idx_session),'.mat']));
    BO_Mod=data_BO.BO_index;
    %% histogram of BO modulation index 
    figure('Color',[1 1 1],'Position',[100 100 300 200]);   
    histogram(BO_Mod,-1.05:0.1:1.05,'FaceColor',[0.5 0.5 0.5],'EdgeColor','none');hold on
    xline(nanmedian(BO_Mod),'r--');hold on
    xline(0,'k--');hold on
    ax=gca;ax.XLim=[-1.2,1.2];ax.TickDir = 'out';ax.Box='off';ax.TickLength=[0.02,0.02];ax.FontSize=12;
    p=signtest(BO_Mod);
    title(['p=',num2str(p,2),', Median=',num2str(nanmedian(BO_Mod),3)])
    %% depth plot of BO modulation index 
    figure('Color',[1 1 1],'Position',[100 100 300 600]);   
    idx_nonsig=data_BO.p_anova(:,1)>=0.05;
    idx_sig=data_BO.p_anova(:,1)< 0.05;
    
    scatter(BO_Mod(idx_nonsig),data_BO.cluster_depth(idx_nonsig),40,[0.8 0.8 0.8],'filled');hold on
    scatter(BO_Mod(idx_sig),data_BO.cluster_depth(idx_sig),40,[0 0 0],'filled');hold on
    plot([0,0],[-1500,2500],'k--','Linewidth',1); hold on;
    xlim([-1.2 1.2]);
    if idx_session<=2
        ylim([-800,1400]);
        depth_mat=[data_BO.layer_depth(2),data_BO.layer_depth(3);
        data_BO.layer_depth(3),data_BO.layer_depth(4);
        data_BO.layer_depth(4),data_BO.layer_depth(5);
        data_BO.layer_depth(5),max(data_BO.cluster_depth)];
    else
        ylim([-500,900]);
        depth_mat=[data_BO.layer_depth(1),data_BO.layer_depth(2);
        data_BO.layer_depth(2),data_BO.layer_depth(3);
        data_BO.layer_depth(3),data_BO.layer_depth(4);
        data_BO.layer_depth(4),max(data_BO.cluster_depth)];
    end
    for id_layer=1:4
        plot([-1.2,-1.2],[depth_mat(id_layer,1),depth_mat(id_layer,2)],'Color',colorlabel_layer(id_layer,:),'LineWidth',2);hold on
    end 
    ax=gca;ax.TickDir = 'out'; ax.TickLength=[0.02,0.02]; ax.YTick=-1000:500:2000; ax.FontSize=12;ax.Box='off';
end