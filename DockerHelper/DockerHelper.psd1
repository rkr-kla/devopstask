@{
	RootModule 		= 'DockerHelper.psm1' 
	ModuleVersion 		= '0.0.1' 
	CompatiblePSEditions 	= 'Desktop', 'Core' 
	GUID 			= 'fc18a919-f4ba-4da2-8c76-24b68fa31ef0' 
	Author 			= 'Robert Krueger' 
	CompanyName 		= 'none' 
	Copyright 		= '(c) Robert Krueger. All rights reserved.' 
	Description 		= 'DockerHelper'
	FunctionsToExport 	= 'CopyPrerequisites','BuildImage','RunContainer' 
	CmdletsToExport 	= @() 
	VariablesToExport 	= @() 
	AliasesToExport 	= @() 
	PrivateData 		= @{
	PSData 			= @{} 
	} 
}
