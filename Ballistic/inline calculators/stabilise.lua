-- MOST COOKED STABILISER EVER
-- WE ARE FUCKING UP THE TANK WITH THIS ONE 🗣️🗣️🗣️
-- NUMBER INPUTS
-- 1 current yaw rotations
-- 2 current pitch rotations
-- 3 current roll rotations
-- 4 target yaw degrees
-- 5 target pitch degrees
-- 6 target roll degrees
-- 7 mouse X / seat ad
-- 8 mouse Y / seat ws
-- 10 mouse sensitivity degrees per tick
-- BOOL INPUTS
-- 1 enable stabiliser
-- 2 mouse mode
-- NUMBER OUTPUTS
-- 1 yaw velocity command
-- 2 pitch velocity command
-- 3 roll velocity command
-- 4 yaw error rotations
-- 5 pitch error rotations
-- 6 roll error rotations
ty, tp, tr = 0, 0, 0
py, pp, pr = 0, 0, 0

function clamp(x, a, b)
    return math.max(a, math.min(b, x))
end

function wrapHalf(a)
    return (a + 0.5) % 1 - 0.5
end

function pid(axis, current, target, previous)
    local err = wrapHalf(target - current)
    local rate = current - previous

    local p = property.getNumber(axis .. " P")
    local d = property.getNumber(axis .. " D")
    local maxOut = property.getNumber("Max Output")

    if p == 0 then p = 8 end
    if d == 0 then d = 35 end
    if maxOut == 0 then maxOut = 1 end

    return clamp(err * p - rate * d, -maxOut, maxOut), err
end

function onTick()


    local cy = input.getNumber(1)
    local cp = input.getNumber(2)
    local cr = input.getNumber(3)

    local enable = input.getBool(1)
    local mouse = input.getBool(2)

    local sens = input.getNumber(10)
    if sens == 0 then sens = property.getNumber("Mouse Sens") end
    if sens == 0 then sens = 1 end

    if mouse then
        ty = wrapHalf(ty + input.getNumber(7) * sens / 360)
        tp = clamp(tp + input.getNumber(8) * sens / 360, -0.247, 0.247)
        tr = wrapHalf(tr + input.getNumber(9) * sens / 360)
    else
        ty = input.getNumber(4) / 360
        tp = input.getNumber(5) / 360
        tr = input.getNumber(6) / 360
    end


    if not enable then
        ty = ty * 0.15
        tp = tp * 0.15
        tr = tr * 0.15

        if math.abs(ty) < 0.001 then ty = 0 end
        if math.abs(tp) < 0.001 then tp = 0 end
        if math.abs(tr) < 0.001 then tr = 0 end
    end

    local yo, ye = pid("Yaw", cy, ty, py)
    local po, pe = pid("Pitch", cp, tp, pp)
    local ro, re = pid("Roll", cr, tr, pr)

    py, pp, pr = cy, cp, cr



    output.setNumber(1, yo)
    output.setNumber(2, po)
    output.setNumber(3, ro)
    output.setNumber(4, ye)
    output.setNumber(5, pe)
    output.setNumber(6, re)
end