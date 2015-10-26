function m_toggleGeneralTab(toggleArray, toggleUIpanel, indexSelected)

nbrButtons = length(toggleArray);

%init array
buttonActivation = false(1,nbrButtons);
buttonActivation(1,indexSelected) = true;
uipanelActivation = {'off','off','off','off'};
uipanelActivation{indexSelected} = 'on';

for i=1:nbrButtons
    set(toggleArray(i), 'value', false);
    set(toggleUIpanel(i), 'visible', 'off');
end
drawnow
 
set(toggleArray(indexSelected), 'value', true);
set(toggleUIpanel(indexSelected), 'visible', 'on');
drawnow

end