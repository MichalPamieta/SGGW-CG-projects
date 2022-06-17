%% ZMIENNE POMOCNICZE I WARTOŚCI POCZĄTKOWE

% pierwszy trójkąt - czerwony
p11 = [2;0;0;1]; p12 = [-1;-1;2;1]; p13 = [-1;1;-2;1];
colort1 = red; % kolor pierwszego trójkąta

% drugi trójkąt - zielony
p21 = [0;-2;0;1]; p22 = [-1;2;1;1]; p23 = [1;2;-1;1];
colort2 = green; % kolor drugiego trójkąta

% ogniskowa
f = 5;

% pozycja kamery względem osi Z (zakładamy położenie x=0, y=0, z=pozcam)
pozcam = -10;

% wymiary obrazka 
m = 480;
n = 640;

% rozmiar piksela
pix = 0.01;

% numer albumu 196099
index = 99;
ind = 0.99;

% kolory
red = [255 0 0]; % czerwony
green = [0 255 0]; % zielony
blue = [0 0 255]; % niebieski
yellow = [255 255 0]; % żółty
magenta = [255 0 255]; % magenta (różowo-fioletowy)
cyan = [0 255 255]; % cyjan (jasnoniebieski)

%% WYWOŁANIA FUNKCJI I PRZEKSZTAŁCENIA

% transformacja pierwszego trójkąta - pozycja początkowa
H1 = RPYT(0,0,0,0,0,0);
r11 = H1*p11; r12 = H1*p12; r13 = H1*p13;

% transformacja drugiego trójkąta - pozycja początkowa
H2 = RPYT(0,0,0,0,0,0);
r21 = H2*p21; r22 = H2*p22; r23 = H2*p23;

HHH = Persp(f);

% rzuty perspektywiczne
rp11 = HHH*r11; rp11 = rp11/rp11(4);
rp12 = HHH*r12; rp12 = rp12/rp12(4);
rp13 = HHH*r13; rp13 = rp13/rp13(4);

rp21 = HHH*r21; rp21 = rp21/rp21(4);
rp22 = HHH*r22; rp22 = rp22/rp22(4);
rp23 = HHH*r23; rp23 = rp23/rp23(4);

[A1, B1, C1, D1] = plane(r11,r12,r13);
[A2, B2, C2, D2] = plane(r21,r22,r23);

%% CZĘŚĆ 1
SH1P = inside(rp11,rp12,rp13,m,n,pix,pix,colort1); figure(1); imshow(SH1P);
title('Rzut perspektywiczny pierwszego trójkąta - pozycja początkowa');
SH2P = inside(rp21,rp22,rp23,m,n,pix,pix,colort2); figure(2); imshow(SH2P);
title('Rzut perspektywiczny drugiego trójkąta - pozycja początkowa');

FImP = uint8(zeros(m,n,3)); %czarny
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp(:) = SH1P(i,j,1:3);
        if isequal(temp,colort1)
            d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH1P(i,j,1:3);
            end
        end
        temp(:) = SH2P(i,j,1:3);
        if isequal(temp,colort2)
            d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH2P(i,j,1:3);
            end
        end
    end
end
figure(3); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, brak przeźroczystości'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = blue; %niebieski
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp(:) = SH1P(i,j,1:3);
        if isequal(temp,colort1)
            d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH1P(i,j,1:3);
            end
        end
        temp(:) = SH2P(i,j,1:3);
        if isequal(temp,colort2)
            d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH2P(i,j,1:3);
            end
        end
    end
end
figure(4); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, brak przeźroczystości'});

FImP = uint8(255*ones(m,n,3)); %biały
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp(:) = SH1P(i,j,1:3);
        if isequal(temp,colort1)
            d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH1P(i,j,1:3);
            end
        end
        temp(:) = SH2P(i,j,1:3);
        if isequal(temp,colort2)
            d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH2P(i,j,1:3);
            end
        end
    end
end
figure(5); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, brak przeźroczystości'});

