%% SR_ppm基础修改，两个背底，没有循环
clear;clc;close all;warning off
%% 平均最后n个光谱数据文件
file_list1 = dir('F:\课题\数据\原始光谱数据\标准单一气体\SO2\bd\*.txt');
file_list2 = dir('F:\课题\数据\原始光谱数据\标准单一气体\SO2\950ppbSO2\*.txt');
file_list3 = dir('F:\课题\数据\原始光谱数据\6-25\6-7\air\bd\*.txt');
file_list4 = dir('F:\课题\数据\原始光谱数据\6-25\6-7\air\1ppbSO2\*.txt');
file_list5 = dir('F:\课题\数据\原始光谱数据\标准单一气体\CS2\bd\*.txt');
file_list6 = dir('F:\课题\数据\原始光谱数据\标准单一气体\CS2\180ppbCS2\*.txt');
u0=196;v0=227;%测量波段
u1=u0-0;v1=v0+0;%拟合波段
%标注浓度，测量浓度
S_C=950;M_C=500;S_C_CS2=180;
len1 = size(file_list1, 1);
len2 = size(file_list2, 1);
len3 = size(file_list3, 1);
len4 = size(file_list4, 1);
len5 = size(file_list5, 1);
len6 = size(file_list6, 1);
Q1=[];Q2=[];Q3=[];Q4=[];Q5=[];Q6=[];
%% 标准谱1bd采用最后10个文件
for i1=(len1-9):1:len1
    file_list1(i1).name;
    %     fileID=fopen(file_list(i).name);(路径不全,使用strcat连接文本)
    fileID1=fopen(strcat('F:\课题\数据\原始光谱数据\标准单一气体\SO2\bd\',file_list1(i1).name));
    A1=textscan(fileID1,'%f%f');
    %     figure
    %     plot(A1{1,1},A1{1,2});
    %     hold on;循环打开n个光谱图
    Q1=[Q1;A1];
    fclose all;
end
%平均了最后10个文件的背底谱数据
beidibochang1=Q1{1,1};
a1=zeros(length(beidibochang1),1);
for i2=1:length(Q1)
    a1=a1+Q1{i2,2};
end
beidiguangqiang1=a1/length(Q1);
beidishuju1=[beidibochang1 beidiguangqiang1];
%% 标准谱1的透过谱采用最后10个
for i3=(len2-9):1:len2
    file_list2(i3).name;
    fileID2=fopen(strcat('F:\课题\数据\原始光谱数据\标准单一气体\SO2\950ppbSO2\',file_list2(i3).name));
    A2=textscan(fileID2,'%f%f');
    %     figure
    %     plot(A2{1,1},A2{1,2});
    %     hold on;
    Q2=[Q2;A2];
    fclose all;
end
celiangbochang1=Q2{1,1};
a2=zeros(length(celiangbochang1),1);
for i4=1:length(Q2)
    a2=a2+Q2{i4,2};
end
%平均了最后10个文件的测量谱1数据
celiangguangqiang1=a2/length(Q2);
celiangshuju1=[celiangbochang1 celiangguangqiang1];
%% 测量波长与拟合波长选取
array=beidishuju1(:,1);
u00 = findClosestNum(array, u0);
v00 = findClosestNum(array, v0);
u11 = findClosestNum(array, u1);
v11 = findClosestNum(array, v1);
wave1=[u00,v00];
wave2=[u11,v11];
% fprintf('吸收波长: ');
% fprintf('%f ', wave1);
% fprintf('\n');
% fprintf('拟合波长: ');
% fprintf('%f ', wave2);
% fprintf('\n');  % 可选，添加换行符
%% 差分谱1
xishoupu1=celiangguangqiang1./beidiguangqiang1;
u01 = find(celiangbochang1==u00);
v01 = find(celiangbochang1==v00);
yongdexishoupu1=xishoupu1(u01:v01,1);
yongdebochang1=celiangbochang1(u01:v01,1);%用的吸收谱波长选取

u12 = find(celiangbochang1==u11);
v12 = find(celiangbochang1==v11);
nihebochang1=celiangbochang1(u12:v12,1);
nihexishoupu1=xishoupu1(u12:v12,1);
manbianxishou=polyfit(nihebochang1,nihexishoupu1,4);
manbianxishou1=polyval(manbianxishou,nihebochang1);
manbianpu1=[nihebochang1,manbianxishou1];
u22 = find(nihebochang1==u00);
v22 = find(nihebochang1==v00);
yongdemanbian1=manbianpu1(u22:v22,:);%用的慢变拟合波段选取

kuaibianxishoupu2=yongdexishoupu1./yongdemanbian1(:,2);
chafenpu1=log(kuaibianxishoupu2);%取对数
%% 标准谱2bd采用最后10个文件
for i5=(len3-9):1:len3
    file_list3(i5).name;
    %     fileID=fopen(file_list(i).name);(路径不全,使用strcat连接文本)
    fileID3=fopen(strcat('F:\课题\数据\原始光谱数据\6-25\6-7\air\bd\',file_list3(i5).name));
    A3=textscan(fileID3,'%f%f');
    %     figure
    %     plot(A1{1,1},A1{1,2});
    %     hold on;循环打开n个光谱图
    Q3=[Q3;A3];
    fclose all;
end
%平均了最后10个文件的背底谱数据
beidibochang2=Q3{1,1};
a3=zeros(length(beidibochang2),1);
for i6=1:length(Q3)
    a3=a3+Q3{i6,2};
end
beidiguangqiang2=a3/length(Q3);
beidishuju2=[beidibochang2 beidiguangqiang2];
%% 谱2的透过谱采用最后10个
Ta=50;
MN=floor(len4/Ta)
Lunwen=[];
for M=1:MN
    Q4=[];
    for i7=Ta*(M-1)+1:1:Ta*M    
% for i7=(len4-9):1:len4
    file_list4(i7).name;
    fileID4=fopen(strcat('F:\课题\数据\原始光谱数据\6-25\6-7\air\1ppbSO2\',file_list4(i7).name));
    A4=textscan(fileID4,'%f%f');
    %     figure
    %     plot(A3{1,1},A3{1,2});
    %     hold on;
    Q4=[Q4;A4];
    fclose all;
end
celiangbochang2=Q4{1,1};
a4=zeros(length(celiangbochang2),1);
for i8=1:length(Q4)
    a4=a4+Q4{i8,2};
end
%平均了最后10个文件的测量谱2数据
celiangguangqiang2=a4/length(Q4);
celiangshuju2=[celiangbochang2 celiangguangqiang2];
fclose all;
%% 差分谱2选择另一个波段
u_2th=210;v_2th=227;
u00_2th = findClosestNum(array, u_2th);
v00_2th = findClosestNum(array, v_2th);
wave3=[u00_2th,v00_2th];
%% 差分谱2
xishoupu02=celiangguangqiang2./beidiguangqiang2;
yongdexishoupu02=xishoupu02(u01:v01,1);
yongdebochang02=celiangbochang1(u01:v01,1);%用的吸收谱波长选取

nihebochang1=celiangbochang1(u12:v12,1);
nihexishoupu02=xishoupu02(u12:v12,1);
manbianxishou02=polyfit(nihebochang1,nihexishoupu02,4);
manbianxishou02=polyval(manbianxishou02,nihebochang1);
manbianpu02=[nihebochang1,manbianxishou02];%用的慢变拟合波段选取

yongdemanbian02=manbianpu02(u22:v22,:);
kuaibianxishoupu02=yongdexishoupu02./yongdemanbian02(:,2);
chafenpu02=log(kuaibianxishoupu02);%取对数
%% 差分谱2的部分
% u01_2th = find(celiangbochang2==u00_2th);
% v01_2th = find(celiangbochang2==v00_2th);
% xishoupu2=celiangguangqiang2./beidiguangqiang2;
% yongdexishoupu2=xishoupu2(u01_2th:v01_2th,1);
% yongdebochang2=celiangbochang2(u01_2th:v01_2th,1);%用的吸收谱波长选取
% 
% nihebochang2=celiangbochang2(u01_2th:v01_2th,1);
% nihexishoupu2=xishoupu2(u01_2th:v01_2th,1);
% manbianxishou=polyfit(nihebochang2,nihexishoupu2,4);
% manbianxishou2=polyval(manbianxishou,nihebochang2);
% manbianpu2=[nihebochang2,manbianxishou2];%用的慢变拟合波段选取
% 
% u22_2th = find(nihebochang2==u00_2th);
% v22_2th = find(nihebochang2==v00_2th);
% 
% yongdemanbian2=manbianpu2(u22_2th:v22_2th,:);
% kuaibianxishoupu2=yongdexishoupu2./yongdemanbian2(:,2);
% chafenpu2=log(kuaibianxishoupu2);%取对数
yongdebochang2=celiangbochang2(find(celiangbochang2==u00_2th):find(celiangbochang2==v00_2th),1);
u01_2th = find(yongdebochang02==u00_2th);
v01_2th = find(yongdebochang02==v00_2th);
chafenpu2=chafenpu02(u01_2th:v01_2th);
%% 图1两个差分谱
y1=chafenpu1;
y2=chafenpu2;
% plot(yongdebochang1,chafenpu1,'b')
% hold on
% plot(yongdebochang2,chafenpu2,'o')
% hold on
% plot(yongdebochang1,chafenpu02,'r')
% title('两组差分谱');
% xlabel('波长λ(nm)');
% ylabel('差分吸收光谱(a.u)');
% legend('标准浓度SO2差分谱','选取波段','待测差分谱')
%% NAN
zuo=find(yongdebochang1==yongdebochang2(1));
zuo_2=zuo-1;
you=find(yongdebochang1==yongdebochang2(length(yongdebochang2)));
you_2=length(yongdebochang1)-you;
row_1=NaN(1, zuo_2);
row_2=NaN(1, you_2);
y2_2=[row_1 y2' row_2]';
%% 排序
bochang=yongdebochang1;
m=length(bochang);
a=1:m;
Y=[y1 y2_2 a'];
Y0=[y1 y2_2];
Y1=sortrows(Y,1);%标准谱从小到大排序，测量谱跟着变动
Y01=sortrows(Y0,1);
%% 图3 标准谱线性
X=[];
X(1)=0;
for p1=2:length(Y1)
    X(p1)=1*(Y1(p1,1)-Y1(p1-1,1))+X(p1-1);
    p1=p1+1;
end
XX=X';
lunwen02=[X' Y01];
% figure
% plot(X,Y01);
%% 图 线性标准谱，拟合测量谱
cc=Y1(:,2)';

non_nan_rows = any(isnan(lunwen02), 2);
Y01_cleaned = lunwen02(~non_nan_rows, :);

yn=polyfit(Y01_cleaned(:,1),Y01_cleaned(:,3),1);
ynn=polyval(yn,Y01_cleaned(:,1));
% Y2=[Y1(:,1) y2_4'];
% Y3=[Y1(:,1) ynn'];
% figure
% plot(Y01_cleaned(:,1),ynn,'b');
C_SO2=(yn(1)*S_C)/6.4;
Y_augment=yn(1)*X+yn(2);
Y_augment=Y_augment';
% figure
% plot(X,Y_augment,'b');
%% 图6 逆重构
Y31=[Y1(:,1) Y_augment Y1(:,3)];
Y32=sortrows(Y31,3);
Y33=[Y32(:,1) Y32(:,2)];
bochang=bochang';
% figure
% plot(yongdebochang2,chafenpu2,'o');hold on
% plot(bochang,Y33(:,2),'r');hold on
% plot(yongdebochang1,chafenpu02,'b')
% title('三组差分谱');
% xlabel('波长λ(nm)');
% ylabel('差分吸收光谱(a.u)');
% legend('选取波段','逆重构差分谱','原始光谱')
a_1=1:length(cc);
% U=[a_1' Y1(:,1) ynn'];
%% 减去SO2特征
Y_CS2=chafenpu02-Y32(:,2);
% figure
% plot(yongdebochang1,Y_CS2,'r');hold on
% plot(yongdebochang1,chafenpu02,'b')
%legend('减去SO2特征后','原始光谱')
A_getCS2=[yongdebochang1 Y_CS2];
%% 标准CS2 bd采用最后10个文件
for i9=(len5-9):1:len5
    file_list5(i9).name;
    fileID5=fopen(strcat('F:\课题\数据\原始光谱数据\标准单一气体\CS2\bd\',file_list5(i9).name));
    A5=textscan(fileID5,'%f%f');
    Q5=[Q5;A5];
    fclose all;
end
beidibochang_CS2=Q5{1,1};
a5=zeros(length(beidibochang_CS2),1);
for i10=1:length(Q5)
    a5=a5+Q5{i10,2};
end
beidiguangqiang_CS2=a5/length(Q5);
beidishuju_CS2=[beidibochang_CS2 beidiguangqiang_CS2];
%% 标准谱1的透过谱采用最后10个
for i11=(len6-9):1:len6
    file_list6(i11).name;
    fileID6=fopen(strcat('F:\课题\数据\原始光谱数据\标准单一气体\CS2\180ppbCS2\',file_list6(i11).name));
    A6=textscan(fileID6,'%f%f');
    Q6=[Q6;A6];
    fclose all;
end
celiangbochang_CS2=Q6{1,1};
a6=zeros(length(celiangbochang_CS2),1);
for i12=1:length(Q6)
    a6=a6+Q6{i12,2};
end
celiangguangqiang_CS2=a6/length(Q6);
celiangshuju_CS2=[celiangbochang_CS2 celiangguangqiang_CS2];
%% 测量波长与拟合波长选取
u_CS2=u0;v_CS2=210;%测量波段
u_CS2_0=u_CS2-1;v_CS2_0=v_CS2+1;%拟合波段
u_CS2_1 = findClosestNum(beidibochang_CS2, u_CS2);
v_CS2_1 = findClosestNum(beidibochang_CS2, v_CS2);
u_CS2_2 = findClosestNum(beidibochang_CS2, u_CS2_0);
v_CS2_2 = findClosestNum(beidibochang_CS2, v_CS2_0);
wave_CS2_1=[u_CS2_1,v_CS2_1];
wave_CS2_2=[u_CS2_2,v_CS2_2];
%% 标准CS2差分谱
xishoupu_CS2=celiangguangqiang_CS2./beidiguangqiang_CS2;
u001 = find(celiangbochang_CS2==u_CS2_1);
v001 = find(celiangbochang_CS2==v_CS2_1);
yongdexishoupu_CS2=xishoupu_CS2(u001:v001,1);
yongdebochang_CS2=celiangbochang_CS2(u001:v001,1);%用的吸收谱波长选取

u012 = find(celiangbochang_CS2==u_CS2_2);
v012 = find(celiangbochang_CS2==v_CS2_2);
nihebochang_CS2=celiangbochang_CS2(u012:v012,1);
nihexishoupu_CS2=xishoupu_CS2(u012:v012,1);

manbianxishou_CS2=polyfit(nihebochang_CS2,nihexishoupu_CS2,4);
manbianxishou_CS2=polyval(manbianxishou_CS2,nihebochang_CS2);
manbianpu_CS2=[nihebochang_CS2,manbianxishou_CS2];
u022 = find(nihebochang_CS2==u_CS2_1);
v022 = find(nihebochang_CS2==v_CS2_1);
yongdemanbian_CS2=manbianpu_CS2(u022:v022,:);%用的慢变拟合波段选取

kuaibianxishoupu_CS2=yongdexishoupu_CS2./yongdemanbian_CS2(:,2);
chafenpu_CS2=log(kuaibianxishoupu_CS2);%取对数
% figure
% plot(yongdebochang_CS2,chafenpu_CS2,'r')
%legend('标准CS2')
A_CS2=[yongdebochang_CS2 chafenpu_CS2];
%% CS2_concertration待测波段选取
% len_CS2=length(A_CS2);
% M_chfenepu=A_getCS2(1:len_CS2,:);
wave_1=find(A_getCS2(:,1)==u_CS2_1);
wave_2=find(A_getCS2(:,1)==v_CS2_1);
M_chfenepu=A_getCS2(wave_1:wave_2,:);
%% 排序
% a_CS2=1:len_CS2;
a_CS2=1:length(M_chfenepu);
Y_CS2=[A_CS2(:,2) M_chfenepu(:,2) a_CS2'];
Y0_CS2=[A_CS2(:,2) M_chfenepu(:,2)];
Y1_CS2=sortrows(Y_CS2,1);%标准谱从小到大排序，测量谱跟着变动
Y01_CS2=sortrows(Y0_CS2,1);
%% 图8 标准谱线性
X_CS2=[];
X_CS2(1)=0;
for p01=2:length(Y1_CS2)
    X_CS2(p01)=1*(Y1_CS2(p01,1)-Y1_CS2(p01-1,1))+X_CS2(p01-1);
    p01=p01+1;
end
XX_CS2=X_CS2';
% lunwen02=[X_CS2' Y01_CS2];
% figure
% plot(X_CS2,Y01_CS2);
%legend('标准排序','待测排序')
%% 图 线性标准谱，拟合测量谱
yn_CS2=polyfit(X_CS2,Y01_CS2(:,2),1);
ynn_CS2=polyval(yn_CS2,X_CS2);

% figure
% plot(X_CS2,ynn_CS2,'b');
% legend('拟合')
C_CS2=(yn_CS2(1)*S_C_CS2)/6.4;
%% CS2逆重构
Y1_CS2(:,2)=ynn_CS2';
Y_CS2_CS2=sortrows(Y1_CS2,3);

fprintf('SO2 = %f, CS2 = %f\n', C_SO2, C_CS2);
format compact
end
