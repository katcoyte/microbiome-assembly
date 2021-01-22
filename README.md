# microbiome-assembly
Code associated with "Ecological rules for the assembly of microbiome communities"

"microbiome_assembly_main.m" solves community assembly dynamics for a range of community types (e.g. level of cooperation, interaction strength) in accordance with a variety of assembly processes (e.g. multiple species arrivals). The parameter spaces used in our analyses are defined within the code, to explore other areas of parameter space simply change these at the start of the code (Section, "Set up simulation") and hit run.

Should you wish to build the assembly map for a single predefined community (defined by an interaction matrix M and intrinsic growth vector mu) following a specified assembly processes, feed your parameters into the function single_assembly_run.m. Note, when using your own community, parameters for initial community creation (e.g. Pm/C) or already analysed communities (e.g. all_communities) can be left blank ([]).

Raw data associated with each figure can be found in raw_data_and_code_for_figures folder, to generate figures run corresponding .m or .ipynb files.  
