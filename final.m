vid = videoinput('winvideo', 2, 'YUY2_640x480');
preview(vid)
pause(1)
aur=arduino('COM1');
pinMode(aur,12,'output');
pinMode(aur,13,'output');
pinMode(aur,11,'output');
pinMode(aur,10,'output');

while(1)

    im=getsnapshot(vid);
    im=ycbcr2rgb(im);
    r_c=im(:,:,1);
    g_c=im(:,:,2);
b_c=im(:,:,3);
%subplot(1,3,1);imshow(r_c);subplot(1,3,2);imshow(g_c);subplot(1,3,3);imshow(b_c);
out=0;
r_out=r_c<5;
g_out=g_c<5;
b_out=b_c<5;
%figure(2);
%subplot(1,3,1);imshow(r_out);subplot(1,3,2);imshow(g_out);subplot(1,3,3);imshow(b_out);
out=r_out;
s=strel('disk',2);
out=imdilate(out,s);
se=strel('disk',10);
out=imerode(out,se);
a=zeros(480,640);
a(129,:)=1;
a(301,:)=1;
a(:,179)=1;
a(:,401)=1;
R1=zeros(480,640);
R2=zeros(480,640);
R3=zeros(480,640);
R4=zeros(480,640);
for x=1:179
    for y=130:299
        R1(y,x)=1;
    end
end
for x=180:400
    for y=130:299
        R2(y,x)=1;
    end
end
for x=400:640
    for y=130:299
        R3(y,x)=1;
    end
end
for x=180:400
    for y=300:480
        R4(y,x)=1;
    end
end
R1_o=and(out,R1);
R2_o=and(out,R2);
R3_o=and(out,R3);
R4_o=and(out,R4);
%subplot(1,4,1);imshow(R1_o);subplot(1,4,2);imshow(R2_o);subplot(1,4,3);imshow(R3_o);subplot(1,4,4);imshow(R4_o);
R1_c=size(find(R1_o(:)==1));
R2_c=size(find(R2_o(:)==1));
R3_c=size(find(R3_o(:)==1));
R4_c=size(find(R4_o(:)==1));
M1=max(R1_c(1,1),R2_c(1,1));
M2=max(R3_c(1,1),R4_c(1,1));
M=max(M1,M2);
if R1_c(1,1)==M
   out=R1;
   digitalWrite(aur,12,1);
   digitalWrite(aur,13,0);
   digitalWrite(aur,11,0);
   digitalWrite(aur,10,0);
   disp('Left')
   
elseif R2_c(1,1)==M
    out=R2;
    digitalWrite(aur,12,0);
    digitalWrite(aur,13,0);
    digitalWrite(aur,11,0);
    digitalWrite(aur,10,0);
    
elseif R3_c(1,1)==M
    out=R3;
    digitalWrite(aur,10,1);
    digitalWrite(aur,11,0);
    digitalWrite(aur,12,0);
    digitalWrite(aur,13,0);
   
    disp('Right')
   
elseif R4_c(1,1)==M
    out=R4;   
    digitalWrite(aur,10,1);
    digitalWrite(aur,11,0);
    digitalWrite(aur,12,1);
    digitalWrite(aur,13,0);
    disp('Forward')
else
    out=0;
end
imshow(out);
pause(1)

    %close all
    clear im
end
