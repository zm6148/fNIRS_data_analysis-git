function varargout = ImageRecon(varargin)
% IMAGERECON MATLAB code for ImageRecon.fig
%      IMAGERECON, by itself, creates a new IMAGERECON or raises the existing
%      singleton*.
%
%      H = IMAGERECON returns the handle to a new IMAGERECON or the handle to
%      the existing singleton*.
%
%      IMAGERECON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGERECON.M with the given input arguments.
%
%      IMAGERECON('Property','Value',...) creates a new IMAGERECON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageRecon_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageRecon_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageRecon

% Last Modified by GUIDE v2.5 05-Oct-2015 21:10:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ImageRecon_OpeningFcn, ...
    'gui_OutputFcn',  @ImageRecon_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ImageRecon is made visible.
function ImageRecon_OpeningFcn(hObject, eventdata, handles, varargin)
global atlasViewer

% Choose default command line output for ImageRecon
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

imgrecon   = atlasViewer.imgrecon;
fwmodel   = atlasViewer.fwmodel;
hGroupList = atlasViewer.handles.hGroupList;
pialsurf = atlasViewer.pialsurf;
probe    = atlasViewer.probe;
dirnameSubj = atlasViewer.dirnameSubj;

imgrecon.handles.ImageRecon = hObject;

if isempty(imgrecon.subjData)
    imgrecon = getImgRecon(imgrecon, dirnameSubj, fwmodel, pialsurf, probe);
    if isempty(imgrecon.subjData)
        menu('Subject data missing from groupResults','Okay');
        return;
    end
end

% Display list of subject name
set(handles.ListofSubjects,'String',imgrecon.subjData.name);

% default exp condition
set(handles.Condition,'String',1);

% default time range
set(handles.time_range,'String',num2str([5 10]));

% default alpha (regularization) for brain only reconstruction
set(handles.alpha_brainonly,'String',1e3);

% default alpha (regularization) for brain and scalp reconstruction
set(handles.alpha_brain_scalp,'String',1e-2);

% default beta (regularization) for brain and scalp reconstruction
set(handles.beta_brain_scalp,'String',1e-2);

atlasViewer.imgrecon = imgrecon;




% --- Executes on button press in changedataset.
function changedataset_Callback(hObject, eventdata, handles)
% get groupResults.mat
global group;
currentdir = pwd;
[F,PathName] = uigetfile({'*.*','All Files(*.*)'}, 'Browse groupResults.mat file ');

if isequal(PathName,0)
    return
end

cd(PathName)
load(F);
cd(currentdir);

% initialize list of subject names
array(1) = cellstr('Group');
for i = 1:group.nFiles;
    array(i+1) = cellstr(group.subjs(i).name);
end

set(handles.ListofSubjects,'String',array);



% --- Outputs from this function are returned to the command line.
function varargout = ImageRecon_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;




% --- Executes on selection change in ListofSubjects.
function ListofSubjects_Callback(hObject, eventdata, handles, cond)
s = set(handles.ListofSubjects, 'Value');



% --- Executes during object creation, after setting all properties.
function ListofSubjects_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Condition_Callback(hObject, eventdata, handles)
cond = get(handles.Condition, 'String');


% --- Executes during object creation, after setting all properties.
function Condition_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_range_Callback(hObject, eventdata, handles)
tRangeimg = str2num(get(handles.time_range,'String'));


% --- Executes during object creation, after setting all properties.
function time_range_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function shortsep_thresh_Callback(hObject, eventdata, handles)
rhoSD_ssThresh = str2num(get(handles.shortsep_thresh,'String'));


% --- Executes during object creation, after setting all properties.
function shortsep_thresh_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in brainonly.
function brainonly_Callback(hObject, eventdata, handles)
value1 = get(handles.brainonly, 'Value');
if value1==1
    set(handles.brain_scalp, 'value', 0);
end



% --- Executes on button press in brain_scalp.
function brain_scalp_Callback(hObject, eventdata, handles)
value2 = get(handles.brain_scalp, 'Value');
if value2==1
    set(handles.brainonly, 'value', 0);
end



function alpha_brainonly_Callback(hObject, eventdata, handles)
alpha = str2num(get(handles.alpha_brainonly,'String'));

% --- Executes during object creation, after setting all properties.
function alpha_brainonly_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha_brain_scalp_Callback(hObject, eventdata, handles)
alpha = str2num(get(handles.alpha_brain_scalp,'String'));


% --- Executes during object creation, after setting all properties.
function alpha_brain_scalp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beta_brain_scalp_Callback(hObject, eventdata, handles)
beta = str2num(get(handles.beta_brain_scalp,'String'));


