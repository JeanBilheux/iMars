function testLoadRoi6
%Test the loading with an 'a' instead of value

f = @() m_loadROIdata('Data/roi6.txt');
assertExceptionThrown(f, 'LoadROIdata:MissingData');


