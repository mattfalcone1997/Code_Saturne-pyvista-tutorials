# Pyvista tutorials
This folder contains tutorials for using `pyvista` with Code_Saturne. Tutorials use Jupyter notebooks which can be opened with text editors such as Visual Studio Code or JupyterLab. The tutorials can be run using the conda environment in the `.yml` file. If there are any issues feel free to raise an issue on this repository.

## Using Conda 
### Creating conda environment
Using Linux, if you have Anaconda or Miniconda installed run using

```
conda env create -f environment.yml
```

### Loading conda environment

```
conda activate pyvista_test
```

### Running JupyterLab
To run JupyterLab use the command
```
jupyter-lab
```

## Code_Saturne case
### Getting the case data
A python script is given `get_data.py` which downloads the data from my [Google drive](https://drive.google.com/file/d/11E0jUjsIMr1pehkZMr3Qt2wacMgO82g4/view?usp=drive_link). It then checks the `sha256sum` of the zip file and then unzips it. The zip file is then removed. The Python script should be executed from this directory.

### Information about the case setup
The input `setup.xml` file and src directory from the Results directory are presented in the directory `case'

### Post-processing data
The ```.case``` files and associated data are located in the directory `case/postprocessing'

## Jupyter Notebooks
These have the file extension `.ipynb`

## Bash script to install VTK Python from source.
This can be executed using
```
./bash_wheel.sh
```
This downloads and installs VTK with OpenMP threading activated. The VTK version and Python executable path must be specified in the file's preamble. If the script is exited during the VTK download or unpacking it is likely best to delete them with 
```
rm -r VTK-*
```


