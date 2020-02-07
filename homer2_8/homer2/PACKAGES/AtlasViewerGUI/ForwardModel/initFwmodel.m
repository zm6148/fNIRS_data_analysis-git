function fwmodel = initFwmodel(handles, argExtern)

if ~exist('handles','var')
    handles=[];
end
if ~exist('argExtern','var')
    argExtern={};
end

if ~exist('./fw','dir')
    mkdir('./fw');
end

fwmodel = struct(...
      'name', 'fwmodel', ...
      'pathname', '', ...
      'handles',[],...
      'mc_rootpath','', ...
      'mc_exepath','', ...
      'mc_appname','', ...
      'mc_exename', '', ...
      'mc_exename_ext', '', ...
      'mc_options', '', ...
      'nphotons',1e6, ...
      'timegates',[0 5e-9 5e-9],...
      'nWavelengths',1, ...
      'tiss_prop',struct([]), ...
      'Ch',[], ...
      'cmThreshold',[-2,0], ...
      'cmThresholdFluence',[-3,-1], ...
      'headvol',initHeadvol(), ...
      'mesh_orig',initMesh(), ...
      'mesh',initMesh(), ...
      'mesh_scalp_orig',initMesh(), ...
      'mesh_scalp',initMesh(), ...
      'errMCoutput',[], ...
      'Adot',[], ...
      'Adot_scalp',[], ...
      'AdotDate',struct('num',0), ...
      'AdotVolFlag',0, ...
      'projVoltoMesh_brain', '', ...
      'projVoltoMesh_scalp', '', ...
      ... %'colormin',[.74 .47 .40], ...
      'colormin',[.80, .80, .80], ...
      'fluenceProfFnames',{[]}, ...
      'fluenceProf',repmat(initFluenceProf(), 2,1), ...
      'fluenceProfDecim',repmat(initFluenceProf(), 1,1), ...
      'nFluenceProfPerFile', 50, ...
      'MNI_inMCspace', [0, 0, 0],...
      'normalizeFluence', true, ...
      'menuoffset', 2, ...      
      'axes',[], ...
      'center',[], ...
      'orientation', '', ...
      'checkCompatability',[], ...
      'isempty',@isempty_loc, ...         
      'prepObjForSave',[], ...
      'voxPerNode',[], ...
      'platform','' ...
);


if ispc()
    fwmodel.platform = 'Win';
elseif ismac()
    fwmodel.platform = 'Darwin';
else
    fwmodel.platform = 'Linux';
end

% Set handles specific to the current GUI
if ~isempty(handles)
    if ishandles(handles.output)
        guiname = get(handles.output, 'tag');
        if strcmpi(guiname, 'AtlasViewerGUI')
            fwmodel = setAtlasViewerGUI(fwmodel, handles);
        elseif strcmpi(guiname, 'brainScape')
            fwmodel = setBrainscape(fwmodel, handles);
        end
    end
end


% Find MC application 
fwmodel = findMCapp(fwmodel, argExtern);

% Make sure executable permission for MC app is set 
if ismac() | islinux()
    exefile = [fwmodel.mc_exepath, '/', fwmodel.mc_exename]; 
    if exist(exefile,'file')==2
        cmd = sprintf('chmod 755 %s', exefile);
        system(cmd);
    end
end

% Set MC options based on app type
fwmodel = setMCoptions(fwmodel);




% ----------------------------------------------------------------------------
function fwmodel = setAtlasViewerGUI(fwmodel, handles)

ENABLE_FLUENCE_PROF=0;

fwmodel.handles = struct(...
    'surf',[], ...
    'hLighting',[], ...
    'editSelectChannel',[], ...
    'textSelectChannel',[], ...
    'editColormapThreshold',[], ...
    'textColormapThreshold',[], ...
    'menuItemGenerateLoadSensitivityProfile',[], ...
    'menuItemGenerateMCInput',[], ...
    'menuItemEnableSensitivityMatrixVolume',[], ...
    'menuItemGenFluenceProfile',[], ....
    'menuItemLoadPrecalculatedProfile',[], ...
    'menuItemGetSensitivityatMNICoordinates',[], ...
    'popupmenuImageDisplay',[], ...
    'menuItemImageReconGUI', [] ...
    );
fwmodel.handles.editSelectChannel = handles.editSelectChannel;
fwmodel.handles.textSelectChannel = handles.textSelectChannel;
fwmodel.handles.editColormapThreshold = handles.editColormapThreshold;
fwmodel.handles.textColormapThreshold = handles.textColormapThreshold;
fwmodel.handles.menuItemGenerateLoadSensitivityProfile = handles.menuItemGenerateLoadSensitivityProfile;
fwmodel.handles.menuItemGenerateMCInput = handles.menuItemGenerateMCInput;
fwmodel.handles.menuItemEnableSensitivityMatrixVolume = handles.menuItemEnableSensitivityMatrixVolume;
fwmodel.handles.menuItemGenFluenceProfile = handles.menuItemGenFluenceProfile;
fwmodel.handles.menuItemLoadPrecalculatedProfile = handles.menuItemLoadPrecalculatedProfile;
fwmodel.handles.popupmenuImageDisplay = handles.popupmenuImageDisplay;
fwmodel.handles.menuItemGetSensitivityatMNICoordinates = handles.menuItemGetSensitivityatMNICoordinates;

% Need image recon handle in order to enable it when Adot is present
fwmodel.handles.menuItemImageReconGUI = handles.menuItemImageReconGUI;

fwmodel.handles.axes = handles.axesSurfDisplay;

set(handles.menuItemEnableSensitivityMatrixVolume,'enable','off');

set(fwmodel.handles.editSelectChannel,'string','0 0');

set(fwmodel.handles.menuItemGenerateLoadSensitivityProfile,'enable','off');
set(fwmodel.handles.menuItemGenerateMCInput,'enable','off');

set(fwmodel.handles.menuItemGenFluenceProfile,'enable','off');
if ENABLE_FLUENCE_PROF
    set(fwmodel.handles.menuItemGenFluenceProfile,'visible','on');
end
set(fwmodel.handles.menuItemLoadPrecalculatedProfile,'enable','off');
set(fwmodel.handles.menuItemGetSensitivityatMNICoordinates,'enable','off');

fwmodel.Ch          = str2num(get(fwmodel.handles.editSelectChannel,'string'));




% ----------------------------------------------------------------------------
function fwmodel = setBrainscape(fwmodel, handles)

fwmodel.handles = struct(...
    'surf', [], ...
    'textSelectChannelSensitivity', [], ...
    'editSelectChannelSensitivity', [] ...
    );
fwmodel.handles.editSelectChannelSensitivity = handles.editSelectChannelSensitivity;
fwmodel.handles.textSelectChannelSensitivity =  handles.textSelectChannelSensitivity;

set(fwmodel.handles.editSelectChannelSensitivity,'enable','on');
set(fwmodel.handles.textSelectChannelSensitivity,'enable','on');
set(fwmodel.handles.editSelectChannelSensitivity,'string','0 0');



% --------------------------------------------------------------
function b = isempty_loc(fwmodel)

b = false;
if isempty(fwmodel)
    b = true;
elseif isempty(fwmodel.Adot)
    b = true;
end

