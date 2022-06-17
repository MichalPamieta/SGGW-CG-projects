r1 = [ 20; 20; 20; 1]; 
r2 = [ 20;-20; 20; 1]; 
r3 = [-20;-20; 20; 1];
r4 = [-20; 20; 20; 1];
r5 = [0; 0; 10; 1];

Int = 245;
Amb = 10;

Ish1 = inside(r1,r5,r2, 480, 640, 0.1, 0.1);
[A1, B1, C1, D1] = plane(r1,r5,r2);
nA = [A1;B1;C1]/norm([A1;B1;C1]);

Ish2 = inside(r2,r5,r3, 480, 640, 0.1, 0.1);
[A2, B2, C2, D2] = plane(r2,r5,r3);
nB = [A2;B2;C2]/norm([A2;B2;C2]);

Ish3 = inside(r3,r5,r4, 480, 640, 0.1, 0.1);
[A3, B3, C3, D3] = plane(r3,r5,r4);
nC = [A3;B3;C3]/norm([A3;B3;C3]);

Ish4 = inside(r4,r5,r1, 480, 640, 0.1, 0.1);
[A4, B4, C4, D4] = plane(r4,r5,r1);
nD = [A4;B4;C4]/norm([A4;B4;C4]);

%% Zadanie 1 A

Im1 = uint8(zeros(480,640));
lamp = [10;0;0];

