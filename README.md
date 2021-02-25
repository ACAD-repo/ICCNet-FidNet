# ICCNet-FidNet
Codes for carrying out simulation datasets for training and evaluating ICCNet and FidNet and trained final models for predictions.

## Minimum system requirements
Here is the list of required softwares to run all codes:
* MATLAB
* CVX package available at http://cvxr.com/cvx/download/, properly set up to PATH
* MATLAB files for maximum-likelihood estimation found at https://github.com/qMLE/qMLE
* Python version 3.5.3
* Tensorflow version 1.9
* Keras version 2.1.6

## Instructions to generate trained ICCNet and FidNet model files
1. Download the whole package by clicking [Download ZIP](https://github.com/ACAD-repo/ICCNet-FidNet/archive/main.zip) and extract it to any directory. (\*Do not alter the subdirectories.\*)
2. Extract all files downloaded from https://github.com/qMLE/qMLE into the `MATLAB` subdirectory.
3. Run `train_ex_gen.m` with MATLAB and generate raw training examples in the folder `/raw_training_examples/` for all four data types: `train_ex_Haar`, `train_ex_Haar_N_1000`, `train_ex_ACT` and `train_ex_ACT_N_1000`.
4. Run the MATLAB code files `raw2X_right.m` and `raw2X_wrong.m`. These generate packaged input matrices `X_*` and output matrices `y_*` for the right target states and wrong target states, as indicated by the wildcard.
