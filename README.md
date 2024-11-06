# lfc-downloader

## Overview
`lfc-downloader` is a script to download video episodes and their corresponding subtitles from a predefined list of series and episodes. The script uses `ffmpeg` to download videos and `jq` to parse JSON data.

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