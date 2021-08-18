global c;
global total_entropy;
f = imread("cameraman.tif");
e = entropy(f);
disp("Original Image Entropy:"),disp(e);
colormap(gray);
c = reshape(f,8,8,[]);
Q = [[16 11 10 16 24 40 51 61],
[12 12 14 19 26 58 60 55],
[14 13 16 24 40 57 69 56],
[14 17 22 29 51 87 80 62],
[18 22 37 56 68 109 103 77],
[24 35 55 64 81 104 113 92],
[49 64 78 87 103 121 120 101],
[72 92 95 98 112 100 103 99]];
total_entropy = 0;


function quantize(Q)
  global c;
  global total_entropy;
  total_entropy = 0;
  length(c);
  for i=1:1024
    
    F = dct2(c(:,:,i));
    temp = F;
    for u=1:8
      for v=1:8
        F(u,v) = round(F(u,v)/Q(u,v));
        temp(u,v) =  abs(F(u,v));
        F(u,v) = F(u,v)*Q(u,v);
      endfor
    endfor
    total_entropy = total_entropy+entropy(temp);
    c(:,:,i) = idct2(F);
  endfor
endfunction

###############################################
Q1 = Q;
quantize(Q1);
x1 = reshape(c,256,256,[]);
y1 = uint8(x1);
disp("PSNR for Q1:"), disp(psnr(y1,f))
disp("Total Entropy for Q1");disp(total_entropy)

###############################################
Q2 = 3*Q;
c = reshape(f,8,8,[]);
quantize(Q2);
x2 = reshape(c,256,256,[]);
y2 = uint8(x2);
disp("PSNR for Q2:"), disp(psnr(y2,f))
disp("Total Entropy for Q2");disp(total_entropy)

###############################################
Q3 = 4*Q;
c = reshape(f,8,8,[]);
quantize(Q3);
x3 = reshape(c,256,256,[]);
y3 = uint8(x3);
disp("PSNR for Q3:"), disp(psnr(y3,f))
disp("Total Entropy for Q3");disp(total_entropy)

montage([f,y1,y2,y3]);
title("Original - Q1 - Q2 - Q3");