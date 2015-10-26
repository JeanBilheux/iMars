slice1 = [[1 2 3];[1 2 4];[2 2 2]];
slice2 = [[11 2 13];[2 12 3];[2 2 2]];
slice3 = [[3 3 4];[11 21 14];[21 12 12]];
slice4 = [[31 2 33];[1 32 4];[22 2 32]];
slice5 = [[10 9 8];[2 3 4];[6 7 8]];

bigArray = zeros(5,3,3);

bigArray(1,:,:) = slice1;
bigArray(2,:,:) = slice2;
bigArray(3,:,:) = slice3;
bigArray(4,:,:) = slice4;
bigArray(5,:,:) = slice5;

sortedBigArray = sort(bigArray,1);

bigArray
sortedBigArray

'median array'
sortedBigArray(3,:,:)

