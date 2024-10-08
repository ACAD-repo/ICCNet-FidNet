# ICCNet-FidNet
Package containing sample codes in MATLAB and Python for generating simulation datasets, training and evaluating ICCNet and FidNet, which are the two neural networks used for benchmarking quantum tomography completeness of measurements and fidelity of unknown quantum states. Details in Y. S. Teo *et al.*, New J. Phys. **23** 103021 (2021).

## System requirements
Here is the list of required softwares to run all codes:
* MATLAB
* CVX package available at http://cvxr.com/cvx/download/
* MATLAB files for maximum-likelihood estimation found at https://github.com/qMLE/qMLE
* Python version 3.5.3
* Jupyter
* Tensorflow version 1.9
* Keras version 2.1.6
* All other python packages stated in the Python Jupyter notebooks
* Recommended minimum disk space of 4GB

## Package content
* `/MATLAB/`: contains MATLAB code files and functions
* `/Python/`: contains Python Jupyter notebooks
* `/training/8000_perf_noisy_ex/`: contains test and neural-network-predicted array files, obtained from 2000 training datasets for each data type as sample examples.

## Related article
* Yong Siah Teo, Seongwook Shin, Hyunseok Jeong, Yosep Kim, Yoon-Ho Kim, Gleb I. Struchalin, Egor V. Kovlakov, Stanislav S. Straupe, Sergei P. Kulik, Gerd Leuchs, Luis L. Sanchez-Soto, _Benchmarking quantum tomography completeness and fidelity with machine learning_, https://arxiv.org/abs/2103.01535

## Instructions to generate trained ICCNet and FidNet model files and plot results
### Preparation
1. Download the whole package by clicking [Download ZIP](https://github.com/ACAD-repo/ICCNet-FidNet/archive/main.zip) and extract it to any directory. __(Do not alter the subdirectories.)__
2. Extract all files downloaded from https://github.com/qMLE/qMLE into the `MATLAB` subdirectory. They execute maximum-likelihood procedures very quickly using projected-gradient methods.
3. Ensure that the MATLAB CVX package is properly installed and set to PATH. We need this to run semidefinite programs.

### MATLAB runs
#### Generate training examples
4. Run `train_ex_gen.m` with MATLAB and generate raw training examples in the directory `/raw_training_examples/train_ex_*/D16/raw_data/` for all four data types `*`: `Haar`, `Haar_N_1000`, `ACT` and `ACT_N_1000`.
5. Run `raw2X_train.m` to generate packaged input `X_*.mat` and output matrices `y_*.mat`, which are located in the directory `/training/*_perf_noisy_ex/`. These files will be used to train ICCNet and FidNet on Python.
#### Generate test examples
6. Run `test_ex_gen.m` with MATLAB and generate raw testing examples in the directory `/raw_test_examples/D16/raw_data/` for all four data types and state ranks between 1 and 3.
7. Run `raw2X_test.m` to generate the corresponding processed input and output files.

### Python runs
8. Run `ICCNet_trainer.ipynb` to train ICCNet. All trained model files will be stored in `/training/*_perf_noisy_ex/ICCNet_trained_files/`.
9. Run `FidNet_trainer.ipynb` to train FidNet. All trained model files will be stored in `/training/*_perf_noisy_ex/FidNet_trained_files/`.
10. Execute `Net_evaluator.ipynb` to carry out predictions with the trained model files on test datasets found in `/raw_test_examples/` and plots the results.

## Sample results
Due to space constraints, only the final ICCNet and FidNet prediction results are included in this package as MATLAB MAT files. These files are generated from pre-trained neural-network models created with 2000 training datasets per data type, which are fewer than those used in the related article. They comprise 16 files:

8 files for ICCNet 

`/training/8000_perf_noisy_ex/ICCNet_trained_files/model_ICCNet_scvx_*.mat`

`/training/8000_perf_noisy_ex/ICCNet_trained_files/model_ICCNet_scvx_pred_*.mat`

and 8 for FidNet 

`/training/8000_perf_noisy_ex/FidNet_trained_files/model_FidNet_fid_*.mat`

`/training/8000_perf_noisy_ex/FidNet_trained_files/model_FidNet_fid_pred_*.mat`

While better results can be obtained with more training datasets, as a preview, some important results are shown regarding the training and evaluation of ICCNet and FidNet based on the aforementioned included files:

__Training and validation of ICCNet and FidNet__

<img src="/training/Fig_ICCNet_FidNet_train_val.png" alt="Click to enlarge picture" width="768" height="auto">

__Performances for random Haar measurement bases__

<img src="/training/Fig_Haar_perf_noisy.png" alt="Click to enlarge picture" width="640" height="auto">

__Performance for adaptive-compressive-tomography (ACT) measurement bases__

<img src="/training/Fig_ACT_perf_noisy.png" alt="Click to enlarge picture" width="640" height="auto">
