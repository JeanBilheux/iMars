function testLoadRoi5
%Test the loading of a missing element of ROI

f = @() m_loadROIdata('Data/roi5.txt');
assertExceptionThrown(f, 'LoadROIdata:MissingData');


