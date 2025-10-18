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
Run the script and follow the prompts

- Series selection: enter numbers using a single (`1`), comma list (`1,3,5`), range (`1-3`), or leave blank to select all series.
	- If you select exactly one series, you'll be prompted to choose episodes (same syntax).
	- If you select multiple series (or leave blank), the script downloads all episodes for each selected series.
- Output directory: enter a path or press Enter to use the default `~/Downloads/lfc`.

Files are saved like:

```
~/Downloads/lfc/{series}/{episode_title}/{episode_title}.mp4
~/Downloads/lfc/{series}/{episode_title}/{episode_title}.srt 
```
