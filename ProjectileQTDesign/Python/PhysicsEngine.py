import pymunk
import math

class PhysicsSimulation:

    def __init__(self):
        self.space = pymunk.Space()
        self.space.gravity = (0, -981)  # pixels per second²

        self.body = None
        self.shape = None

    def BeginSimulation(self, velocity, angle, gravity_deg):
        angle = math.radians(gravity_deg)
        #make da projectile instance
        mass = 1
        radius = 5
        moment = pymunk.moment_for_circle(mass, 0, radius)
        self.body = pymunk.Body()
        self.body.position = (100, 100)

        #me when trig is real
        VelocityX = velocity * math.cos(angle)
        VelocityY = velocity * math.sin(angle)
