-- Ballistic Calculator v1
-- This script calculates the firing angle for a projectile to hit a target at a given distance,
-- taking into account gravity and air resistance (drag). It's designed for use in a game or simulation
-- environment, likely Stormworks, where projectiles follow ballistic trajectories.

-- Bullet parameters
muzzle_velocity = 800          -- Initial velocity of the projectile (units per second)
drag = 0.002 * 60  -- Drag coefficient, scaled by 60 (likely for per-tick simulation)
lifeSpan = 1500 / 60  -- Maximum lifespan of the projectile in seconds (converted from ticks)

gravity = 30             -- Gravity acceleration (units per second squared)
error = 0.1        -- Error tolerance for the solution (acceptable vertical error in units)

-- Function to solve for the firing angle given a target distance
-- Uses an iterative method to find the angle where the projectile hits the target
function solve(dist)
    x = dist      -- Horizontal distance to target
    yT = 0        -- Target vertical position (assuming flat ground)

    a = 0         -- Initial guess for angle (radians)
    t = 0         -- Time of flight

    -- Iterate up to 10 times to refine the angle
    for k = 1, 10 do
        vx = muzzle_velocity * math.cos(a)  -- Horizontal component of velocity
        vy = muzzle_velocity * math.sin(a)  -- Vertical component of velocity

        t = getTime(vx, x)  -- Calculate time to reach horizontal distance
        if t > lifeSpan then  -- Check if time exceeds projectile lifespan
            return a, false  -- Return angle and failure flag
        end

        y = getY(vy, t)  -- Calculate vertical position at time t

        if y >= yT - error then  -- Check if vertical position is within error tolerance
            return a, true     -- Return angle and success flag
        end

        -- Adjust angle using atan approximation for correction
        a = a - math.atan(y, x)
    end

    return a, t, false  -- Return angle, time, and failure flag after max iterations
end


-- Function to calculate vertical position at time t with initial vertical velocity v
-- Accounts for gravity and drag using the equation of motion
function getY(v, t)
    return -gravity * t / drag + (gravity / drag + v) * (1 - math.exp(-drag * t)) / drag
end


-- Function to calculate time to reach horizontal distance x with initial horizontal velocity v
-- Solves the drag equation for time
function getTime(v, x)
    return -math.log(1 - drag * x / v) / drag
end


-- Main tick function, called every simulation tick
function onTick()
    -- Note: 'dist' is assumed to be a global variable representing current target distance
    local drp, ok = solve(dist)  -- Solve for drop angle and success flag
    if ok then
        offset = dist * math.tan(drp)  -- Calculate horizontal offset for aiming
        time = t  -- Set time of flight (note: 't' may not be defined here, potential bug)
    end
end