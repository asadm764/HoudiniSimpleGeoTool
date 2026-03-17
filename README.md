# HoudiniSimpleGeoTool
A prototype of Houdini geo creation tool. This project helped me understand each step of creating and sharing a tool with other artists.

**This tool's purpose is to create a simple geometric shape and deform it.

## Installing the Tool

1. Automatic Install (Recommended)  
Run the INSTALL_ME.bat and UNINSTALL.bat files. These scripts will automatically place the tool onto your Houdini shelf without requiring any manual file copying.

2. Manual Install (If you prefer not to use batch files)  
Copy the file named ArtProofTool.shelf into your Houdini toolbar directory.  
Typical location:  
C:\Users\<you>\Documents\houdini21.0\toolbar  
After placing the file in that folder, restart Houdini and the shelf will appear.

3. HDA Install  
Simply double-click on the HDA file and it should load directly to assets in Houdini.
(Make sure Houdini is installed on your computer, otherwise you WILL receive an error message)

## Uninstalling the Tool

If you installed the tool in your Documents Houdini folder:  
You can remove it in one of two ways:

- While Houdini is running:  
  Delete the shelf tab directly from the toolbar menu at the top of the interface.

- Outside Houdini:  
  Delete the entire “toolbar” folder located at:  
  C:\Users\<you>\Documents\houdini21.0\toolbar  
  Houdini will automatically recreate a clean toolbar folder the next time it starts.

If you installed the shelf file into Program Files:  
Some users place shelf files inside Houdini’s installation directory. If you did this:

- Delete only the ArtProofTool.shelf file from the Program Files toolbar directory.  
- Then delete the Documents\houdini21.0\toolbar folder as well so Houdini can rebuild it cleanly the next time it launches.

  
## SHAPE OPTIONS

- Sphere

- Box

- Torus

- Grid

- Tube

## DEFORM OPTIONS

- Fractal

- Mountain


**After creating your desired shape, click the 'Export FBX' button to automatically export the geometry onto your desktop. You can then drag the FBX file into Maya, Unreal, etc.
