import pymunk
import math

PROJECTILE = 1
TARGET = 2
KILL = 3
GROUND = 4

class PhysicsSimulation:

    def __init__(self, screen_height):
        self.space = None
        self.screenHeight = screen_height
        self.body = None
        self.shape = None

    def reset_space(self):
        self.space = pymunk.Space()
        self.space.gravity = (0, -981) # pixels per second²
        self.setup_collision_handlers()

    def on_target_hit(self, space, data):
        print("You reached the goal!")
        return True

    def on_kill_hit(self, space, data):
        print("You hit the kill box!")
        return True

    def add_static_box(self, box, collision_type):
        pass #do funny hit box creation here


    def setup_collision_handlers(self):
        handler = self.space.add_collision_handler(PROJECTILE, TARGET)
        handler.begin = self.on_target_hit

        handler = self.space.add_collision_handler(PROJECTILE, KILL)
        handler.begin = self.on_kill_hit

    def build_level(self, level_data):
        for box in level_data["collisionBoxes"]:
            self.add_static_box(box,GROUND)
        for box in level_data["targets"]:
            self.add_static_box(box, TARGET)

        for box in level_data["killZones"]:
            self.add_static_box(box, KILL)

    def start(self, velocity, angle_deg):
        angle = math.radians(180-angle_deg)
        print("Angle:", angle)
        #make da projectile instance
        mass = 10
        radius = 5
        moment = pymunk.moment_for_circle(mass, 0, radius, (0,0))
        self.body = pymunk.Body(mass, moment)
        self.body.position = (100, 100)

        #me when trig is real
        velocityX = velocity * math.cos(angle)
        velocityY = velocity * math.sin(angle)

        self.body.velocity = (velocityX, velocityY)

        self.shape = pymunk.Circle(self.body, radius)
        self.space.add(self.body, self.shape)

    def step(self, delta_time):
        self.space.step(delta_time)
        print(self.body.position, delta_time)
        return self.body.position


