/*
 * Just use click location for first digitizing
 * Add in tracking with velocity
 * Add option to save or correct after stopping tracking
 */



/////////////////////////////////////////////////////////////////////////////
/*
A. Load new video
B. Get names and threshold
C. Check threshold
D. Manually digitize
E. Automatic tracking
F. Autotrack stop, choose to correct track or analyze
G. Filter data, save data, load new
*/


M1Name = "Enter";
M2Name = "Enter";
M3Name = "Enter";
M4Name = "Enter";
M5Name = "Enter";
M6Name = "Enter";
M7Name = "Enter";
M8Name = "Enter";
 
LoadNew();


function LoadNew() {

	      while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 
      
fname = File.openDialog("Select video");
run("Movie (FFMPEG)...", "choose=["+fname+"] first_frame=0 last_frame=-1");
run("8-bit");

GetNameandThresh();

}





function GetNameandThresh() {
	
	resetThreshold;
	
Dialog.createNonBlocking("Initialize AVADS");
Dialog.addString("M1Name:", M1Name);
Dialog.addString("M2Name:", M2Name);
Dialog.addString("M3Name:", M3Name);
Dialog.addString("M4Name:", M4Name);
Dialog.addString("M5Name:", M5Name);
Dialog.addString("M6Name:", M6Name);
Dialog.addString("M7Name:", M7Name);
Dialog.addString("M8Name:", M8Name);
Dialog.addSlider("Threshold:", 1, 255, 225);
Dialog.addCheckbox("White markers", 1)
Dialog.show;

M1Name = Dialog.getString();
M2Name = Dialog.getString();
M3Name = Dialog.getString();
M4Name = Dialog.getString();
M5Name = Dialog.getString();
M6Name = Dialog.getString();
M7Name = Dialog.getString();
M8Name = Dialog.getString();
ThreshOut = Dialog.getNumber();
WhiteMarkers = Dialog.getCheckbox();

if (WhiteMarkers) {
	setThreshold(ThreshOut,255,"black & white");
}	else {
	setThreshold(0,ThreshOut,"black & white");
}

CheckThreshold();

}




function CheckThreshold() {
waitForUser("Check the threshold");
	
 Dialog_options = newArray("No, proceed","Yes, adjust");
 Dialog.create("Adjust threshold?");
 Dialog.addChoice("Choose one", Dialog_options);
 Dialog.show();

 BlockCOut = Dialog.getChoice();

if (BlockCOut == "Yes, adjust") {
      GetNameandThresh();
   } else {
      ManuallyDigitize();
   } 

}


function ManuallyDigitize() {

resetThreshold;

waitForUser("Scroll to first frame you wish to start tracking");
FirstFrame = getSliceNumber();
CurrentFrame = getSliceNumber();	


if (WhiteMarkers) {
	setThreshold(ThreshOut,255,"black & white");
}	else {
	setThreshold(0,ThreshOut,"black & white");
}

//run("Set... ", "zoom=100");
run("Analyze Particles...", "display slice");
resetThreshold;
selectImage(getTitle()); 

// Code to click on marker of interest
if (M1Name != "Enter") {
showMessage("Digitizing markers", "Click on "+M1Name+"");
startclick = 1;
while (startclick) {
getCursorLoc(x, y, z, flags);
if (flags==16) { 
	x1 = x;
	y1 = y;
	startclick = 0;
	wait(250);
}
}

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x1)*(getResult("X", i)-x1);
	tempy = (getResult("Y", i)-y1)*(getResult("Y", i)-y1);
	
	tempDist = sqrt(tempx+tempy);
	setResult("M1Distance",i,tempDist);
}
Table.sort("M1Distance");
updateResults();
xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");

X1Data = newArray();
Y1Data = newArray();
X1Data = Array.concat(X1Data,xloc);
Y1Data = Array.concat(Y1Data,yloc);

}

if (M2Name != "Enter") {
showMessage("Digitizing markers", "Click on "+M2Name+"");
startclick = 1;
while (startclick) {
getCursorLoc(x, y, z, flags);
if (flags==16) { //Left click, add in shift left to skip
//	print(x,y);
	x2 = x;
	y2 = y;
	startclick = 0;
	wait(250);
}
}

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x2)*(getResult("X", i)-x2);
	tempy = (getResult("Y", i)-y2)*(getResult("Y", i)-y2);
	
	tempDist = sqrt(tempx+tempy);
	setResult("M2Distance",i,tempDist);
}
Table.sort("M2Distance");
updateResults();
xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X2Data = newArray();
Y2Data = newArray();
X2Data = Array.concat(X2Data,xloc);
Y2Data = Array.concat(Y2Data,yloc);
}

