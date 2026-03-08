import json
import os

import pymunk

class LevelInitialisation:
    def __init__(self):
        base_dir = os.path.dirname(os.path.abspath(__file__))
        self.file_path = os.path.join(base_dir, "Levels")
        self.levelfile = os.path.join(base_dir, "Levels", "level.json")
        self.hitboxfile = os.path.join(base_dir, "Levels", "projectileHitbox.json")

    def saveLevelDev(self, leveldata):

        data = json.loads(leveldata)

        os.makedirs(self.file_path, exist_ok=True)

        file_path = os.path.join(self.file_path, "level.json")

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


    def load(self):
        with open(self.levelfile, "r") as f:
            return json.load(f)

    def loadProjectile(self):
        with open(self.hitboxfile, "r") as f:
            return json.load(f)