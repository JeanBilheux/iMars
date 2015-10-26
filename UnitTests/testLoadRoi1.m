function testLoadRoi1
%Test the loading of a normal single ROI region

expected_out = {'r:100,200,300,400'};
out = m_loadROIdata('Data/roi1.txt');

if ~isequal(out{1}, expected_out)
    error('testLoadRoi1:notEqual','Can not read normal single ROI region');
end