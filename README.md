# ICCNet-FidNet
Codes for carrying out simulation datasets for training and evaluating ICCNet and FidNet and trained final models for predictions.

## Minimum system requirements
Here is the list of required softwares to run all codes:
* MATLAB
* CVX package available at http://cvxr.com/cvx/download/
* MATLAB files for maximum-likelihood estimation found at https://github.com/qMLE/qMLE
* Python version 3.5.3
* Jupyter
* Tensorflow version 1.9
* Keras version 2.1.6
* All other python packages stated in the Python Jupyter notebooks.

## Instructions to generate trained ICCNet and FidNet model files and plot results
### Preparation
1. Download the whole package by clicking [Download ZIP](https://github.com/ACAD-repo/ICCNet-FidNet/archive/main.zip) and extract it to any directory. (\*Do not alter the subdirectories.\*)
2. Extract all files downloaded from https://github.com/qMLE/qMLE into the `MATLAB` subdirectory. They execute maximum-likelihood procedures very quickly using projected-gradient methods.
3. Ensure that the MATLAB CVX package is properly installed and set to PATH. We need this to run semidefinite programs.

### MATLAB runs
5. Run `train_ex_gen.m` with MATLAB and generate raw training examples in the folder `/raw_training_examples/` for all four data types: `train_ex_Haar`, `train_ex_Haar_N_1000`, `train_ex_ACT` and `train_ex_ACT_N_1000`.
6. Run the MATLAB code files `raw2X_right.m` and `raw2X_wrong.m`. These generate packaged input matrices `X_*.mat` and output matrices `y_*.mat` for the "right" target states and "wrong" target states, as indicated by the wildcard.
7. Run the MATLAB code file `right_wrong_combine.m` to combine the input and output array files from both the "right" and "wrong" target states. Since these files encode all information (including the <img src="https://render.githubusercontent.com/render/math?math=s_\textsc{cvx}"> and <img src="https://render.githubusercontent.com/render/math?math=\mathcal{F}"> values), they can be used to train ICCNet and FidNet with Python.

### Python runs
8. Run `ICCNet_trainer.ipynb` to train ICCNet. All trained model files will be stored in `/training/*_perf_noisy_ex/ICCNet_trained_files/`.
9. Run `FidNet_trainer.ipynb` to train FidNet. All trained model files will be stored in `/training/*_perf_noisy_ex/FidNet_trained_files/`.
10. Execute `Net_evaluator.ipynb` to carry out predictions with the test datasets found in `/raw_test_examples/` and plot the results.

## Sample results
Due to space constraints, only the final ICCNet and FidNet prediction results are included in this package. These comprise 16 files:
8 files for ICCNet 
`/training/*_perf_noisy_ex/ICCNet_trained_files/model_ICCNet_scvx_*.mat`
`*_perf_noisy_ex/ICCNet_trained_files/model_ICCNet_scvx_pred_*.mat`
and 8 for FidNet 
`/training/*_perf_noisy_ex/FidNet_trained_files/model_FidNet_fid_*.mat`
`*_perf_noisy_ex/FidNet_trained_files/model_FidNet_fid_pred_*.mat`
