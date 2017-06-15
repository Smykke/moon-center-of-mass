points = {}
------- READ FROM FILE -------
-- Output: list of points from input file
function points.pointsFromFile()
  local pointList = {}
  local i = 1
  for line in io.lines() do
    local point = {}
    for w in string.gmatch(line, "%d+%.?%d*") do   -- or "%S+" (everything that is not a space)
      if tonumber(w) then table.insert(point, tonumber(w))  -- store the coordinates
      else
        print("There is an error in line", i); os.exit()
      end
    end
    point.l = i; pointList[i] = point  -- store the line number
    i = i + 1
  end
  points.checkDimension(pointList)
  return pointList
end

------- CHECK NUMBER OF COORDINATES FOR EACH POINT -------
-- Input: list of points
-- Output: none (program stops running is there's a problem)
function points.checkDimension (pointList)
  local dim = #pointList[1]
  for _, p in ipairs(pointList) do
    if dim ~= #p then
      print("There's a problem with the dimension of point ", p.l)
      os.exit()
    end
  end
end

------- SMALLEST SUM OF COORDINATES -------
-- Input: list of (all) points
-- Output: point that has the minimum sum of coordinates
function points.getSmallest (pointList)
  local small = {points.sumPoint(pointList[1]), pointList[1]} -- the first point is the default

  for p = 2, #pointList do
    local sum = points.sumPoint(pointList[p])
    if sum < small[1] then
      small[1] = sum
      small[2] = pointList[p]
    elseif sum == small[1] then small[2] = points.smallestCoord(small[2], pointList[p])
    end
  end
  return small[2]
end

------- SUM OF COORDINATES OF A POINT -------
-- Input: point
-- Output: Sum of the coordinate
function points.sumPoint (point)
  local sum = 0
  for r = 1, #point do
    sum = sum + point[r]
  end
  return sum
end

------- THE MOST DISTANT POINT -------
-- Input: list of points, centroids/points already selected and the reference point
-- Output: point that is the most distant from the reference point
function points.getMostDistant (pointList, previouslySelected, point)
  local distant = {0, point} -- the reference point itself is the default

  for p = 1, #pointList do
    if not points.inList(previouslySelected, pointList[p]) then -- check if the point is not a part of centroids
      local distance = points.euclidean(pointList[p], point)
      if (distance > distant[1]) then
        distant[1] = distance
        distant[2] = pointList[p]
      -- in case of same distance:
      elseif distance == distant[1] then distant[2] = points.smallestCoord(distant[2], pointList[p])
      end
    end
  end
  return distant[2]
end

------- CHECK IF A POINT IS PART OF A LIST -------
-- Input: list of points and a point
-- Output: True or False
function points.inList(pointList, point)
  if points.isEmpty(pointList) then return false end

  for k, p in ipairs(pointList) do
    if p.l == point.l then
      return true
    end
  end
  return false
end

------- CHECK IF A LIST IS EMPTY -------
-- Input: list of points
-- Output: True or False
function points.isEmpty(pointList)
  if not next(pointList) then return true end
  return false
end

------- EUCLIDEAN DISTANCE -------
-- Input: two points
-- Output: distance between them
function points.euclidean(p1, p2)
  local sum = 0
  for p = 1, #p1 do
    sum = sum + (p1[p] - p2[p])^2
  end
  return sum^0.5 -- similar to math.sqrt(sum)
end

------- GET THE POINT THAT HAS THE SMALLEST COORDINATES (TIE BRAKER) -------
-- Input: two points to be compared (this function is a tie braker)
-- Output: the point which has the smallest coordinates
function points.smallestCoord (point1, point2)
  local c = 1
  while c <= #point1 do
    if point1[c] < point2[c] then return point1
    elseif point2[c] < point1[c] then return point2
    end
    c = c + 1
  end
  return point2
end

------- GET THE NEAREST POINT -------
-- Input: list of points and a reference point
-- Output: a point from the list that is nearest from reference point
function points.getNearest (pointList, point)
  local near = {points.euclidean(pointList[1], point), pointList[1], 1}

  for p = 2, #pointList do
    local distance = points.euclidean(pointList[p], point)
    if distance < near[1] then
      near[1] = distance
      near[2] = pointList[p]
      near[3] = p
    elseif distance == near[1] then
      near[2] = points.smallestCoord(near[2], pointList[p])
      near[3] = p
    end
  end

  return near[3]
end


------- GET CENTROID OF A GROUP -------
-- Input: list of points
-- Output: centroid
function points.getCentroid (pointList)
  local centroid = {}
  local dimensions = #pointList[1]
  --print(dimensions)
  local sum = 0
  for i = 1, dimensions do
    for _, p in ipairs(pointList) do sum = sum + p[i] end
    -- for p = 1, #pointList do sum = sum + pointList[p][i] end
    centroid[i] = sum/#pointList
    sum = 0
  end
  --print(#centroid)
  return centroid
end

------- GET A POINT'S POSITION IN A LIST -------
-- Input: list of points and a point
-- Output: the point's position
function points.getPosition (pointList, point)
  for k, p in ipairs(pointList) do
    for i = 1, #p do
      if p[i] ~= point[i] then break end
      return k
    end
  end
end



------- PRINT POINTS -------
-- Input: list of points
-- Output: all points' line numbers printed on output stream defined by io.output
function points.printPoints (pointList)
  if points.isEmpty(pointList) then print("Empty list") end

  for i = 1, #pointList - 1 do
    io.write(pointList[i].l, ", ")
  end
  io.write(pointList[#pointList].l) -- different format for the last number
end

return points