FImP = uint8(zeros(m,n,3)); %czarny
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(6); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 25%, przeźroczystość trójkątów 75%'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = blue; %niebieski
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(7); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 25%, przeźroczystość trójkątów 75%'});

FImP = uint8(255*ones(m,n,3)); %biały
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(8); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 25%, przeźroczystość trójkątów 75%'});

FImP = uint8(zeros(m,n,3)); %czarny
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(9); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 50%, przeźroczystość trójkątów 50%'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = blue; %niebieski
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(10); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 50%, przeźroczystość trójkątów 50%'});

FImP = uint8(255*ones(m,n,3)); %biały
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(11); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 50%, przeźroczystość trójkątów 50%'});

FImP = uint8(zeros(m,n,3)); %czarny
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(12); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 75%, przeźroczystość trójkątów 25%'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = blue; %niebieski
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(13); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 75%, przeźroczystość trójkątów 25%'});

FImP = uint8(255*ones(m,n,3)); %biały
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(14); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 75%, przeźroczystość trójkątów 25%'});

% transformacja pierwszego trójkąta - pozycja końcowa
H1 = RPYT(99,99,0,1,1,1);
r11 = H1*p11; r12 = H1*p12; r13 = H1*p13;

% transformacja drugiego trójkąta - pozycja końcowa
H2 = RPYT(0,99,99,1,1,-1);
r21 = H2*p21; r22 = H2*p22; r23 = H2*p23;

HHH = Persp(f);

% rzuty perspektywiczne
rp11 = HHH*r11; rp11 = rp11/rp11(4);
rp12 = HHH*r12; rp12 = rp12/rp12(4);
rp13 = HHH*r13; rp13 = rp13/rp13(4);

rp21 = HHH*r21; rp21 = rp21/rp21(4);
rp22 = HHH*r22; rp22 = rp22/rp22(4);
rp23 = HHH*r23; rp23 = rp23/rp23(4);

[A1, B1, C1, D1] = plane(r11,r12,r13);
[A2, B2, C2, D2] = plane(r21,r22,r23);

SH1P = inside(rp11,rp12,rp13,m,n,pix,pix,red); figure(15); imshow(SH1P);
title('Rzut perspektywiczny pierwszego trójkąta - pozycja końcowa');
SH2P = inside(rp21,rp22,rp23,m,n,pix,pix,green); figure(16); imshow(SH2P);
title('Rzut perspektywiczny drugiego trójkąta - pozycja końcowa');

FImP = uint8(zeros(m,n,3)); %czarny
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp(:) = SH1P(i,j,1:3);
        if isequal(temp,colort1)
            d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH1P(i,j,1:3);
            end
        end
        temp(:) = SH2P(i,j,1:3);
        if isequal(temp,colort2)
            d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH2P(i,j,1:3);
            end
        end
    end
end
figure(17); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, brak przeźroczystości'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = blue; %niebieski
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp(:) = SH1P(i,j,1:3);
        if isequal(temp,colort1)
            d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH1P(i,j,1:3);
            end
        end
        temp(:) = SH2P(i,j,1:3);
        if isequal(temp,colort2)
            d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH2P(i,j,1:3);
            end
        end
    end
end
figure(18); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, brak przeźroczystości'});

FImP = uint8(255*ones(m,n,3)); % biały
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp(:) = SH1P(i,j,1:3);
        if isequal(temp,colort1)
            d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH1P(i,j,1:3);
            end
        end
        temp(:) = SH2P(i,j,1:3);
        if isequal(temp,colort2)
            d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH2P(i,j,1:3);
            end
        end
    end
end
figure(19); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, brak przeźroczystości'});

FImP = uint8(zeros(m,n,3)); %czarny
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(20); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 25%, przeźroczystość trójkątów 75%'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = blue; %niebieski
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(21); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 25%, przeźroczystość trójkątów 75%'});

FImP = uint8(255*ones(m,n,3)); %biały
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(22); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 25%, przeźroczystość trójkątów 75%'});

