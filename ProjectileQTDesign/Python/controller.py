from socket import send_fds

from PySide6.QtCore import QObject, Signal, Slot, Property, QTimer
from PySide6.QtGui import QVector2DList
from pymunk.vec2d import Vec2d

from PhysicsEngine import *
from LevelInitialisation import *

import os

class GameController(QObject):

    velocityChanged = Signal()
    angleChanged = Signal()
    gravityChanged = Signal()
    simulateEnabledChanged = Signal()
    debugBoxEnabledChanged = Signal()
    windChanged = Signal()
    projectilePositionChanged: Signal = Signal(float, float, float, float)
    debugBoxesChanged = Signal(list)

    def __init__(self):
        super().__init__()
        self._screenheight = 832
        self._velocity = 0.0
        self._angle = 90.0
        self._gravity = -9.8
        self._simulateEnabled = True
        self._debugBoxEnabled = False
        self._windForce = (0.0, 0.0)
        self.simulation = PhysicsSimulation(self)
        self.LevelMan = LevelInitialisation()
        self.timer = QTimer()
        self.timer.timeout.connect(self.updatePhysics)
        self.LastAngle = 0.0


        self.base_dir = os.path.dirname(os.path.abspath(__file__))
        #self._CurrentLevel =
        #self.file_path = os.path.join(base_dir, "Levels")

    @Property(float, notify=velocityChanged)
    def velocity(self):
        return self._velocity

    @velocity.setter
    def velocity(self, value):
        if self._velocity == value:
            return
        self._velocity = value
        print("velocity: " + str(value))
        self.velocityChanged.emit()

    @Slot(int)
    def setScreenHeight(self, height):
        self.simulation.screenHeight = height

    @Property(float, notify=angleChanged)
    def angle(self):
        return self._angle

    @angle.setter
    def angle(self, value):
        if self._angle == value:
            return
        self._angle = value
        print("angle: " + str(value))
        self.angleChanged.emit()

    @Property(float, notify=gravityChanged)
    def gravity(self):
        return self._gravity

    @gravity.setter
    def gravity(self, value):
        if self._gravity == value:
            return
        self._gravity = value
        print("gravity: " + str(value))
        self.gravityChanged.emit()

    def setWindForce(self, force):
        self._windForce = force
        self.windChanged.emit()

    def getWindAngle(self):
        wind = self._windForce
        angle = (math.degrees(math.atan2(wind[1], wind[0])) + 360) % 360
        return angle

    windAngle = Property(float, getWindAngle, notify=windChanged)

    def getWindLength(self):
        if self._windForce == (0.0, 0.0):
            return 0.0

        windResultant = math.hypot(self._windForce[0], self._windForce[1])
        wind = round( windResultant / 100, 1)
        return wind

    windVelocity = Property(float, getWindLength, notify=windChanged)

    @Property(bool, notify=simulateEnabledChanged)
    def simulateEnabled(self):
        return self._simulateEnabled

    def setSimulateEnabled(self, value):
        if self._simulateEnabled == value:
            return
        self._simulateEnabled = value
        self.simulateEnabledChanged.emit()

    @Slot(bool)
    def setDebugBoxEnabled(self, value):
        if self._debugBoxEnabled == value:
            return

        self._debugBoxEnabled = value
        self.debugBoxEnabledChanged.emit()

    @Property(bool, fset=setDebugBoxEnabled, notify=debugBoxEnabledChanged)
    def debugBoxEnabled(self):
        return self._debugBoxEnabled



    @Slot(float, float, float)
    def startSimulation(self, velocity, angle, gravity):
        print("Velocity:", velocity)
        print("Angle:", angle)
        print("Gravity:", gravity)
        self.setSimulateEnabled(False)

        self.simulation.reset_space()
        #Get Level Json and send to Physics Engine to parse
        self.simulation.build_level(self.LevelMan.load())
        self.simulation.create_projectile_shape(self.LevelMan.loadProjectile())

        self.simulation.space.gravity = (0, gravity * 100)
        self.simulation.start(velocity * 100, angle)

        self.timer.start(16)

    @Slot(str)
    def saveLevelDev(self, leveldata):
        self.LevelMan.saveLevelDev(leveldata)

    @Slot(str)
    def saveProjectileHitbox(self, hitboxdata):
        self.LevelMan.saveProjectileHitbox(hitboxdata)

    def updatePhysics(self):
        x, y = self.simulation.step(1/60)

        boxes = self.simulation.get_debug_boxes()
        self.debugBoxesChanged.emit(boxes)

        pos = self.simulation.body.position
        vel = self.simulation.body.velocity

        if vel.length > 50:
            angle = math.degrees(math.atan2(vel.y, vel.x) - math.pi / 2)
            self.LastAngle = angle
        else:
            #angle = self.LastAngle
            angle = math.degrees(self.simulation.body.angle)

        #self.simulation.body.angle = angle # this is ver broke

        rocket_w = 57
        rocket_h = 142

        qml_x = pos.x - rocket_w / 2
        qml_y = self.simulation.screenHeight - pos.y - rocket_h / 2

        displayVelocity = round(float(vel.length) / 100 , 1)

        self.projectilePositionChanged.emit(qml_x, qml_y, angle, displayVelocity)

    def reset(self):
        self.timer.stop()
        self.setSimulateEnabled(True)
        self.simulation.reset_space()