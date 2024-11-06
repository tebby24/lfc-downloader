# lfc-downloader

## Overview
`lfc-downloader` is a script to download video and subtitles from Little Fox Chinese. The script uses `ffmpeg` to download videos and `jq` to parse JSON data.

## Dependencies
- `ffmpeg`
- `jq`

## Installation

### Clone the Repository
First, clone the repository to your local machine:
```sh
git clone <repository-url>
cd <repository-directory>
```

### Install Dependencies
Ensure that `ffmpeg` and `jq` are installed on your system. You can install them using the following commands:

#### On Ubuntu/Debian:
```sh
sudo apt-get update
sudo apt-get install ffmpeg jq
```

#### On macOS (using Homebrew):
```sh
brew install ffmpeg jq
```

#### On Windows:

1. **Install `ffmpeg`:**
   - Download the latest version of `ffmpeg` from the [official website](https://ffmpeg.org/download.html).
   - Extract the downloaded ZIP file to a folder of your choice (e.g., `C:\ffmpeg`).
   - Add `ffmpeg` to your PATH:
     - Open the Start menu, search for "Environment Variables," and select "Edit the system environment variables."
     - In the System Properties window, click "Environment Variables."
     - Under "System variables," find and select the `Path` variable, then click "Edit."
     - Click "New" and add the path to the `bin` folder within your `ffmpeg` folder (e.g., `C:\ffmpeg\bin`).
     - Click "OK" on all windows to apply changes.

2. **Install `jq`:**
   - Download the `jq` executable for Windows from the [official GitHub repository](https://github.com/stedolan/jq/releases).
   - Rename the downloaded file to `jq.exe` and move it to a folder of your choice (e.g., `C:\jq`).
   - Add `jq` to your PATH:
     - Repeat the same steps as above, adding the path to the folder where `jq.exe` is located (e.g., `C:\jq`).

After setting up `ffmpeg` and `jq`, you can verify the installations by opening a new Command Prompt and running:
```sh
ffmpeg -version
jq --version
```

## Usage

### Running the Script
To run the script, use the following command:
```sh
bash lfc_downloader.sh
```

### Instructions
1. **Select Series**: The script will display a list of available series. Enter the number corresponding to the series you want to download.
2. **Select Episodes**: You will be prompted to enter the episode numbers to download. You can specify individual episodes (e.g., `1`), a comma-separated list (e.g., `1,3,5`), a range (e.g., `1-3`), or leave it blank to download all episodes.
3. **Select Output Directory**: You will be prompted to enter the output directory where the downloaded episodes will be saved. If you leave it blank, the default directory will be `~/Downloads`.

The script will then download the selected episodes and their corresponding subtitles (if available) to the specified output directory.