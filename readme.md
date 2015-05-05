## about

Converts mol/sdf into a gspan dataset. Assigns targets from target file to graphs.

## instructions

* To convert your sdf files and label file into a gspan dataset run: `sdf2gsp.pl <path to sdf files> <sdf file list in correct label order>
  <targets file>`
  - path to sdf files: Is an absolute path to the folder containing the
    sdf/mol files
  - sdf file list in correct label order: The list of the sdf/mol files in
    the order that also the labels are ordered
  - targets file: the file with the 1-dim targets

  
Further scripts:

* If you have a multilabel target file, first run `get_dim_x_from_labels.sh <dimension> <multi-dim target file>`. This extracts one dimension from every line from a multi-dim target file.
* `split_dataset.pl <training samples>` splits a gspan dataset. The training data set has an amount of samples given as argument and the rest of the samples  will go into the test set.  
* `sdf2gsp_nolabels.pl <path to sdf files>` will convert the dataset into gspan without labels (it will simply add a graph id) 
* `sdf2gsp_randomlabels.pl <path to sdf files>` will convert the dataset into gspan and randomly label each graph with either 1 or -1