import json
import os

import pymunk

class LevelInitialisation:
    def __init__(self):
        base_dir = os.path.dirname(os.path.abspath(__file__))
        self.file_path = os.path.join(base_dir, "Levels")
        self.hitboxfile = os.path.join(base_dir, "Levels", "projectileHitbox.json")
        # Register level data files in one place so adding a new level mostly
        # means adding a JSON file here and the matching QML artwork component.
        self.levels = [
            {
                "name": "Level 1",
                "file": "level1.json",
                # Level 1 keeps a gentler wind range for the opening stage.
                "wind": {
                    "horizontalMin": -70,
                    "horizontalMax": 70,
                    "verticalMin": -20,
                    "verticalMax": 0,
                },
            },
            {
                "name": "Level 2",
                "file": "level2.json",
                # Level 2 increases the wind range so the next stage feels harder.
                "wind": {
                    "horizontalMin": -110,
                    "horizontalMax": 110,
                    "verticalMin": -30,
                    "verticalMax": 0,
                },
            },
        ]

    def getLevelCount(self):
        return len(self.levels)

    def hasLevel(self, level_index):
        return 0 <= level_index < len(self.levels)

    def getLevelDefinition(self, level_index):
        if not self.hasLevel(level_index):
            raise IndexError(f"Level index out of range: {level_index}")
        return self.levels[level_index]

    def getLevelFilePath(self, level_index):
        level_definition = self.getLevelDefinition(level_index)
        return os.path.join(self.file_path, level_definition["file"])

    def getWindProfile(self, level_index):
        level_definition = self.getLevelDefinition(level_index)
        return dict(level_definition.get("wind", {}))

    def saveLevelDev(self, leveldata, level_index=0):

        data = json.loads(leveldata)

        os.makedirs(self.file_path, exist_ok=True)

        file_path = self.getLevelFilePath(level_index)

        with open(file_path, "w") as levelfile:
            json.dump(data, levelfile, indent=4)
        print("Level data saved", file_path)

    def saveProjectileHitbox(self, hitboxes):

        data = json.loads(hitboxes)

        os.makedirs(self.file_path, exist_ok=True)

        file_path = os.path.join(self.file_path, "projectileHitbox.json")

        with open(file_path, "w") as hitboxfile:
            json.dump(data, hitboxfile, indent=4)
        print("Projectile data saved", file_path)


    def load(self, level_index=0):
        with open(self.getLevelFilePath(level_index), "r") as f:
            return json.load(f)

    def loadProjectile(self):
        with open(self.hitboxfile, "r") as f:
            return json.load(f)
