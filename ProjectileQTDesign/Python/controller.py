import os
import math

from PySide6.QtCore import QObject, Signal, Slot, Property, QTimer
from PySide6.QtGui import QVector2DList
from pymunk.vec2d import Vec2d

from PhysicsEngine import *
from LevelInitialisation import *

class GameController(QObject):

    velocityChanged = Signal()
    angleChanged = Signal()
    gravityChanged = Signal()
    flightTimeChanged = Signal()
    maxHeightChanged = Signal()
    attemptsChanged = Signal()
    totalDisplacementChanged = Signal()
    scoreChanged = Signal()
    resultsVisibleChanged = Signal()
    simulateEnabledChanged = Signal()
    debugBoxEnabledChanged = Signal()
    windChanged = Signal()
    projectileRotationChanged = Signal()
    projectilePositionChanged: Signal = Signal(float, float, float, float)
    debugBoxesChanged = Signal(list)

    def __init__(self):
        super().__init__()
        self._screenheight = 832
        self._velocity = 0.0
        self._angle = 90.0
        self._gravity = -9.8
        self._flightTime = 0.0
        self._maxHeight = 0.0
        self._attempts = 0
        self._totalDisplacement = 0.0
        self._score = 0
        self._resultsVisible = False
        self._simulateEnabled = True
        self._debugBoxEnabled = False
        self._windForce = (0.0, 0.0)
        self._projectileRotation = 0.0
        self._attemptInProgress = False
        self._settleFrames = 0
        self._attemptStartPosition = (0.0, 0.0)
        self._targetHitThisAttempt = False
        self.simulation = PhysicsSimulation(self)
        self.LevelMan = LevelInitialisation()
        self.timer = QTimer()
        self.timer.timeout.connect(self.updatePhysics)


        self.base_dir = os.path.dirname(os.path.abspath(__file__))
        #self._CurrentLevel =
        #self.file_path = os.path.join(base_dir, "Levels")
        self._rebuildSimulationState()
        self._setProjectileRotation(self.simulation.get_projectile_qml_rotation())
        self._resetAttemptMetrics()

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
        self._emitProjectileState(0.0)

    @Property(float, notify=angleChanged)
    def angle(self):
        return self._angle

    @angle.setter
    def angle(self, value):
        if self._angle == value:
            return
        self._angle = value
        print("angle: " + str(value))
        if self._simulateEnabled:
            self.simulation.reset_projectile_state(self._angle)
            self._setProjectileRotation(self.simulation.get_projectile_qml_rotation())
            self._emitProjectileState(0.0)
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

    @Property(float, notify=flightTimeChanged)
    def flightTime(self):
        return self._flightTime

    @Property(float, notify=maxHeightChanged)
    def maxHeight(self):
        return self._maxHeight

    @Property(int, notify=attemptsChanged)
    def attempts(self):
        return self._attempts

    @Property(float, notify=totalDisplacementChanged)
    def totalDisplacement(self):
        return self._totalDisplacement

    @Property(int, notify=scoreChanged)
    def score(self):
        return self._score

    @Property(bool, notify=resultsVisibleChanged)
    def resultsVisible(self):
        return self._resultsVisible

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

    @Property(float, notify=projectileRotationChanged)
    def projectileRotation(self):
        return self._projectileRotation

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

    def _setProjectileRotation(self, value):
        if math.isclose(self._projectileRotation, value, abs_tol=0.001):
            return
        self._projectileRotation = value
        self.projectileRotationChanged.emit()

    def _setFlightTime(self, value):
        if math.isclose(self._flightTime, value, abs_tol=0.001):
            return
        self._flightTime = value
        self.flightTimeChanged.emit()

    def _setMaxHeight(self, value):
        if math.isclose(self._maxHeight, value, abs_tol=0.001):
            return
        self._maxHeight = value
        self.maxHeightChanged.emit()

    def _setAttempts(self, value):
        if self._attempts == value:
            return
        self._attempts = value
        self.attemptsChanged.emit()

    def _setTotalDisplacement(self, value):
        if math.isclose(self._totalDisplacement, value, abs_tol=0.001):
            return
        self._totalDisplacement = value
        self.totalDisplacementChanged.emit()

    def _setScore(self, value):
        if self._score == value:
            return
        self._score = value
        self.scoreChanged.emit()

    def _setResultsVisible(self, value):
        if self._resultsVisible == value:
            return
        self._resultsVisible = value
        self.resultsVisibleChanged.emit()

    def _resetAttemptMetrics(self):
        # Reset only the per-run results. Attempts remain session-wide.
        self._attemptInProgress = False
        self._settleFrames = 0
        self._attemptStartPosition = (0.0, 0.0)
        self._targetHitThisAttempt = False
        self._setResultsVisible(False)
        self._setFlightTime(0.0)
        self._setMaxHeight(0.0)
        self._setTotalDisplacement(0.0)

    def _startAttemptMetrics(self):
        if self.simulation.body is None:
            return

        # Each simulate click starts a fresh run and increments attempts once.
        self._attemptInProgress = True
        self._settleFrames = 0
        self._targetHitThisAttempt = False
        self._setResultsVisible(False)
        self._attemptStartPosition = (
            float(self.simulation.body.position.x),
            float(self.simulation.body.position.y),
        )
        self._setAttempts(self._attempts + 1)
        self._setFlightTime(0.0)
        self._setTotalDisplacement(0.0)
        self._setMaxHeight(self._attemptStartPosition[1] / PIXELS_PER_METER)

    def _updateAttemptMetrics(self, delta_time):
        if not self._attemptInProgress or self.simulation.body is None:
            return

        body_position = self.simulation.body.position
        body_velocity = self.simulation.body.velocity

        # Flight time is measured from launch until the attempt is finalised.
        self._setFlightTime(self._flightTime + delta_time)
        # Height is tracked in world-space metres using the same physics scale.
        self._setMaxHeight(max(self._maxHeight, body_position.y / PIXELS_PER_METER))
        # Displacement is measured horizontally from the attempt start point.
        self._setTotalDisplacement(
            abs(body_position.x - self._attemptStartPosition[0]) / PIXELS_PER_METER
        )

        if self.simulation.run_completed:
            if self.simulation.run_completion_reason == "target":
                self._handleTargetHit()
            elif self.simulation.run_completion_reason == "kill":
                self._handleKillZoneTriggered()
            else:
                self._finishAttempt()
                return

        # Consider the run complete once the projectile has stayed almost still
        # for a short stretch of frames after launch.
        if self._flightTime >= 0.25 and body_velocity.length < 20:
            self._settleFrames += 1
        else:
            self._settleFrames = 0

        if self._settleFrames >= 12:
            self._finishAttempt()

    def _handleTargetHit(self):
        if self._targetHitThisAttempt:
            self.simulation.clear_completion_event()
            return

        # Show results and award score immediately, but keep the simulation
        # running while the projectile drops vertically after the hit.
        self._targetHitThisAttempt = True
        self._setScore(self._score + 1)
        self._setResultsVisible(True)
        self.simulation.begin_target_drop()
        self.simulation.clear_completion_event()

    def _handleKillZoneTriggered(self):
        # Kill boxes are sensor-only trigger zones. They should not stop the
        # simulation or block the projectile, but the event is still cleared so
        # future passes through kill zones or target zones can be detected.
        self.simulation.clear_completion_event()

    def _finishAttempt(self):
        if not self._attemptInProgress:
            return

        # Finalise the result values and re-enable launching once motion has settled.
        self._attemptInProgress = False
        self._settleFrames = 0
        self.timer.stop()
        self.setSimulateEnabled(True)
        self._setTotalDisplacement(
            abs(self.simulation.body.position.x - self._attemptStartPosition[0]) / PIXELS_PER_METER
        )
        self.simulation.clear_run_state()

    def _rebuildSimulationState(self):
        self.simulation.reset_space()
        self.simulation.build_level(self.LevelMan.load())
        self.simulation.create_projectile_shape(self.LevelMan.loadProjectile())
        self.simulation.space.gravity = (0, self._gravity * 100)
        self.simulation.reset_projectile_state(self._angle)

    def _emitProjectileState(self, velocity):
        qml_x, qml_y = self.simulation.get_projectile_qml_position()
        self.projectilePositionChanged.emit(
            qml_x,
            qml_y,
            self._projectileRotation,
            velocity,
        )

    @Slot()
    def resetSimulation(self):
        self.timer.stop()
        self.setSimulateEnabled(True)
        self._rebuildSimulationState()
        self._setProjectileRotation(self.simulation.get_projectile_qml_rotation())
        self._resetAttemptMetrics()
        self.debugBoxesChanged.emit(self.simulation.get_debug_boxes())
        self._emitProjectileState(0.0)


    @Slot(float, float, float)
    def startSimulation(self, velocity, angle, gravity):
        print("Velocity:", velocity)
        print("Angle:", angle)
        print("Gravity:", gravity)
        self.setSimulateEnabled(False)
        self._angle = angle
        self._gravity = gravity

        self._rebuildSimulationState()
        self.simulation.start(velocity * 100, angle)
        self._setProjectileRotation(self.simulation.get_projectile_qml_rotation())

        # Ignore zero-speed launches so attempts only count real shots.
        if self.simulation.body.velocity.length <= 0.001:
            self.setSimulateEnabled(True)
            self._resetAttemptMetrics()
            self._emitProjectileState(0.0)
            return

        self._startAttemptMetrics()
        self._emitProjectileState(round(velocity, 1))

        self.timer.start(16)

    @Slot(str)
    def saveLevelDev(self, leveldata):
        self.LevelMan.saveLevelDev(leveldata)

    @Slot(str)
    def saveProjectileHitbox(self, hitboxdata):
        self.LevelMan.saveProjectileHitbox(hitboxdata)

    def updatePhysics(self):
        if self.simulation.body is None:
            return

        delta_time = 1 / 60
        self.simulation.step(delta_time)

        boxes = self.simulation.get_debug_boxes()
        self.debugBoxesChanged.emit(boxes)

        vel = self.simulation.body.velocity

        if vel.length > 50:
            self.simulation.align_projectile_to_velocity()

        qml_rotation = self.simulation.get_projectile_qml_rotation()
        qml_x, qml_y = self.simulation.get_projectile_qml_position()
        self._setProjectileRotation(qml_rotation)
        self._updateAttemptMetrics(delta_time)

        displayVelocity = round(float(vel.length) / 100 , 1)

        self.projectilePositionChanged.emit(qml_x, qml_y, qml_rotation, displayVelocity)
