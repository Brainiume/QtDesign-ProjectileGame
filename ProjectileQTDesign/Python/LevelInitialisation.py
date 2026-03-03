import json
import pymunk

class LevelInitialisation:
    def __init__(self, file_path):
        self.file_path = file_path


    def load(self):
        with open(self.file_path, "r") as f:
            return json.load(f)