PI=math.pi
TAU=math.pi*2
DEG=math.pi/180
function clamp(val, min, max) return math.min(math.max(val, min), max) end
function lerp(a, b, t) return a + (b - a) * t end
function map(t, a, b, c, d) return ((t - a) / (b - a)) * (d - c) + c end -- map a-b to c-d according to t

vec=function(x,y,z) return {x=x,y=y,z=z} end
function vec_add(A,B) return vec(A.x+B.x,A.y+B.y,A.z+B.z) end
function vec_sub(A,B) return vec(A.x-B.x,A.y-B.y,A.z-B.z) end
function vec_scal(A,n) return vec(A.x*n,A.y*n,A.z*n) end
function vec_dot(A,B) return A.x*B.x+A.y*B.y+A.z*B.z end
function vec_div(A,n) return vec_scal(A,1/n) end
function vec_length(A) return math.sqrt(A.x*A.x+A.y*A.y+A.z*A.z) end
function vec_norm(A) return vec_length(A)~=0 and vec_div(A,vec_length(A)) or vec(0,0,0) end
function vec_cross(A,B) return vec(A.y*B.z-A.z*B.y,A.z*B.x-A.x*B.z,A.x*B.y-A.y*B.x) end
function vec_lerp(A,B,t) return vec_add(A,vec_scal(vec_sub(B,A),t)) end

-- Property settings --

-- Activation Delay: ticks to wait after launch before activating booster
-- Guidance Delay: ticks to wait after launch before guiding

-- Guidance Mode: 0 for direct, 1 for cruising, 2 for ballistic

-- Ejection Turn: none/up/down, if true missile will pitch down fully after launch to clear the vehicle

-- Roll Control: true/false
-- Roll Gain: proportional gain for roll control, only used if Roll Control is true
-- Max Roll: the angle the missile will roll to during turns, in degrees

-- Terrain Following: true/false
-- Follow Angle: the angle the missile will pitch to to follow terrain
-- Follow Max Distance: the distance from terrain at which the missile will begin to pitch up
-- Follow Min Distance: the distance from terrain at which the missile will reach the max follow angle

-- Max Angle: limits the angle of ascent during cruise phase, in degrees
-- Cruise Altitude: altitude at which missile will cruise until dive phase, in meters
-- Altitude Gain: Proportional gain for altitude control during cruise phase

-- Dive Distance: distance from target at which missile will transition from cruise to dive, in meters

-- Guidance Gain: proportional gain for yaw and pitch control

-- Yaw Trim: added to yaw control before output
-- Pitch Trim: same thing

-- Altitude Trim: the angle the missile needs to hold to maintain altitude

activation_delay = property.getNumber("Activation Delay") -- in ticks
guidance_delay = property.getNumber("Guidance Delay")

guidance_mode = property.getNumber("Guidance Mode") -- 0 for direct, 1 for cruising, 2 for ballistic

ejection_turn = property.getNumber("Ejection Turn") -- 0 for none, 1 for up, 2 for down

roll_control = property.getBool("Roll Control")
roll_gain = property.getNumber("Roll Gain")
max_roll = property.getNumber("Max Roll") / DEG -- in degrees

terrain_following = property.getBool("Terrain Following")
follow_angle = property.getNumber("Follow Angle") / DEG -- in degrees
follow_max_distance = property.getNumber("Follow Max Distance")
follow_min_distance = property.getNumber("Follow Min Distance")

max_angle = property.getNumber("Max Angle") / DEG -- in degrees
cruise_altitude = property.getNumber("Cruise Altitude")
altitude_gain = property.getNumber("Altitude Gain")

dive_distance = property.getNumber("Dive Distance")

guidance_gain = property.getNumber("Guidance Gain")

yaw_trim = property.getNumber("Yaw Trim")
pitch_trim = property.getNumber("Pitch Trim")

altitude_trim = property.getNumber("Altitude Trim")