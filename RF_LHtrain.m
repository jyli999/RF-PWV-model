clc;clear;
ctrlFile=fopen('E:\桌面\test\TKpoint\chinaTK148.txt');
files=dir(['F:\wang\RF_TK2\regular\RF(探空去除偏差)\cha_data/*.mat']);
filenumber=length(files);
filename={files.name}';%读取的文件名
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
        fileName = line(1:11);%截取Line中的字符
        if filename_1==fileName
            BLHstring = line(12:38);
            station = sscanf(BLHstring,'%f%f%f');
            B = station(2,1);
            L = station(1,1);
            H = station(3,1);   %正高
            B1 = floor(B/1)*1; %左上/下角
            B2 = ceil(B/1)*1;   %右上/下角
            L1 = floor(L/1)*1;  %左/右下角
            L2 = ceil(L/1)*1;  %左/右上角
            break
        end
    end
    if  B1==B2
        spoint(1,1)=B1;spoint(1,2)=L1;%下点
        spoint(2,1)=B1;spoint(2,2)=L2;%上点
    elseif L1==L2
        spoint(1,1)=B1;spoint(1,2)=L1;%左点
        spoint(2,1)=B2;spoint(2,2)=L1;%右点
    else
        spoint(1,1)=B1;spoint(1,2)=L1;%左下
        spoint(2,1)=B2;spoint(2,2)=L1;%右下
        spoint(3,1)=B1;spoint(3,2)=L2;%左上
        spoint(4,1)=B2;spoint(4,2)=L2;%右上
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
    elseif z==2
        data1dz=['F:\wang\RF_TK2\TKsp_train_data\',num2str((spoint(1,1)), '%06.2f'),'_',num2str((spoint(1,2)),'%05.2f'),'.mat'];
        data1=importdata(data1dz);
        data2dz=['F:\wang\RF_TK2\TKsp_train_data\',num2str((spoint(2,1)), '%06.2f'),'_',num2str((spoint(2,2)),'%05.2f'),'.mat'];
        data2=importdata(data2dz);
        stand_data=[data1;data2];
    end
    for ii=1:size(spoint,1)
        lon=spoint(ii,1);
        lai=spoint(ii,2);
        pointdz=['F:\wang\RF_TK2\TKsp_train_data\',num2str((lon), '%06.2f'),'_',num2str((lai),'%05.2f'),'.mat'];
        pointdata=importdata(pointdz);
        bpname=[num2str((lon), '%06.2f'),'_',num2str((lai),'%05.2f'),filename_1];
        tic;
        tree=55;
        rf_fit(bpname,tree,pointdata,RSdata,stand_data);
        toc;
        clear pointdz pointdata bpname
    end
  clear RSdata filename_1 spoint stand_data
end


