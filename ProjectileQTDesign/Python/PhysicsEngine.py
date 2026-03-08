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
            local_vertices = shape.get_vertices()
            local_xs = [v.x for v in local_vertices]
            local_ys = [v.y for v in local_vertices]

            width = max(local_xs) - min(local_xs)
            height = max(local_ys) - min(local_ys)

            local_centre = pymunk.Vec2d(
                (min(local_xs) + max(local_xs)) / 2,
                (min(local_ys) + max(local_ys)) / 2,
            )
            world_centre = body.local_to_world(local_centre)

            qml_x = world_centre.x - width / 2
            qml_y = self.screenHeight - world_centre.y - height / 2

            boxes.append({
                "Rotation": -math.degrees(body.angle),
                "x": qml_x,
                "y": qml_y,
                "width": width,
                "height": height,
            })

        #print("Debug boxes:", boxes)

        return boxes

    def add_static_box(self, box, collision_type):
        print(box)
        box_size = (box["width"], box["height"])

        qml_cx = box["x"] + box["width"] / 2
        qml_cy = box["y"] + box["height"] / 2

        box_position = (qml_cx, self.screenHeight - qml_cy)
        body = pymunk.Body(body_type=pymunk.Body.STATIC)
        body.position = box_position

        shape = pymunk.Poly.create_box(body, box_size)

        if collision_type == TARGET:
            shape.sensor = True
        elif collision_type == KILL:
            shape.sensor = True

        shape.collision_type = collision_type




        shape.friction = 0.4
        self.space.add(body, shape)
        self.debug_shapes.append(shape)

    def build_level(self, level_data):

        for box in level_data["collisionBoxes"]:
            self.add_static_box(box,GROUND)
        for box in level_data["targets"]:
            self.add_static_box(box, TARGET)

        for box in level_data["killZones"]:
            self.add_static_box(box, KILL)

    def create_projectile_shape(self, hitbox_data):
        mass = 6.0
        sprite_w, sprite_h = 57.0, 142.0
        sprite_x, sprite_y = 127.0, 460.0  # QML top-left

        hitboxes = hitbox_data["hitboxes"] if isinstance(hitbox_data, dict) else hitbox_data

        moment = pymunk.moment_for_box(mass, (sprite_w, sprite_h))
        self.body = pymunk.Body(mass, moment)

        # QML (top-left, y down) -> Pymunk (center, y up)
        cx = sprite_x + sprite_w / 2.0
        cy_qml = sprite_y + sprite_h / 2.0
        cy = self.screenHeight - cy_qml
        self.body.position = (cx, cy)
        self.space.add(self.body)

        for box in hitboxes:
            w = float(box["width"])
            h = float(box["height"])
            bx = float(box["x"])
            by = float(box["y"])

            # If data is accidentally world-space, convert to sprite-local first
            if bx > sprite_w or by > sprite_h:
                bx -= sprite_x
                by -= sprite_y

            local_x = (bx + w / 2.0) - sprite_w / 2.0
            local_y = sprite_h / 2.0 - (by + h / 2.0)

            verts = [
                (local_x - w / 2.0, local_y - h / 2.0),
                (local_x + w / 2.0, local_y - h / 2.0),
                (local_x + w / 2.0, local_y + h / 2.0),
                (local_x - w / 2.0, local_y + h / 2.0),
            ]
            shape = pymunk.Poly(self.body, verts)
            shape.friction = 0.6
            shape.elasticity = 0.1
            shape.collision_type = PROJECTILE

            self.space.add(shape)
            self.debug_shapes.append(shape)


    def start(self, velocity, angle_deg):
        angle = math.radians(angle_deg)
        print("Angle:", angle)

        # Dial: 0 = left, 90 = up, 180 = right.
        velocityX = -velocity * math.cos(angle)
        velocityY = velocity * math.sin(angle)

        self.body.velocity = (velocityX, velocityY)
        self.body.angle = math.cos(angle)
        #self.shape = pymunk.Poly.create_box(self.body, size)
        #self.space.add(self.body, self.shape)

    def step(self, delta_time):
        self.space.step(delta_time)
        #print(self.body.position, delta_time)
        return self.body.position


