function colony(input, output, filename) {
        open(input + filename);
        selectWindow(filename);
		run("Brightness/Contrast...");
		resetMinAndMax();
		setMinAndMax(0, 10000);
		call("ij.ImagePlus.setDefault16bitRange", 0);
		run("Subtract Background...", "rolling=50");
		setAutoThreshold("Default dark");
		//run("Threshold...");
		resetThreshold();
		setThreshold(2000, 20000);
		run("Convert to Mask");
		run("Analyze Particles...", "size=20-15000 circularity=0.50-1.00 show=[Overlay Outlines] exclude summarize");
		run("Flatten");
		saveAs("Tiff", output + filename);
		
}

input = "C:\\Users\\Juliana\\Downloads\\janu\\teste\\";
output = "C:\\Users\\Juliana\\Downloads\\janu\\results\\";

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)
        colony(input, output, list[i]);
selectWindow("Summary");
	saveAs("Text", output + "Counts" + ".xls");
setBatchMode(false);