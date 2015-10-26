% will create simple 2000x2000 images to test combine algorithm

image1 = rand(2000,2000);
image1(200:500,600:800) = 1;
fitswrite(image1,'image1.fits');
fitswrite(image1,'image2.fits');
fitswrite(image1,'image3.fits');
