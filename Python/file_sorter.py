import os, shutil

path = "D:\\BootCamp\\Python\\5\\Sorting\\"
file_name = os.listdir(path)
folder_name = ["xlsx_files","image_files","pdf_files"]

for folder in folder_name:
    if (not os.path.exists(path + folder)):
        os.makedirs(path + folder)
        print(folder, " folder created!")
    else:
        print(folder, " folder already exists!")

for file in file_name:
    if ".xlsx" in file and not os.path.exists(path + "xlsx_files\\" + file):
        shutil.move(path + file, path + "xlsx_files\\" + file)
    elif (".png" in file or ".jpg" in file) and not os.path.exists(path + "image_files\\" + file):
        shutil.move(path + file, path + "image_files\\" + file)
    elif ".pdf" in file and not os.path.exists(path + "pdf_files\\" + file):
        shutil.move(path + file, path + "pdf_files\\" + file)
    else:
        print(file, " file not moved!")