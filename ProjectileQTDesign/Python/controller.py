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
    currentLevelChanged = Signal()
    resultsVisibleChanged = Signal()
    winVisibleChanged = Signal()
    loseVisibleChanged = Signal()
    winMessageChanged = Signal()
    loseMessageChanged = Signal()
    simulateEnabledChanged = Signal()
    debugBoxEnabledChanged = Signal()
    windChanged = Signal()
    projectileRotationChanged = Signal()
    projectilePositionChanged: Signal = Signal(float, float, float, float)
    impactEffectTriggered: Signal = Signal(str, float, float)
    debugBoxesChanged = Signal(list)

    def __init__(self):
        super().__init__()
        self._screenheight = 832
        self._screenWidth = 1280
        self._velocity = 0.0
        self._angle = 90.0
        self._gravity = -9.8
        self._flightTime = 0.0
        self._maxHeight = 0.0
        self._attempts = 0
        self._totalDisplacement = 0.0
        self._score = 0
        self._currentLevelIndex = 0
        self._resultsVisible = False
        self._winVisible = False
        self._loseVisible = False
        self._winMessage = ""
        self._loseMessage = ""
        self._simulateEnabled = True
        self._debugBoxEnabled = False
        self._windForce = (0.0, 0.0)
        self._projectileRotation = 0.0
        self._attemptInProgress = False
        self._stationaryTime = 0.0
        self._attemptStartPosition = (0.0, 0.0)
        self._targetHitThisAttempt = False
        self._attemptResolved = False
        self._levelData = {}
        self.simulation = PhysicsSimulation(self)
        self.LevelMan = LevelInitialisation()
        self.timer = QTimer()
        self.timer.timeout.connect(self.updatePhysics)


        self.base_dir = os.path.dirname(os.path.abspath(__file__))
        #self._CurrentLevel =
        #self.file_path = os.path.join(base_dir, "Levels")
        self.simulation.set_wind_profile(
            self.LevelMan.getWindProfile(self._currentLevelIndex),
            regenerate_force=True,
        )
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

    @Property(int, notify=currentLevelChanged)
    def currentLevel(self):
        # Expose a 1-based level number to QML to keep bindings and labels simple.
        return self._currentLevelIndex + 1

    @Property(bool, notify=resultsVisibleChanged)
    def resultsVisible(self):
        return self._resultsVisible

    @Property(bool, notify=winVisibleChanged)
    def winVisible(self):
        return self._winVisible

    @Property(bool, notify=loseVisibleChanged)
    def loseVisible(self):
        return self._loseVisible

    @Property(str, notify=winMessageChanged)
    def winMessage(self):
        return self._winMessage

    @Property(str, notify=loseMessageChanged)
    def loseMessage(self):
        return self._loseMessage

    def setWindForce(self, force):
        self._windForce = force
        self.windChanged.emit()

    def getWindAngle(self):
        wind = self._windForce
        angle = (math.degrees(math.atan2(wind[1], wind[0])) + 360) % 360
        return angle

    windAngle = Property(float, getWindAngle, notify=windChanged)

    def getWindCompassRotation(self):
        # Wind angles are measured with 0 degrees pointing East. The compass
        # arrow artwork points North by default, so convert to a North-up
        # rotation before QML renders the icon.
        return 90.0 - self.getWindAngle()

    windCompassRotation = Property(float, getWindCompassRotation, notify=windChanged)

    def _getWindDirectionIndex(self):
        # Use a 16-point compass so the UI can teach directions like NNE and WSW.
        angle = self.getWindAngle()
        return int(round(angle / 22.5)) % 16

    def getWindCardinalDirection(self):
        directions = [
            "East",
            "East-North-East",
            "North-East",
            "North-North-East",
            "North",
            "North-North-West",
            "North-West",
            "West-North-West",
            "West",
            "West-South-West",
            "South-West",
            "South-South-West",
            "South",
            "South-South-East",
            "South-East",
            "East-South-East",
        ]
        return directions[self._getWindDirectionIndex()]

    windCardinalDirection = Property(str, getWindCardinalDirection, notify=windChanged)

    def getWindCardinalShort(self):
        directions = [
            "E",
            "ENE",
            "NE",
            "NNE",
            "N",
            "NNW",
            "NW",
            "WNW",
            "W",
            "WSW",
            "SW",
            "SSW",
            "S",
            "SSE",
            "SE",
            "ESE",
        ]
        return directions[self._getWindDirectionIndex()]

    windCardinalShort = Property(str, getWindCardinalShort, notify=windChanged)

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

    def _setCurrentLevelIndex(self, value):
        if self._currentLevelIndex == value:
            return
        self._currentLevelIndex = value
        self.currentLevelChanged.emit()

    def _setResultsVisible(self, value):
        if self._resultsVisible == value:
            return
        self._resultsVisible = value
        self.resultsVisibleChanged.emit()

    def _setWinVisible(self, value):
        if self._winVisible == value:
            return
        self._winVisible = value
        self.winVisibleChanged.emit()

    def _setLoseVisible(self, value):
        if self._loseVisible == value:
            return
        self._loseVisible = value
        self.loseVisibleChanged.emit()

    def _setWinMessage(self, value):
        if self._winMessage == value:
            return
        self._winMessage = value
        self.winMessageChanged.emit()

    def _setLoseMessage(self, value):
        if self._loseMessage == value:
            return
        self._loseMessage = value
        self.loseMessageChanged.emit()

    def _getPrimaryTargetCentreX(self):
        targets = self._levelData.get("targets", [])
        if not targets:
            return None

        first_target = targets[0]
        return float(first_target["x"]) + float(first_target["width"]) / 2.0

    def _getRemainingTargetDistanceMeters(self):
        if self.simulation.body is None:
            return 0.0

        target_centre_x = self._getPrimaryTargetCentreX()
        if target_centre_x is None:
            return 0.0

        return abs(float(self.simulation.body.position.x) - target_centre_x) / PIXELS_PER_METER

    def _getWindGuidanceText(self):
        wind_speed = self.windVelocity
        horizontal_force = float(self._windForce[0]) if self._windForce else 0.0
        cardinal_direction = self.getWindCardinalDirection()

        if wind_speed <= 0.05:
            return "The wind is calm, so focus on changing your angle or velocity."

        if abs(horizontal_force) < 1.0:
            return (
                f"The wind is blowing {cardinal_direction} at {wind_speed:.1f} m/s, "
                "so small changes can still matter."
            )

        direction = "right" if horizontal_force > 0 else "left"
        return (
            f"Watch out for the wind blowing {cardinal_direction} at {wind_speed:.1f} m/s. "
            f"It is mostly pushing to the {direction}."
        )

    def _buildLoseMessage(self):
        remaining_distance = self._getRemainingTargetDistanceMeters()
        return (
            f"Try another angle or velocity. You were {remaining_distance:.1f} m away from the target.\n\n"
            f"{self._getWindGuidanceText()}"
        )

    def _buildWinMessage(self):
        wind_speed = self.windVelocity
        horizontal_force = float(self._windForce[0]) if self._windForce else 0.0
        cardinal_direction = self.getWindCardinalDirection()

        if wind_speed <= 0.05:
            wind_text = "The calm wind let your launch line up nicely."
        elif abs(horizontal_force) < 1.0:
            wind_text = (
                f"You handled the light wind blowing {cardinal_direction} at {wind_speed:.1f} m/s really well."
            )
        else:
            direction = "right" if horizontal_force > 0 else "left"
            wind_text = (
                f"You handled the wind blowing {cardinal_direction} at {wind_speed:.1f} m/s really well. "
                f"It was mostly pushing to the {direction}."
            )

        next_level_text = "Get ready for the next level."
        if not self.LevelMan.hasLevel(self._currentLevelIndex + 1):
            next_level_text = "You cleared the last level for now. Press Continue to play it again."

        return (
            "Amazing shot! You hit the target.\n\n"
            f"Your launch choices worked really well. {wind_text} "
            f"{next_level_text}"
        )

    def _showWinState(self):
        if self._attemptResolved:
            return

        # Lock the attempt outcome so later frames cannot replace a win with a loss.
        self._attemptResolved = True
        self._setLoseVisible(False)
        self._setLoseMessage("")
        self._setWinMessage(self._buildWinMessage())
        self._setWinVisible(True)
        self._setResultsVisible(True)

    def _showLoseState(self):
        if self._attemptResolved:
            return

        # Lock the attempt outcome so X-bounds or kill-box checks only trigger once.
        self._attemptResolved = True
        self._setWinVisible(False)
        self._setWinMessage("")
        # Show the same results card for failed attempts so the player can still
        # review the shot data while the simulation continues in the background.
        self._setResultsVisible(True)
        self._setLoseMessage(self._buildLoseMessage())
        self._setLoseVisible(True)

    def _isOutOfHorizontalBounds(self, qml_x):
        return qml_x < 0.0 or qml_x > float(self._screenWidth)

    def _checkHorizontalFailure(self, qml_x):
        if not self._attemptInProgress or self._attemptResolved:
            return

        # Losing only depends on the visible horizontal screen bounds, not Y.
        if self._isOutOfHorizontalBounds(qml_x):
            self._showLoseState()
            # Keep the body simulating after an out-of-bounds loss so the player
            # can still watch the shot finish. The projectile is only rebuilt
            # when the normal reset routine is called.

    def _resetAttemptMetrics(self):
        # Reset only the per-run results. Attempts remain session-wide.
        self._attemptInProgress = False
        self._stationaryTime = 0.0
        self._attemptStartPosition = (0.0, 0.0)
        self._targetHitThisAttempt = False
        self._attemptResolved = False
        self._setResultsVisible(False)
        self._setWinVisible(False)
        self._setLoseVisible(False)
        self._setWinMessage("")
        self._setLoseMessage("")
        self._setFlightTime(0.0)
        self._setMaxHeight(0.0)
        self._setTotalDisplacement(0.0)

    def _startAttemptMetrics(self):
        if self.simulation.body is None:
            return

        # Each simulate click starts a fresh run and increments attempts once.
        self._attemptInProgress = True
        self._stationaryTime = 0.0
        self._targetHitThisAttempt = False
        self._attemptResolved = False
        self._setResultsVisible(False)
        self._setWinVisible(False)
        self._setLoseVisible(False)
        self._setWinMessage("")
        self._setLoseMessage("")
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

        # Keep the physics timer running after a win/lose event, but freeze the
        # recorded stats at the moment the attempt was resolved.
        if self._attemptResolved:
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

        if self._attemptResolved:
            return

        # Treat a long stationary rest as a failed shot. There is no dedicated
        # grounded-state flag yet, so sustained near-zero speed is the cleanest
        # proxy for "the projectile has landed and stopped moving".
        if self._flightTime >= 0.25 and body_velocity.length < 20:
            self._stationaryTime += delta_time
        else:
            self._stationaryTime = 0.0

        if self._stationaryTime >= 3.5 and not self._attemptResolved:
            # A settled landing gets a small dust burst in the QML scene.
            self._emitImpactEffect("dust")
            self._showLoseState()
            self._finishAttempt()

    def _handleTargetHit(self):
        if self._targetHitThisAttempt or self._attemptResolved:
            self.simulation.clear_completion_event()
            return

        # Show results and award score immediately, but keep the simulation
        # running while the projectile drops vertically after the hit.
        self._targetHitThisAttempt = True
        self._setScore(self._score + 1)
        self._showWinState()
        self.simulation.begin_target_drop()
        self.simulation.clear_completion_event()

    def _handleKillZoneTriggered(self):
        if self._attemptResolved:
            self.simulation.clear_completion_event()
            return

        # Kill boxes are sensor-only trigger zones, so show the lose screen but
        # let the projectile keep moving until the player resets the level.
        self._emitImpactEffect("splash")
        self._showLoseState()
        self.simulation.clear_completion_event()

    def _finishAttempt(self):
        if not self._attemptInProgress:
            return

        # Finalise the result values and re-enable launching once motion has settled.
        self._attemptInProgress = False
        self._stationaryTime = 0.0
        self.timer.stop()
        self.setSimulateEnabled(True)
        self._setTotalDisplacement(
            abs(self.simulation.body.position.x - self._attemptStartPosition[0]) / PIXELS_PER_METER
        )
        self.simulation.clear_run_state()

    def _emitImpactEffect(self, effect_type):
        if self.simulation.body is None:
            return

        qml_x, qml_y = self.simulation.get_projectile_qml_position()
        # Emit the projectile centre so QML can place small visual bursts cleanly.
        self.impactEffectTriggered.emit(
            effect_type,
            qml_x + PROJECTILE_WIDTH / 2.0,
            qml_y + PROJECTILE_HEIGHT / 2.0,
        )

    def _rebuildSimulationState(self):
        self.simulation.reset_space()
        self._levelData = self.LevelMan.load(self._currentLevelIndex)
        self.simulation.build_level(self._levelData)
        self.simulation.create_projectile_shape(self.LevelMan.loadProjectile())
        self.simulation.space.gravity = (0, self._gravity * 100)
        self.simulation.reset_projectile_state(self._angle)

    def _loadLevel(self, level_index):
        if not self.LevelMan.hasLevel(level_index):
            return False

        # Switching levels should rebuild the entire physics state for the new
        # layout while preserving the existing controller/session structure.
        level_changed = level_index != self._currentLevelIndex
        self.timer.stop()
        self.setSimulateEnabled(True)
        self._setCurrentLevelIndex(level_index)
        self.simulation.set_wind_profile(
            self.LevelMan.getWindProfile(level_index),
            regenerate_force=level_changed,
        )
        self._rebuildSimulationState()
        self._setProjectileRotation(self.simulation.get_projectile_qml_rotation())
        self._resetAttemptMetrics()
        self.debugBoxesChanged.emit(self.simulation.get_debug_boxes())
        self._emitProjectileState(0.0)
        return True

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
        self._loadLevel(self._currentLevelIndex)


    @Slot(float, float, float)
    def startSimulation(self, velocity, angle, gravity):
        print("Velocity:", velocity)
        print("Angle:", angle)
        print("Gravity:", gravity)
        self.setSimulateEnabled(False)
        self._velocity = velocity
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
        self.LevelMan.saveLevelDev(leveldata, self._currentLevelIndex)

    @Slot(str)
    def saveProjectileHitbox(self, hitboxdata):
        self.LevelMan.saveProjectileHitbox(hitboxdata)

    @Slot()
    def continueAfterLose(self):
        # Retry the current level immediately after the player closes the lose screen.
        self._setLoseVisible(False)
        self.resetSimulation()

    @Slot()
    def continueAfterWin(self):
        # Advance to the next registered level when possible. If the player has
        # finished the final available level, safely restart that same level.
        self._setWinVisible(False)
        self._setResultsVisible(False)
        if not self._loadLevel(self._currentLevelIndex + 1):
            self.resetSimulation()

    def updatePhysics(self):
        if self.simulation.body is None:
            return

        delta_time = 1 / 60
        self.simulation.step(delta_time)

        boxes = self.simulation.get_debug_boxes()
        self.debugBoxesChanged.emit(boxes)

        vel = self.simulation.body.velocity
        # Let the physics layer choose between full flight alignment and the
        # low-speed safe fallback so slow shots cannot snap unpredictably.
        self.simulation.align_projectile_to_velocity()

        qml_rotation = self.simulation.get_projectile_qml_rotation()
        qml_x, qml_y = self.simulation.get_projectile_qml_position()
        self._setProjectileRotation(qml_rotation)
        self._updateAttemptMetrics(delta_time)
        self._checkHorizontalFailure(qml_x)

        displayVelocity = round(float(vel.length) / 100 , 1)

        self.projectilePositionChanged.emit(qml_x, qml_y, qml_rotation, displayVelocity)
