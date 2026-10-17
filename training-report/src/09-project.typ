#import "styles.typ": *

// ── 9 Capstone project ─────────────────────────────────────────────────────
= Capstone project: FPGA-based automotive ECU suite <ch-project>

== Motivation and proposal

The final project of the course was submitted by a team of five — Amr Waheed, Aly Hamdy,
Zeyad Khaled, Abdelrahman Mohamed and Adham Amr — under the NTI project-recognition scheme
(proposal 19 July, submission 23 July). The team chose an *advanced automotive electronic
control unit (ECU) suite*: safety- and performance-critical vehicle functions implemented
as dedicated synchronous hardware instead of tasks on a shared microcontroller.

The engineering argument is the one the whole training builds toward. A sequential MCU
executes `task 1 → task 2 → …` plus interrupts and OS jitter; acceptable for comfort
functions, risky for safety functions, because queuing delay turns into variable reaction
time. A late ABS reaction lengthens stopping distance; a missed rev limit damages an
engine; a crashed task hangs everything. The suite's answer: one dedicated hardware
controller per function, all executing in the same clock cycle — true parallelism,
deterministic latency, and fault isolation.

== Architecture

#imgfig("assets/fig/ecu-arch.svg",
  [Top-level architecture of the capstone suite. Sensors on the left feed five independent
  synthesizable controllers inside one clocked FPGA fabric; actuators on the right receive
  PWM, cut and alert signals. No controller waits for another: the five blocks evaluate
  every cycle, concurrently.])
<fig-ecu>

Figure #ref(<fig-ecu>) shows the suite as built: five modules sharing the vehicle-level
signals (speed, brake, throttle, RPM, echo) and producing actuator-level outputs. Design
rules were fixed in the proposal: single clock, synchronous resets, fully synthesizable
RTL, and a self-checking testbench per module.

#tbl(
  [The five ECU modules, their interfaces and verification],
  (left, left, left, left),
  ([Module], [Inputs], [Outputs], [Testbench]),
  ([ABS + traction control], [front/rear wheel speed (8-bit), brake, ecu PWM], [final PWM, ABS brake pulse, TCS/ABS LEDs], [`tb_Traction_ABS`]),
  ([Smart RPM limiter], [engine RPM, speed, brake, throttle], [spark retard, fuel cut], [`tb_Smart_RPM`]),
  ([Active spoiler], [speed (9-bit), brake], [servo PWM, air-brake LED], [`tb_Active_Spoiler`]),
  ([Ultrasonic parking assist], [echo pulse], [green/yellow/red LEDs, buzzer], [`tb_parking_system`]),
  ([Multi-mode drive controller], [throttle (2-bit), mode (2-bit)], [motor PWM (8-bit)], [`tb_Drive_Mode`]),
)

== Subsystem design notes

#lead[ABS + traction control.] Every cycle the module compares front and rear wheel speed.
Under braking with slip above the threshold (difference > 15) it generates an ABS pulse so
the wheel never locks — modulating pressure in the increase→hold→decrease cycle; under
drive with wheel spin it halves the torque PWM (traction control). The FSM of
#ref(<ch-fsm>) appears here verbatim as the pulse sequencer.

#lead[Smart RPM limiter.] A three-stage protection scheme: launch control near 4 000 rpm
(vehicle stopped, brake and full throttle) holds revs by spark retard; a soft cut at
9 000 rpm retards spark in the warning zone; a hard cut at 10 000 rpm cuts fuel in the
danger zone. Spark retard acts on the power stroke and fuel cut on the intake, so the
redline is a hardware property, not a software promise.

#lead[Active spoiler.] Speed stages map to servo targets — closed below 80 km/h, cruise
angle 80–150 km/h, maximum downforce above — and braking at speed deploys the full
air-brake (PWM 255) with its LED. A ±1-step slew limiter moves the servo smoothly, the same
rate-limiting idiom used in the drive controller.

#lead[Ultrasonic parking assist.] An always-on echo timer: a counter starts with the
trigger, stops with the echo return, and the count maps to distance zones (safe, mid,
close, danger) that escalate LED colour and buzzer rate from slow beeps to continuous.

#lead[Multi-mode drive controller.] A lookup table per drive mode (Eco, Normal, Sport,
Track) maps throttle steps to target duty cycles — from Eco's calm 1:2 mapping to Track's
aggressive 3:1 — and a slew-rate limiter (±1 step per window) protects the drivetrain from
step commands. Its duty output can also be handed to the traction module for torque
management, which is how the suite's modules integrate without coupling.

#vcode("project/rtl/Drive_Mode_Controller.v (excerpt)", "alyhamdy879/FPGA-labs-project", include("../snippets/drive.typ"))

== Verification and results

Each module ships a self-checking testbench; all five report passing: lock-up braking,
launch spin and cruising for ABS/TCS; a 0→10 000 rpm sweep plus the launch combination for
the limiter; a speed ramp through all spoiler stages plus a brake stab at speed; short and
long echo pulses for the parking assist; and every mode × throttle combination for the
drive controller. Against the MCU baseline the suite offers parallel execution (five
controllers in one cycle instead of five queued tasks), deterministic reaction time
(identical every run), and isolation (one faulty block cannot hang the others). The
hardware demo used a physical mode dial to switch Eco→Track live, and the design was
reviewed and recognised under the NTI project scheme.

== What the project consolidated

The capstone is where the training's threads tie together: specification-first design
(#ref(<ch-org>)), FSM controllers and datapaths (#ref(<ch-fsm>),
Laboratories 6–9), synchronous coding rules (#ref(<ch-rtl>)), PWM and counters as
the actuator interface (Laboratory 8), self-checking verification (#ref(<ch-rtl>)), and Git
discipline across five contributors — with the timing vocabulary of
#ref(<ch-sta>) as the language of the design reviews.