FImP = uint8(zeros(m,n,3)); %czarny
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(23); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 50%, przeźroczystość trójkątów 50%'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = blue; %niebieski
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(24); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 50%, przeźroczystość trójkątów 50%'});

FImP = uint8(255*ones(m,n,3)); %biały
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(25); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 50%, przeźroczystość trójkątów 50%'});

FImP = uint8(zeros(m,n,3)); %czarny
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(26); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 75%, przeźroczystość trójkątów 25%'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = blue; %niebieski
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(27); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 75%, przeźroczystość trójkątów 25%'});

FImP = uint8(255*ones(m,n,3)); %biały
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(28); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 75%, przeźroczystość trójkątów 25%'});

% video
v = VideoWriter('SkryptPomocniczy1_Pamieta_196099.avi');
open(v);

for k = 1:4
  for l = 0:99
    % pierwsza transformacja
    H1 = RPYT(l*ind,l*ind,0,l*0.01,l*0.01,l*0.01);
    r11 = H1*p11; r12 = H1*p12; r13 = H1*p13;
    
    % druga transformacja
    H2 = RPYT(0,l*ind,l*ind,l*0.01,l*0.01,-l*0.01);
    r21 = H2*p21; r22 = H2*p22; r23 = H2*p23;
    
    HHH = Persp(f);
    
    % rzuty perspektywiczne
    rp11 = HHH*r11; rp11 = rp11/rp11(4);
    rp12 = HHH*r12; rp12 = rp12/rp12(4);
    rp13 = HHH*r13; rp13 = rp13/rp13(4);

    rp21 = HHH*r21; rp21 = rp21/rp21(4);
    rp22 = HHH*r22; rp22 = rp22/rp22(4);
    rp23 = HHH*r23; rp23 = rp23/rp23(4);
    
    [A1, B1, C1, D1] = plane(r11,r12,r13);
    [A2, B2, C2, D2] = plane(r21,r22,r23);
    
    SH1P = inside(rp11,rp12,rp13,m,n,pix,pix,colort1);
    SH2P = inside(rp21,rp22,rp23,m,n,pix,pix,colort2);
    
    % Z-buffer perspective
    FImP = uint8(zeros(m,n,3)); %czarny
    ZbufP = 1000000*ones(m,n); %nieskończoność
    for i = 1:m
        y = (m/2-i)/100;
        for j = 1:n
            x = (j-n/2)/100;
            temp(:) = SH1P(i,j,1:3);
            if isequal(temp,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = SH1P(i,j,1:3);
                end
            end
            temp(:) = SH2P(i,j,1:3);
            if isequal(temp,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = SH2P(i,j,1:3);
                end
            end
        end
    end
    writeVideo(v,FImP);
  end
  
  for l = 0:99
    % pierwsza transformacja
    H1 = RPYT(index-l*ind,index-l*ind,0,1-l*0.01,1-l*0.01,1-l*0.01);
    r11 = H1*p11; r12 = H1*p12; r13 = H1*p13;
    
    % druga transformacja
    H2 = RPYT(0,index-l*ind,index-l*ind,1-l*0.01,1-l*0.01,-1+l*0.01);
    r21 = H2*p21; r22 = H2*p22; r23 = H2*p23;
    
    HHH = Persp(f);
    
    % rzuty perspektywiczne
    rp11 = HHH*r11; rp11 = rp11/rp11(4);
    rp12 = HHH*r12; rp12 = rp12/rp12(4);
    rp13 = HHH*r13; rp13 = rp13/rp13(4);

    rp21 = HHH*r21; rp21 = rp21/rp21(4);
    rp22 = HHH*r22; rp22 = rp22/rp22(4);
    rp23 = HHH*r23; rp23 = rp23/rp23(4);
    
    [A1, B1, C1, D1] = plane(r11,r12,r13);
    [A2, B2, C2, D2] = plane(r21,r22,r23);
    
    SH1P = inside(rp11,rp12,rp13,m,n,pix,pix,colort1);
    SH2P = inside(rp21,rp22,rp23,m,n,pix,pix,colort2);

    % Z-buffer perspective
    FImP = uint8(zeros(m,n,3)); %czarny
    ZbufP = 1000000*ones(m,n); %nieskończoność
    for i = 1:m
        y = (m/2-i)/100;
        for j = 1:n
            x = (j-n/2)/100;
            temp(:) = SH1P(i,j,1:3);
            if isequal(temp,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = SH1P(i,j,1:3);
                end
            end
            temp(:) = SH2P(i,j,1:3);
            if isequal(temp,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = SH2P(i,j,1:3);
                end
            end
        end
    end
    writeVideo(v,FImP);
  end
end
close(v);

%% Inny przykład dla części 3

% nowe kolory: trójkąt 1 - magenta, trójkąt 2 - cyjan, tło - żółty
colort1 = magenta;
colort2 = cyan;

% transformacja pierwszego trójkąta - pozycja początkowa
H1 = RPYT(0,0,0,0,0,0);
r11 = H1*p11; r12 = H1*p12; r13 = H1*p13;

% transformacja drugiego trójkąta - pozycja początkowa
H2 = RPYT(0,0,0,0,0,0);
r21 = H2*p21; r22 = H2*p22; r23 = H2*p23;

HHH = Persp(f);

% rzuty perspektywiczne
rp11 = HHH*r11; rp11 = rp11/rp11(4);
rp12 = HHH*r12; rp12 = rp12/rp12(4);
rp13 = HHH*r13; rp13 = rp13/rp13(4);

rp21 = HHH*r21; rp21 = rp21/rp21(4);
rp22 = HHH*r22; rp22 = rp22/rp22(4);
rp23 = HHH*r23; rp23 = rp23/rp23(4);

[A1, B1, C1, D1] = plane(r11,r12,r13);
[A2, B2, C2, D2] = plane(r21,r22,r23);

SH1P = inside(rp11,rp12,rp13,m,n,pix,pix,colort1); figure(29); imshow(SH1P);
title('Rzut perspektywiczny pierwszego trójkąta - pozycja początkowa');
SH2P = inside(rp21,rp22,rp23,m,n,pix,pix,colort2); figure(30); imshow(SH2P);
title('Rzut perspektywiczny drugiego trójkąta - pozycja początkowa');

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = yellow; %żółty
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp(:) = SH1P(i,j,1:3);
        if isequal(temp,colort1)
            d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH1P(i,j,1:3);
            end
        end
        temp(:) = SH2P(i,j,1:3);
        if isequal(temp,colort2)
            d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH2P(i,j,1:3);
            end
        end
    end
end
figure(31); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, brak przeźroczystości'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = yellow; %żółty
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(32); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 25%, przeźroczystość trójkątów 75%'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = yellow; %żółty
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(33); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 50%, przeźroczystość trójkątów 50%'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = yellow; %żółty
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(34); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja początkowa, przeźroczystość drugiego planu: 75%, przeźroczystość trójkątów 25%'});

% transformacja pierwszego trójkąta - pozycja końcowa
H1 = RPYT(99,99,0,1,1,1);
r11 = H1*p11; r12 = H1*p12; r13 = H1*p13;

% transformacja drugiego trójkąta - pozycja końcowa
H2 = RPYT(0,99,99,1,1,-1);
r21 = H2*p21; r22 = H2*p22; r23 = H2*p23;

HHH = Persp(f);

% rzuty perspektywiczne
rp11 = HHH*r11; rp11 = rp11/rp11(4);
rp12 = HHH*r12; rp12 = rp12/rp12(4);
rp13 = HHH*r13; rp13 = rp13/rp13(4);

rp21 = HHH*r21; rp21 = rp21/rp21(4);
rp22 = HHH*r22; rp22 = rp22/rp22(4);
rp23 = HHH*r23; rp23 = rp23/rp23(4);

[A1, B1, C1, D1] = plane(r11,r12,r13);
[A2, B2, C2, D2] = plane(r21,r22,r23);

SH1P = inside(rp11,rp12,rp13,m,n,pix,pix,colort1); figure(35); imshow(SH1P);
title('Rzut perspektywiczny pierwszego trójkąta - pozycja końcowa');
SH2P = inside(rp21,rp22,rp23,m,n,pix,pix,colort2); figure(36); imshow(SH2P);
title('Rzut perspektywiczny drugiego trójkąta - pozycja końcowa');

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = yellow; %żółty
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp(:) = SH1P(i,j,1:3);
        if isequal(temp,colort1)
            d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH1P(i,j,1:3);
            end
        end
        temp(:) = SH2P(i,j,1:3);
        if isequal(temp,colort2)
            d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d<ZbufP(i,j)
                ZbufP(i,j) = d;
                FImP(i,j,1:3) = SH2P(i,j,1:3);
            end
        end
    end
end
figure(37); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, brak przeźroczystości'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = yellow; %żółty
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(38); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 25%, przeźroczystość trójkątów 75%'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = yellow; %żółty
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.5*FImP(i,j,1:3) + 0.5*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(39); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 50%, przeźroczystość trójkątów 50%'});

FImP = uint8(zeros(m,n,3));
for i = 1:m
    for j = 1:n
        FImP(i,j,1:3) = yellow; %żółty
    end
end
ZbufP = 1000000*ones(m,n); %nieskończoność
for i = 1:m
    y = (m/2-i)/100;
    for j = 1:n
        x = (j-n/2)/100;
        temp1(:) = SH1P(i,j,1:3);
        temp2(:) = SH2P(i,j,1:3);
        if isequal(temp1,colort1) && isequal(temp2,colort2)
            d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
            d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
            if d1 <= d2
                ZbufP(i,j) = d1;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
            else
                ZbufP(i,j) = d2;
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
            end
        else
            if isequal(temp1,colort1)
                d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH1P(i,j,1:3);
                end
            end
            if isequal(temp2,colort2)
                d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d<ZbufP(i,j)
                    ZbufP(i,j) = d;
                    FImP(i,j,1:3) = 0.75*FImP(i,j,1:3) + 0.25*SH2P(i,j,1:3);
                end
            end
        end
    end
end
figure(40); imshow(FImP); title({'Rzut perspektywiczny obu trójkątów (algorytm Z-bufora)','pozycja końcowa, przeźroczystość drugiego planu: 75%, przeźroczystość trójkątów 25%'});

% video - wersja alternatywna
valt = VideoWriter('Projekt1_Pamięta_196099_alt.avi');
open(valt);

for k = 1:4
  for l = 0:99
    % pierwsza transformacja
    H1 = RPYT(l*ind,l*ind,0,l*0.01,l*0.01,l*0.01);
    r11 = H1*p11; r12 = H1*p12; r13 = H1*p13;
    
    % druga transformacja
    H2 = RPYT(0,l*ind,l*ind,l*0.01,l*0.01,-l*0.01);
    r21 = H2*p21; r22 = H2*p22; r23 = H2*p23;
    
    HHH = Persp(f);
    
    % rzuty perspektywiczne
    rp11 = HHH*r11; rp11 = rp11/rp11(4);
    rp12 = HHH*r12; rp12 = rp12/rp12(4);
    rp13 = HHH*r13; rp13 = rp13/rp13(4);

    rp21 = HHH*r21; rp21 = rp21/rp21(4);
    rp22 = HHH*r22; rp22 = rp22/rp22(4);
    rp23 = HHH*r23; rp23 = rp23/rp23(4);
    
    [A1, B1, C1, D1] = plane(r11,r12,r13);
    [A2, B2, C2, D2] = plane(r21,r22,r23);
    
    SH1P = inside(rp11,rp12,rp13,m,n,pix,pix,colort1);
    SH2P = inside(rp21,rp22,rp23,m,n,pix,pix,colort2);
    
    % CZĘŚĆ 3
    % Z-buffer perspective
    FImP = uint8(zeros(m,n,3));
    for i = 1:m
        for j = 1:n
            FImP(i,j,1:3) = yellow; %żółty
        end
    end
    ZbufP = 1000000*ones(m,n); %nieskończoność
    for i = 1:m
        y = (m/2-i)/100;
        for j = 1:n
            x = (j-n/2)/100;
            temp1(:) = SH1P(i,j,1:3);
            temp2(:) = SH2P(i,j,1:3);
            if isequal(temp1,colort1) && isequal(temp2,colort2)
                d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d1 <= d2
                    ZbufP(i,j) = d1;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                else
                    ZbufP(i,j) = d2;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                end
            else
                if isequal(temp1,colort1)
                    d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                    if d<ZbufP(i,j)
                        ZbufP(i,j) = d;
                        FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                    end
                end
                if isequal(temp2,colort2)
                    d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                    if d<ZbufP(i,j)
                        ZbufP(i,j) = d;
                        FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                    end
                end
            end
        end
    end
    writeVideo(valt,FImP);
  end
  
  for l = 0:99
    % pierwsza transformacja
    H1 = RPYT(index-l*ind,index-l*ind,0,1-l*0.01,1-l*0.01,1-l*0.01);
    r11 = H1*p11; r12 = H1*p12; r13 = H1*p13;
    
    % druga transformacja
    H2 = RPYT(0,index-l*ind,index-l*ind,1-l*0.01,1-l*0.01,-1+l*0.01);
    r21 = H2*p21; r22 = H2*p22; r23 = H2*p23;
    
    HHH = Persp(f);
    
    % rzuty perspektywiczne
    rp11 = HHH*r11; rp11 = rp11/rp11(4);
    rp12 = HHH*r12; rp12 = rp12/rp12(4);
    rp13 = HHH*r13; rp13 = rp13/rp13(4);

    rp21 = HHH*r21; rp21 = rp21/rp21(4);
    rp22 = HHH*r22; rp22 = rp22/rp22(4);
    rp23 = HHH*r23; rp23 = rp23/rp23(4);
    
    [A1, B1, C1, D1] = plane(r11,r12,r13);
    [A2, B2, C2, D2] = plane(r21,r22,r23);
    
    SH1P = inside(rp11,rp12,rp13,m,n,pix,pix,colort1);
    SH2P = inside(rp21,rp22,rp23,m,n,pix,pix,colort2);

    % CZĘŚĆ 3
    % Z-buffer perspective
    FImP = uint8(zeros(m,n,3));
    for i = 1:m
        for j = 1:n
            FImP(i,j,1:3) = yellow; %żółty
        end
    end
    ZbufP = 1000000*ones(m,n); %nieskończoność
    for i = 1:m
        y = (m/2-i)/100;
        for j = 1:n
            x = (j-n/2)/100;
            temp1(:) = SH1P(i,j,1:3);
            temp2(:) = SH2P(i,j,1:3);
            if isequal(temp1,colort1) && isequal(temp2,colort2)
                d1 = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                d2 = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                if d1 <= d2
                    ZbufP(i,j) = d1;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                else
                    ZbufP(i,j) = d2;
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                    FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                end
            else
                if isequal(temp1,colort1)
                    d = dist2plane(A1,B1,C1,D1,x,y,pozcam,-x,-y,f);
                    if d<ZbufP(i,j)
                        ZbufP(i,j) = d;
                        FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH1P(i,j,1:3);
                    end
                end
                if isequal(temp2,colort2)
                    d = dist2plane(A2,B2,C2,D2,x,y,pozcam,-x,-y,f);
                    if d<ZbufP(i,j)
                        ZbufP(i,j) = d;
                        FImP(i,j,1:3) = 0.25*FImP(i,j,1:3) + 0.75*SH2P(i,j,1:3);
                    end
                end
            end
        end
    end
    writeVideo(valt,FImP);
  end
end
close(valt);

%% KOD - FUNKCJE

function [A, B, C, D] = plane(p1, p2, p3)
%parametry równanie płaszczyzny Ax+By+Cz+D=0
%przechodzącej przez trzy punkty p1,p2,p3
	A = det([p1(2), p1(3), 1;...
			p2(2), p2(3), 1;...
			p3(2), p3(3), 1]);		
	B = -det([p1(1), p1(3), 1;...
			p2(1), p2(3), 1;...
			p3(1), p3(3), 1]);
	C = det([p1(1), p1(2), 1;...
			p2(1), p2(2), 1;...
			p3(1), p3(2), 1]);
	D = -det([p1(1), p1(2), p1(3);...
			p2(1), p2(2), p2(3);...
			p3(1), p3(2), p3(3)]);
end

function d = dist2plane(A, B, C, D, x, y, z, l, m, n)
% odległość punktu {x,y,z) od płaszczyzny o równaniu Ax+By+Cz+D=0
% odległość mierzona jest wzdłuż prostej o wektorze kierunkowym [l,m,n]
	d = NaN;
	ro = (A*x+B*y+C*z+D)/(A*l+B*m+C*n);
	x1 = x-1*ro; y1 = y-m*ro; z1 = z-n*ro;
	d = sqrt((x-x1)^2+(y-y1)^2+(z-z1)^2);
end

function Hmat = RPYT(roll,pitch,yaw,px,py,pz)
	r = roll*pi/180; p = pitch*pi/180; y = yaw*pi/180;
	MR = [cos(r), -sin(r), 0; sin(r), cos(r), 0; 0, 0, 1];
	MP = [cos(p), 0, sin(p); 0, 1, 0; -sin(p), 0, cos(p)];
	MY = [1, 0, 0; 0, cos(y), -sin(y); 0, sin(y), cos(y)];
	Rot = MR*MP*MY;
	Hmat = zeros(4,4);
	Hmat(1:3,1:3) = Rot;
	Hmat(1,4)=px; Hmat(2,4)=py; Hmat(3,4)=pz;
	Hmat(4,4)=1;
end

function Hmat = Persp(f)
	Hmat = zeros(4,4);
	Hmat(1,1)=1; Hmat(2,2)=1;
	Hmat(4,3)=-1/f; Hmat(4,4)=1;
end


function Im = inside(r1,r2,r3,m,n,dy,dx,color)
	% m,n - rodzielczość obrazu
	% proste
	x1 = r1(1); y1 = r1(2);
	x2 = r2(1); y2 = r2(2);
	x3 = r3(1); y3 = r3(2);
	A1 = y3-y2; B1 = x2-x3; C1 = y2*(x3-x2)-x2*(y3-y2);
	A2 = y3-y1; B2 = x1-x3; C2 = y1*(x3-x1)-x1*(y3-y1);
	A3 = y1-y2; B3 = x2-x1; C3 = y2*(x1-x2)-x2*(y1-y2);
	Im = uint8(zeros(m,n,3));
	for i = 1:m
		y = (i-m/2)*dy;
		for j = 1:n
			x = (j-n/2)*dx;
			vis = test(x,y,x1,y1,x2,y2,x3,y3,A1,B1,C1,A2,B2,C2,A3,B3,C3);
			if vis > 0
				Im(i,j,:)=color;
			end
		end
	end
end

function v = test(x,y,x1,y1,x2,y2,x3,y3,A1,B1,C1,A2,B2,C2,A3,B3,C3)
	r1 = (A1*x1+B1*y1+C1) * (A1*x+B1*y+C1);
	r2 = (A2*x2+B2*y2+C2) * (A2*x+B2*y+C2);
	r3 = (A3*x3+B3*y3+C3) * (A3*x+B3*y+C3);
	if r1>=0 && r2>=0 && r3>=0
		v = 1;
	else
		v = 0;
	end
end