function m_tabButtonsActivation(hObject)
% This is where the top right buttons will behave when the mouse
% goes over them

obj = get(hObject, 'CurrentObject');
if ~isempty(obj)
    switch obj
        case handles.toggleNormalization
          m_toggleTabButton(hObject, 1);
        case handles.toggleBasicAnalysis
          m_toggleTabButton(hObject, 2);
        case handles.toggleSegmentation
          m_toggleTabButton(hObject, 3);
        case handles.toggleFiltering
          m_toggleTabButton(hObject, 4);
        otherwise
    end
end


