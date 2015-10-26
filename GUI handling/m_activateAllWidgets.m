function m_activateAllWidgets(parentUIpanel, status)

    kids = get(parentUIpanel, 'children');
    if isempty(kids)
        return
    end
        
    for i=1:length(kids)
    
            if ~strcmp(get(kids(i),'type'),'uipanel')
                set(kids(i), 'enable', status);
            else
                m_activateAllWidgets(kids(i), status);
            end
    end
    
