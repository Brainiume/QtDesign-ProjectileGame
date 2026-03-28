import pymunk
import math
import random

from pymunk.vec2d import Vec2d


PROJECTILE = 1
TARGET = 2
KILL = 3
GROUND = 4
PIXELS_PER_METER = 100.0
PROJECTILE_WIDTH = 57.0
PROJECTILE_HEIGHT = 142.0
PROJECTILE_START_X = 127.0
PROJECTILE_START_Y = 460.0

class PhysicsSimulation:

    def __init__(self, controller):
        self.wind_force = Vec2d(0.0, 0.0)
        self.space = None
        #self.screenHeight = screen_height
        self.controller = controller
        self.body = None
        self.shape = None
        self.run_completed = False
        self.run_completion_reason = ""
        self.target_drop_active = False
        self.reset_space()
        self.screenHeight = 832
        self.debug_shapes = []

        self.initial_state = {
            "wind_force": Vec2d(0.0, 0.0),
            "projectile_position_pymunk": (100, 500),
            "projectile_position_qml": (PROJECTILE_START_X, PROJECTILE_START_Y),
            "projectile_angle_deg": 90.0,
        }



    def reset_space(self):
        self.space = pymunk.Space()
        self.space.gravity = (0, -981) # pixels per second²
        self.space.damping = 0.9
        self.debug_shapes = []
        self.clear_run_state()
        self.create_wind(self.wind_force)


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
    def reset(self):
        self.space = None
        self.body = None
        self.shape = None
        self.reset_space()
        self.debug_shapes = []

    def clear_run_state(self):
        # Reset all per-attempt collision/drop state for the next launch.
        self.run_completed = False
        self.run_completion_reason = ""
        self.target_drop_active = False

    def clear_completion_event(self):
        # Clear the one-shot completion event after the controller has handled it.
        self.run_completed = False
        self.run_completion_reason = ""

    def mark_run_complete(self, reason):
        if self.run_completed:
            return
        self.run_completed = True
        self.run_completion_reason = reason

    def begin_target_drop(self):
        if self.body is None:
            return

        # Freeze horizontal travel immediately after the target hit so gravity
        # can pull the projectile straight down to the flag base.
        self.target_drop_active = True
        self.body.velocity = (0.0, min(0.0, self.body.velocity.y))
        self.body.angular_velocity = 0.0

    def apply_target_drop_constraints(self):
        if not self.target_drop_active or self.body is None:
            return

        # Wind still runs globally, so clamp horizontal velocity every frame
        # while the projectile is in the post-hit drop state.
        self.body.velocity = (0.0, self.body.velocity.y)
        self.body.angular_velocity = 0.0





        

    def on_target_hit(self, arbiter, space, data):
        print("You reached the goal!")
        self.mark_run_complete("target")
        return True

    def on_kill_hit(self, arbiter, space, data):
        print("You hit the kill box!")
        self.mark_run_complete("kill")
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




        shape.friction = 1
        self.space.add(body, shape)
        self.debug_shapes.append(shape)

    def create_wind(self, WindForce):
        if WindForce == Vec2d(0.0, 0.0):
            x_force = float(random.randint(-70, 70) * 20)

            y_force = float(random.randrange(-20,0) * 20)
            #y_force = 0
            self.wind_force = (x_force, y_force)
            print("Wind Force:", str(self.wind_force))
        else:
            self.wind_force = WindForce
            print("Wind Force ELSE:", str(self.wind_force))

        self.controller.setWindForce(self.wind_force)

    def apply_wind(self, wind_velocity:Vec2d, drag_coefficient, area):
        rel_vel = self.body.velocity - wind_velocity

        # force_mag = 0.5 * 1.225 * rel_vel.length_squared * drag_coefficient * area
        # force_mag = 0.5 * 1.225 * rel_vel.length_squared * drag_coefficient * area
        # force_vector = -rel_vel.normalized() * force_mag
        self.body.apply_force_at_local_point(-rel_vel, (0, 0))

    def build_level(self, level_data):

        for box in level_data["collisionBoxes"]:
            self.add_static_box(box,GROUND)
        for box in level_data["targets"]:
            self.add_static_box(box, TARGET)

        for box in level_data["killZones"]:
            self.add_static_box(box, KILL)

    def dial_angle_to_body_angle(self, angle_deg):
        return math.radians(90.0 - angle_deg)

    def get_projectile_qml_rotation(self):
        if self.body is None:
            return self.initial_state["projectile_angle_deg"] - 90.0
        return -math.degrees(self.body.angle)

    def get_projectile_qml_position(self):
        if self.body is None:
            return self.initial_state["projectile_position_qml"]

        qml_x = self.body.position.x - PROJECTILE_WIDTH / 2.0
        qml_y = self.screenHeight - self.body.position.y - PROJECTILE_HEIGHT / 2.0
        return (qml_x, qml_y)

    def create_projectile_shape(self, hitbox_data):
        mass = 6.0
        sprite_w, sprite_h = PROJECTILE_WIDTH, PROJECTILE_HEIGHT
        sprite_x, sprite_y = PROJECTILE_START_X, PROJECTILE_START_Y  # QML top-left

        hitboxes = hitbox_data["hitboxes"] if isinstance(hitbox_data, dict) else hitbox_data

        moment = pymunk.moment_for_box(mass, (sprite_w, sprite_h))
        self.body = pymunk.Body(mass, moment)

        # QML (top-left, y down) -> Pymunk (center, y up)
        cx = sprite_x + sprite_w / 2.0
        cy_qml = sprite_y + sprite_h / 2.0
        cy = self.screenHeight - cy_qml
        self.body.position = (cx, cy)
        self.initial_state["projectile_position_pymunk"] = (cx, cy)
        self.initial_state["projectile_position_qml"] = (sprite_x, sprite_y)

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

    def reset_projectile_state(self, angle_deg):
        if self.body is None:
            return

        self.body.position = self.initial_state["projectile_position_pymunk"]
        self.body.velocity = (0.0, 0.0)
        self.body.force = (0.0, 0.0)
        self.body.torque = 0.0
        self.body.angular_velocity = 0.0
        self.body.angle = self.dial_angle_to_body_angle(angle_deg)
        self.initial_state["projectile_angle_deg"] = angle_deg

    def align_projectile_to_velocity(self):
        if self.body is None:
            return

        velocity = self.body.velocity
        if velocity.length == 0:
            return

        # Keep the body and sprite aligned to the flight direction.
        self.body.angle = math.atan2(velocity.y, velocity.x) - math.pi / 2
        self.body.angular_velocity = 0.0


    def start(self, velocity, angle_deg):
        self.create_wind(self.wind_force)
        angle = math.radians(angle_deg)
        print("Angle:", angle)

        # Dial: 0 = left, 90 = up, 180 = right.
        velocityX = -velocity * math.cos(angle)
        velocityY = velocity * math.sin(angle)

        self.reset_projectile_state(angle_deg)
        self.body.velocity = (velocityX, velocityY)
        self.align_projectile_to_velocity()
        #self.shape = pymunk.Poly.create_box(self.body, size)
        #self.space.add(self.body, self.shape)

    def step(self, delta_time):
        self.space.step(delta_time)
        self.apply_wind(self.wind_force, 0.47, 10)
        self.apply_target_drop_constraints()
        #print(self.body.position, delta_time)
        return self.body.position


