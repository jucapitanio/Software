/*
 Macro template to process multiple images in a folder and create figures from them.
 You need the EDF (developer distribution), the Find Focused Slices and the Bio-Formats Importer plugins installed.
 
 Info: https://sites.google.com/site/qingzongtseng/find-focus - Download: http://goo.gl/ZVQn1
 Info: bigwww.epfl.ch/demo/edf/ - Download: http://bigwww.epfl.ch/demo/edf/EDF.zip
 Info: https://www.openmicroscopy.org/site/support/bio-formats5.1/users/imagej/ - Download: http://downloads.openmicroscopy.org/latest/bio-formats5.1/artifacts/bioformats_package.jar
*/

input = getDirectory("Input directory");
output = getDirectory("Output directory");

Dialog.create("File type");
Dialog.addString("File suffix: ", ".dv", 5);
Dialog.show();
suffix = Dialog.getString();

channelnumber = getNumber("Number of channels in images to be processed", 2);
C = newArray(channelnumber);
	for (i = 0; i < channelnumber; i++) {
		C[i] = getString("Provide channel name in the order acquired. Question repeats for the number of channels available. Example: DAPI", "");
	}

processFolder(input);

function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + list[i]))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {

	print("Processing: " + input + file);
	
	newfile = input + file;
	options = "open=newfile autoscale color_mode=Default split_channels view=[Standard ImageJ] stack_order=XYZCT";
	run("Bio-Formats Importer",options);
	
	imageslist = getList("image.titles");
	selectWindow(imageslist[0]);
	getDimensions(dummy, dummy, dummy, nslice, dummy);
	run("Properties...", "global");
	
	run("Brightness/Contrast...");
	for (i = 0; i < imageslist.length; i++) {
		selectWindow(imageslist[i]);
		resetMinAndMax();
	}
	
	// Use the central 5 slices in the image for the creation of the projection.
	
	Zstart = d2s((nslice/2 - 3),0);
	Zstop = d2s((nslice/2 + 3),0);
	
	option2 = " slices=" + Zstart + "-" + Zstop;
	setFont("SansSerif", 24, " antialiased");
	// Create a substack of about 6 in focus images, you can change that by changing the number in Zstart Zstop to include more or less images.
	// As is this will only save a composite and montage of each file, if you'd like to save each channel uncomment the lines with saveAs.
	// First for the channel used to find the focused stack
	
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
		//saveAs("Tiff", output + filename + "C0.tif");
		selectWindow("Substack (" + Zstart + "-" + Zstop + ")");
		close();
		selectWindow(imageslist[i]); 
		close();
		
	}
	// Now lets make a composite with a scale bar and a montage to save
	selectWindow(imageslist[i-1] + "EDF");
	run("Scale Bar...", "width=5 height=3 font=28 color=White background=None location=[Lower Right] bold");
	
	imageslist2 = getList("image.titles");
	options3 = "";
	for (i = 0; i < imageslist2.length; i++) {
		cnum = i+1;
		options3 = options3 + "c" + cnum + "=[" + imageslist2[i] + "] ";
	}
	options3 = options3 + " create";	
	// The [] separating the channel names is necessary in some ImageJ versions, but not others.
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

	selectWindow("Composite");
	saveAs("Tiff", output + file + "composite.tif");
	selectWindow("Montage of Composite");
	saveAs("Tiff", output + file + "compositemontage.tif");

	while (nImages>0) { 
	    selectImage(nImages); 
	    close(); 
	} 
	print("Saving to: " + output);
}
