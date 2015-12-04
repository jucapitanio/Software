/*
We start by creating a function that can perform all the steps we need to create the figures.
This function will use open images that should have each channel in a separate window and contain Zstacks. 
It will output a Composite and a Montage of you image. 
The best focused stack is selected and then 3 stacks above and below that are used for projection with Extended Depth of Field.  
The projections are used to create a composite and a montage with scale bars.

You need the EDF (developer distribution), the Find Focused Slices and the Bio-Formats Importer plugins installed.
 Info: https://sites.google.com/site/qingzongtseng/find-focus - Download: http://goo.gl/ZVQn1
 Info: bigwww.epfl.ch/demo/edf/ - Download: http://bigwww.epfl.ch/demo/edf/EDF.zip
 Info: https://www.openmicroscopy.org/site/support/bio-formats5.1/users/imagej/ - Download: http://downloads.openmicroscopy.org/latest/bio-formats5.1/artifacts/bioformats_package.jar
*/

macro "make figure" {
	
	// Identify files and collect some info.
	
	imageslist = getList("image.titles");
	selectWindow(imageslist[0]);
	getDimensions(dummy, dummy, dummy, nslice, dummy);
	run("Properties...", "global");
	
	run("Brightness/Contrast...");
	for (i = 0; i < imageslist.length; i++) {
		selectWindow(imageslist[i]);
		resetMinAndMax();
	}
	C = newArray(imageslist.length);
	for (i = 0; i < imageslist.length; i++) {
		C[i] = getString("Provide Channel name in the order acquired. Enter one channel name at a time and the question repeats for the number of channels available. Examples: DAPI, Nup98..., default is empty string", "");
	}

	forfocus = getNumber("Channel number for focusing slices (0,1,2...), default is 0", 0);

	// Finding the central focused slice (make sure you choose the channel to use for this wisely, for ex. Nup98 or FISH channel, not DAPI).
	selectWindow(imageslist[forfocus]);
	run("Find focused slices", "select=100 variance=0.000 edge select_only");
	selectWindow("Focused slices of " + imageslist[forfocus] + "_100.0%");
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
	selectWindow("Focused slices of " + imageslist[forfocus] + "_100.0%");
	close();
	
	option2 = " slices=" + Zstart + "-" + Zstop;
	setFont("SansSerif", 24, " antialiased");
	
	// Create a substack of about 6 in focus images, you can change that by changing the number in Zstart Zstop to include more or less images.
	// The substack is used for Extended Depth of Field.
	
	for (i = 0; i < imageslist.length; i++) {
	
		selectWindow(imageslist[i]); 
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
		rename(imageslist[i] + "EDF");
		drawString(C[i], 40, 40);
		selectWindow("Substack (" + Zstart + "-" + Zstop + ")");
		close();
		selectWindow(imageslist[i]); 
		close();
		
	}
	
	// Now lets make a composite with a scale bar and a montage
	selectWindow(imageslist[i-1] + "EDF");
	run("Scale Bar...", "width=5 height=3 font=28 color=White background=None location=[Lower Right] bold");
	
	imageslist2 = getList("image.titles");
	options3 = "";
	for (i = 0; i < imageslist2.length; i++) {
		cnum = i+1;
		options3 = options3 + "c" + cnum + "=[" + imageslist2[i] + "] "; // The [] separating the channel names is necessary in some ImageJ versions, but not others.
	}
	options3 = options3 + " create";	
	run("Merge Channels...", options3);
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

	selectWindow("tempmont");
	close();

	for (i = 1; i <= channels; i++) { 
		selectWindow("temp" + i); 
		close();
	}
}