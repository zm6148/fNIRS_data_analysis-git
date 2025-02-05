function headsurf = initHeadsurf(handles)

headsurf = struct(...
    'pathname','', ...
    'name', 'headsurf', ...
    'handles', struct(...
        'surf',[], ...
        'radiobuttonShowHead',[], ...
        'editTransparency',[], ...
        'menuItemMakeProbe',[], ...
        'menuItemImportProbe',[], ...
        'axes',[] ... 
    ), ...
    'mesh',initMesh(), ...
    'T_2vol',eye(4), ...
    'center',[], ...
    'centerRotation',[], ...
    'visible',1, ...
    'color',[.69 .74 .67], ...
    'currentPt',[], ...
    'orientation', '', ...
    'checkCompatability',[], ...
    'isempty',@isempty_loc, ...
    'prepObjForSave',[] ...
);

if exist('handles','var')
    headsurf.handles.radiobuttonShowHead = handles.radiobuttonShowHead;
    set(headsurf.handles.radiobuttonShowHead,'enable','off');

    headsurf.handles.editTransparency = handles.editHeadTransparency;
    set(headsurf.handles.editTransparency,'enable','off');

    headsurf.handles.menuItemMakeProbe = handles.menuItemMakeProbe;
    set(headsurf.handles.menuItemMakeProbe,'enable','off');

    headsurf.handles.menuItemImportProbe = handles.menuItemImportProbe;
    set(headsurf.handles.menuItemImportProbe,'enable','off');

    headsurf.handles.axes = handles.axesSurfDisplay;
end


% --------------------------------------------------------------
function b = isempty_loc(headsurf)

b = false;
if isempty(headsurf.mesh.vertices) | isempty(headsurf.mesh.faces)
    b = true;
end