if (M3Name != "Enter") {
showMessage("Digitizing markers", "Click on "+M3Name+"");
startclick = 1;
while (startclick) {
getCursorLoc(x, y, z, flags);
if (flags==16) { //Left click, add in shift left to skip
//	print(x,y);
	x3 = x;
	y3 = y;
	startclick = 0;
	wait(250);
}
}

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x3)*(getResult("X", i)-x3);
	tempy = (getResult("Y", i)-y3)*(getResult("Y", i)-y3);
	
	tempDist = sqrt(tempx+tempy);
	setResult("M3Distance",i,tempDist);
}
Table.sort("M3Distance");
updateResults();
xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X3Data = newArray();
Y3Data = newArray();
X3Data = Array.concat(X3Data,xloc);
Y3Data = Array.concat(Y3Data,yloc);
}

if (M4Name != "Enter") {
showMessage("Digitizing markers", "Click on "+M4Name+"");
startclick = 1;
while (startclick) {
getCursorLoc(x, y, z, flags);
if (flags==16) { //Left click, add in shift left to skip
//	print(x,y);
	x4 = x;
	y4 = y;
	startclick = 0;
	wait(250);
}
}

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x4)*(getResult("X", i)-x4);
	tempy = (getResult("Y", i)-y4)*(getResult("Y", i)-y4);
	
	tempDist = sqrt(tempx+tempy);
	setResult("M4Distance",i,tempDist);
}
Table.sort("M4Distance");
updateResults();
xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X4Data = newArray();
Y4Data = newArray();
X4Data = Array.concat(X4Data,xloc);
Y4Data = Array.concat(Y4Data,yloc);
}

if (M5Name != "Enter") {
showMessage("Digitizing markers", "Click on "+M5Name+"");
startclick = 1;
while (startclick) {
getCursorLoc(x, y, z, flags);
if (flags==16) { //Left click, add in shift left to skip
//	print(x,y);
	x5 = x;
	y5 = y;
	startclick = 0;
	wait(250);
}
}

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x5)*(getResult("X", i)-x5);
	tempy = (getResult("Y", i)-y5)*(getResult("Y", i)-y5);
	
	tempDist = sqrt(tempx+tempy);
	setResult("M5Distance",i,tempDist);
}
Table.sort("M5Distance");
updateResults();
xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X5Data = newArray();
Y5Data = newArray();
X5Data = Array.concat(X5Data,xloc);
Y5Data = Array.concat(Y5Data,yloc);
}

if (M6Name != "Enter") {
showMessage("Digitizing markers", "Click on "+M6Name+"");
startclick = 1;
while (startclick) {
getCursorLoc(x, y, z, flags);
if (flags==16) { //Left click, add in shift left to skip
//	print(x,y);
	x6 = x;
	y6 = y;
	startclick = 0;
	wait(250);
}
}

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x6)*(getResult("X", i)-x6);
	tempy = (getResult("Y", i)-y6)*(getResult("Y", i)-y6);
	
	tempDist = sqrt(tempx+tempy);
	setResult("M6Distance",i,tempDist);
}
Table.sort("M6Distance");
updateResults();
xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X6Data = newArray();
Y6Data = newArray();
X6Data = Array.concat(X6Data,xloc);
Y6Data = Array.concat(Y6Data,yloc);
}

if (M7Name != "Enter") {
showMessage("Digitizing markers", "Click on "+M7Name+"");
startclick = 1;
while (startclick) {
getCursorLoc(x, y, z, flags);
if (flags==16) { //Left click, add in shift left to skip
//	print(x,y);
	x7 = x;
	y7 = y;
	startclick = 0;
	wait(250);
}
}

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x7)*(getResult("X", i)-x7);
	tempy = (getResult("Y", i)-y7)*(getResult("Y", i)-y7);
	
	tempDist = sqrt(tempx+tempy);
	setResult("M7Distance",i,tempDist);
}
Table.sort("M7Distance");
updateResults();
xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X7Data = newArray();
Y7Data = newArray();
X7Data = Array.concat(X7Data,xloc);
Y7Data = Array.concat(Y7Data,yloc);
}

