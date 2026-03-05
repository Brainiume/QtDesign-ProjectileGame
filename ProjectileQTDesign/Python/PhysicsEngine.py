import pymunk
import math

from pymunk import body

PROJECTILE = 1
TARGET = 2
KILL = 3
GROUND = 4

class PhysicsSimulation:

    def __init__(self):
        self.space = None
        #self.screenHeight = screen_height
        self.body = None
        self.shape = None
        self.reset_space()
        self.screenHeight = 832
        self.debug_shapes = []


    def reset_space(self):
        self.space = pymunk.Space()
        self.space.gravity = (0, -981) # pixels per second²
        self.debug_shapes = []

        self.space.on_collision(
            PROJECTILE,
            TARGET,
            begin=self.on_target_hit
        )

        self.space.on_collision(
            PROJECTILE,
            KILL,
            begin=self.on_kill_hit
        )


    def on_target_hit(self, arbiter, space, data):
        print("You reached the goal!")
        return True

    def on_kill_hit(self, arbiter, space, data):
        print("You hit the kill box!")
        return True

    def get_debug_boxes(self):

        boxes = []

        for shape in self.debug_shapes:

            body = shape.body
            vertices = shape.get_vertices()

            points = [body.local_to_world(v) for v in vertices]

            xs = [p.x for p in points]
            ys = [p.y for p in points]

            boxes.append({
                "Rotation": body.angle,
                "x": min(xs),
                "y": min(ys),
                "width": max(xs) - min(xs),
                "height": max(ys) - min(ys),
            })

        #print("Debug boxes:", boxes)

        return boxes

    def add_static_box(self, box, collision_type):
        print(box)
        if collision_type == GROUND:
            box_size = (box["width"], box["height"])


            y = box["y"] + box["height"] / 2
            x = box["x"] + box["width"] / 2

            box_position = (x, y)
            body = pymunk.Body(body_type=pymunk.Body.STATIC)
            body.position = box_position

            shape = pymunk.Poly.create_box(body, box_size)
            shape.collision_type = collision_type
            shape.friction = 1
            self.space.add(body, shape)
            print("Ground Box created")
            print(box_position)

            verts = [shape.body.local_to_world(v) for v in shape.get_vertices()]
            print("Pymunk box verts:", [(round(v.x, 1), round(v.y, 1)) for v in verts])
            print("Body centre:", shape.body.position)
            self.debug_shapes.append(shape)

    def build_level(self, level_data):

        for box in level_data["collisionBoxes"]:
            self.add_static_box(box,GROUND)
        for box in level_data["targets"]:
            self.add_static_box(box, TARGET)

        for box in level_data["killZones"]:
            self.add_static_box(box, KILL)

    def start(self, velocity, angle_deg):
        angle = math.radians(angle_deg)
        print("Angle:", angle)
        #make da projectile instance
        mass = 10
        size = (57, 142)

        moment = pymunk.moment_for_box(mass, size)
        self.body = pymunk.Body(mass, moment)
        self.body.position = (127, 447)


        #me when trig is real
        velocityX = velocity * math.cos(angle)
        velocityY = velocity * math.sin(angle)


        self.body.velocity = (velocityX, velocityY)
        size = (57, 142)
        self.shape = pymunk.Poly.create_box(self.body, size)

        self.shape.friction = 0.6
        self.shape.elasticity = 0.1

        self.shape.collision_type = PROJECTILE

        self.debug_shapes.append(self.shape)
        self.space.add(self.body, self.shape)

    def step(self, delta_time):
        self.space.step(delta_time)
        #print(self.body.position, delta_time)
        return self.body.position