% pierwszy naroznik
x = r1(1); y=r1(2); z = r1(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nD; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int1 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% drugi naroznik
x = r2(1); y=r2(2); z = r2(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nB; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int2 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% trzeci naroznik
x = r3(1); y=r3(2); z = r3(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nB+nC; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int3 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% czwarty naroznik
x = r4(1); y=r4(2); z = r4(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nC+nD;
cs = n1'*l1; if cs < 0 cs = 0; end
Int4 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% piaty naroznik
x = r5(1); y=r5(2); z = r5(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nB+nC+nD;
cs = n1'*l1; if cs < 0 cs = 0; end
Int5 = Amb + Int * cs / (1+0.001*dist1*dist1);   


for i = 1:640
    for j = 1:480
        if Ish1(j,i)==255
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A1,B1,C1,D1, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nA'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            Im1(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
        end
        if Ish2(j,i)==255 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A2,B2,C2,D2, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nB'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            Im1(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
        end
        if Ish3(j,i)==255 && Ish2(j,i) == 0 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A3,B3,C3,D3, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nC'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            Im1(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
        end
        if Ish4(j,i)==255 && Ish3(j,i) == 0 && Ish2(j,i) == 0 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A4,B4,C4,D4, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nD'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            Im1(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
        end
    end
end
figure(1);imshow(Im1);


%% Zadanie 1 B

Im2 = uint8(zeros(480,640));
lamp = [-5;-5;0];


% pierwszy naroznik
x = r1(1); y=r1(2); z = r1(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nD; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int1 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% drugi naroznik
x = r2(1); y=r2(2); z = r2(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nB; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int2 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% trzeci naroznik
x = r3(1); y=r3(2); z = r3(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nB+nC; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int3 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% czwarty naroznik
x = r4(1); y=r4(2); z = r4(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nC+nD;
cs = n1'*l1; if cs < 0 cs = 0; end
Int4 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% piaty naroznik
x = r5(1); y=r5(2); z = r5(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nB+nC+nD;
cs = n1'*l1; if cs < 0 cs = 0; end
Int5 = Amb + Int * cs / (1+0.001*dist1*dist1);   


for i = 1:640
    for j = 1:480
        if Ish1(j,i)==255
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A1,B1,C1,D1, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nA'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            Im2(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
        end
        if Ish2(j,i)==255 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A2,B2,C2,D2, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nB'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            Im2(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
        end
        if Ish3(j,i)==255 && Ish2(j,i) == 0 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A3,B3,C3,D3, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nC'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            Im2(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
        end
        if Ish4(j,i)==255 && Ish3(j,i) == 0 && Ish2(j,i) == 0 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A4,B4,C4,D4, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nD'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            Im2(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
        end
    end
end
figure(2);imshow(Im2);


%% Zadanie 1 C


Im3 = uint8(zeros(480,640));
lamp = [10;0;0];
eye = [65;0;0];
m = 15;


% pierwszy naroznik
x = r1(1); y=r1(2); z = r1(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nD; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int1 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% drugi naroznik
x = r2(1); y=r2(2); z = r2(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nB; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int2 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% trzeci naroznik
x = r3(1); y=r3(2); z = r3(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nB+nC; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int3 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% czwarty naroznik
x = r4(1); y=r4(2); z = r4(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nC+nD;
cs = n1'*l1; if cs < 0 cs = 0; end
Int4 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% piaty naroznik
x = r5(1); y=r5(2); z = r5(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nB+nC+nD;
cs = n1'*l1; if cs < 0 cs = 0; end
Int5 = Amb + Int * cs / (1+0.001*dist1*dist1);   


for i = 1:640
    for j = 1:480
        if Ish1(j,i)==255
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A1,B1,C1,D1, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nA'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
            rp = 2*(nA'*l1)*nA-l1;
            rp = rp/norm(rp);
            vp = [x;y;z]-eye;
            vp = vp/norm(vp);
            cs2 = rp'*vp; 
            if cs2 < 0 
                cs2 = 0; 
            end
            temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
            if temp > 255 
                temp = 255; 
            end
            Im3(j,i) = temp;
        end
        if Ish2(j,i)==255 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A2,B2,C2,D2, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nB'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
            rp = 2*(nB'*l1)*nB-l1;
            rp = rp/norm(rp);
            vp = [x;y;z]-eye;
            vp = vp/norm(vp);
            cs2 = rp'*vp; 
            if cs2 < 0 
                cs2 = 0; 
            end
            temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
            if temp > 255 
                temp = 255; 
            end
            Im3(j,i) = temp;
        end
        if Ish3(j,i)==255 && Ish2(j,i) == 0 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A3,B3,C3,D3, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nC'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
            rp = 2*(nC'*l1)*nC-l1;
            rp = rp/norm(rp);
            vp = [x;y;z]-eye;
            vp = vp/norm(vp);
            cs2 = rp'*vp; 
            if cs2 < 0 
                cs2 = 0; 
            end
            temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
            if temp > 255 
                temp = 255; 
            end
            Im3(j,i) = temp;
        end
        if Ish4(j,i)==255 && Ish3(j,i) == 0 && Ish2(j,i) == 0 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A4,B4,C4,D4, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nD'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
            rp = 2*(nD'*l1)*nD-l1;
            rp = rp/norm(rp);
            vp = [x;y;z]-eye;
            vp = vp/norm(vp);
            cs2 = rp'*vp; 
            if cs2 < 0 
                cs2 = 0; 
            end
            temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
            if temp > 255 
                temp = 255; 
            end
            Im3(j,i) = temp;
        end
    end
end
figure(3);imshow(Im3);


%% Zadanie 1 D


Im4 = uint8(zeros(480,640));
lamp = [-5;-5;0];
eye = [65;0;0];
m = 15;


% pierwszy naroznik
x = r1(1); y=r1(2); z = r1(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nD; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int1 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% drugi naroznik
x = r2(1); y=r2(2); z = r2(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nB; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int2 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% trzeci naroznik
x = r3(1); y=r3(2); z = r3(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nB+nC; %n = n/norm(n);
cs = n1'*l1; if cs < 0 cs = 0; end
Int3 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% czwarty naroznik
x = r4(1); y=r4(2); z = r4(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nC+nD;
cs = n1'*l1; if cs < 0 cs = 0; end
Int4 = Amb + Int * cs / (1+0.001*dist1*dist1);   

% piaty naroznik
x = r5(1); y=r5(2); z = r5(3);
l1 = [x;y;z] - lamp;
dist1 = norm(l1);
l1 = l1/dist1;       
n1 = nA+nB+nC+nD;
cs = n1'*l1; if cs < 0 cs = 0; end
Int5 = Amb + Int * cs / (1+0.001*dist1*dist1);   


for i = 1:640
    for j = 1:480
        if Ish1(j,i)==255
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A1,B1,C1,D1, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nA'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
            rp = 2*(nA'*l1)*nA-l1;
            rp = rp/norm(rp);
            vp = [x;y;z]-eye;
            vp = vp/norm(vp);
            cs2 = rp'*vp; 
            if cs2 < 0 
                cs2 = 0; 
            end
            temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
            if temp > 255 
                temp = 255; 
            end
            Im4(j,i) = temp;
        end
        if Ish2(j,i)==255 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A2,B2,C2,D2, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nB'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
            rp = 2*(nB'*l1)*nB-l1;
            rp = rp/norm(rp);
            vp = [x;y;z]-eye;
            vp = vp/norm(vp);
            cs2 = rp'*vp; 
            if cs2 < 0 
                cs2 = 0; 
            end
            temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
            if temp > 255 
                temp = 255; 
            end
            Im4(j,i) = temp;
        end
        if Ish3(j,i)==255 && Ish2(j,i) == 0 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A3,B3,C3,D3, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nC'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
            rp = 2*(nC'*l1)*nC-l1;
            rp = rp/norm(rp);
            vp = [x;y;z]-eye;
            vp = vp/norm(vp);
            cs2 = rp'*vp; 
            if cs2 < 0 
                cs2 = 0; 
            end
            temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
            if temp > 255 
                temp = 255; 
            end
            Im4(j,i) = temp;
        end
        if Ish4(j,i)==255 && Ish3(j,i) == 0 && Ish2(j,i) == 0 && Ish1(j,i) == 0
            [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
            [d,x,y,z] = dist2plane(A4,B4,C4,D4, xx,yy, 0,0,0,1);
            l1 = [x;y;z] - lamp;
            dist1 = norm(l1);
            l1 = l1/dist1;
            cs1 = nD'*l1; 
            if cs1 < 0
                cs1 = 0; 
            end
            temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
            rp = 2*(nD'*l1)*nD-l1;
            rp = rp/norm(rp);
            vp = [x;y;z]-eye;
            vp = vp/norm(vp);
            cs2 = rp'*vp; 
            if cs2 < 0 
                cs2 = 0; 
            end
            temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
            if temp > 255 
                temp = 255; 
            end
            Im4(j,i) = temp;
        end
    end
end
figure(4);imshow(Im4);

%% Zadanie 2 A

% Im5 = uint8(zeros(480,640));
% 
% v = VideoWriter('resultProj2.avi');
% open(v);
% 
% 
% for k = 1:3
%     for t = 0:99
%         lampx = 10 * cos(2*pi*(t*0.01));
%         lampy = 10 * sin(2*pi*(t*0.01));
% 
%         lamp = [lampx;lampy;0];
% 
% 
%         % pierwszy naroznik
%         x = r1(1); y=r1(2); z = r1(3);
%         l1 = [x;y;z] - lamp;
%         dist1 = norm(l1);
%         l1 = l1/dist1;       
%         n1 = nA+nD; %n = n/norm(n);
%         cs = n1'*l1; if cs < 0 cs = 0; end
%         Int1 = Amb + Int * cs / (1+0.001*dist1*dist1);   
% 
%         % drugi naroznik
%         x = r2(1); y=r2(2); z = r2(3);
%         l1 = [x;y;z] - lamp;
%         dist1 = norm(l1);
%         l1 = l1/dist1;       
%         n1 = nA+nB; %n = n/norm(n);
%         cs = n1'*l1; if cs < 0 cs = 0; end
%         Int2 = Amb + Int * cs / (1+0.001*dist1*dist1);   
% 
%         % trzeci naroznik
%         x = r3(1); y=r3(2); z = r3(3);
%         l1 = [x;y;z] - lamp;
%         dist1 = norm(l1);
%         l1 = l1/dist1;       
%         n1 = nB+nC; %n = n/norm(n);
%         cs = n1'*l1; if cs < 0 cs = 0; end
%         Int3 = Amb + Int * cs / (1+0.001*dist1*dist1);   
% 
%         % czwarty naroznik
%         x = r4(1); y=r4(2); z = r4(3);
%         l1 = [x;y;z] - lamp;
%         dist1 = norm(l1);
%         l1 = l1/dist1;       
%         n1 = nC+nD;
%         cs = n1'*l1; if cs < 0 cs = 0; end
%         Int4 = Amb + Int * cs / (1+0.001*dist1*dist1);   
% 
%         % piaty naroznik
%         x = r5(1); y=r5(2); z = r5(3);
%         l1 = [x;y;z] - lamp;
%         dist1 = norm(l1);
%         l1 = l1/dist1;       
%         n1 = nA+nB+nC+nD;
%         cs = n1'*l1; if cs < 0 cs = 0; end
%         Int5 = Amb + Int * cs / (1+0.001*dist1*dist1);   
% 
% 
%         for i = 1:640
%             for j = 1:480
%                 if Ish1(j,i)==255
%                     [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
%                     [d,x,y,z] = dist2plane(A1,B1,C1,D1, xx,yy, 0,0,0,1);
%                     l1 = [x;y;z] - lamp;
%                     dist1 = norm(l1);
%                     l1 = l1/dist1;
%                     cs1 = nA'*l1; 
%                     if cs1 < 0
%                         cs1 = 0; 
%                     end
%                     Im5(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
%                     
%                 end
%                 if Ish2(j,i)==255 && Ish1(j,i) == 0
%                     [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
%                     [d,x,y,z] = dist2plane(A2,B2,C2,D2, xx,yy, 0,0,0,1);
%                     l1 = [x;y;z] - lamp;
%                     dist1 = norm(l1);
%                     l1 = l1/dist1;
%                     cs1 = nB'*l1; 
%                     if cs1 < 0
%                         cs1 = 0; 
%                     end
%                     Im5(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
%                 end
%                 if Ish3(j,i)==255 && Ish2(j,i) == 0 && Ish1(j,i) == 0
%                     [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
%                     [d,x,y,z] = dist2plane(A3,B3,C3,D3, xx,yy, 0,0,0,1);
%                     l1 = [x;y;z] - lamp;
%                     dist1 = norm(l1);
%                     l1 = l1/dist1;
%                     cs1 = nC'*l1; 
%                     if cs1 < 0
%                         cs1 = 0; 
%                     end
%                     Im5(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
%                 end
%                 if Ish4(j,i)==255 && Ish3(j,i) == 0 && Ish2(j,i) == 0 && Ish1(j,i) == 0
%                     [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
%                     [d,x,y,z] = dist2plane(A4,B4,C4,D4, xx,yy, 0,0,0,1);
%                     l1 = [x;y;z] - lamp;
%                     dist1 = norm(l1);
%                     l1 = l1/dist1;
%                     cs1 = nD'*l1; 
%                     if cs1 < 0
%                         cs1 = 0; 
%                     end
%                     Im5(j,i) = uint8(Amb + Int * cs1 / (1+0.001*dist1*dist1));
%                 end
%             end
%         end
%         writeVideo(v, Im5);
%     end
% end
% close(v);


%% Zadanie 2 B


% Im6 = uint8(zeros(480,640));
% 
% 
% m = 15;
% 
% v = VideoWriter('resultProj2Phong.avi');
% open(v);
% 
% for k = 1:1
%     for t = 0:99
%         eyex = 60 + 5 * cos(2*pi*(t*0.01));
%         eyey = 10 * sin(2*pi*(t*0.01));
%         eye = [eyex;eyey;0];
% 
%         lampx = 10 * cos(2*pi*(t*0.01));
%         lampy = 10 * sin(2*pi*(t*0.01));
% 
%         lamp = [lampx;lampy;0];
% 
% 
%         % pierwszy naroznik
%         x = r1(1); y=r1(2); z = r1(3);
%         l1 = [x;y;z] - lamp;
%         dist1 = norm(l1);
%         l1 = l1/dist1;       
%         n1 = nA+nD; %n = n/norm(n);
%         cs = n1'*l1; if cs < 0 cs = 0; end
%         Int1 = Amb + Int * cs / (1+0.001*dist1*dist1);   
% 
%         % drugi naroznik
%         x = r2(1); y=r2(2); z = r2(3);
%         l1 = [x;y;z] - lamp;
%         dist1 = norm(l1);
%         l1 = l1/dist1;       
%         n1 = nA+nB; %n = n/norm(n);
%         cs = n1'*l1; if cs < 0 cs = 0; end
%         Int2 = Amb + Int * cs / (1+0.001*dist1*dist1);   
% 
%         % trzeci naroznik
%         x = r3(1); y=r3(2); z = r3(3);
%         l1 = [x;y;z] - lamp;
%         dist1 = norm(l1);
%         l1 = l1/dist1;       
%         n1 = nB+nC; %n = n/norm(n);
%         cs = n1'*l1; if cs < 0 cs = 0; end
%         Int3 = Amb + Int * cs / (1+0.001*dist1*dist1);   
% 
%         % czwarty naroznik
%         x = r4(1); y=r4(2); z = r4(3);
%         l1 = [x;y;z] - lamp;
%         dist1 = norm(l1);
%         l1 = l1/dist1;       
%         n1 = nC+nD;
%         cs = n1'*l1; if cs < 0 cs = 0; end
%         Int4 = Amb + Int * cs / (1+0.001*dist1*dist1);   
% 
%         % piaty naroznik
%         x = r5(1); y=r5(2); z = r5(3);
%         l1 = [x;y;z] - lamp;
%         dist1 = norm(l1);
%         l1 = l1/dist1;       
%         n1 = nA+nB+nC+nD;
%         cs = n1'*l1; if cs < 0 cs = 0; end
%         Int5 = Amb + Int * cs / (1+0.001*dist1*dist1);   
% 
% 
%         for i = 1:640
%             for j = 1:480
%                 if Ish1(j,i)==255
%                     [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
%                     [d,x,y,z] = dist2plane(A1,B1,C1,D1, xx,yy, 0,0,0,1);
%                     l1 = [x;y;z] - lamp;
%                     dist1 = norm(l1);
%                     l1 = l1/dist1;
%                     cs1 = nA'*l1; 
%                     if cs1 < 0
%                         cs1 = 0; 
%                     end
%                     temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
%                     rp = 2*(nA'*l1)*nA-l1;
%                     rp = rp/norm(rp);
%                     vp = [x;y;z]-eye;
%                     vp = vp/norm(vp);
%                     cs2 = rp'*vp; 
%                     if cs2 < 0 
%                         cs2 = 0; 
%                     end
%                     temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
%                     if temp > 255 
%                         temp = 255; 
%                     end
%                     Im6(j,i) = temp;
%                 end
%                 if Ish2(j,i)==255 && Ish1(j,i) == 0
%                     [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
%                     [d,x,y,z] = dist2plane(A2,B2,C2,D2, xx,yy, 0,0,0,1);
%                     l1 = [x;y;z] - lamp;
%                     dist1 = norm(l1);
%                     l1 = l1/dist1;
%                     cs1 = nB'*l1; 
%                     if cs1 < 0
%                         cs1 = 0; 
%                     end
%                     temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
%                     rp = 2*(nB'*l1)*nB-l1;
%                     rp = rp/norm(rp);
%                     vp = [x;y;z]-eye;
%                     vp = vp/norm(vp);
%                     cs2 = rp'*vp; 
%                     if cs2 < 0 
%                         cs2 = 0; 
%                     end
%                     temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
%                     if temp > 255 
%                         temp = 255; 
%                     end
%                     Im6(j,i) = temp;
%                 end
%                 if Ish3(j,i)==255 && Ish2(j,i) == 0 && Ish1(j,i) == 0
%                     [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
%                     [d,x,y,z] = dist2plane(A3,B3,C3,D3, xx,yy, 0,0,0,1);
%                     l1 = [x;y;z] - lamp;
%                     dist1 = norm(l1);
%                     l1 = l1/dist1;
%                     cs1 = nC'*l1; 
%                     if cs1 < 0
%                         cs1 = 0; 
%                     end
%                     temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
%                     rp = 2*(nC'*l1)*nC-l1;
%                     rp = rp/norm(rp);
%                     vp = [x;y;z]-eye;
%                     vp = vp/norm(vp);
%                     cs2 = rp'*vp; 
%                     if cs2 < 0 
%                         cs2 = 0; 
%                     end
%                     temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
%                     if temp > 255 
%                         temp = 255; 
%                     end
%                     Im6(j,i) = temp;
%                 end
%                 if Ish4(j,i)==255 && Ish3(j,i) == 0 && Ish2(j,i) == 0 && Ish1(j,i) == 0
%                     [xx,yy] = im2real(640,480, 0.1,0.1,i,j);
%                     [d,x,y,z] = dist2plane(A4,B4,C4,D4, xx,yy, 0,0,0,1);
%                     l1 = [x;y;z] - lamp;
%                     dist1 = norm(l1);
%                     l1 = l1/dist1;
%                     cs1 = nD'*l1; 
%                     if cs1 < 0
%                         cs1 = 0; 
%                     end
%                     temp = Amb+Int*cs1/(1+0.001*dist1*dist1);
%                     rp = 2*(nD'*l1)*nD-l1;
%                     rp = rp/norm(rp);
%                     vp = [x;y;z]-eye;
%                     vp = vp/norm(vp);
%                     cs2 = rp'*vp; 
%                     if cs2 < 0 
%                         cs2 = 0; 
%                     end
%                     temp = temp + (Int/(1+0.001*dist1*dist1))*(cs2^m); % dowolna potega
%                     if temp > 255 
%                         temp = 255; 
%                     end
%                     Im6(j,i) = temp;
%                 end
%             end
%         end
%         writeVideo(v, Im6);
%     end
% end
% close(v);




%% Funkcje do zadañ
function Im = inside(r1,r2,r3,m,n,dy,dx)
x1=r1(1); y1=r1(2);
x2=r2(1); y2=r2(2);
x3=r3(1); y3=r3(2);

A1 = y3-y2; B1 = x2-x3; C1=y2*(x3-x2)-x2*(y3-y2);
A2 = y3-y1; B2 = x1-x3; C2=y1*(x3-x1)-x1*(y3-y1);
A3 = y1-y2; B3 = x2-x1; C3=y2*(x1-x2)-x2*(y1-y2);

Im = uint8(zeros(m,n));
for i = 1:m
    y = (m/2-i)*dy;
    for j = 1:n
        x=(j-n/2)*dx;
        vis = test(x,y,x1,y1,x2,y2,x3,y3,A1,B1,C1,A2,B2,C2,A3,B3,C3);
        if vis>0
            Im(i,j)=255;
        end
    end
end
end

function [A,B,C,D] = plane(p1,p2,p3)
A = det([p1(2),p1(3),1;
    p2(2),p2(3),1;
    p3(2),p3(3),1]);

B = -det([p1(1),p1(3),1;
    p2(1),p2(3),1;
    p3(1),p3(3),1]);

C = det([p1(1),p1(2),1;
    p2(1),p2(2),1;
    p3(1),p3(2),1]);

D = -det([p1(1),p1(2),p1(3);
    p2(1),p2(2),p2(3);
    p3(1),p3(2),p3(3)]);
end

function [d,x1,y1,z1] = dist2plane(A,B,C,D, x,y,z,l, m,n)
d = NaN;
ro = (A*x + B*y+  C*z + D) / (A*l + B*m + C*n);
x1 = x - l*ro;
y1 = y - m*ro;
z1 = z - n*ro;
d = sqrt((x-x1)^2 + (y-y1)^2 + (z-z1)^2);
end

function v = test(x,y,x1,y1,x2,y2,x3,y3,A1,B1,C1,A2,B2,C2,A3,B3,C3)
r1=(A1*x1+B1*y1+C1)*(A1*x+B1*y+C1);
r2=(A2*x2+B2*y2+C2)*(A2*x+B2*y+C2);
r3=(A3*x3+B3*y3+C3)*(A3*x+B3*y+C3);
if r1>=0 && r2>=0 && r3>=0
    v=1;
else
    v=0;
end
end

function [x,y] = im2real(m,n,dx,dy,i,j)
T = [dx,0,-0.5*m*dx;
    0,-dy,0.5*n*dy;
    0,0,1];
vin = [i;j;1];
vout = T*vin;
x = vout(1)/vout(3);
y = vout(2)/vout(3);
end
