import os
import re
import random
from pathlib import Path
from datetime import datetime

def process_single_md(md_path):
    md_path = Path(md_path)
    if not md_path.is_file():
        print(f"{md_path} is not a valid file.")
        return

    folder_name = md_path.stem
    folder_path = md_path.parent / folder_name
    if folder_path.is_dir():
        images = list(folder_path.glob('*'))
        if images:
            last_image = sorted(images, key=os.path.getmtime)[-1].name
            date_str = md_path.stem.split('-')
            year, month, day = date_str[0], date_str[1], date_str[2]
            cover_text = f"cover: /{year}/{month}/{day}/{folder_name}/{last_image}"
            thumbnail_text = f"thumbnail: /{year}/{month}/{day}/{folder_name}/{last_image}"
            update_md_file(md_path, cover_text, thumbnail_text)
    else:
        random_index = random.randint(1, 5)
        cover_text = f"cover: /gallery/defaultCover{random_index}.png"
        thumbnail_text = f"thumbnail: /gallery/defaultThumbnail{random_index}.png"
        update_md_file(md_path, cover_text, thumbnail_text)

def process_directory(directory):
    directory = Path(directory)
    if not directory.is_dir():
        print(f"{directory} is not a valid directory.")
        return

    md_files = list(directory.glob('*.md'))
    for md_file in md_files:
        process_single_md(md_file)

def update_md_file(md_path, cover_text, thumbnail_text):
    with open(md_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    with open(md_path, 'w', encoding='utf-8') as file:
        skip_line = False
        for i, line in enumerate(lines):
            if skip_line:
                skip_line = False
                continue

            if line.startswith("header-img: 'img/post-bg-2015.jpg'"):
                file.write(cover_text + '\n')
                file.write(thumbnail_text + '\n')
            elif line.startswith("date:"):
                date_str = line[len("date: "):].strip()
                if '-' in date_str and ':' not in date_str:
                    date_str = datetime.strptime(date_str, '%Y-%m-%d-%H-%M-%S').strftime('%Y-%m-%d %H:%M:%S')
                    file.write(f"date: {date_str}\n")
                else:
                    file.write(f"date: {date_str}\n")
            elif line.startswith("# "):
                file.write(line)
                if i + 1 < len(lines) and '-' in lines[i + 1] and lines[i + 1].count('-') > 5:
                    skip_line = True
            else:
                corrected_line = correct_header_level(line)
                file.write(corrected_line)
                

def correct_header_level(line):
    match = re.match(r'^(#{2,6})\s+#\s+(.*)', line)
    if match:
        header_level = len(match.group(1))
        corrected_level = max(1, header_level - 2)
        return f"{'#' * corrected_level} {match.group(2)}\n"
    return line

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Process .md files in a directory or a single .md file.")
    parser.add_argument('path', type=str, help="Path to directory or single .md file")

    args = parser.parse_args()
    path = Path(args.path)

    if path.is_file():
        process_single_md(path)
    elif path.is_dir():
        process_directory(path)
    else:
        print(f"{path} is not a valid file or directory.")
