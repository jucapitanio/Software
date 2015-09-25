function beadhalo(input, output, filename) {
        open(input + filename);
        selectWindow(filename + "  Ch0");
		close();
		selectWindow(filename + "  Ch1");
		run("Brightness/Contrast...");
		resetMinAndMax();
		setMinAndMax(0, 2000);
		call("ij.ImagePlus.setDefault16bitRange", 0);
		run("Subtract Background...", "rolling=50");
		setAutoThreshold("Default dark");
		//run("Threshold...");
		resetThreshold();
		setThreshold(150, 2000);
		run("Convert to Mask");
		run("Close");
		run("Create Selection");
		run("Add to Manager");
		roiManager("Add");
		roiManager("Select", 0);
		roiManager("Split");
		roiManager("Select", 0);
		roiManager("Delete");
		selectWindow(filename + "  Ch1");
		close();
		open(input + filename);
		selectWindow(filename + "  Ch0");
		close();
		selectWindow(filename + "  Ch1");
		resetMinAndMax();
		setMinAndMax(0, 2000);
		call("ij.ImagePlus.setDefault16bitRange", 0);
		run("Subtract Background...", "rolling=50");
		roiManager("Deselect");
		roiManager("Show all");
		roiManager("Measure");
		saveAs("Results", output + filename + ".xml");
		close();
		roiManager("Delete");
		run("Clear Results");
}

input = "C:\\Users\\Juliana\\Documents\\Lab Stuff 2014\\Images\\August\\2014-08-14\\teste junto\\tudo\\";
output = "C:\\Users\\Juliana\\Documents\\Lab Stuff 2014\\Images\\August\\2014-08-14\\teste junto\\tabela2\\";

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)
        beadhalo(input, output, list[i]);
setBatchMode(false);