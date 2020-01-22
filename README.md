# Analysis

## Work flow
* GLM
1. DICOM2NIFTI, distortion correction and motion correction (`u*.m`), smooth (`s*.m`)
1. 1st level GLM (`Gx_y`; also need: `create_mat`, `eMask`)
1. Warp structural images to MNI152
1. Warp beta files to MNI152: `group_wbeta.m` and `group_mean_beta.m`
1. 2nd level GLM: `GLM/group_1T.m`
1. Warp atlas to individual mean image (`group_roi`, `inv_normalise`), MVPA

* MVPA
1. group_norm_other
1. group_set_nan (followed by group_0_center for one-sample t-test)
1. group_mean
1. group_value (check distribution)

## for SPM.mat
`build_con` loop thru subjects and build basic contrasts (beta - 0) based on spmT.mat  
`query_con` query contrast number by event name; need to load SPM.mat before function call

## for multiple-condition mat files
shift_mat, , merge_ev, report_short, rm_x

## for nifti files
group_4D

## Bash
`myren.sh` rename files in a folder by replacing substring1 with substring2; need to add path of it before use

## Reference
[atlas.md](https://github.com/ywwang-notes/Analysis/blob/master/atlas.md)

## Keep a record of what I consulted
* [extract time series](https://en.wikibooks.org/wiki/SPM/Timeseries_extraction)

