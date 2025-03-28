import os

def rename_files_in_folder(folder_path):
    try:
        for filename in os.listdir(folder_path):
            old_path = os.path.join(folder_path, filename)
            if os.path.isfile(old_path):  # Check if it's a file
                new_filename = filename.lower().replace(".pnt", ".png").replace("@3x", "")
                new_path = os.path.join(folder_path, new_filename)
                os.rename(old_path, new_path)
                print(f'Renamed: {filename} -> {new_filename}')
    except Exception as e:
        print(f'Error: {e}')


# Example usage
folder = "/Users/jimmywang/Desktop/icons"  # Change this to your target folder path
rename_files_in_folder(folder)