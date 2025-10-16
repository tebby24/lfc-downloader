# lfc-downloader

## Overview
`lfc-downloader` is a script to download video and subtitles from Little Fox Chinese. It uses `ffmpeg` to download videos and `jq` to parse JSON data. The script doesn't actually do any scraping, as all the relevant urls and subtitle files have already been scraped and placed into `/data`.

## Dependencies
- `ffmpeg`
- `jq`

## Installation

### Clone the Repository
```sh
git clone https://github.com/tebby24/lfc-downloader.git
```
```sh
cd lfc-downloader
```

## Usage

### Running the Script
```sh
bash lfc_downloader.sh
```

### Instructions
1. **Select Series**: The script will display a list of available series. Enter the number corresponding to the series you want to download.
2. **Select Episodes**: You will be prompted to enter the episode numbers to download. You can specify individual episodes (e.g., `1`), a comma-separated list (e.g., `1,3,5`), a range (e.g., `1-3`), or leave it blank to download all episodes.
3. **Select Output Directory**: You will be prompted to enter the output directory where the downloaded episodes will be saved. If you leave it blank, the default directory will be `~/Downloads`.

The script will then download the selected episodes and their corresponding subtitles (if available) to the specified output directory.
