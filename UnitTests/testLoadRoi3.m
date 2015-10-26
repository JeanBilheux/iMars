function testLoadRoi3
%Test the loading of an empty ROI ascii file

data = m_loadROIdata('Data/roi3.txt');

if ~isempty(data{1})
    error('testLoadRoi3:notEqual','Should return an empty array');
end
   