% --- Executes during object creation, after setting all properties.
function beta_brain_scalp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function plotylimit_Callback(hObject, eventdata, handles)
ylimits = str2num(get(handles.plotylimit,'String'));


% --- Executes during object creation, after setting all properties.
function plotylimit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in image_recon.
function image_recon_Callback(hObject, eventdata, handles)
%########## NEED TO CD TO PROJECT FOLDER EVERYTIME THIS FUNCTION IS CALLED
%(DO THIS AFTER YOU MAKE THE LINK BETWEEN ATLASVIEWERGUI AND IMAGERECONGUI
global atlasViewer

value1 = get(handles.brainonly, 'Value'); % 1 if brain only checked
value2 = get(handles.brain_scalp, 'Value'); % 1 if brain and scalp checked
cond = str2num(get(handles.Condition, 'String'));
s = get(handles.ListofSubjects, 'Value');
tRangeimg = str2num(get(handles.time_range,'String'));
rhoSD_ssThresh = str2num(get(handles.shortsep_thresh,'String'));

dirnameSubj = atlasViewer.dirnameSubj; 
imgrecon = atlasViewer.imgrecon;
fwmodel = atlasViewer.fwmodel;

subjData    = imgrecon.subjData;
Adot        = fwmodel.Adot;
Adot_scalp  = fwmodel.Adot_scalp;


% Error checking 
if  isempty(subjData)
    msg = sprintf('Subject data is missing. Cannot generate reconstructed image without it.');
    menu(msg,'OK');
    return;
end
if  value1 == 0 & value2 == 0
    msg = sprintf('Please choose one image reconstruction option.');
    menu(msg,'OK');
    return;
end
if  value1 == 1 & value2 == 1
    msg = sprintf('Please choose one image reconstruction option ONLY.');
    menu(msg,'OK');
    return;
end
if value1 == 1 & isempty(Adot)
    menu('You need the file fw/Adot.mat to perform this image reconstruction.','Okay');
    return;
end
if value1 == 1 & ndims(Adot) < 3
    menu('You need at least two wavelengths for image reconstruction.','Okay');
    return;
end
if value2 == 1 & isempty(Adot_scalp)
    menu('You need the file fw/Adot_scalp.mat to perform this image reconstruction.','Okay');
    return;
end
if value2 == 1 & ndims(Adot_scalp) < 3
    menu('You need at least two wavelengths for image reconstruction.','Okay');
    return;
end
if cond<1 | cond>size(subjData.procResult.dcAvg,4)
    menu('Invalid condition for this time course.','Okay');
    return;
end
if cond<1 | cond>size(subjData.procResult.dcAvg,4)
    menu('Invalid condition for this time course.','Okay');
    return;
end

%%%% Get the parameters from subject data for calculating Hb %%%%
SD   = subjData.procInput.SD;
dc   = subjData.procResult.dcAvg;
tHRF = subjData.procResult.tHRF;

if isempty(dc)
    menu('Error: dcAvg is missing from subject data. Check groupResults.mat or use Homer2 to generate new groupResults.mat file','Okay');
    return;
end
if isempty(tHRF)
    menu('Error: tHRFis missing from subject data. Check groupResults.mat use Homer2 to generate new groupResults.mat file','Okay');
    return;
end

% More error checking 
if tRangeimg(1)<tHRF(1) | tRangeimg(1)>tHRF(end) | tRangeimg(2)<tHRF(1) | tRangeimg(2)>tHRF(end)
    menu(sprintf('Invalid time rage entered. Enter values between tHRF range [%0.1f - %0.1f].', tHRF(1), tHRF(end)), 'OK');
    return;    
end

h = waitbar(0,'Please wait, running...');

if ndims(dc) == 4;   % if more than one condition
    dc = squeeze(dc(:,:,:,cond));
end

% convert dc back to dod
dc(find(isnan(dc))) = 0;
dod = hmrConc2OD( dc, SD, [6 6] );

% average HRF over a time range
yavgimg = hmrImageHrfMeanTwin(dod, tHRF, tRangeimg);

% get long separation channels only for reconstruction
ml = SD.MeasList;
mlAct = SD.MeasListAct;
lst = find(ml(:,4)==1);
rhoSD = zeros(length(lst),1);
posM = zeros(length(lst),3);
for iML = 1:length(lst)
    rhoSD(iML) = sum((SD.SrcPos(ml(lst(iML),1),:) - SD.DetPos(ml(lst(iML),2),:)).^2).^0.5;
    posM(iML,:) = (SD.SrcPos(ml(lst(iML),1),:) + SD.DetPos(ml(lst(iML),2),:)) / 2;
end
lstLS = lst(find(rhoSD>=rhoSD_ssThresh));%%& mlAct(lst)==1) %#########NEED TO ADD mlAct LATER AND CORRECT SENSITIVITY MATRIX ACCORDINGLY
lstLS_all = [lstLS; lstLS+size(ml,1)/2]; % both wavelengths

