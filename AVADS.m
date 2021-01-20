% Automated Video Analysis for Dynamic Systems
% Written by Alex Peebles (apeebles@vt.edu) at Virginia Tech
% Last updated on 1.20.2021

% If you use this for research, please cite the following paper: 
%       Peebles AT, Carroll MM, Socha JJ, Schmitt D, Queen RM. 
%       "Validity of Using Automated Two-Dimensional Video Analysis 
%       to Measure Continuous Sagittal Plane Running Kinematics."
%       Ann Biomed Eng. 2021 Jan;49(1):455-468. 
%       doi: 10.1007/s10439-020-02569-y. Epub 2020 Jul 23. PMID: 32705424.


% Please refer to the user manual for information on how to run the program
% and guided tutorials with examples related to undergraduate dynamics and
% human movement biomechanics

%%%%%%%%%%%%%%%%%%%% Initializing functions
function varargout = AVADS(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AVADS_OpeningFcn, ...
                   'gui_OutputFcn',  @AVADS_OutputFcn, ...
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

function AVADS_OpeningFcn(hObject, eventdata, handles, varargin)
clc
handles.output = hObject;
handles.fpath = [pwd];
guidata(hObject, handles);

function varargout = AVADS_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



%%%%%%%%%%%%%%%%%%%%%% Main code
function LoadButton_Callback(hObject, eventdata, handles)

[handles.fname handles.fpath] = uigetfile([handles.fpath,'/*.MOV;*.MP4;*.mov;*.mp4']);
handles.playpause = 0;
handles.vid = VideoReader([handles.fpath handles.fname]);
handles.nframes = handles.vid.NumberOfFrames;
set(handles.FrameRateString,'string',['Frame Rate: ' num2str(handles.vid.FrameRate)]);

set(handles.FrameSlider, 'Value', 1);
set(handles.FrameSlider, 'Min', 1);
set(handles.FrameSlider, 'Max', handles.nframes);
set(handles.FrameSlider, 'SliderStep', [1/handles.nframes , 10/handles.nframes ]);

handles.Threshold = round(get(handles.ThresholdSlider,'Value'));
set(handles.ThreshTextBox,'string',handles.Threshold);

set(handles.FnameText,'string',handles.fname(1:end-4));
set(handles.NframesText,'string',handles.nframes);
set(handles.FrameNText,'string',round(get(handles.FrameSlider,'Value')));

handles.currentFrame = 1;
handles.M1data = [];
handles.M2data = [];
handles.M3data = [];
handles.M4data = [];
handles.M5data = [];
handles.M6data = [];
handles.M7data = [];
handles.M8data = [];
handles.correction = 0;
handles.calibratevid = 0;

contents = cellstr(get(handles.blockwidth,'String')); 
% set(handles.blockwidth,'value',1);
Blockwidth = str2num(contents{get(handles.blockwidth,'Value')});


for i=1:Blockwidth
for j=1:Blockwidth
handles.blockr(i,j,:)=[255,0,0];
handles.blockb(i,j,:)=[0,0,255];
handles.blockg(i,j,:)=[0,255,0];
handles.blocky(i,j,:)=[255,255,0];
handles.blocko(i,j,:)=[255,165,0];
handles.blockp(i,j,:)=[128,0,128];
handles.blocklb(i,j,:)=[0,255,255];
handles.blockm(i,j,:)=[255,0,255];
end
end
blockwidth_Callback(hObject, eventdata, handles)

if exist([handles.fpath handles.fname(1:end-4) '_Processed.mat'])==2
load([handles.fpath handles.fname(1:end-4) '_Processed.mat'])

if ~isempty(AVADS_load.M1data)
handles.M1data = AVADS_load.M1data;
handles.M1data(:,3) = handles.M1data(:,3);%handles.vid.Height - 
handles.UserClicks = [1];
end
if ~isempty(AVADS_load.M2data)
handles.M2data = AVADS_load.M2data;
handles.M2data(:,3) = handles.M2data(:,3);%handles.vid.Height - 
handles.UserClicks = [1;1];
end
if ~isempty(AVADS_load.M3data)
handles.M3data = AVADS_load.M3data;
handles.M3data(:,3) = handles.M3data(:,3);%handles.vid.Height - 
handles.UserClicks = [1;1;1];
end
if ~isempty(AVADS_load.M4data)
handles.M4data = AVADS_load.M4data;
handles.M4data(:,3) = handles.M4data(:,3);%handles.vid.Height - 
handles.UserClicks = [1;1;1;1];
end
if ~isempty(AVADS_load.M5data)
handles.M5data = AVADS_load.M5data;
handles.M5data(:,3) = handles.M5data(:,3);%handles.vid.Height - 
handles.UserClicks = [1;1;1;1;1];
end
if ~isempty(AVADS_load.M6data)
handles.M6data = AVADS_load.M6data;
handles.M6data(:,3) = handles.M6data(:,3);% handles.vid.Height -
handles.UserClicks = [1;1;1;1;1;1];
end
if ~isempty(AVADS_load.M7data)
handles.M7data = AVADS_load.M7data;
handles.M7data(:,3) = handles.M7data(:,3);% handles.vid.Height -
handles.UserClicks = [1;1;1;1;1;1;1];
end
if ~isempty(AVADS_load.M8data)
handles.M8data = AVADS_load.M8data;
handles.M8data(:,3) = handles.M8data(:,3);%handles.vid.Height - 
handles.UserClicks = [1;1;1;1;1;1;1;1];
end


set(handles.M1Name,'string',AVADS_load.M1Name);
set(handles.M2Name,'string',AVADS_load.M2Name);
set(handles.M3Name,'string',AVADS_load.M3Name);
set(handles.M4Name,'string',AVADS_load.M4Name);
set(handles.M5Name,'string',AVADS_load.M5Name);
set(handles.M6Name,'string',AVADS_load.M6Name);
set(handles.M7Name,'string',AVADS_load.M7Name);
set(handles.M8Name,'string',AVADS_load.M8Name);

set(handles.Ang1Name,'string',AVADS_load.Ang1Name);
set(handles.Ang2Name,'string',AVADS_load.Ang2Name);

set(handles.OutVar1Name,'string',AVADS_load.OutVar1Name);
set(handles.OutVar2Name,'string',AVADS_load.OutVar2Name);
set(handles.OutVar3Name,'string',AVADS_load.OutVar3Name);
set(handles.OutVar4Name,'string',AVADS_load.OutVar4Name);
set(handles.OutVar5Name,'string',AVADS_load.OutVar5Name);
set(handles.OutVar6Name,'string',AVADS_load.OutVar6Name);

set(handles.OutVar1Value,'string',AVADS_load.OutVar1Value);
set(handles.OutVar2Value,'string',AVADS_load.OutVar2Value);
set(handles.OutVar3Value,'string',AVADS_load.OutVar3Value);
set(handles.OutVar4Value,'string',AVADS_load.OutVar4Value);
set(handles.OutVar5Value,'string',AVADS_load.OutVar5Value);
set(handles.OutVar6Value,'string',AVADS_load.OutVar6Value);

set(handles.TimeEvent_1,'value',AVADS_load.TimeEvent_1);
set(handles.TimeEvent_2,'value',AVADS_load.TimeEvent_2);
set(handles.TimeEvent_3,'value',AVADS_load.TimeEvent_3);
set(handles.TimeEvent_4,'value',AVADS_load.TimeEvent_4);
set(handles.TimeEvent_5,'value',AVADS_load.TimeEvent_5);
set(handles.TimeEvent_6,'value',AVADS_load.TimeEvent_6);

handles.Threshold = AVADS_load.Threshold;
set(handles.ThresholdSlider,'Value',round(AVADS_load.Threshold));
set(handles.ThreshTextBox,'string',round(AVADS_load.Threshold));

set(handles.SkipFrames,'string',AVADS_load.SkipFrames);

set(handles.A1L1Top,'value',AVADS_load.A1L1Top);
set(handles.A1L1Bot,'value',AVADS_load.A1L1Bot);
set(handles.A1L2Top,'value',AVADS_load.A1L2Top);
set(handles.A1L2Bot,'value',AVADS_load.A1L2Bot);

set(handles.A2L1Top,'value',AVADS_load.A2L1Top);
set(handles.A2L1Bot,'value',AVADS_load.A2L1Bot);
set(handles.A2L2Top,'value',AVADS_load.A2L2Top);
set(handles.A2L2Bot,'value',AVADS_load.A2L2Bot);


set(handles.CalMeters,'string',AVADS_load.CalMeters);
set(handles.CalPixels,'string',AVADS_load.CalPixels);
set(handles.Calibrate,'value',AVADS_load.Calibrate);
set(handles.A1Neg,'value',AVADS_load.A1Neg);
set(handles.A2Neg,'value',AVADS_load.A2Neg);
set(handles.Invert,'value',AVADS_load.Invert);
set(handles.blockwidth,'value',AVADS_load.blockwidth);
blockwidth_Callback(hObject, eventdata, handles)
end
set(handles.MessageBox,'string','Name each marker you intend to track, set a threshold, and proceed with digitizing and automatic tracking');
guidata(hObject,handles);

plotimage(hObject, eventdata, handles)

function ManualDigitizeAll_Callback(hObject, eventdata, handles)

Clear_Callback(hObject, eventdata, handles);
set(handles.MessageBox,'string','Digitize each marker you have named by zooming, pressing enter, then clicking on the center of each marker');
    set(handles.AutotrackButton,'Value',0)
    set(handles.GrayBWButton,'Value',0)
    
guidata(hObject,handles);
plotimage(hObject, eventdata, handles)


axes(handles.axes1)
if ~strcmp(get(handles.M1Name,'string'),'M1Name')
zoom on
pause()
UserClick = round(my_ginput(1,[1,0,0]));
handles.M1data = [handles.M1data;handles.currentFrame, UserClick(1,:)]; 
else
set(handles.MessageBox,'string','Name each marker you intend to track before digitizing');    
end

if ~strcmp(get(handles.M2Name,'string'),'M2Name')
zoom on
pause()
UserClick = round(my_ginput(1,[1,0,0]));
handles.M2data = [handles.M2data;handles.currentFrame, UserClick(1,:)]; 
end

if ~strcmp(get(handles.M3Name,'string'),'M3Name')
zoom on
pause()
UserClick = round(my_ginput(1,[1,0,0]));
handles.M3data = [handles.M3data;handles.currentFrame, UserClick(1,:)]; 
end

if ~strcmp(get(handles.M4Name,'string'),'M4Name')
zoom on
pause()
UserClick = round(my_ginput(1,[1,0,0]));
handles.M4data = [handles.M4data;handles.currentFrame, UserClick(1,:)]; 
end

if ~strcmp(get(handles.M5Name,'string'),'M5Name')
zoom on
pause()
UserClick = round(my_ginput(1,[1,0,0]));
handles.M5data = [handles.M5data;handles.currentFrame, UserClick(1,:)]; 
end

if ~strcmp(get(handles.M6Name,'string'),'M6Name')
zoom on
pause()
UserClick = round(my_ginput(1,[1,0,0]));
handles.M6data = [handles.M6data;handles.currentFrame, UserClick(1,:)]; 
end

if ~strcmp(get(handles.M7Name,'string'),'M7Name')
zoom on
pause()
UserClick = round(my_ginput(1,[1,0,0]));
handles.M7data = [handles.M7data;handles.currentFrame, UserClick(1,:)]; 
end

if ~strcmp(get(handles.M8Name,'string'),'M8Name')
zoom on
pause()
UserClick = round(my_ginput(1,[1,0,0]));
handles.M8data = [handles.M8data;handles.currentFrame, UserClick(1,:)]; 
end

zoom reset

guidata(hObject,handles);
plotimage(hObject, eventdata, handles)
pause(0.5)

handles.currentFrame = handles.currentFrame + 1;
set(handles.FrameSlider, 'Value', handles.currentFrame);
set(handles.FrameNText,'string',handles.currentFrame);
set(handles.MessageBox,'string','All set up to enable automatic tracking!');
guidata(hObject,handles);
plotimage(hObject, eventdata, handles)

function AutotrackButton_Callback(hObject, eventdata, handles)
set(handles.MessageBox,'string','Unclick automatic tracking to stop. If you want to speed up tracking, increase the number of frames skipped');
counter = 1;
useone = 0;

Clear_Callback(hObject, eventdata, handles);

M1prev1 = find(handles.M1data(:,1)==handles.currentFrame-1);
M1prev2 = find(handles.M1data(:,1)==handles.currentFrame-2);

if isempty(M1prev1)
set(handles.AutotrackButton, 'Value', 0)
end
    
if isempty(M1prev2)
useone = 1;
end 

if handles.correction == 1
    useone = 1;
end
    
while get(handles.AutotrackButton,'Value')==1
singleFrame = read(handles.vid,handles.currentFrame);

Ig = rgb2gray(singleFrame(:,:,:));
% grayRGB = cat(3, Ig, Ig, Ig);
BWfinal = imbinarize(Ig,handles.Threshold/255);
% BW(1:700,1:850) = imbinarize(Ig(1:700,1:850,:),165/255);

if get(handles.Invert,'Value')==1 %If pressed, plot BW
    BWfinal = imcomplement(BWfinal);
end

stats = regionprops('table',BWfinal,'Area','Centroid',...
    'MajorAxisLength','MinorAxisLength');

stats_sort = sortrows(stats,1);


% ObjThis = round([stats_f.Centroid])
areaArray = round([stats_sort.Area]);
ObjThis = round([stats_sort.Centroid]);


%Track object with only one current data pont
if useone == 1
for j=1:size(ObjThis,1)
    if ~strcmp(get(handles.M1Name,'string'),'M1Name')
        Dist(1,j) = sqrt((ObjThis(j,1)-handles.M1data(end,2)).^2+(ObjThis(j,2)-handles.M1data(end,3)).^2); 
        NumTrack = 1; end
    if ~strcmp(get(handles.M2Name,'string'),'M2Name')
        Dist(2,j) = sqrt((ObjThis(j,1)-handles.M2data(end,2)).^2+(ObjThis(j,2)-handles.M2data(end,3)).^2); 
        NumTrack = 2; end
    if ~strcmp(get(handles.M3Name,'string'),'M3Name')
        Dist(3,j) = sqrt((ObjThis(j,1)-handles.M3data(end,2)).^2+(ObjThis(j,2)-handles.M3data(end,3)).^2); 
        NumTrack = 3; end
    if ~strcmp(get(handles.M4Name,'string'),'M4Name')
        Dist(4,j) = sqrt((ObjThis(j,1)-handles.M4data(end,2)).^2+(ObjThis(j,2)-handles.M4data(end,3)).^2); 
        NumTrack = 4; end
    if ~strcmp(get(handles.M5Name,'string'),'M5Name')
        Dist(5,j) = sqrt((ObjThis(j,1)-handles.M5data(end,2)).^2+(ObjThis(j,2)-handles.M5data(end,3)).^2); 
        NumTrack = 5; end
    if ~strcmp(get(handles.M6Name,'string'),'M6Name')
        Dist(6,j) = sqrt((ObjThis(j,1)-handles.M6data(end,2)).^2+(ObjThis(j,2)-handles.M6data(end,3)).^2); 
        NumTrack = 6; end
    if ~strcmp(get(handles.M7Name,'string'),'M7Name')
        Dist(7,j) = sqrt((ObjThis(j,1)-handles.M7data(end,2)).^2+(ObjThis(j,2)-handles.M7data(end,3)).^2); 
        NumTrack = 7; end
    if ~strcmp(get(handles.M8Name,'string'),'M8Name')
        Dist(8,j) = sqrt((ObjThis(j,1)-handles.M8data(end,2)).^2+(ObjThis(j,2)-handles.M8data(end,3)).^2); 
        NumTrack = 8; end
end

else

%Track already identified objects
for j=1:size(ObjThis,1)
    if ~strcmp(get(handles.M1Name,'string'),'M1Name')
        Dist(1,j) = sqrt((ObjThis(j,1)-(handles.M1data(end,2)-(handles.M1data(end-1,2)-handles.M1data(end,2)))).^2+(ObjThis(j,2)-(handles.M1data(end,3)-(handles.M1data(end-1,3)-handles.M1data(end,3)))).^2); 
        NumTrack = 1; end
    if ~strcmp(get(handles.M2Name,'string'),'M2Name')
        Dist(2,j) = sqrt((ObjThis(j,1)-(handles.M2data(end,2)-(handles.M2data(end-1,2)-handles.M2data(end,2)))).^2+(ObjThis(j,2)-(handles.M2data(end,3)-(handles.M2data(end-1,3)-handles.M2data(end,3)))).^2); 
        NumTrack = 2; end
    if ~strcmp(get(handles.M3Name,'string'),'M3Name')
        Dist(3,j) = sqrt((ObjThis(j,1)-(handles.M3data(end,2)-(handles.M3data(end-1,2)-handles.M3data(end,2)))).^2+(ObjThis(j,2)-(handles.M3data(end,3)-(handles.M3data(end-1,3)-handles.M3data(end,3)))).^2); 
        NumTrack = 3; end
    if ~strcmp(get(handles.M4Name,'string'),'M4Name')
        Dist(4,j) = sqrt((ObjThis(j,1)-(handles.M4data(end,2)-(handles.M4data(end-1,2)-handles.M4data(end,2)))).^2+(ObjThis(j,2)-(handles.M4data(end,3)-(handles.M4data(end-1,3)-handles.M4data(end,3)))).^2); 
        NumTrack = 4; end
    if ~strcmp(get(handles.M5Name,'string'),'M5Name')
        Dist(5,j) = sqrt((ObjThis(j,1)-(handles.M5data(end,2)-(handles.M5data(end-1,2)-handles.M5data(end,2)))).^2+(ObjThis(j,2)-(handles.M5data(end,3)-(handles.M5data(end-1,3)-handles.M5data(end,3)))).^2); 
        NumTrack = 5; end
    if ~strcmp(get(handles.M6Name,'string'),'M6Name')
        Dist(6,j) = sqrt((ObjThis(j,1)-(handles.M6data(end,2)-(handles.M6data(end-1,2)-handles.M6data(end,2)))).^2+(ObjThis(j,2)-(handles.M6data(end,3)-(handles.M6data(end-1,3)-handles.M6data(end,3)))).^2); 
        NumTrack = 6; end
    if ~strcmp(get(handles.M7Name,'string'),'M7Name')
        Dist(7,j) = sqrt((ObjThis(j,1)-(handles.M7data(end,2)-(handles.M7data(end-1,2)-handles.M7data(end,2)))).^2+(ObjThis(j,2)-(handles.M7data(end,3)-(handles.M7data(end-1,3)-handles.M7data(end,3)))).^2); 
        NumTrack = 7; end
    if ~strcmp(get(handles.M8Name,'string'),'M8Name')
        Dist(8,j) = sqrt((ObjThis(j,1)-(handles.M8data(end,2)-(handles.M8data(end-1,2)-handles.M8data(end,2)))).^2+(ObjThis(j,2)-(handles.M8data(end,3)-(handles.M8data(end-1,3)-handles.M8data(end,3)))).^2); 
        NumTrack = 8; end
end
end

useone = 0;

for j = 1:NumTrack
[v,i] = nanmin(Dist,[],2);
[vv,ii] = nanmin(v);
if ii==1
handles.M1data = [handles.M1data;handles.currentFrame,ObjThis(i(ii),:)];
elseif ii==2
handles.M2data = [handles.M2data;handles.currentFrame,ObjThis(i(ii),:)];
elseif ii==3
handles.M3data = [handles.M3data;handles.currentFrame,ObjThis(i(ii),:)];
elseif ii==4
handles.M4data = [handles.M4data;handles.currentFrame,ObjThis(i(ii),:)];
elseif ii==5
handles.M5data = [handles.M5data;handles.currentFrame,ObjThis(i(ii),:)];
elseif ii==6
handles.M6data = [handles.M6data;handles.currentFrame,ObjThis(i(ii),:)];
elseif ii==7
handles.M7data = [handles.M7data;handles.currentFrame,ObjThis(i(ii),:)];
else
handles.M8data = [handles.M8data;handles.currentFrame,ObjThis(i(ii),:)];
end

Dist(ii,:)=nan;
Dist(:,i(ii))=nan;

end


if counter > str2num(get(handles.SkipFrames,'String'))
guidata(hObject,handles);
% pause(0.02) %Changed from below
plotimage(hObject, eventdata, handles)
set(handles.FrameSlider, 'Value', handles.currentFrame);
set(handles.FrameNText,'string',handles.currentFrame);
counter = 1;
end

if handles.currentFrame+1 > handles.nframes
set(handles.AutotrackButton, 'Value', 0)
guidata(hObject,handles);
else
handles.currentFrame = handles.currentFrame + 1;
counter = counter+1;
end

end

function ManualDigitizeOne_Callback(hObject, eventdata, handles)
if handles.Threshold > 150
handles.correction = 1; 
end


    set(handles.AutotrackButton,'Value',0)
    set(handles.GrayBWButton,'Value',0)

    guidata(hObject,handles);
plotimage(hObject, eventdata, handles)

contents = cellstr(get(handles.OneMarkerToDigit,'String')); 
MarkerCorrect = contents{get(handles.OneMarkerToDigit,'Value')}; 

axes(handles.axes1)
zoom on
pause()
Tempin = round(my_ginput(1,[1,0,0]));
zoom reset

eval(['data = handles.M' MarkerCorrect(end:end) 'data;'])

dataloc = find(data(:,1)==handles.currentFrame);
data(dataloc,:) = [];
data = [data;handles.currentFrame, Tempin(1,:)];

eval(['handles.M' MarkerCorrect(end:end) 'data = data;'])


guidata(hObject,handles);
plotimage(hObject, eventdata, handles)
pause(0.5)

handles.currentFrame = handles.currentFrame + 1;
set(handles.FrameSlider, 'Value', handles.currentFrame);
set(handles.FrameNText,'string',handles.currentFrame);
guidata(hObject,handles);
plotimage(hObject, eventdata, handles)

function FrameSlider_Callback(hObject, eventdata, handles)
handles.currentFrame = round(get(handles.FrameSlider, 'Value'));
set(handles.FrameNText,'string',handles.currentFrame);
guidata(hObject,handles);
plotimage(hObject, eventdata, handles)

function GrayBWButton_Callback(hObject, eventdata, handles)
guidata(hObject,handles);
plotimage(hObject, eventdata, handles)

function Invert_Callback(hObject, eventdata, handles)
guidata(hObject,handles);
plotimage(hObject, eventdata, handles)

function PlayButton_Callback(hObject, eventdata, handles)
set(handles.MessageBox,'string','Unselect play video to pause');
while get(handles.PlayButton,'Value')==1
if handles.currentFrame == handles.nframes
set(handles.PlayButton, 'Value', 0)
else
handles.currentFrame = handles.currentFrame+1;
set(handles.FrameSlider, 'Value', handles.currentFrame);
set(handles.FrameNText,'string',handles.currentFrame);
guidata(hObject,handles);
pause(0.02)
plotimage(hObject, eventdata, handles)
end
end

function ThresholdSlider_Callback(hObject, eventdata, handles)

handles.Threshold = round(get(handles.ThresholdSlider,'Value'));
set(handles.ThreshTextBox,'string',handles.Threshold);
guidata(hObject,handles);
plotimage(hObject, eventdata, handles)

function blockwidth_Callback(hObject, eventdata, handles)
contents = cellstr(get(handles.blockwidth,'String')); 
Blockwidth = str2num(contents{get(handles.blockwidth,'Value')});

handles.blockr = []; handles.blockb = []; handles.blockg = []; 
handles.blocky = []; handles.blocko = []; handles.blockp = []; 
handles.blocklb = []; handles.blockm = []; 
    

for i=1:Blockwidth
for j=1:Blockwidth
handles.blockr(i,j,:)=[255,0,0];
handles.blockb(i,j,:)=[0,0,255];
handles.blockg(i,j,:)=[0,255,0];
handles.blocky(i,j,:)=[255,255,0];
handles.blocko(i,j,:)=[255,165,0];
handles.blockp(i,j,:)=[128,0,128];
handles.blocklb(i,j,:)=[0,255,255];
handles.blockm(i,j,:)=[255,0,255];
end
end

guidata(hObject,handles);

function plotimage(hObject, eventdata, handles)

singleFrame = read(handles.vid,handles.currentFrame);
%  imwrite(singleFrame,['C:\Users\apeebles\Desktop\IC17.png'])

Ig = rgb2gray(singleFrame(:,:,:));



if get(handles.GrayBWButton,'Value')==1 %If pressed, plot BW
    
BWfinal = imbinarize(Ig,handles.Threshold/255);
% BW(1:700,1:850) = imbinarize(Ig(1:700,1:850,:),165/255);

if get(handles.Invert,'Value')==1 %If pressed, plot BW
    BWfinal = imcomplement(BWfinal);
end

    DisplayIM = BWfinal;
%     imwrite(BWfinal,[pwd '/BW.png'])
else
    DisplayIM =  cat(3, Ig, Ig, Ig);
    blockwidth_Callback(hObject, eventdata, handles)
    contents = cellstr(get(handles.blockwidth,'String')); 
    Blockwidth = str2num(contents{get(handles.blockwidth,'Value')});
    SideLength = (Blockwidth-1)/2;
    
if ~isempty(handles.M1data)
M1loc = find(handles.M1data(:,1)==handles.currentFrame);
if ~isempty(M1loc)
    if handles.M1data(M1loc,3)>SideLength & handles.M1data(M1loc,2)>SideLength
DisplayIM(handles.M1data(M1loc,3)-SideLength:handles.M1data(M1loc,3)+SideLength,handles.M1data(M1loc,2)-SideLength:handles.M1data(M1loc,2)+SideLength,:) = handles.blockr; end
end
end

if ~isempty(handles.M2data)
M2loc = find(handles.M2data(:,1)==handles.currentFrame);
if ~isempty(M2loc)
    if handles.M2data(M2loc,3)>SideLength & handles.M2data(M2loc,2)>SideLength
DisplayIM(handles.M2data(M2loc,3)-SideLength:handles.M2data(M2loc,3)+SideLength,handles.M2data(M2loc,2)-SideLength:handles.M2data(M2loc,2)+SideLength,:) = handles.blockb; end
end
end

if ~isempty(handles.M3data)
M3loc = find(handles.M3data(:,1)==handles.currentFrame);
if ~isempty(M3loc)
        if handles.M3data(M3loc,3)>SideLength & handles.M3data(M3loc,2)>SideLength
DisplayIM(handles.M3data(M3loc,3)-SideLength:handles.M3data(M3loc,3)+SideLength,handles.M3data(M3loc,2)-SideLength:handles.M3data(M3loc,2)+SideLength,:) = handles.blockg; end
end
end

if ~isempty(handles.M4data)
M4loc = find(handles.M4data(:,1)==handles.currentFrame);
if ~isempty(M4loc)
        if handles.M4data(M4loc,3)>SideLength & handles.M4data(M4loc,2)>SideLength
DisplayIM(handles.M4data(M4loc,3)-SideLength:handles.M4data(M4loc,3)+SideLength,handles.M4data(M4loc,2)-SideLength:handles.M4data(M4loc,2)+SideLength,:) = handles.blocky; end
end
end

if ~isempty(handles.M5data)
M5loc = find(handles.M5data(:,1)==handles.currentFrame);
if ~isempty(M5loc)
        if handles.M5data(M5loc,3)>SideLength & handles.M5data(M5loc,2)>SideLength
DisplayIM(handles.M5data(M5loc,3)-SideLength:handles.M5data(M5loc,3)+SideLength,handles.M5data(M5loc,2)-SideLength:handles.M5data(M5loc,2)+SideLength,:) = handles.blocko; end
end
end

if ~isempty(handles.M6data)
M6loc = find(handles.M6data(:,1)==handles.currentFrame);
if ~isempty(M6loc)
        if handles.M6data(M6loc,3)>SideLength & handles.M6data(M6loc,2)>SideLength
DisplayIM(handles.M6data(M6loc,3)-SideLength:handles.M6data(M6loc,3)+SideLength,handles.M6data(M6loc,2)-SideLength:handles.M6data(M6loc,2)+SideLength,:) = handles.blockp; end
end
end

if ~isempty(handles.M7data)
M7loc = find(handles.M7data(:,1)==handles.currentFrame);
if ~isempty(M7loc)
        if handles.M7data(M7loc,3)>SideLength & handles.M7data(M7loc,2)>SideLength
DisplayIM(handles.M7data(M7loc,3)-SideLength:handles.M7data(M7loc,3)+SideLength,handles.M7data(M7loc,2)-SideLength:handles.M7data(M7loc,2)+SideLength,:) = handles.blocklb; end
end
end

if ~isempty(handles.M8data)
M8loc = find(handles.M8data(:,1)==handles.currentFrame);
if ~isempty(M8loc)
        if handles.M8data(M8loc,3)>SideLength & handles.M8data(M8loc,2)>SideLength
DisplayIM(handles.M8data(M8loc,3)-SideLength:handles.M8data(M8loc,3)+SideLength,handles.M8data(M8loc,2)-SideLength:handles.M8data(M8loc,2)+SideLength,:) = handles.blockm; end
end
end

end

axes(handles.axes1)
imshow(DisplayIM)

function Clear_Callback(hObject, eventdata, handles)

if ~isempty(handles.M1data)
handles.M1data = sortrows(handles.M1data,1);
M1loc = find(handles.M1data(:,1)==handles.currentFrame);
if ~isempty(M1loc)
handles.M1data(M1loc:end,:) = [];
end
end

if ~isempty(handles.M2data)
handles.M2data = sortrows(handles.M2data,1);
M2loc = find(handles.M2data(:,1)==handles.currentFrame);
if ~isempty(M2loc)
handles.M2data(M2loc:end,:) = [];
end
end

if ~isempty(handles.M3data)
handles.M3data = sortrows(handles.M3data,1);
M3loc = find(handles.M3data(:,1)==handles.currentFrame);
if ~isempty(M3loc)
handles.M3data(M3loc:end,:) = [];
end
end

if ~isempty(handles.M4data)
handles.M4data = sortrows(handles.M4data,1);
M4loc = find(handles.M4data(:,1)==handles.currentFrame);
if ~isempty(M4loc)
handles.M4data(M4loc:end,:) = [];
end
end

if ~isempty(handles.M5data)
handles.M5data = sortrows(handles.M5data,1);
M5loc = find(handles.M5data(:,1)==handles.currentFrame);
if ~isempty(M5loc)
handles.M5data(M5loc:end,:) = [];
end
end

if ~isempty(handles.M6data)
handles.M6data = sortrows(handles.M6data,1);
M6loc = find(handles.M6data(:,1)==handles.currentFrame);
if ~isempty(M6loc)
handles.M6data(M6loc:end,:) = [];
end
end

if ~isempty(handles.M7data)
handles.M7data = sortrows(handles.M7data,1);
M7loc = find(handles.M7data(:,1)==handles.currentFrame);
if ~isempty(M7loc)
handles.M7data(M7loc:end,:) = [];
end
end

if ~isempty(handles.M8data)
handles.M8data = sortrows(handles.M8data,1);
M8loc = find(handles.M8data(:,1)==handles.currentFrame);
if ~isempty(M8loc)
handles.M8data(M8loc:end,:) = [];
end
end

guidata(hObject,handles);
plotimage(hObject, eventdata, handles)

function Filter_Callback(hObject, eventdata, handles)

handles.StoreM1data = handles.M1data;
handles.StoreM2data = handles.M2data;
handles.StoreM3data = handles.M3data;
handles.StoreM4data = handles.M4data;
handles.StoreM5data = handles.M5data;
handles.StoreM6data = handles.M6data;
handles.StoreM7data = handles.M7data;
handles.StoreM8data = handles.M8data;

fc = str2num(get(handles.FilterFreq,'String'));
fs = round(handles.vid.FrameRate); 
[b,a] = butter(4,fc/(fs/2));

handles.M1data = round(filtfilt(b,a,handles.M1data));
handles.M2data = round(filtfilt(b,a,handles.M2data));
handles.M3data = round(filtfilt(b,a,handles.M3data));
handles.M4data = round(filtfilt(b,a,handles.M4data));
handles.M5data = round(filtfilt(b,a,handles.M5data));
handles.M6data = round(filtfilt(b,a,handles.M6data));
handles.M7data = round(filtfilt(b,a,handles.M7data));
handles.M8data = round(filtfilt(b,a,handles.M8data));
guidata(hObject,handles);

function Unfilter_Callback(hObject, eventdata, handles)
handles.M1data = handles.StoreM1data;
handles.M2data = handles.StoreM2data;
handles.M3data = handles.StoreM3data;
handles.M4data = handles.StoreM4data;
handles.M5data = handles.StoreM5data;
handles.M6data = handles.StoreM6data;
handles.M7data = handles.StoreM7data;
handles.M8data = handles.StoreM8data;
guidata(hObject,handles);

function SaveButton_Callback(hObject, eventdata, handles)

M1Data = handles.M1data;
M2Data = handles.M2data;
M3Data = handles.M3data;
M4Data = handles.M4data;
M5Data = handles.M5data;
M6Data = handles.M6data;
M7Data = handles.M7data;
M8Data = handles.M8data;

Var1Data = str2num(get(handles.OutVar1Value,'String'));
Var2Data = str2num(get(handles.OutVar2Value,'String'));
Var3Data = str2num(get(handles.OutVar3Value,'String'));
Var4Data = str2num(get(handles.OutVar4Value,'String'));
Var5Data = str2num(get(handles.OutVar5Value,'String'));
Var6Data = str2num(get(handles.OutVar6Value,'String'));

minA = 1;
maxA = handles.nframes;

if ~isempty(M1Data)
handles.M1data = sortrows(handles.M1data,1);
M1Data(:,3) = handles.vid.Height - M1Data(:,3); 
[~,U1] = unique(M1Data(:,1)); 
M1Data = M1Data(U1,:);
min1 = min(M1Data(:,1));
minA = max(min1,minA);
max1 = max(M1Data(:,1));
maxA = min(max1,maxA);
end
if ~isempty(M2Data)
handles.M2data = sortrows(handles.M2data,1);
M2Data(:,3) = handles.vid.Height - M2Data(:,3); 
[~,U2] = unique(M2Data(:,1)); 
M2Data = M2Data(U2,:);
min1 = min(M2Data(:,1));
minA = max(min1,minA);
max1 = max(M2Data(:,1));
maxA = min(max1,maxA);
end
if ~isempty(M3Data)
handles.M3data = sortrows(handles.M3data,1);
M3Data(:,3) = handles.vid.Height - M3Data(:,3); 
[~,U3] = unique(M3Data(:,1)); 
M3Data = M3Data(U3,:);
min1 = min(M3Data(:,1));
minA = max(min1,minA);
max1 = max(M3Data(:,1));
maxA = min(max1,maxA);
end
if ~isempty(M4Data)
handles.M4data = sortrows(handles.M4data,1);
M4Data(:,3) = handles.vid.Height - M4Data(:,3); 
[~,U4] = unique(M4Data(:,1)); 
M4Data = M4Data(U4,:);
min1 = min(M4Data(:,1));
minA = max(min1,minA);
max1 = max(M4Data(:,1));
maxA = min(max1,maxA);
end
if ~isempty(M5Data)
handles.M5data = sortrows(handles.M5data,1);
M5Data(:,3) = handles.vid.Height - M5Data(:,3); 
[~,U5] = unique(M5Data(:,1)); 
M5Data = M5Data(U5,:);
min1 = min(M5Data(:,1));
minA = max(min1,minA);
max1 = max(M5Data(:,1));
maxA = min(max1,maxA);
end
if ~isempty(M6Data)
handles.M6data = sortrows(handles.M6data,1);
M6Data(:,3) = handles.vid.Height - M6Data(:,3); 
[~,U6] = unique(M6Data(:,1)); 
M6Data = M6Data(U6,:);
min1 = min(M6Data(:,1));
minA = max(min1,minA);
max1 = max(M6Data(:,1));
maxA = min(max1,maxA);
end
if ~isempty(M7Data)
handles.M7data = sortrows(handles.M7data,1);
M7Data(:,3) = handles.vid.Height - M7Data(:,3); 
[~,U7] = unique(M7Data(:,1)); 
M7Data = M7Data(U7,:);
min1 = min(M7Data(:,1));
minA = max(min1,minA);
max1 = max(M7Data(:,1));
maxA = min(max1,maxA);
end
if ~isempty(M8Data)
handles.M8data = sortrows(handles.M8data,1);
M8Data(:,3) = handles.vid.Height - M8Data(:,3); 
[~,U8] = unique(M8Data(:,1)); 
M8Data = M8Data(U8,:);
min1 = min(M8Data(:,1));
minA = max(min1,minA);
max1 = max(M8Data(:,1));
maxA = min(max1,maxA);
end

if ~isempty(M1Data)
   CropStart = find(M1Data(:,1)==minA); 
   CropStop = find(M1Data(:,1)==maxA);
   M1Data = M1Data(CropStart:CropStop,:);
end
if ~isempty(M2Data)
   CropStart = find(M2Data(:,1)==minA); 
   CropStop = find(M2Data(:,1)==maxA);
   M2Data = M2Data(CropStart:CropStop,:);
end
if ~isempty(M3Data)
   CropStart = find(M3Data(:,1)==minA); 
   CropStop = find(M3Data(:,1)==maxA);
   M3Data = M3Data(CropStart:CropStop,:);
end
if ~isempty(M4Data)
   CropStart = find(M4Data(:,1)==minA); 
   CropStop = find(M4Data(:,1)==maxA);
   M4Data = M4Data(CropStart:CropStop,:);
end
if ~isempty(M5Data)
   CropStart = find(M5Data(:,1)==minA); 
   CropStop = find(M5Data(:,1)==maxA);
   M5Data = M5Data(CropStart:CropStop,:);
end
if ~isempty(M6Data)
   CropStart = find(M6Data(:,1)==minA); 
   CropStop = find(M6Data(:,1)==maxA);
   M6Data = M6Data(CropStart:CropStop,:);
end
if ~isempty(M7Data)
   CropStart = find(M7Data(:,1)==minA); 
   CropStop = find(M7Data(:,1)==maxA);
   M7Data = M7Data(CropStart:CropStop,:);
end
if ~isempty(M8Data)
   CropStart = find(M8Data(:,1)==minA); 
   CropStop = find(M8Data(:,1)==maxA);
   M8Data = M8Data(CropStart:CropStop,:);
end


M1Name = get(handles.M1Name,'string');
M2Name = get(handles.M2Name,'string');
M3Name = get(handles.M3Name,'string');
M4Name = get(handles.M4Name,'string');
M5Name = get(handles.M5Name,'string');
M6Name = get(handles.M6Name,'string');
M7Name = get(handles.M7Name,'string');
M8Name = get(handles.M8Name,'string');
Var1Name = get(handles.OutVar1Name,'string');
Var2Name = get(handles.OutVar2Name,'string');
Var3Name = get(handles.OutVar3Name,'string');
Var4Name = get(handles.OutVar4Name,'string');
Var5Name = get(handles.OutVar5Name,'string');
Var6Name = get(handles.OutVar6Name,'string');
Ang1Name = get(handles.Ang1Name,'string');
Ang2Name = get(handles.Ang2Name,'string');

M1Name(find(M1Name==' '))=[];
M2Name(find(M2Name==' '))=[];
M3Name(find(M3Name==' '))=[];
M4Name(find(M4Name==' '))=[];
M5Name(find(M5Name==' '))=[];
M6Name(find(M6Name==' '))=[];
M7Name(find(M7Name==' '))=[];
M8Name(find(M8Name==' '))=[];
Var1Name(find(Var1Name==' '))=[];
Var2Name(find(Var2Name==' '))=[];
Var3Name(find(Var3Name==' '))=[];
Var4Name(find(Var4Name==' '))=[];
Var5Name(find(Var5Name==' '))=[];
Var6Name(find(Var6Name==' '))=[];
Ang1Name(find(Ang1Name==' '))=[];
Ang2Name(find(Ang2Name==' '))=[];


contents = cellstr(get(handles.A1L1Top,'String'));

choice = contents{get(handles.A1L1Top,'Value')};
eval(['A1L1Top = handles.M' choice(end:end) 'data;']);
choice = contents{get(handles.A1L1Bot,'Value')};
eval(['A1L1Bot = handles.M' choice(end:end) 'data;']);
choice = contents{get(handles.A1L2Top,'Value')};
if choice(1:1) == 'H'
    A1L2Top = ones(size(handles.M1data));
    A1L2Bot = ones(size(handles.M1data));
    A1L2Bot(:,2) = A1L2Bot(:,2)+5;
else
    eval(['A1L2Top = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A1L2Bot,'Value')};
    eval(['A1L2Bot = handles.M' choice(end:end) 'data;']);
end
    
choice = contents{get(handles.A2L1Top,'Value')};
eval(['A2L1Top = handles.M' choice(end:end) 'data;']);
choice = contents{get(handles.A2L1Bot,'Value')};
eval(['A2L1Bot = handles.M' choice(end:end) 'data;']);
choice = contents{get(handles.A2L2Top,'Value')};
if choice(1:1) == 'H'
    A2L2Top = ones(size(handles.M1data));
    A2L2Bot = ones(size(handles.M1data));
    A2L2Bot(:,2) = A2L2Bot(:,2)+5;
else
    eval(['A2L2Top = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A2L2Bot,'Value')};
    eval(['A2L2Bot = handles.M' choice(end:end) 'data;']);
end
    
A1L1Top(:,3) = handles.vid.Height - A1L1Top(:,3);
A1L1Bot(:,3) = handles.vid.Height - A1L1Bot(:,3);
A1L2Top(:,3) = handles.vid.Height - A1L2Top(:,3);
A1L2Bot(:,3) = handles.vid.Height - A1L2Bot(:,3);


A1L1 = atan2(A1L1Top(:,3)-A1L1Bot(:,3),A1L1Top(:,2)-A1L1Bot(:,2))*180/pi;
A1L2 = atan2(A1L2Top(:,3)-A1L2Bot(:,3),A1L2Top(:,2)-A1L2Bot(:,2))*180/pi;
% A1L1(find(A1L1<0)) = A1L1(find(A1L1<0)) + 360;
% A1L2(find(A1L2<0)) = A1L2(find(A1L2<0)) + 360;

if get(handles.A1Neg,'Value')==1
factor = -1;
else
factor = 1;
end

Ang1Data = factor*(A1L2-A1L1);



A2L1Top(:,3) = handles.vid.Height - A2L1Top(:,3);
A2L1Bot(:,3) = handles.vid.Height - A2L1Bot(:,3);
A2L2Top(:,3) = handles.vid.Height - A2L2Top(:,3);
A2L2Bot(:,3) = handles.vid.Height - A2L2Bot(:,3);


A2L1 = atan2(A2L1Top(:,3)-A2L1Bot(:,3),A2L1Top(:,2)-A2L1Bot(:,2))*180/pi;
A2L2 = atan2(A2L2Top(:,3)-A2L2Bot(:,3),A2L2Top(:,2)-A2L2Bot(:,2))*180/pi;
% A2L1(find(A2L1<0)) = A2L1(find(A2L1<0)) + 360;
% A2L2(find(A2L2<0)) = A2L2(find(A2L2<0)) + 360;

if get(handles.A2Neg,'Value')==1
factor = -1;
else
factor = 1;
end

% Ang2Data = 180-factor*(A2L1-A2L2);
Ang2Data = factor*(A2L2-A2L1);

% Out = struct(M1Name,M1Data,M2Name,M2Data,M3Name,M3Data,M4Name,M4Data,...
%     M5Name,M5Data,M6Name,M6Data,M7Name,M7Data,M8Name,M8Data,...
%     Var1Name,Var1Data,Var2Name,Var2Data,Var3Name,Var3Data,Var4Name,Var4Data,...
%     Var5Name,Var5Data,Var6Name,Var6Data,Ang1Name,Ang1Data,Ang2Name,Ang2Data);

AVADS_load.M1Name = M1Name;
AVADS_load.M2Name = M2Name;
AVADS_load.M3Name = M3Name;
AVADS_load.M4Name = M4Name;
AVADS_load.M5Name = M5Name;
AVADS_load.M6Name = M6Name;
AVADS_load.M7Name = M7Name;
AVADS_load.M8Name = M8Name;
AVADS_load.Ang1Name = Ang1Name;
AVADS_load.Ang2Name = Ang2Name;
AVADS_load.OutVar1Name = Var1Name;
AVADS_load.OutVar2Name = Var2Name;
AVADS_load.OutVar3Name = Var3Name;
AVADS_load.OutVar4Name = Var4Name;
AVADS_load.OutVar5Name = Var5Name;
AVADS_load.OutVar6Name = Var6Name;

AVADS_load.M1data = handles.M1data;
AVADS_load.M2data = handles.M2data;
AVADS_load.M3data = handles.M3data;
AVADS_load.M4data = handles.M4data;
AVADS_load.M5data = handles.M5data;
AVADS_load.M6data = handles.M6data;
AVADS_load.M7data = handles.M7data;
AVADS_load.M8data = handles.M8data;
AVADS_load.OutVar1Value = get(handles.OutVar1Value,'String');
AVADS_load.OutVar2Value = get(handles.OutVar2Value,'String');
AVADS_load.OutVar3Value = get(handles.OutVar3Value,'String');
AVADS_load.OutVar4Value = get(handles.OutVar4Value,'String');
AVADS_load.OutVar5Value = get(handles.OutVar5Value,'String');
AVADS_load.OutVar6Value = get(handles.OutVar6Value,'String');
AVADS_load.TimeEvent_1 = get(handles.TimeEvent_1,'Value');
AVADS_load.TimeEvent_2 = get(handles.TimeEvent_2,'Value');
AVADS_load.TimeEvent_3 = get(handles.TimeEvent_3,'Value');
AVADS_load.TimeEvent_4 = get(handles.TimeEvent_4,'Value');
AVADS_load.TimeEvent_5 = get(handles.TimeEvent_5,'Value');
AVADS_load.TimeEvent_6 = get(handles.TimeEvent_6,'Value');



AVADS_load.Threshold = handles.Threshold;

AVADS_load.SkipFrames = get(handles.SkipFrames,'String');

AVADS_load.A1L1Top = get(handles.A1L1Top,'Value');
AVADS_load.A1L1Bot = get(handles.A1L1Bot,'Value');
AVADS_load.A1L2Top = get(handles.A1L2Top,'Value');
AVADS_load.A1L2Bot = get(handles.A1L2Bot,'Value');

AVADS_load.A2L1Top = get(handles.A2L1Top,'Value');
AVADS_load.A2L1Bot = get(handles.A2L1Bot,'Value');
AVADS_load.A2L2Top = get(handles.A2L2Top,'Value');
AVADS_load.A2L2Bot = get(handles.A2L2Bot,'Value');

AVADS_load.blockwidth = get(handles.blockwidth,'Value');

AVADS_load.CalMeters = get(handles.CalMeters,'String');
AVADS_load.CalPixels = get(handles.CalPixels,'String');
AVADS_load.Calibrate = get(handles.Calibrate,'Value');
AVADS_load.A1Neg = get(handles.A1Neg,'Value');
AVADS_load.A2Neg = get(handles.A2Neg,'Value');
AVADS_load.Invert = get(handles.Invert,'Value');

Out = struct(M1Name,M1Data,M2Name,M2Data,M3Name,M3Data,M4Name,M4Data,...
    M5Name,M5Data,M6Name,M6Data,M7Name,M7Data,M8Name,M8Data,...
    Var1Name,Var1Data,Var2Name,Var2Data,Var3Name,Var3Data,Var4Name,Var4Data,...
    Var5Name,Var5Data,Var6Name,Var6Data,Ang1Name,Ang1Data,Ang2Name,Ang2Data,...
    'AVADS_load',AVADS_load);

save([handles.fpath '/' handles.fname(1:end-4) '_Processed.mat'],'-struct','Out');

function PlotButton_Callback(hObject, eventdata, handles)
contents = cellstr(get(handles.PlotChoice,'String')); 
choice = contents{get(handles.PlotChoice,'Value')};

if choice(1) == 'M'

marker = choice;
eval(['data = handles.M' marker(end:end) 'data;'])
data = sortrows(data,1);

data(:,3) = handles.vid.Height - data(:,3);

if get(handles.Calibrate,'Value')==1
    LPixel = str2num(get(handles.CalPixels,'String'));
    LMeter = str2num(get(handles.CalMeters,'String'));
    data(:,2:3) = data(:,2:3)*(LMeter/LPixel);
end

contents = cellstr(get(handles.PosVelAcc,'String')); 
choice = contents{get(handles.PosVelAcc,'Value')};

axes(handles.axes1)
if choice(1)=='P'
plot(data(:,1),data(:,2),'-r.',data(:,1),data(:,3),'-b.')
legend('horizontal','vertical')
    if get(handles.Calibrate,'Value')==1
        ylabel('meters')
    else
        ylabel('pixels')
    end
elseif choice(1)=='V'
    vel2 = diff(data(:,2))*handles.vid.FrameRate;
    vel3 = diff(data(:,3))*handles.vid.FrameRate;
    data(1,:)=[];
plot(data(:,1),vel2,'-r.',data(:,1),vel3,'-b.')
legend('horizontal','vertical')
    if get(handles.Calibrate,'Value')==1
        ylabel('meters/second')
    else
        ylabel('pixels/second')
    end
else 
    acc2 = diff(diff(data(:,2)))*handles.vid.FrameRate*handles.vid.FrameRate;
    acc3 = diff(diff(data(:,3)))*handles.vid.FrameRate*handles.vid.FrameRate;
    data(1:2,:)=[];    
plot(data(:,1),acc2,'-r.',data(:,1),acc3,'-b.')
legend('horizontal','vertical')
    if get(handles.Calibrate,'Value')==1
        ylabel('meters/second^2')
    else
        ylabel('pixels/second^2')
    end
end         
xlabel('frame number')
grid on 


else
contents = cellstr(get(handles.A1L1Top,'String'));
angle = choice;

if angle(end:end) == '1'
    choice = contents{get(handles.A1L1Top,'Value')};
    eval(['L1Top = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A1L1Bot,'Value')};
    eval(['L1Bot = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A1L2Top,'Value')};
    if choice(1:1) == 'H'
        L2Top = ones(size(handles.M1data));
        L2Bot = ones(size(handles.M1data));
        L2Bot(:,2) = L2Top(:,2)+5;
    else
    eval(['L2Top = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A1L2Bot,'Value')};
    eval(['L2Bot = handles.M' choice(end:end) 'data;']);
    end
    
    if get(handles.A1Neg,'Value')==1
        factor = -1;
    else
        factor = 1;
    end
else
    choice = contents{get(handles.A2L1Top,'Value')};
    eval(['L1Top = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A2L1Bot,'Value')};
    eval(['L1Bot = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A2L2Top,'Value')};
    if choice(1:1) == 'H'
        L2Top = ones(size(handles.M1data));
        L2Top(:,2) = L2Top(:,2)+5;
        L2Bot = ones(size(handles.M1data));        
    else
    eval(['L2Top = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A2L2Bot,'Value')};
    eval(['L2Bot = handles.M' choice(end:end) 'data;']);
    end    
    if get(handles.A2Neg,'Value')==1
        factor = -1;
    else
        factor = 1;
    end
    
end


L1Top(:,3) = handles.vid.Height - L1Top(:,3);
L1Bot(:,3) = handles.vid.Height - L1Bot(:,3);
L2Top(:,3) = handles.vid.Height - L2Top(:,3);
L2Bot(:,3) = handles.vid.Height - L2Bot(:,3);

L1 = atan2(L1Top(:,3)-L1Bot(:,3),L1Top(:,2)-L1Bot(:,2))*180/pi;
L2 = atan2(L2Top(:,3)-L2Bot(:,3),L2Top(:,2)-L2Bot(:,2))*180/pi;
% L1(find(L1<0)) = L1(find(L1<0)) + 360;
% L2(find(L2<0)) = L2(find(L2<0)) + 360;
%Angle = factor*(180-abs(L2-L1));
Angle = factor*(L2-L1);


contents = cellstr(get(handles.PosVelAcc,'String')); 
choice = contents{get(handles.PosVelAcc,'Value')};

axes(handles.axes1)
if choice(1)=='P'
plot(L1Top(:,1),Angle)
ylabel('degrees')
elseif choice(1)=='V'
    vel2 = diff(Angle);
    vel2(find(vel2<-330)) = vel2(find(vel2<-330)) + 360;
    vel2(find(vel2>330)) = vel2(find(vel2>330)) - 360;
    vel2 = vel2*handles.vid.FrameRate;
    L1Top(1,:)=[];
plot(L1Top(:,1),vel2)
ylabel('degrees/second')
else 
    acc2 = diff(diff(Angle))*handles.vid.FrameRate*handles.vid.FrameRate;
    L1Top(1:2,:)=[];    
plot(L1Top(:,1),acc2)
ylabel('degrees/second^2')
end         
xlabel('frame number')
grid on 

end


hold on
if get(handles.TimeEvent_1,'Value')==1
    frame = str2num(get(handles.OutVar1Value,'String'));
    line([frame frame],[ylim],'Color','green');    
end
if get(handles.TimeEvent_2,'Value')==1
    frame = str2num(get(handles.OutVar2Value,'String'));
    line([frame frame],[ylim],'Color','green');
end
if get(handles.TimeEvent_3,'Value')==1
    frame = str2num(get(handles.OutVar3Value,'String'));
    line([frame frame],[ylim],'Color','green');
end
if get(handles.TimeEvent_4,'Value')==1
    frame = str2num(get(handles.OutVar4Value,'String'));
    line([frame frame],[ylim],'Color','green');
end
if get(handles.TimeEvent_5,'Value')==1
    frame = str2num(get(handles.OutVar5Value,'String'));
    line([frame frame],[ylim],'Color','green');
end
if get(handles.TimeEvent_6,'Value')==1
    frame = str2num(get(handles.OutVar6Value,'String'));
    line([frame frame],[ylim],'Color','green');
end

hold off

function ZoomBtn_Callback(hObject, eventdata, handles)
zoom on

function PanBtn_Callback(hObject, eventdata, handles)
pan on

function Inspect_Callback(hObject, eventdata, handles)
datacursormode on

function MeasureLength_Callback(hObject, eventdata, handles)
zoom on
pause()
Clicks1 = round(my_ginput(1,[1,0,0]));
zoom on
pause()
Clicks2 = round(my_ginput(1,[1,0,0]));

zoom out

axes(handles.axes1)

hold on
line([Clicks2(1),Clicks1(1)],[Clicks2(2),Clicks1(2)],'Color','red')
hold off
MeasLength = sqrt((Clicks2(1)-Clicks1(1))^2+(Clicks2(2)-Clicks1(2))^2);

axes(handles.axes1)
text('position',[mean([Clicks1(1),Clicks2(1)]) mean([Clicks1(2),Clicks2(2)])],'fontsize',15,'string',num2str(MeasLength),'color','red') 

function MeasureAngle_Callback(hObject, eventdata, handles)
zoom on
pause()
Clicks1 = round(my_ginput(1,[1,0,0]));
zoom on
pause()
Clicks2 = round(my_ginput(1,[1,0,0]));
zoom on
pause()
Clicks3 = round(my_ginput(1,[1,0,0]));
axes(handles.axes1)
zoom out
hold on
line([Clicks2(1),Clicks1(1)],[Clicks2(2),Clicks1(2)],'Color','red')
line([Clicks2(1),Clicks3(1)],[Clicks2(2),Clicks3(2)],'Color','red')
hold off
L1 = atan2(Clicks2(1)-Clicks1(1),Clicks2(2)-Clicks1(2))*180/pi;
L2 = atan2(Clicks3(1)-Clicks2(1),Clicks3(2)-Clicks2(2))*180/pi;

if L1<0, L1=L1+360;
end
if L2<0, L2=L2+360;
end

MeasAngle = abs(180-abs(L2-L1));

axes(handles.axes1)
text('position',[mean([Clicks1(1),Clicks3(1)]) mean([Clicks1(2),Clicks3(2)])],'fontsize',15,'string',num2str(MeasAngle),'color','red') 

function ClearAndFill_Callback(hObject, eventdata, handles)
Clicks = round(ginput(2));
CS = Clicks(1,1);
CE = Clicks(2,1);

contents = cellstr(get(handles.PlotChoice,'String')); 
marker = contents{get(handles.PlotChoice,'Value')};

contents = cellstr(get(handles.FillMethod,'String')); 
FillMethod = contents{get(handles.FillMethod,'Value')};

eval(['data = handles.M' marker(end:end) 'data;'])
data = sortrows(data,1);
[~,U1] = unique(data(:,1));
data = data(U1,:);
CSloc = find(data(:,1)==CS);
CEloc = find(data(:,1)==CE);


data(CSloc:CEloc,:) = [];
vect = [CS:CE];

X = data(:,1);
Vx = data(:,2);
Vy = data(:,3);
vq1 = interp1(X,Vx,vect,FillMethod);
vq2 = interp1(X,Vy,vect,FillMethod);
data = [data(1:CSloc-1,:);[vect',vq1',vq2'];data(CSloc:end,:)];

% axes(handles.axes1)
% plot(data(:,1),data(:,2),'r',data(:,1),data(:,3),'b')
% legend('horizontal','vertical')
% xlabel('frame number')

eval(['handles.M' marker(end:end) 'data = data;'])
guidata(hObject,handles);
PlotButton_Callback(hObject, eventdata, handles)

function Compute_Callback(hObject, eventdata, handles)
contents = cellstr(get(handles.ComputeType,'String')); 
comptype = contents{get(handles.ComputeType,'Value')};

contents = cellstr(get(handles.CompData,'String')); 
compdata = contents{get(handles.CompData,'Value')};

contents = cellstr(get(handles.CompPosVelAcc,'String')); 
compPVA = contents{get(handles.CompPosVelAcc,'Value')};


if compdata(1) == 'M'

marker = compdata;
eval(['data = handles.M' marker(end:end) 'data;'])
data = sortrows(data,1);

data(:,3) = handles.vid.Height - data(:,3);

if get(handles.Calibrate,'Value')==1
    LPixel = str2num(get(handles.CalPixels,'String'));
    LMeter = str2num(get(handles.CalMeters,'String'));
    data(:,2:3) = data(:,2:3)*(LMeter/LPixel);
end


if compPVA(1)=='P'
    Signal = data;
elseif compPVA(1)=='V'
    vel2 = diff(data(:,2))*handles.vid.FrameRate;
    vel3 = diff(data(:,3))*handles.vid.FrameRate;
    data(1,:)=[];
    Signal = [data(:,1),vel2,vel3];
else 
    acc2 = diff(diff(data(:,2)))*handles.vid.FrameRate*handles.vid.FrameRate;
    acc3 = diff(diff(data(:,3)))*handles.vid.FrameRate*handles.vid.FrameRate;
    data(1:2,:)=[];    
    Signal = [data(:,1),acc2,acc3];
end 

temp = get(handles.CompStart,'String');
if temp(1)=='B'
    Begining = Signal(1,1);
else
    Begining = find(Signal(:,1)==str2num(temp));
end

temp = get(handles.CompStop,'String');
if temp(1)=='End'
    Ending = Signal(end,1);
else
    Ending = find(Signal(:,1)==str2num(temp));
end


if comptype(1:3)=='Min'
    outx = min(Signal(Begining:Ending,2));
    outy = min(Signal(Begining:Ending,3));
elseif comptype(1:3)=='Max'
    outx = max(Signal(Begining:Ending,2));
    outy = max(Signal(Begining:Ending,3));   
elseif comptype(1:3)=='Ran'
    outx = max(Signal(Begining:Ending,2))-min(Signal(Begining:Ending,2));
    outy = max(Signal(Begining:Ending,3))-min(Signal(Begining:Ending,3));   
else
    outx = mean(Signal(Begining:Ending,2));
    outy = mean(Signal(Begining:Ending,3));
end

output = [num2str(round(outx,4)) ', ' num2str(round(outy,4))];

set(handles.CompResult,'string',output);

else
contents = cellstr(get(handles.A1L1Top,'String'));
angle = compdata;

if angle(end:end) == '1'
    choice = contents{get(handles.A1L1Top,'Value')};
    eval(['L1Top = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A1L1Bot,'Value')};
    eval(['L1Bot = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A1L2Top,'Value')};
    if choice(1:1) == 'H'
        L2Top = ones(size(handles.M1data));
        L2Bot = ones(size(handles.M1data));
        L2Bot(:,2) = L2Top(:,2)+5;
    else
    eval(['L2Top = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A1L2Bot,'Value')};
    eval(['L2Bot = handles.M' choice(end:end) 'data;']);
    end
    
    if get(handles.A1Neg,'Value')==1
        factor = -1;
    else
        factor = 1;
    end
else
    choice = contents{get(handles.A2L1Top,'Value')};
    eval(['L1Top = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A2L1Bot,'Value')};
    eval(['L1Bot = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A2L2Top,'Value')};
    if choice(1:1) == 'H'
        L2Top = ones(size(handles.M1data));
        L2Top(:,2) = L2Top(:,2)+5;
        L2Bot = ones(size(handles.M1data));        
    else
    eval(['L2Top = handles.M' choice(end:end) 'data;']);
    choice = contents{get(handles.A2L2Bot,'Value')};
    eval(['L2Bot = handles.M' choice(end:end) 'data;']);
    end    
    if get(handles.A2Neg,'Value')==1
        factor = -1;
    else
        factor = 1;
    end
    
end


L1Top(:,3) = handles.vid.Height - L1Top(:,3);
L1Bot(:,3) = handles.vid.Height - L1Bot(:,3);
L2Top(:,3) = handles.vid.Height - L2Top(:,3);
L2Bot(:,3) = handles.vid.Height - L2Bot(:,3);

L1 = atan2(L1Top(:,3)-L1Bot(:,3),L1Top(:,2)-L1Bot(:,2))*180/pi;
L2 = atan2(L2Top(:,3)-L2Bot(:,3),L2Top(:,2)-L2Bot(:,2))*180/pi;
% L1(find(L1<0)) = L1(find(L1<0)) + 360;
% L2(find(L2<0)) = L2(find(L2<0)) + 360;
% Angle = 180-factor*abs(L1-L2);
Angle = factor*(L2-L1);


if compPVA(1)=='P'
    Signal = [L1Top(:,1),Angle];
elseif compPVA(1)=='V'
    vel2 = diff(Angle);
    vel2(find(vel2<-330)) = vel2(find(vel2<-330)) + 360;
    vel2(find(vel2>330)) = vel2(find(vel2>330)) - 360;
    vel2 = vel2*handles.vid.FrameRate;
    L1Top(1,:)=[];
    Signal = [L1Top(:,1),vel2];
else 
    acc2 = diff(diff(Angle))*handles.vid.FrameRate*handles.vid.FrameRate;
    L1Top(1:2,:)=[];
    Signal = [L1Top(:,1),acc2];
end 

temp = get(handles.CompStart,'String');
if temp(1)=='B'
    Begining = Signal(1,1);
else
    Begining = find(Signal(:,1)==str2num(temp));
end

temp = get(handles.CompStop,'String');
if temp(1)=='End'
    Ending = Signal(end,1);
else
    Ending = find(Signal(:,1)==str2num(temp));
end


if comptype(1:3)=='Min'
    outx = min(Signal(Begining:Ending,2));
elseif comptype(1:3)=='Max'
    outx = max(Signal(Begining:Ending,2));
elseif comptype(1:3)=='Ran'
    outx = max(Signal(Begining:Ending,2))-min(Signal(Begining:Ending,2));
else
    outx = mean(Signal(Begining:Ending,2));
end

output = [num2str(round(outx,4))];

set(handles.CompResult,'string',output);

end

function ClearNames_Callback(hObject, eventdata, handles)
set(handles.M1Name,'string','M1Name');
set(handles.M2Name,'string','M2Name');
set(handles.M3Name,'string','M3Name');
set(handles.M4Name,'string','M4Name');
set(handles.M5Name,'string','M5Name');
set(handles.M6Name,'string','M6Name');
set(handles.M7Name,'string','M7Name');
set(handles.M8Name,'string','M8Name');

set(handles.Ang1Name,'string','Ang1Name');
set(handles.Ang2Name,'string','Ang2Name');

set(handles.OutVar1Name,'string','Var1Name');
set(handles.OutVar2Name,'string','Var2Name');
set(handles.OutVar3Name,'string','Var3Name');
set(handles.OutVar4Name,'string','Var4Name');
set(handles.OutVar5Name,'string','Var5Name');
set(handles.OutVar6Name,'string','Var6Name');

set(handles.OutVar1Value,'string','Var1Value');
set(handles.OutVar2Value,'string','Var2Value');
set(handles.OutVar3Value,'string','Var3Value');
set(handles.OutVar4Value,'string','Var4Value');
set(handles.OutVar5Value,'string','Var5Value');
set(handles.OutVar6Value,'string','Var6Value');

set(handles.TimeEvent_1,'value',0);
set(handles.TimeEvent_2,'value',0);
set(handles.TimeEvent_3,'value',0);
set(handles.TimeEvent_4,'value',0);
set(handles.TimeEvent_5,'value',0);
set(handles.TimeEvent_6,'value',0);

set(handles.A1L1Top,'value',1);
set(handles.A1L1Bot,'value',1);
set(handles.A1L2Top,'value',1);
set(handles.A1L2Bot,'value',1);

set(handles.A2L1Top,'value',1);
set(handles.A2L1Bot,'value',1);
set(handles.A2L2Top,'value',1);
set(handles.A2L2Bot,'value',1);

guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%% Not set up yet or not important crap
function FrameSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Calibrate_Callback(hObject, eventdata, handles)

function ThresholdSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function M1Name_Callback(hObject, eventdata, handles)

function M1Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M2Name_Callback(hObject, eventdata, handles)

function M2Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M3Name_Callback(hObject, eventdata, handles)

function M3Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M4Name_Callback(hObject, eventdata, handles)

function M4Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M5Name_Callback(hObject, eventdata, handles)

function M5Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M6Name_Callback(hObject, eventdata, handles)

function M6Name_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M1Color_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'))
contents{get(hObject,'Value')}

function M1Color_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M2Color_Callback(hObject, eventdata, handles)

function M2Color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to M2Color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M3Color_Callback(hObject, eventdata, handles)

function M3Color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to M3Color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M4Color_Callback(hObject, eventdata, handles)

function M4Color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to M4Color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M5Color_Callback(hObject, eventdata, handles)

function M5Color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to M5Color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M6Color_Callback(hObject, eventdata, handles)

function M6Color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to M6Color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M7Name_Callback(hObject, eventdata, handles)

function M7Name_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function M8Name_Callback(hObject, eventdata, handles)

function M8Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to M8Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SkipFrames_Callback(hObject, eventdata, handles)

function SkipFrames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SkipFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PlotChoice_Callback(hObject, eventdata, handles)

function PlotChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OneMarkerToDigit_Callback(hObject, eventdata, handles)

function OneMarkerToDigit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OneMarkerToDigit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Ang1Name_Callback(hObject, eventdata, handles)

function Ang1Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ang1Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function A1L1Top_Callback(hObject, eventdata, handles)

function A1L1Top_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1L1Top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function A1L1Bot_Callback(hObject, eventdata, handles)

function A1L1Bot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1L1Bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in A1L2Top.
function A1L2Top_Callback(hObject, eventdata, handles)
% hObject    handle to A1L2Top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns A1L2Top contents as cell array
%        contents{get(hObject,'Value')} returns selected item from A1L2Top


% --- Executes during object creation, after setting all properties.
function A1L2Top_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1L2Top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in A1L2Bot.
function A1L2Bot_Callback(hObject, eventdata, handles)
% hObject    handle to A1L2Bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns A1L2Bot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from A1L2Bot


% --- Executes during object creation, after setting all properties.
function A1L2Bot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1L2Bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ang2Name_Callback(hObject, eventdata, handles)
% hObject    handle to Ang2Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ang2Name as text
%        str2double(get(hObject,'String')) returns contents of Ang2Name as a double


% --- Executes during object creation, after setting all properties.
function Ang2Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ang2Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in A2L1Top.
function A2L1Top_Callback(hObject, eventdata, handles)
% hObject    handle to A2L1Top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns A2L1Top contents as cell array
%        contents{get(hObject,'Value')} returns selected item from A2L1Top


% --- Executes during object creation, after setting all properties.
function A2L1Top_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2L1Top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in A2L1Bot.
function A2L1Bot_Callback(hObject, eventdata, handles)
% hObject    handle to A2L1Bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns A2L1Bot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from A2L1Bot


% --- Executes during object creation, after setting all properties.
function A2L1Bot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2L1Bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in A2L2Top.
function A2L2Top_Callback(hObject, eventdata, handles)
% hObject    handle to A2L2Top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns A2L2Top contents as cell array
%        contents{get(hObject,'Value')} returns selected item from A2L2Top


% --- Executes during object creation, after setting all properties.
function A2L2Top_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2L2Top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in A2L2Bot.
function A2L2Bot_Callback(hObject, eventdata, handles)
% hObject    handle to A2L2Bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns A2L2Bot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from A2L2Bot


% --- Executes during object creation, after setting all properties.
function A2L2Bot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2L2Bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in A1Neg.
function A1Neg_Callback(hObject, eventdata, handles)
% hObject    handle to A1Neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of A1Neg


% --- Executes on button press in A2Neg.
function A2Neg_Callback(hObject, eventdata, handles)
% hObject    handle to A2Neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of A2Neg

  

% --- Executes during object creation, after setting all properties.
function blockwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blockwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OutVar1Name_Callback(hObject, eventdata, handles)
% hObject    handle to OutVar1Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutVar1Name as text
%        str2double(get(hObject,'String')) returns contents of OutVar1Name as a double


% --- Executes during object creation, after setting all properties.
function OutVar1Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OutVar2Name_Callback(hObject, eventdata, handles)

function OutVar2Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CalPixels_Callback(hObject, eventdata, handles)

function CalPixels_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CalMeters_Callback(hObject, eventdata, handles)

function CalMeters_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text45_ButtonDownFcn(hObject, eventdata, handles)

function OutVar1Value_Callback(hObject, eventdata, handles)

function OutVar1Value_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OutVar2Value_Callback(hObject, eventdata, handles)

function OutVar2Value_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TimeEvent_1_Callback(hObject, eventdata, handles)

function TimeEvent_2_Callback(hObject, eventdata, handles)

function FilterFreq_Callback(hObject, eventdata, handles)

function FilterFreq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PosVelAcc_Callback(hObject, eventdata, handles)

function PosVelAcc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OutVar3Name_Callback(hObject, eventdata, handles)

function OutVar3Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OutVar3Value_Callback(hObject, eventdata, handles)

function OutVar3Value_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TimeEvent_3_Callback(hObject, eventdata, handles)

function OutVar4Name_Callback(hObject, eventdata, handles)

function OutVar4Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OutVar4Value_Callback(hObject, eventdata, handles)

function OutVar4Value_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TimeEvent_4_Callback(hObject, eventdata, handles)

function ComputeType_Callback(hObject, eventdata, handles)

function ComputeType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CompStart_Callback(hObject, eventdata, handles)

function CompStart_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CompStop_Callback(hObject, eventdata, handles)

function CompStop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CompData_Callback(hObject, eventdata, handles)

function CompData_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CompPosVelAcc_Callback(hObject, eventdata, handles)

function CompPosVelAcc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OutVar5Name_Callback(hObject, eventdata, handles)

function OutVar5Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OutVar5Value_Callback(hObject, eventdata, handles)

function OutVar5Value_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TimeEvent_5_Callback(hObject, eventdata, handles)

function OutVar6Name_Callback(hObject, eventdata, handles)

function OutVar6Name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OutVar6Value_Callback(hObject, eventdata, handles)

function OutVar6Value_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TimeEvent_6_Callback(hObject, eventdata, handles)

function CompResult_CreateFcn(hObject, eventdata, handles)

% This is an original matlab function which I modified. 
function [out1,out2,out3] = my_ginput(arg1,arg2)
out1 = []; out2 = []; out3 = []; y = [];

if ~matlab.ui.internal.isFigureShowEnabled
    error(message('MATLAB:hg:NoDisplayNoFigureSupport', 'ginput'))
end
    
    % Check Inputs
    if nargin == 0
        how_many = -1;
        b = [];
        CustomColor = [0,0,0];
    elseif nargin == 1
        how_many = arg1;
        CustomColor = [0,0,0];
        b = [];
        if  ~isPositiveScalarIntegerNumber(how_many) 
            error(message('MATLAB:ginput:NeedPositiveInt'))
        end
        if how_many == 0
            % If input argument is equal to zero points,
            % give a warning and return empty for the outputs.            
            warning (message('MATLAB:ginput:InputArgumentZero'));
        end        
    else
        how_many = arg1;
        b = [];
        if  ~isPositiveScalarIntegerNumber(how_many) 
            error(message('MATLAB:ginput:NeedPositiveInt'))
        end
        if how_many == 0
            % If input argument is equal to zero points,
            % give a warning and return empty for the outputs.            
            warning (message('MATLAB:ginput:InputArgumentZero'));
        end
        CustomColor = arg2;
    end
    
    % Get figure
    fig = gcf;
    drawnow;
    figure(gcf);
    
    % Make sure the figure has an axes
    gca(fig);    
    
    % Setup the figure to disable interactive modes and activate pointers. 
    initialState = setupFcn(fig,CustomColor);
    
    % onCleanup object to restore everything to original state in event of
    % completion, closing of figure errors or ctrl+c. 
    c = onCleanup(@() restoreFcn(initialState));
    
    drawnow
    char = 0;
    
    while how_many ~= 0
        waserr = 0;
        try
            keydown = wfbp;
        catch %#ok<CTCH>
            waserr = 1;
        end
        if(waserr == 1)
            if(ishghandle(fig))
                cleanup(c);
                error(message('MATLAB:ginput:Interrupted'));
            else
                cleanup(c);
                error(message('MATLAB:ginput:FigureDeletionPause'));
            end
        end
        % g467403 - ginput failed to discern clicks/keypresses on the figure it was
        % registered to operate on and any other open figures whose handle
        % visibility were set to off
        figchildren = allchild(0);
        if ~isempty(figchildren)
            ptr_fig = figchildren(1);
        else
            error(message('MATLAB:ginput:FigureUnavailable'));
        end
        %         old code -> ptr_fig = get(0,'CurrentFigure'); Fails when the
        %         clicked figure has handlevisibility set to callback
        if(ptr_fig == fig)
            if keydown
                char = get(fig, 'CurrentCharacter');
                button = abs(get(fig, 'CurrentCharacter'));
            else
                button = get(fig, 'SelectionType');
                if strcmp(button,'open')
                    button = 1;
                elseif strcmp(button,'normal')
                    button = 1;
                elseif strcmp(button,'extend')
                    button = 2;
                elseif strcmp(button,'alt')
                    button = 3;
                else
                    error(message('MATLAB:ginput:InvalidSelection'))
                end
            end
            
            if(char == 13) % & how_many ~= 0)
                % if the return key was pressed, char will == 13,
                % and that's our signal to break out of here whether
                % or not we have collected all the requested data
                % points.
                % If this was an early breakout, don't include
                % the <Return> key info in the return arrays.
                % We will no longer count it if it's the last input.
                break;
            end
            
            axes_handle = gca;            
            if ~(isa(axes_handle,'matlab.graphics.axis.Axes') ...
                    || isa(axes_handle,'matlab.graphics.axis.GeographicAxes'))
                % If gca is not an axes, warn but keep listening for clicks. 
                % (There may still be other subplots with valid axes)
                warning(message('MATLAB:Chart:UnsupportedConvenienceFunction', 'ginput', axes_handle.Type));
                continue            
            end
            
            drawnow;
            pt = get(axes_handle, 'CurrentPoint');            
            how_many = how_many - 1;
            

            
            out1 = [out1;pt(1,1)]; %#ok<AGROW>
            y = [y;pt(1,2)]; %#ok<AGROW>
            b = [b;button]; %#ok<AGROW>
        end
    end
    
    % Cleanup and Restore 
    cleanup(c);
    
    if nargout > 1
        out2 = y;
        if nargout > 2
            out3 = b;
        end
    else
        out1 = [out1 y];
    end
    



function valid = isPositiveScalarIntegerNumber(how_many)
valid = ~isa(how_many, 'matlab.graphics.Graphics') && ... % not a graphics handle
        ~ischar(how_many) && ...            % is numeric
        isscalar(how_many) && ...           % is scalar
        (fix(how_many) == how_many) && ...  % is integer in value
        how_many >= 0;                      % is positive

function key = wfbp
%WFBP   Replacement for WAITFORBUTTONPRESS that has no side effects.

fig = gcf;
current_char = []; % #ok<NASGU>

% Now wait for that buttonpress, and check for error conditions
waserr = 0;
try
    h=findall(fig,'Type','uimenu','Accelerator','C');   % Disabling ^C for edit menu so the only ^C is for
    set(h,'Accelerator','');                            % interrupting the function.
    keydown = waitforbuttonpress;
    current_char = double(get(fig,'CurrentCharacter')); % Capturing the character.
    if~isempty(current_char) && (keydown == 1)          % If the character was generated by the
        if(current_char == 3)                           % current keypress AND is ^C, set 'waserr'to 1
            waserr = 1;                                 % so that it errors out.
        end
    end
    
    set(h,'Accelerator','C');                           % Set back the accelerator for edit menu.
catch %#ok<CTCH>
    waserr = 1;
end
drawnow;
if(waserr == 1)
    set(h,'Accelerator','C');                          % Set back the accelerator if it errored out.
    error(message('MATLAB:ginput:Interrupted'));
end

if nargout>0, key = keydown; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function initialState = setupFcn(fig,CustomColor)

% Store Figure Handle. 
initialState.figureHandle = fig; 

% Suspend figure functions
initialState.uisuspendState = uisuspend(fig);

% Disable Plottools Buttons
initialState.toolbar = findobj(allchild(fig),'flat','Type','uitoolbar');
if ~isempty(initialState.toolbar)
    initialState.ptButtons = [uigettool(initialState.toolbar,'Plottools.PlottoolsOff'), ...
        uigettool(initialState.toolbar,'Plottools.PlottoolsOn')];
    initialState.ptState = get (initialState.ptButtons,'Enable');
    set (initialState.ptButtons,'Enable','off');
end

% Disable AxesToolbar
initialState.axes = findobj(allchild(fig),'-isa','matlab.graphics.axis.AbstractAxes');
tb = get(initialState.axes, 'Toolbar');
if ~iscell(tb)
    initialState.toolbarVisible{1} = tb.Visible;
    tb.Visible = 'off';
else
    for i=1:numel(tb)
        initialState.toolbarVisible{i} = tb{i}.Visible;
        tb{i}.Visible = 'off';
    end
end

%Setup empty pointer
cdata = NaN(16,16);
hotspot = [8,8];
set(gcf,'Pointer','custom','PointerShapeCData',cdata,'PointerShapeHotSpot',hotspot)

% Create uicontrols to simulate fullcrosshair pointer.
initialState.CrossHair = createCrossHair(fig,CustomColor);

% Adding this to enable automatic updating of currentpoint on the figure 
% This function is also used to update the display of the fullcrosshair
% pointer and make them track the currentpoint.
set(fig,'WindowButtonMotionFcn',@(o,e) dummy()); % Add dummy so that the CurrentPoint is constantly updated
initialState.MouseListener = addlistener(fig,'WindowMouseMotion', @(o,e) updateCrossHair(o,initialState.CrossHair));

% Get the initial Figure Units
initialState.fig_units = get(fig,'Units');


function restoreFcn(initialState)
if ishghandle(initialState.figureHandle)
    delete(initialState.CrossHair);
    
    % Figure Units
    set(initialState.figureHandle,'Units',initialState.fig_units);
    
    set(initialState.figureHandle,'WindowButtonMotionFcn','');
    delete(initialState.MouseListener);
    
    % Plottools Icons
    if ~isempty(initialState.toolbar) && ~isempty(initialState.ptButtons)
        set (initialState.ptButtons(1),'Enable',initialState.ptState{1});
        set (initialState.ptButtons(2),'Enable',initialState.ptState{2});
    end
    
    % Restore axestoolbar
    for i=1:numel(initialState.axes)
        initialState.axes(i).Toolbar.Visible_I = initialState.toolbarVisible{i};
    end    
    
    % UISUSPEND
    uirestore(initialState.uisuspendState);    
end


function updateCrossHair(fig, crossHair)
% update cross hair for figure.
gap = 3; % 3 pixel view port between the crosshairs
cp = hgconvertunits(fig, [fig.CurrentPoint 0 0], fig.Units, 'pixels', fig);
cp = cp(1:2);
figPos = hgconvertunits(fig, fig.Position, fig.Units, 'pixels', fig.Parent);
figWidth = figPos(3);
figHeight = figPos(4);

% Early return if point is outside the figure
if cp(1) < gap || cp(2) < gap || cp(1)>figWidth-gap || cp(2)>figHeight-gap
    return
end

set(crossHair, 'Visible', 'on');
thickness = 1; % 1 Pixel thin lines. 
set(crossHair(1), 'Position', [0 cp(2) cp(1)-gap thickness]);
set(crossHair(2), 'Position', [cp(1)+gap cp(2) figWidth-cp(1)-gap thickness]);
set(crossHair(3), 'Position', [cp(1) 0 thickness cp(2)-gap]);
set(crossHair(4), 'Position', [cp(1) cp(2)+gap thickness figHeight-cp(2)-gap]);


function crossHair = createCrossHair(fig,CustomColor)
% Create thin uicontrols with black backgrounds to simulate fullcrosshair pointer.
% 1: horizontal left, 2: horizontal right, 3: vertical bottom, 4: vertical top
for k = 1:4
    crossHair(k) = uicontrol(fig, 'Style', 'text', 'Visible', 'off', 'Units', 'pixels', 'BackgroundColor', CustomColor, 'HandleVisibility', 'off', 'HitTest', 'off'); %#ok<AGROW>
end


function cleanup(c)
if isvalid(c)
    delete(c);
end


function dummy(~,~) 


% --- Executes on selection change in FillMethod.
function FillMethod_Callback(hObject, eventdata, handles)
% hObject    handle to FillMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FillMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FillMethod


% --- Executes during object creation, after setting all properties.
function FillMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FillMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
