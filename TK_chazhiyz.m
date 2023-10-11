%̽�ղ�ֵ��֤
clc;clear;
ctrlFile=fopen('E:\����\test\TKpoint\chinaTK148.txt');
files=dir(['F:\wang\RF_TK2\regular\RF(̽��ȥ��ƫ��)\cha_data/*.mat']);%̽������λ��
filenumber=length(files);
filename={files.name}';%��ȡ���ļ���
filedz={files.folder}';
for i=1:filenumber
    filedz{i,2}=char('\');
    filedz{i,3}=strcat(filedz{i,1},filedz{i,2},filename{i,1});
end
h=0;
for i=1:filenumber
    RSdata=importdata(filedz{i,3});
    filename_1=filename{i,1}(:,1:end-4);
    while ~feof(ctrlFile)
        line = fgetl(ctrlFile);
        fileName = line(1:11);%��ȡLine�е��ַ�
        if filename_1==fileName
            BLHstring = line(12:38);
            station = sscanf(BLHstring,'%f%f%f');
            B = station(2,1);
            L = station(1,1);
            H = station(3,1);   %����
            B1 = floor(B/1)*1; %����/�½�
            B2 = ceil(B/1)*1;   %����/�½�
            L1 = floor(L/1)*1;  %��/���½�
            L2 = ceil(L/1)*1;  %��/���Ͻ�
            break
        end
    end
    if  B1==B2
        spoint(1,1)=B1;spoint(1,2)=L1;%�µ�
        spoint(2,1)=B1;spoint(2,2)=L2;%�ϵ�
    elseif L1==L2
        spoint(1,1)=B1;spoint(1,2)=L1;%���
        spoint(2,1)=B2;spoint(2,2)=L1;%�ҵ�
    else
        spoint(1,1)=B1;spoint(1,2)=L1;%����
        spoint(2,1)=B2;spoint(2,2)=L1;%����
        spoint(3,1)=B1;spoint(3,2)=L2;%����
        spoint(4,1)=B2;spoint(4,2)=L2;%����
    end
    z=size(spoint,1);
    if z==4
        data1dz=['F:\wang\RF_TK2\TKsp_train_data\',num2str((spoint(1,1)), '%06.2f'),'_',num2str((spoint(1,2)),'%05.2f'),'.mat'];
        data1=importdata(data1dz);
        data2dz=['F:\wang\RF_TK2\TKsp_train_data\',num2str((spoint(2,1)), '%06.2f'),'_',num2str((spoint(2,2)),'%05.2f'),'.mat'];
        data2=importdata(data2dz);
        data3dz=['F:\wang\RF_TK2\TKsp_train_data\',num2str((spoint(3,1)), '%06.2f'),'_',num2str((spoint(3,2)),'%05.2f'),'.mat'];
        data3=importdata(data3dz);
        data4dz=['F:\wang\RF_TK2\TKsp_train_data\',num2str((spoint(4,1)), '%06.2f'),'_',num2str((spoint(4,2)),'%05.2f'),'.mat'];
        data4=importdata(data4dz);
        stand_data=[data1;data2;data3;data4];
        for j=1:size(spoint)
            lon=spoint(j,1);
            lai=spoint(j,2);
            p_tr  = stand_data(:,1:4);%pointdata
            t_tr  = stand_data(:,5);
            p_tr_1=RSdata(:,1:4);%RSdata
            t_tr_1=RSdata(:,5);
            pb_train=[p_tr;p_tr_1];%��׼��shuju
            tb_train=[t_tr;t_tr_1];
            %��׼��
            [pv, p_set] = mapminmax(pb_train');
            [tv, t_set] = mapminmax(tb_train');
            pv = pv';
            tv = tv';
            pvRS=pv(253441:end,:);%RS predict need data
            tvRS=tv(253441:end,:);
            bpname=[num2str((lon), '%06.2f'),'_',num2str((lai),'%05.2f'),filename_1];
            model=['F:\wang\RF_TK2\regular\RF(̽��ȥ��ƫ��)\model\',bpname,'model_rf.mat'];
            load(model);
            test_pre = predict(model_rf, pvRS);
            %����һ��
            t_val_pre = mapminmax.reverse(test_pre, t_set);%Ԥ��ֵ
            t_val = mapminmax.reverse(tvRS, t_set);
            RSyuce(:,1:5)=RSdata(:,1:5);
            RSyuce(:,j+5)=t_val_pre;
            clear model bpname model_rf
        end
    elseif z==2
        data1dz=['F:\wang\RF_TK2\TKsp_train_data\',num2str((spoint(1,1)), '%06.2f'),'_',num2str((spoint(1,2)),'%05.2f'),'.mat'];
        data1=importdata(data1dz);
        data2dz=['F:\wang\RF_TK2\TKsp_train_data\',num2str((spoint(2,1)), '%06.2f'),'_',num2str((spoint(2,2)),'%05.2f'),'.mat'];
        data2=importdata(data2dz);
        stand_data=[data1;data2];
        for j=1:size(spoint)
            lon=spoint(j,1);
            lai=spoint(j,2);
            p_tr  = stand_data(:,1:4);%pointdata
            t_tr  = stand_data(:,5);
            p_tr_1=RSdata(:,1:4);%RSdata
            t_tr_1=RSdata(:,5);
            pb_train=[p_tr;p_tr_1];%��׼��shuju
            tb_train=[t_tr;t_tr_1];
            %��׼��
            [pv, p_set] = mapminmax(pb_train');
            [tv, t_set] = mapminmax(tb_train');
            pv = pv';
            tv = tv';
            pvRS=pv(126721:end,:);%RS predict need data
            tvRS=tv(126721:end,:);
            bpname=[num2str((lon), '%06.2f'),'_',num2str((lai),'%05.2f'),filename_1];
            model=['F:\wang\RF_TK2\regular\RF(̽��ȥ��ƫ��)\model\',bpname,'model_rf.mat'];
            load(model);
            test_pre = predict(model_rf, pvRS);
            %����һ��
            t_val_pre = mapminmax.reverse(test_pre, t_set);%Ԥ��ֵ
            t_val = mapminmax.reverse(tvRS, t_set);
            RSyuce(:,1:5)=RSdata(:,1:5);
            RSyuce(:,j+5)=t_val_pre;
            clear model bpname 
        end
    end
    %˫���Բ�ֵ
    if B1==B2
        x=B;y=L;y1=L1;y2=L2;%ͬ���ȵ���
        pwv_x1_y1=RSyuce(:,6);pwv_x1_y2=RSyuce(:,7);
        pwv_cha=(y-y1)*pwv_x1_y1/(y2-y1)+(y2-y)*pwv_x1_y2/((y2-y1));
        RSyuce(:,8)=pwv_cha;
    elseif L1==L2
        x=B;y=L;x1=B1;x2=B2;%ͬγ�ȵ���
        pwv_x1_y1=RSyuce(:,6);pwv_x2_y1=RSyuce(:,7);
        pwv_cha=(x-x1)*pwv_x1_y1/(x2-x1)+(x2-x)*pwv_x2_y1/(x2-x1);
        RSyuce(:,8)=pwv_cha;
    else
        x=B;y=L;x1=B1;x2=B2;y1=L1;y2=L2;
        pwv_x1_y1=RSyuce(:,6);pwv_x2_y1=RSyuce(:,7);
        pwv_x1_y2=RSyuce(:,8);pwv_x2_y2=RSyuce(:,9);
        %y������
        f_r1=((y-y1)*pwv_x1_y1)/(y2-y1)+((y2-y)*pwv_x1_y2)/(y2-y1);
        f_r2=((y-y1)*pwv_x2_y1)/(y2-y1)+((y2-y)*pwv_x2_y2)/(y2-y1);
        %x������
        pwv_cha=((x-x1)*f_r1)/(x2-x1)+((x2-x)*f_r2)/(x2-x1);
        RSyuce(:,10)=pwv_cha;
    end
    TKname=[filename_1,'.mat'];
    save(TKname,'RSyuce');
    clear RSdata filename_1 spoint RSyuce stand_data
end