if isempty(lstLS_all)
    menu('No channels selected. No channels meet the short separation threshold. Please lower the threshold and retry', 'Okay');
    return;
end

yavgimg = yavgimg(lstLS_all,:);
SD.MeasList = SD.MeasList(lstLS_all,:);

if ~exist([dirnameSubj, '/imagerecon/'],'dir')
    mkdir([dirnameSubj, '/imagerecon']);
end

HbO = [];
HbR = [];
if value1 == 1 % brain only reconstruction after short separation regression
       
    % put A matrix together and combine with extinction coefficients
    E = GetExtinctions([SD.Lambda(1) SD.Lambda(2)]);
    E = E/10; %convert from /cm to /mm  E raws: wavelength, columns 1:HbO, 2:HbR
    Amatrix = [squeeze(Adot(:,:,1))*E(1,1) squeeze(Adot(:,:,1))*E(1,2);
               squeeze(Adot(:,:,2))*E(2,1) squeeze(Adot(:,:,2))*E(2,2)];
    %########### CORRECT A MATRIX WITH LIST OF long and ACTIVE CHANNELS
    
   if isfield(SD, 'MeasListAct') == 1
      lstA = SD.MeasListAct;
      lstAct = find(lstA(1:size(lstA,1)/2) == 1);
      lstAct = [lstAct; lstAct+size(lstA,1)/2];
    Amatrix = Amatrix(lstAct,:);
    yavgimg = yavgimg(lstAct);
    end
    
    alpha = str2num(get(handles.alpha_brainonly,'String'));
    [HbO, HbR, err] = hmrImageReconConc(yavgimg, [], alpha, Amatrix);    
    if err==1
        menu('Error: Number of channels in measuremnt is not the same as in Adot.', 'Okay');
        return;
    end
    
    imgrecon.Aimg_conc.HbO = HbO;
    imgrecon.Aimg_conc.HbR = HbR;
    
