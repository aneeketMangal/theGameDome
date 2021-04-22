from os import listdir
from os.path import isfile, join
onlyfiles = [f[:-4] for f in listdir("C:/Users/lenovo/Desktop/Adhoora/flutter/snake2/assets/characterIcons") if isfile(join("assets/characterIcons/", f))]
print(onlyfiles)