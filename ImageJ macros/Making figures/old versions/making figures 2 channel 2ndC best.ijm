/*
We start by creating a function that can perform all the steps we need to create the figures.
This function will get a .dv file, and output a Composite and a Montage. 
The best focused stack is selected and then 3 stacks above and below that are used for projection with Extended Depth of Field.  
The projections are used to create a composite and a montage with scale bars. Both saved as .tif.
The channels are not saved separately in .tif files unless you uncomment that function.
*/

/* I need to see if this will work better switching around the channel for focusing in IF images. 
This is probably ideal for cy5/cy3/dapi FISH though as the cy3 FISH will be the best channel. 
I also need to rewrite a version for 2 channel images.
*/

function make_figure(input, output, filename, C0, C1) {
	newfile = input + filename;
	options = "open=newfile autoscale color_mode=Default split_channels view=[Standard ImageJ] stack_order=XYZCT";
	run("Bio-Formats Importer",options);

	// Adjust brightness and contrast first, not sure if makes a difference. Also set the image scale to global so you can add scale bars later.
	run("Brightness/Contrast...");
	selectWindow(filename + " - C=0");
	getDimensions(dummy, dummy, dummy, nslice, dummy);
	resetMinAndMax();
	selectWindow(filename + " - C=1");
	resetMinAndMax();
	run("Properties...", "global");

	// Finding the central focused slice (make sure you choose the channel to use for this wisely, for ex. Nup98 or FISH channel, not DAPI).
	selectWindow(filename + " - C=1");
	run("Find focused slices", "select=100 variance=0.000 edge select_only");
	selectWindow("Focused slices of " + filename + " - C=1_100.0%");
	Zgood = getMetadata("Label");
	Zgsub = substring(Zgood, 2, lengthOf(Zgood));
	Zgnum = parseInt(Zgsub); 
	if (Zgnum > 3) {
		Zstart = d2s((Zgnum - 3),0);
	} else {
		Zstart = 1;
	}
	
	if (Zgnum + 3 <= nslice) {
		Zstop = d2s((Zgnum + 3),0);
	} else {
		Zstop = d2s((nslice),0);
	}
	
	option2 = " slices=" + Zstart + "-" + Zstop;

	// Create a substack of about 6 in focus images, you can change that by changing the number in Zstart Zstop to include more or less images.
	// As is this will only save a composite and montage of each file, if you'd like to save each channel uncomment the lines with saveAs.
	// First for the channel used to find the focused stack
	selectWindow(filename + " - C=1"); 
	run("Make Substack...", option2);
	selectWindow("Substack (" + Zstart + "-" + Zstop + ")");
	run("EDF Easy ", "quality='0' topology='0' show-topology='off' show-view='off'");

		// The following code is required in order to wait for the the EDF plugin to finish, and open the expected image. 
		// We must wait for a window called "Output" . Batch mode cannot be true, because if so the window will not open. 
	initTime = getTime(); 
	oldTime = initTime; 
	while (!isOpen("Output")) { 
	    elapsedTime = getTime() - initTime; 
	    newTime = getTime() - oldTime; 
	// print something every 10 seconds so that we will know it is still alive 
	    if (newTime > 10000) { 
	        oldTime = getTime(); 
	             newTime = 0; 
	        print(elapsedTime/1000, " seconds elapsed"); 
	    } 
	} 
	wait(1000); // let's really make sure that window is open -- give it another second 
	selectImage("Output"); 
	rename(filename + "C1.tif");
	setFont("SansSerif", 24, " antialiased");
	drawString(C1, 40, 40);
	//saveAs("Tiff", output + filename + "C0.tif");
	selectWindow("Substack (" + Zstart + "-" + Zstop + ")");
	close();
	selectWindow(filename + " - C=1"); 
	close();
	selectWindow("Focused slices of " + filename + " - C=1_100.0%");
	close();

	// Run it again for other channel.
	selectWindow(filename + " - C=0"); 
	run("Make Substack...", option2);
	selectWindow("Substack (" + Zstart + "-" + Zstop + ")");
	run("EDF Easy ", "quality='0' topology='0' show-topology='off' show-view='off'");

		// The following code is required in order to wait for the the EDF plugin to finish, and open the expected image. 
		// We must wait for a window called "Output" . Batch mode cannot be true, because if so the window will not open. 
	initTime = getTime(); 
	oldTime = initTime; 
	while (!isOpen("Output")) { 
	    elapsedTime = getTime() - initTime; 
	    newTime = getTime() - oldTime; 
	// print something every 10 seconds so that we will know it is still alive 
	    if (newTime > 10000) { 
	        oldTime = getTime(); 
	             newTime = 0; 
	        print(elapsedTime/1000, " seconds elapsed"); 
	    } 
	} 
	wait(1000); // let's really make sure that window is open -- give it another second 
	selectImage("Output"); 
	rename(filename + "C0.tif");
	drawString(C0, 40, 40);
	//saveAs("Tiff", output + filename + "C1.tif");
	selectWindow("Substack (" + Zstart + "-" + Zstop + ")");
	close();
	selectWindow(filename + " - C=0"); 
	close();

	// Now lets make a composite with a scale bar and a montage to save
	selectWindow(filename + "C1.tif");
	run("Scale Bar...", "width=5 height=3 font=28 color=White background=None location=[Lower Right] bold");
	option3 = "c2=[" + filename + "C0.tif]" + " c3=[" + filename + "C1.tif]" + " create";
	// The [] separating the channel names is necessary in some ImageJ versions, but not others.
	run("Merge Channels...", option3);

	selectWindow("Composite");

	b=bitDepth;
	if ((b!=24)&&(nSlices==1)) 	{ exit("Stack, Composite, or RGB image required.");}
	if ((b==24)&&(nSlices==1)) 	{ run("Make Composite"); b=8;}
	Stack.getDimensions(width, height, channels, slices, frames);
	getVoxelSize(xp,yp,zp,unit);
	if (channels==1) { channels = channels* frames*slices; Stack.setDimensions(channels,1,1); }
	id=getImageID;
	t=getTitle;
	if (b!=24) {
	    newImage("tempmont", "RGB", width, height,channels);
	    id2=getImageID;
	    for (i=1;i<=channels;i++) {
	        setPasteMode("copy");
	        selectImage(id);
	        Stack.setChannel(i);
	        getLut(r,g,b);
	        run("Duplicate...", "title=temp"+i);
	        setLut(r,g,b);
	        run("RGB Color");
	        run("Copy");
	        selectImage(id2);
	        setSlice(i);
	        run("Paste");
	    }
	}
	run("Make Montage...", "scale=1 border=0");
	rename(getTitle+" of "+t);
	setVoxelSize(xp,yp,zp,unit);

	selectWindow("Composite");
	saveAs("Tiff", output + filename + "composite.tif");
	selectWindow("Montage of Composite");
	saveAs("Tiff", output + filename + "compositemontage.tif");

	while (nImages>0) { 
	    selectImage(nImages); 
	    close(); 
	} 
}

// Below are the folder were your .dv files are (input) and the folder where you'd like to save the files (output). 
// The channels in the image are used for labels

input = "C:\\Users\\Juliana\\Documents\\Lab Stuff 2015\\Images\\DeltaVision microscope\\2015-07-02 FISH-IF drugs\\GAPDH FISH\\input\\";
output = "C:\\Users\\Juliana\\Documents\\Lab Stuff 2015\\Images\\DeltaVision microscope\\2015-07-02 FISH-IF drugs\\GAPDH FISH\\output2\\";
C0 = "GAPDH-mRNA";
C1 = "DAPI";

// This will iterate the function created above in all the files present in input.
// You cannot set BatchMode true because of the depth of field plugin, so this will take a while. 
//I may try using Zproject later to see if that's better.

list = getFileList(input);
for (i = 0; i < list.length; i++)
        make_figure(input, output, list[i], C0, C1);