elseif value2 == 1 % brain and scalp reconstruction without short separation regression (Zhan2012)
    
       
    % get alpha and beta for regularization
    alpha = str2num(get(handles.alpha_brain_scalp,'String'));
    beta = str2num(get(handles.beta_brain_scalp,'String'));
    
    % spatial regularization on brain only
    for j = 1:size(Adot,3);
        J = single(squeeze(Adot(:,:,j)));
        try
            JTJ = diag(J'*J);
        catch
            close(h);
            menu(sprintf('Out of memory: JTJ = diag(J''*J) generates matrix that is too large!!'), 'Okay');
            return;
        end
        L = beta.*max(JTJ);
        LL = sqrt(JTJ+L)';
        LL = diag(1./LL);
        % Normalise J
        Adot(:,:,j) = J*LL;
    end
    
    [u1,s1,v1]=svds(double([squeeze(Adot(:,:,1)) squeeze(Adot_scalp(:,:,1))]),size(Adot,1)); max_sing1 = max(s1(:));
    [u2,s2,v2]=svds(double([squeeze(Adot(:,:,2)) squeeze(Adot_scalp(:,:,2))]),size(Adot,1)); max_sing2 = max(s2(:));
    
    % regularization parameters
    alpha1 = alpha * max_sing1 ;
    alpha2 = alpha * max_sing2 ;
    
    % new sensitivity with regularization
    Anew(:,:,1) = u1 * sqrtm(s1*s1 + alpha1^2*eye(size(s1))) *v1';
    Anew(:,:,2) = u2 * sqrtm(s2*s2 + alpha2^2*eye(size(s2))) *v2';
    
    % put A matrix together and combine with extinction coefficients
    E = GetExtinctions([SD.Lambda(1) SD.Lambda(2)]);
    E = E/10; %convert from /cm to /mm  E raws: wavelength, columns 1:HbO, 2:HbR
    Amatrix = [squeeze(Anew(:,:,1))*E(1,1) squeeze(Anew(:,:,1))*E(1,2);
               squeeze(Anew(:,:,2))*E(2,1) squeeze(Anew(:,:,2))*E(2,2)];
    %########### CORRECT A MATRIX WITH LIST OF long and ACTIVE CHANNELS
    
    % all regularization (alpha and beta) is done above so here we put 0 to alpha!
    [HbO, HbR] = hmrImageReconConc(yavgimg, [], 0, Amatrix);
       
    imgrecon.Aimg_conc_scalp.HbO = HbO;
    imgrecon.Aimg_conc_scalp.HbR = HbR;
end

close(h); % close waitbar

saveImgRecon(imgrecon, dirnameSubj);

atlasViewer.imgrecon = imgrecon;



% --- Executes on button press in plotHb.
function plotHb_Callback(hObject, eventdata, handles)
global atlasViewer
value1 = get(handles.brainonly, 'Value'); % 1 if brain only checked
value2 = get(handles.brain_scalp, 'Value'); % 1 if brain and scalp checked

dirnameSubj = atlasViewer.dirnameSubj;
imgrecon = atlasViewer.imgrecon;
fwmodel = atlasViewer.fwmodel;
axesv = atlasViewer.axesv;
pialsurf = atlasViewer.pialsurf;

axes(axesv.handles.axesSurfDisplay);
hold on;

ylimits = str2num(get(handles.plotylimit,'String'));

if value1 == 1;
Aimg_conc = imgrecon.Aimg_conc;
HbO = Aimg_conc.HbO;
HbR = Aimg_conc.HbR;
elseif value2 == 1;
    Aimg_conc_scalp = imgrecon.Aimg_conc_scalp;
    HbO = Aimg_conc_scalp.HbO;
    HbR = Aimg_conc_scalp.HbR;
end

if isempty(imgrecon)
    return;
end
if isempty(HbO) & isempty(HbR)
    menu('Missing reconstructed image. First generate HbO and HbR', 'Okay');
    return;
end
if isempty(fwmodel)
    return;
end

if leftRightFlipped(imgrecon)
    axes_order = [2,1,3];
else
    axes_order = [1,2,3];
end

hHbO = [];
hHbR = [];
if value1 == 1; % brain only
    
    HbO = Aimg_conc.HbO;
    HbR = Aimg_conc.HbR;
    
    % plot HbO
    hHbO = displayIntensityOnMesh(imgrecon.mesh, HbO, [ylimits(1) ylimits(2)], ...
                                  [0,0,0], 'off','off', axes_order);
    
    hHbR = displayIntensityOnMesh(imgrecon.mesh, HbR, [ylimits(1) ylimits(2)], ...
                                  [0,0,0], 'off','off', axes_order);
    
elseif value2 == 1;
    
    HbO = Aimg_conc_scalp.HbO;
    HbR = Aimg_conc_scalp.HbR;
    
    % plot HbO
    hHbO = displayIntensityOnMesh(imgrecon.mesh, HbO(1:size(imgrecon.mesh.vertices,1)), [ylimits(1) ylimits(2)], ...
                                  imgrecon.colormin, 'off','off', axes_order);
                       
    hHbR = displayIntensityOnMesh(imgrecon.mesh, HbR(1:size(imgrecon.mesh.vertices,1)), [ylimits(1) ylimits(2)], ...
                                  imgrecon.colormin, 'off','off', axes_order);
                       
else
    
    q = menu('Please select a image reconstruction type: Brian Only or Brian and Scalp', 'OK');
    
end
hold off;

% Set image popupmenu to HbO
set(imgrecon.handles.popupmenuImageDisplay,'value',4);

% Since sensitivity profile exists, enable all image panel controls 
% for calculating metrics
if ishandles(imgrecon.handles.hHbO)
    delete(imgrecon.handles.hHbO)
end
if ishandles(imgrecon.handles.hHbR)
    delete(imgrecon.handles.hHbR)
end

imgrecon.handles.hHbO = hHbO;
imgrecon.handles.hHbR = hHbR;
imgrecon.cmThreshold = [ylimits(1) ylimits(2)];

set(imgrecon.handles.editImageReconColormapThreshold, 'enable','on');
set(imgrecon.handles.textImageReconColormapThreshold, 'enable','on');
set(imgrecon.handles.editImageReconColormapThreshold, 'string', ...
    sprintf('%g, %g',ylimits(1), ylimits(2)));

set(pialsurf.handles.radiobuttonShowPial, 'value',0);
uipanelBrainDisplay(pialsurf.handles.radiobuttonShowPial, []);

% Turn sensitivity display off
fwmodel = showFwmodelDisplay(fwmodel, axesv(1).handles.axesSurfDisplay, 'off');

% Turn resolution on and localization error display off
imgrecon = showImgReconDisplay(imgrecon, axesv(1).handles.axesSurfDisplay, 'off', 'off', 'on', 'off');

atlasViewer.fwmodel = fwmodel;
atlasViewer.imgrecon = imgrecon;
