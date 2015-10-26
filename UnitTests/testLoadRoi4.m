function testLoadRoi4
%Test the loading of a missing element of ROI

f = @() m_loadROIdata('Data/roi4.txt');
assertExceptionThrown(f, 'LoadROIdata:MissingData');