if (M8Name != "Enter") {
showMessage("Digitizing markers", "Click on "+M8Name+"");
startclick = 1;
while (startclick) {
getCursorLoc(x, y, z, flags);
if (flags==16) { //Left click, add in shift left to skip
//	print(x,y);
	x8 = x;
	y8 = y;
	startclick = 0;
	wait(250);
}
}

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x8)*(getResult("X", i)-x8);
	tempy = (getResult("Y", i)-y8)*(getResult("Y", i)-y8);
	
	tempDist = sqrt(tempx+tempy);
	setResult("M8Distance",i,tempDist);
}
Table.sort("M8Distance");
updateResults();
xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X8Data = newArray();
Y8Data = newArray();
X8Data = Array.concat(X8Data,xloc);
Y8Data = Array.concat(Y8Data,yloc);
}

AutoTrack_Dist();
	
}


function AutoTrack_Dist() {
Flags = 1;

	while (Flags==1) {
run("Clear Results");

CurrentFrame++;

setSlice(CurrentFrame);

if (WhiteMarkers) {
	setThreshold(ThreshOut,255,"black & white");
}	else {
	setThreshold(0,ThreshOut,"black & white");
}

//run("Set... ", "zoom=100");
run("Analyze Particles...", "display slice");
resetThreshold;
selectImage(getTitle()); 

if (M1Name != "Enter") {
x1 = Array.slice(X1Data, X1Data.length-1);
y1 = Array.slice(Y1Data, Y1Data.length-1);

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x1[0])*(getResult("X", i)-x1[0]);
	tempy = (getResult("Y", i)-y1[0])*(getResult("Y", i)-y1[0]);
	
	tempDist = sqrt(tempx+tempy);
	
	Table.set("index1",i,i);
	Table.set("M1Distance",i,tempDist);
	//setResult("M1Distance",i,tempDist);
}
Table.update;
//updateResults();
Table.sort("M1Distance");
Val = Table.getString("index1",0);

//updateResults();
xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X1Data = Array.concat(X1Data,xloc);
Y1Data = Array.concat(Y1Data,yloc);
}

Table.sort("index1");
if (M2Name != "Enter") {
x2 = Array.slice(X2Data, X2Data.length-1);
y2 = Array.slice(Y2Data, Y2Data.length-1);

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x2[0])*(getResult("X", i)-x2[0]);
	tempy = (getResult("Y", i)-y2[0])*(getResult("Y", i)-y2[0]);

	tempDist = sqrt(tempx+tempy);
	
	Table.set("index2",i,i);
	Table.set("M2Distance",i,tempDist);
}
Table.update;
Table.sort("M2Distance");
Val = Table.getString("index2",0);

xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X2Data = Array.concat(X2Data,xloc);
Y2Data = Array.concat(Y2Data,yloc);
}

if (M3Name != "Enter") {
x3 = Array.slice(X3Data, X3Data.length-1);
y3 = Array.slice(Y3Data, Y3Data.length-1);

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x3[0])*(getResult("X", i)-x3[0]);
	tempy = (getResult("Y", i)-y3[0])*(getResult("Y", i)-y3[0]);
	
	tempDist = sqrt(tempx+tempy);
	
	Table.set("index3",i,i);
	Table.set("M3Distance",i,tempDist);
}
Table.update;
Table.sort("M3Distance");
Val = Table.getString("index3",0);

xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X3Data = Array.concat(X3Data,xloc);
Y3Data = Array.concat(Y3Data,yloc);
}

if (M4Name != "Enter") {
x4 = Array.slice(X4Data, X4Data.length-1);
y4 = Array.slice(Y4Data, Y4Data.length-1);

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x4[0])*(getResult("X", i)-x4[0]);
	tempy = (getResult("Y", i)-y4[0])*(getResult("Y", i)-y4[0]);
	
	tempDist = sqrt(tempx+tempy);
	
	Table.set("index4",i,i);
	Table.set("M4Distance",i,tempDist);
}
Table.update;
Table.sort("M4Distance");
Val = Table.getString("index4",0);

xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X4Data = Array.concat(X4Data,xloc);
Y4Data = Array.concat(Y4Data,yloc);
}

if (M5Name != "Enter") {
x5 = Array.slice(X5Data, X5Data.length-1);
y5 = Array.slice(Y5Data, Y5Data.length-1);

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x5[0])*(getResult("X", i)-x5[0]);
	tempy = (getResult("Y", i)-y5[0])*(getResult("Y", i)-y5[0]);
	
	tempDist = sqrt(tempx+tempy);
	
	Table.set("index5",i,i);
	Table.set("M5Distance",i,tempDist);
}
Table.update;
Table.sort("M5Distance");
Val = Table.getString("index5",0);

xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X5Data = Array.concat(X5Data,xloc);
Y5Data = Array.concat(Y5Data,yloc);
}

if (M6Name != "Enter") {
x6 = Array.slice(X6Data, X6Data.length-1);
y6 = Array.slice(Y6Data, Y6Data.length-1);

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x6[0])*(getResult("X", i)-x6[0]);
	tempy = (getResult("Y", i)-y6[0])*(getResult("Y", i)-y6[0]);
	
	tempDist = sqrt(tempx+tempy);
	
	Table.set("index6",i,i);
	Table.set("M6Distance",i,tempDist);
}
Table.update;
Table.sort("M6Distance");
Val = Table.getString("index6",0);

xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X6Data = Array.concat(X6Data,xloc);
Y6Data = Array.concat(Y6Data,yloc);
}

if (M7Name != "Enter") {
x7 = Array.slice(X7Data, X7Data.length-1);
y7 = Array.slice(Y7Data, Y7Data.length-1);

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x7[0])*(getResult("X", i)-x7[0]);
	tempy = (getResult("Y", i)-y7[0])*(getResult("Y", i)-y7[0]);
	
	tempDist = sqrt(tempx+tempy);
	
	Table.set("index7",i,i);
	Table.set("M7Distance",i,tempDist);
}
Table.update;
Table.sort("M7Distance");
Val = Table.getString("index7",0);

xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X7Data = Array.concat(X7Data,xloc);
Y7Data = Array.concat(Y7Data,yloc);
}

if (M8Name != "Enter") {
x8 = Array.slice(X8Data, X8Data.length-1);
y8 = Array.slice(Y8Data, Y8Data.length-1);

for (i=0; i<nResults ; i++) {
	tempx = (getResult("X", i)-x8[0])*(getResult("X", i)-x8[0]);
	tempy = (getResult("Y", i)-y8[0])*(getResult("Y", i)-y8[0]);
	
	tempDist = sqrt(tempx+tempy);
	
	Table.set("index8",i,i);
	Table.set("M8Distance",i,tempDist);
}
Table.update;
Table.sort("M8Distance");
Val = Table.getString("index8",0);

xloc = getResult("X",0);
yloc = getResult("Y",0);
makePoint(xloc, yloc, "large red circle add");
X8Data = Array.concat(X8Data,xloc);
Y8Data = Array.concat(Y8Data,yloc);
}

wait(250);
getCursorLoc(x, y, z, flags);
if (flags==16) {
Flags = 0;
wait(3000);
	}
	
	}

SaveData();

}

function SaveData() {


Table.create("OutData");

FrameArr = newArray(CurrentFrame);
for (i=0;i < FrameArr.length;i++) {
	FrameArr[i] = i;
}


FrameArr = Array.slice(FrameArr, FirstFrame, CurrentFrame+1);
FrameArr = Array.concat(FrameArr,CurrentFrame);

if (M1Name != "Enter") {
Table.setColumn("Frames", FrameArr);
Table.setColumn(M1Name+" X", X1Data);
Table.setColumn(M1Name+" Y", Y1Data);
} 
if (M2Name != "Enter") {
Table.setColumn(M2Name+" X", X2Data);
Table.setColumn(M2Name+" Y", Y2Data);	
}
if (M3Name != "Enter") {
Table.setColumn(M3Name+" X", X3Data);
Table.setColumn(M3Name+" Y", Y3Data);	
}
if (M4Name != "Enter") {
Table.setColumn(M4Name+" X", X4Data);
Table.setColumn(M4Name+" Y", Y4Data);	
}
if (M5Name != "Enter") {
Table.setColumn(M5Name+" X", X5Data);
Table.setColumn(M5Name+" Y", Y5Data);	
}
if (M6Name != "Enter") {
Table.setColumn(M6Name+" X", X6Data);
Table.setColumn(M6Name+" Y", Y6Data);	
}
if (M7Name != "Enter") {
Table.setColumn(M7Name+" X", X7Data);
Table.setColumn(M7Name+" Y", Y7Data);	
}
if (M8Name != "Enter") {
Table.setColumn(M8Name+" X", X8Data);
Table.setColumn(M8Name+" Y", Y8Data);	
}

Dialog.create("Save Data Filename");
Dialog.addString("Output file name","Type name here");
Dialog.show();

OutName = Dialog.getString();

selectWindow("OutData"); 
saveAs("Results", File.directory+OutName+".csv");
}