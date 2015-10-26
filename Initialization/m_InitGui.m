function m_InitGui (hObject)
% Initialize the GUI

return

handles = guidata(hObject);

[~,os] = system('hostname');
os = strtrim(os);
if strcmp(os,'ubuntu')
    opengl software
end

%disable the right widgets that are not supposed to be available yet
m_toggleTabButton(hObject, 1);
m_activateRightGui(hObject);

%%bottom side of GUI
m_activateLeftGui(hObject);

%set up size and position of GUI
screen_size = get(0, 'ScreenSize');
old_units = get(handles.iMarsGUI, 'units');
set(handles.iMarsGUI, 'units', 'pixels');
set(handles.iMarsGUI, 'position', [screen_size(3)/2, ...
    screen_size(4)/2, ...
    1080, 840]);
set(handles.iMarsGUI, 'units', old_units);

guidata(hObject, handles);

