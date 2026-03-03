from PySide6.QtCore import QObject, Signal, Slot, Property, QTimer
from PySide6.QtGui import QVector2DList
from Tools.demo import vector

from PhysicsEngine import *
from LevelInitialisation import *

class GameController(QObject):

    velocityChanged = Signal()
    angleChanged = Signal()
    gravityChanged = Signal()
    simulateEnabledChanged = Signal()
    projectilePositionChanged: Signal = Signal(float, float, float)

    def __init__(self):
        super().__init__()
        self._velocity = 0.0
        self._angle = 90.0
        self._gravity = -9.8
        self._simulateEnabled = True
        self.simulation = PhysicsSimulation()
        self.timer = QTimer()
        self.timer.timeout.connect(self.updatePhysics)

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

    @Property(bool, notify=simulateEnabledChanged)
    def simulateEnabled(self):
        return self._simulateEnabled


    def setSimulateEnabled(self, value):
        if self._simulateEnabled == value:
            return
        self._simulateEnabled = value
        self.simulateEnabledChanged.emit()

    @Slot(float, float, float)
    def startSimulation(self, velocity, angle, gravity):
        print("Velocity:", velocity)
        print("Angle:", angle)
        print("Gravity:", gravity)
        self.setSimulateEnabled(False)

        self.simulation.space.gravity = (0, gravity*100)
        self.simulation.start(velocity * 100, angle)

        self.timer.start(16)


    def updatePhysics(self):
        x, y = self.simulation.step(1/60)

        pos = self.simulation.body.position
        vel = self.simulation.body.velocity

        angle_rad = math.atan2(vel.y, vel.x)
        angle_deg = math.degrees(angle_rad - 90)

        self.projectilePositionChanged.emit(x, 600 - y, angle_deg)