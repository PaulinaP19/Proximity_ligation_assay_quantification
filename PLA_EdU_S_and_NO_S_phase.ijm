// ImageJ macro to count PLA foci number in replicating cells/cels outside replication
// Sphase cells are recognised based on number of EdU local maxima in EdU channel 
//########################
macro "Batch Coloc" 
	{
	dir1 = getDirectory("Choose Source Directory ");
	dir2 = getDirectory("Choose Results Directory ");
	
	// read in file listing from source directory
	list = getFileList(dir1);
	
	
	//Batch mode prevents images opening and makes the script execution faster
	
	setBatchMode(true);
	
	// loop over the files in the source directory
	for (i=0; i<list.length; i++)
		{
		if (endsWith(list[i], ".tif"))
			{
			filename = dir1 + list[i];
			imagename = list[i];	
			//open(filename);
			run("Bio-Formats Windowless Importer", "open=[" + dir1 + imagename +"] autoscale color_mode=Composite rois_import=[ROI manager] view=DataBrowser stack_order=XYCZT");	
			open(filename);	
			rename("image");
			run("Split Channels");
			selectWindow("C3-image");
			rename("DAPI");
			selectWindow("C2-image");
			rename("EdU");
			selectWindow("C1-image");
			rename("PLA");
			selectWindow("DAPI");
			run("Duplicate...", "title=DAPI-mask");
			//create DAPI-mask, choose the best method for auto threshold or set the threshold manually 
			setAutoThreshold("Otsu dark");
			run("Convert to Mask", "method=Otsu background=Dark calculate black");
			run("Options...", "iterations=1 count=1 black do=[Fill Holes]");
			// segment nuclei
			run("Watershed");
			// select 
			run("Analyze Particles...", "size=30-300 display exclude clear summarize add"); 
			//run("Analyze Particles...", "size=3-Infinity display clear summarize add stack"); if you wish a less stringend size selection
			// if there are some cells identified
			if (isOpen("Results")){
				selectWindow("Results");
				run("Close");		
				selectWindow("EdU");
				num=roiManager("count"); 
				// create arrays to store ROIs corresponding to Sphase and non Sphase cells
				NO_Sphase =newArray(num);
				Sphase =newArray(num);
				
			    // find cells in replication based on EdU signal
				counter_S = 0;
				counter_NS =0; 
				
				for(j=0; j < num; j++) {
					
					roiManager("select",j); 
					run("Find Maxima...", "prominence=20 strict exclude  output=Count");
					a = getResult("Count", j);
					
					if (a < 15) {
						
						NO_Sphase[counter_NS] = j;
						counter_NS +=1;
						
					}
					else {
						
						Sphase[counter_S] = j;
						counter_S +=1; 
					}
			
					}
					
				Sphase = Array.slice(Sphase, 0, counter_S);
				NO_Sphase = Array.slice(NO_Sphase, 0, counter_NS);
		
				selectWindow("Results");
				saveAs("Text", dir2 + "EdU_foci_nb_" + imagename + ".txt");	
				run("Close");
				// cont PLA foci in Sphase non Sphase cells
				if (Sphase.length >0) {
					
				selectWindow("PLA");	
				for(Sp=0; Sp < Sphase.length; Sp++) {

					sel = Sphase[Sp];
					roiManager("select", sel ); 
					run("Find Maxima...", "prominence=50 strict exclude  output=Count");
				}
				// save results for Sphase cells
				selectWindow("Results");
				saveAs("Text", dir2 + "PLA_Sphase_" + imagename + ".txt");
				run("Close");
				}
				
				if (NO_Sphase.length >0){
					
				selectWindow("PLA");	
				for(NSp=0; NSp < NO_Sphase.length; NSp++) {
					
					sel2 = NO_Sphase[NSp];
					roiManager("select",sel2); 
					run("Find Maxima...", "prominence=50 strict exclude  output=Count");
				}
				// save results for non Sphase cells
				selectWindow("Results");
				saveAs("Text", dir2 + "PLA_NoSphase_" + imagename + ".txt");
				run("Close");
				}
			
	
				roiManager("Select All");
				// cells ROIs of all cells 
				roiManager("Save", dir2 + imagename + "_all_cells_roi.zip");
				
				
				roiManager("Select", NO_Sphase);
				
				roiManager("Delete");
			
			
				
				num2=roiManager("count");
				if (num2> 0) {
				// save ROIs of Sphase cells
				roiManager("Save", dir2 + imagename + "_Sphase_roi.zip")
				
				roiManager("Select All");
				roiManager("Delete");
				close("ROI Manager");
				
				}
			
				selectWindow("Summary");
				run("Close");
				close('*');
						
			
				
			} else { 
				close('*');
			
			} 
			
			
			}
		}
	}


			