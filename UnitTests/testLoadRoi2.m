function testLoadRoi2
%Test the loading of a normal double ROI region

expected_out1 = 'r:50,50,100,100';
expected_out2 = 'c:60,60,300,300';

out = m_loadROIdata('Data/roi2.txt');

if ~(isequal(out{1}{1}, expected_out1) && isequal(out{1}{2},expected_out2))
    error('testLoadRoi2:notEqual','Can not read normal double ROI region');
end