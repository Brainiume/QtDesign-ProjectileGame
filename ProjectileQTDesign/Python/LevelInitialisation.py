import json
import os

import pymunk

class LevelInitialisation:
    def __init__(self):
        base_dir = os.path.dirname(os.path.abspath(__file__))
        self.file_path = os.path.join(base_dir, "Levels")
        self.levelfile = os.path.join(base_dir, "Levels", "level.json")

    def saveLevelDev(self, leveldata):

        data = json.loads(leveldata)

        os.makedirs(self.file_path, exist_ok=True)

        file_path = os.path.join(self.file_path, "level.json")

        with open(file_path, "w") as levelfile:
            json.dump(data, levelfile, indent=4)
        print("Level data saved", file_path)

    def load(self):
        with open(self.levelfile, "r") as f:
            return json.load(f)