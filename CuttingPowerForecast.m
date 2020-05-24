clear all
clc
format short g
[tumData] = xlsread('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\DataSet.xlsx','Sayfa1','D7:H62')
tumverip=tumData(1:56,1:4)                   %girdi seti   
tumverit=tumData(1:56,5)                     %��kt� seti
ptr=tumverip(1:38,1:4)                       %ptr e�itim girdisi
ttr=tumverit(1:38)                           %ttr e�itim ��kt�s�
val.P=tumverip(39:47,1:4)                    %val.P do�rulama girdisi
val.T=tumverit(39:47)                        %val.T do�rulama ��kt�s�
test.P=tumverip(48:56,1:4)                   %test.P test girdisi
test.T=tumverit(48:56)                       %test.T test ��kt�s� 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[tumveripn,ps]=mapminmax(tumverip')          %transpoze ve normalize i�lemi ps girdi seti normalize bilgisi
[tumveritn,ts]=mapminmax(tumverit')          %transpoze ve normalize i�lemi ts ��kt� seti normalize bilgisi

%[tumveripn,minp,maxp,tumveritn,mint,maxt]=premnmx(tumverip',tumverit') %Transpoze ��lemi
 
tumveripn=tumveripn'
tumveritn=tumveritn'
 
ptrn=tumveripn(1:38,1:4)             %ptrn normalize e�itim girdisi..
ttrn=tumveritn(1:38)                 %ttrn normalize e�itim ��kt�s�
valn.P=tumveripn(39:47,1:4)          %valn.P normalize do�rulama girdisi..
valn.T=tumveritn(39:47)              %valn.T normalize do�rulama ��kt�s�
testn.P=tumveripn(48:56,1:4)         %testn.P normalize test girdisi..
testn.T=tumveritn(48:56)             %testn.T normalize test ��kt�s�
ptrn=ptrn'                                 
ttrn=ttrn'                                  
valn.P=valn.P'
valn.T=valn.T'                               
testn.P=testn.P'                              
testn.T=testn.T'    
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

net=newff(minmax(ptrn),[3 4 1], {'tansig','tansig','purelin'},'trainlm')
net.trainParam.epochs=500
net.trainParam.goal=0.0001
net.trainParam.lr=0.4
net.trainParam.mc=0.6
net.trainParam.max_fail=30
   
 
[net,tr]=train(net,ptrn,ttrn,[],[],valn,testn)
 
 
an=sim(net,ptrn)           %normalize e�itim girdisi i�in a�� sim�le et
avn=sim(net,valn.P)        %normalize do�rulama girdisi i�in a�� sim�le et
atn=sim(net,testn.P)       %normalize test girdisi i�in a�� sim�le et
 
a=mapminmax('reverse',an,ts)       %an yi ts bilgisi ile denormalize et %a=postmnmx(an,mint,maxt)
av=mapminmax('reverse',avn,ts)      %avn yi ts bilgisi ile denormalize et %av=postmnmx(avn,mint,maxt)
at=mapminmax('reverse',atn,ts)     %atn yi ts bilgisi ile denormalize et %at=postmnmx(atn,mint,maxt)
 
 
 
[a]=a'
[av]=av'
[at]=at'
 
 
[m,n]=size(ttr)
mape_egitim=sum(abs((ttr-a)./ttr)*100)/m
rmse_egitim=sqrt(sum((ttr-a).^2)/m)
 
[m,n]=size(val.T)
mape_val=sum(abs((val.T-av)./val.T)*100)/m
rmse_val=sqrt(sum((val.T-av).^2)/m)
 
[m,n]=size(test.T)
mape_test=sum(abs((test.T-at)./test.T)*100)/m
rmse_test=sqrt(sum((test.T-at).^2)/m)
 
[mape_egitim, mape_val, mape_test]
[rmse_egitim, rmse_val, rmse_test]
 
figure(1)
[m,b,r]=postreg(a',ttr')
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\1.png','png')
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\1.fig','fig')

figure(2)
[m,b,r]=postreg(av',val.T')
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\2.png','png')
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\2.fig','fig')

 
figure(3)
[m,b,r]=postreg(at',test.T')
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\3.png','png')
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\3.fig','fig')

 
figure(4)
plot(ttr,'-or','LineWidth',1)
hold on
plot(a,'-.*b','LineWidth',1)
title('E�itim Verileri','FontSize',14)
legend('GER�EK','YSA','Location','NorthEast')
xlabel('�rnekler','FontSize',14);
ylabel('Cutting Power','FontSize',14)
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\4.png','png')
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\4.fig','fig')
 
figure(5)
plot(val.T,'-or','LineWidth',1)
hold on
plot(av,'-.*b','LineWidth',1)
title('Do�rulama Verileri','FontSize',14)
legend('GER�EK','YSA','Location','NorthEast')
xlabel('�rnekler','FontSize',14)
ylabel('Cutting Power','FontSize',14)
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\5.png','png')
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\5.fig','fig')
 
figure(6)
plot(test.T,'-or','LineWidth',1)
hold on
plot(at,'-.*b','LineWidth',1)
title('Test Verileri','FontSize',14)
legend('GER�EK','YSA','Location','NorthEast')
xlabel('�rnekler','FontSize',14)
ylabel('Cutting Power','FontSize',14)
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\6.png','png')
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\6.fig','fig')

 
save ('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\MyApp')
 
olcutler=[mape_egitim mape_val mape_test rmse_egitim rmse_val rmse_test];
xlswrite('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\�l��tler.xlsx',olcutler,'Sayfa1','G2');     
 
alldata=[[ptr,ttr,a,ttr-a,(((ttr-a).*100)./ttr)];[val.P,val.T,av,(val.T-av),(((val.T-av).*100)./val.T)];[test.P,test.T,at,(test.T-at),(((test.T-at).*100)./test.T)]];
xlswrite('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\�l��tler.xlsx',alldata,'Sayfa3','G2');
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%











%Burdan Sonras� Ayr� Bir ��lem A� Kaydedildikten sonra ilgili veriler olcutdata de�i�keni ile ��kar�l�r..
 
load MyApp
 
%MyApp isimli mat dosyas�n� a�ar...!Current Folderda A��k olmal�...!
%%olcutdata=[(((ttr-a).*100)./ttr)(((val.T-av).*100)./val.T)(((test.T-at).*100)./test.T)];
%olcutdata=[[ptr,ttr,a,ttr-a,(((ttr-a).*100)./ttr)];[val.P,val.T,av,(val.T-av),(((val.T-%av).*100)./val.T)];[test.P,test.T,at,(test.T-at),(((test.T-at).*100)./test.T)]];
%xlswrite('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\�l��tler.xlsx',olcutdata,'Sayfa4','G2');
 
%plotperform(net) %kurulan a��n mse ve iterasyon say�s�n� g�sterir...!
%view(net) kurulan a� yap�s�n� g�sterir
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
[depo]= xlsread('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\DataSet.xlsx','Sayfa1','D63:G66')
 
pnew=depo                          % pnew=depo;                           
[pnewn,ps]=mapminmax(pnew')         % pnewn=tramnmx(pnew',minp,maxp);      
anewn=sim(net,pnewn)              % anewn=sim(net,pnewn);                
anew=mapminmax('reverse',anewn,ts) % anew=postmnmx(anewn,mint,maxt);      
[pnew anew']                       % [pnew anew']                         
 
xlswrite('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\optimum.xlsx',[pnew,anew'],'Sayfa5','E8');
 
figure(7)
plot(tr.epoch, tr.perf, 'LineWidth' , 1)
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\7.png','png')
saveas(gcf,'D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\7.fig','fig')
 
 
net.IW{1,1}
net.b{1}
net.LW{2,1}
net.b{2}
net.LW{3,2}
net.b{3}
xlswrite('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\sonuc.xlsx', net.IW{1,1}, 'Sayfa3', 'C3');
xlswrite('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\sonuc.xlsx', net.b{1}, 'Sayfa3', 'M3');
xlswrite('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\sonuc.xlsx', net.LW{2,1}, 'Sayfa3', 'C14');
xlswrite('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\sonuc.xlsx', net.b{2}, 'Sayfa3', 'M14');
xlswrite('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\sonuc.xlsx', net.LW{3,2}, 'Sayfa3', 'C25');
xlswrite('D:\DERS ��ER�KLER�\YAPAY S�N�R A�LARI\ArtificialNeuralNetworks2\sonuc.xlsx', net.b{3}, 'Sayfa3', 'M25');
 


