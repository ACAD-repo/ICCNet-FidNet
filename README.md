# ICCNet-FidNet
Codes for carrying out simulation datasets for training and evaluating ICCNet and FidNet and trained final models for predictions.

## System requirements
Here is the list of required softwares to run all codes:
* MATLAB
* CVX package available at http://cvxr.com/cvx/download/
* MATLAB files for maximum-likelihood estimation found at https://github.com/qMLE/qMLE
* Python version 3.5.3
* Jupyter
* Tensorflow version 1.9
* Keras version 2.1.6
* All other python packages stated in the Python Jupyter notebooks.

## Package content
* `/MATLAB/`: contains MATLAB code files and functions
* `/Python/`: contains Python Jupyter notebooks
* `/training/8000_perf_noisy_ex/`: contains test and neural-network-predicted array files

## Instructions to generate trained ICCNet and FidNet model files and plot results
### Preparation
1. Download the whole package by clicking [Download ZIP](https://github.com/ACAD-repo/ICCNet-FidNet/archive/main.zip) and extract it to any directory. (\*Do not alter the subdirectories.\*)
2. Extract all files downloaded from https://github.com/qMLE/qMLE into the `MATLAB` subdirectory. They execute maximum-likelihood procedures very quickly using projected-gradient methods.
3. Ensure that the MATLAB CVX package is properly installed and set to PATH. We need this to run semidefinite programs.

### MATLAB runs
#### Generate training examples
4. Run `train_ex_gen.m` with MATLAB and generate raw training examples in the directory `/raw_training_examples/train_ex_*/D16/raw_data/` for all four data types `*`: `Haar`, `Haar_N_1000`, `ACT` and `ACT_N_1000`.
5. Run the MATLAB code files `raw2X_right.m` and `raw2X_wrong.m`. These generate packaged input matrices `X_right_*.mat`/`X_wrong_*.mat` and output matrices `y_cont_right_*.mat`/`y_cont_wrong_*.mat` for the "right" target states and "wrong" target states, which are located in the directory `/training/*_perf_noisy_ex/`.
6. Run the MATLAB code file `right_wrong_combine.m` to combine the input and output array files from both the "right" and "wrong" target states. These combined files will be used to train ICCNet and FidNet with Python, and are stored in `/training/*_perf_noisy_ex/`.
#### Generate test examples
7. Run `test_ex_gen.m` with MATLAB and generate raw testing examples in the directory `/raw_testing_examples/D16/raw_data/` for all four data types and state ranks between 1 and 3.
8. Run `raw2X_test.m` to generate the corresponding processed input and output files.

### Python runs
9. Run `ICCNet_trainer.ipynb` to train ICCNet. All trained model files will be stored in `/training/*_perf_noisy_ex/ICCNet_trained_files/`.
10. Run `FidNet_trainer.ipynb` to train FidNet. All trained model files will be stored in `/training/*_perf_noisy_ex/FidNet_trained_files/`.
11. Execute `Net_evaluator.ipynb` to carry out predictions with the trained model files on test datasets found in `/raw_test_examples/` and plots the results.

## Sample results
Due to space constraints, only the final ICCNet and FidNet prediction results are included in this package. These comprise 16 files:

8 files for ICCNet 

`/training/*_perf_noisy_ex/ICCNet_trained_files/model_ICCNet_scvx_*.mat`

`/training/*_perf_noisy_ex/ICCNet_trained_files/model_ICCNet_scvx_pred_*.mat`

and 8 for FidNet 

`/training/*_perf_noisy_ex/FidNet_trained_files/model_FidNet_fid_*.mat`

`/training/*_perf_noisy_ex/FidNet_trained_files/model_FidNet_fid_pred_*.mat`

## License
GNU General Public License v3.0

Copyright (c) 2021 Yong Siah Teo, Seongwook Shin, Hyunseok Jeong, Yosep Kim, Yoon-Ho Kim, Gleb I. Struchalin, Egor V. Kovlakov, Stanislav S. Straupe, Sergei P. Kulik, Gerd Leuchs, and Luis L. Sánchez-Soto

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
