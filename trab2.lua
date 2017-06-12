----------------------------------------------
-- UFES: Linguagens de Programação 2017/1 ----
-- Trabalho 2 ~ Agrupamento de dados em Lua --
-- Marcela Freitas Vieira --------------------
----------------------------------------------


------- READ FROM FILE -------
-- Output: list of points from input file
function pointsFromFile()
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
  checkDimension(pointList)
  return pointList
end

------- CHECK NUMBER OF COORDINATES FOR EACH POINT -------
-- Input: list of points
-- Output: none (program stops running is there's a problem)
function checkDimension (pointList)
  local dim = #pointList[1]
  for _, p in ipairs(pointList) do
    if dim ~= #p then
      print("There's a problem with the dimension of point ", p.l)
      os.exit()
    end
  end
end

------- SUM OF COORDINATES OF A POINT -------
-- Input: point
-- Output: Sum of the coordinate
function sumPoint (point)
  local sum = 0
  for r = 1, #point do
    sum = sum + point[r]
  end
  return sum
end

------- SMALLEST SUM OF COORDINATES -------
-- Input: list of (all) points
-- Output: point that has the minimum sum of coordinates
function getSmallest (pointList)
  local small = {sumPoint(pointList[1]), pointList[1]} -- the first point is the default

  for p = 2, #pointList do
    local sum = sumPoint(pointList[p])
    if sum < small[1] then
      small[1] = sum
      small[2] = pointList[p]
    elseif sum == small[1] then small[2] = smallestCoord(small[2], pointList[p])
    end
  end
  return small[2]
end

------- THE MOST DISTANT POINT -------
-- Input: list of points, centroids/points already selected and the reference point
-- Output: point that is the most distant from the reference point
function getMostDistant (pointList, previouslySelected, point)
  local distant = {0, point} -- the reference point itself is the default

  for p = 1, #pointList do
    if not inList(previouslySelected, pointList[p]) then -- check if the point is not a part of centroids
      local distance = euclidean(pointList[p], point)
      if (distance > distant[1]) then
        distant[1] = distance
        distant[2] = pointList[p]
      -- in case of same distance:
      elseif distance == distant[1] then distant[2] = smallestCoord(distant[2], pointList[p])
      end
    end
  end
  return distant[2]
end

------- GET THE POINT THAT HAS THE SMALLEST COORDINATES (TIE BRAKER) -------
-- Input: two points to be compared (this function is a tie braker)
-- Output: the point which has the smallest coordinates
function smallestCoord (point1, point2)
  local c = 1
  while c <= #point1 do
    if point1[c] < point2[c] then return point1
    elseif point2[c] < point1[c] then return point2
    end
    c = c + 1
  end
  return point2
end

------- CHECK IF A POINT IS PART OF A LIST -------
-- Input: list of points and a point
-- Output: True or False
function inList(pointList, point)
  if isEmpty(pointList) then return false end

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
function isEmpty(pointList)
  if not next(pointList) then return true end
  return false
end

------- GET THE NEAREST POINT -------
-- Input: list of points and a reference point
-- Output: a point from the list that is nearest from reference point
function getNearest (pointList, point)
  local near = {euclidean(pointList[1], point), pointList[1]}

  for p = 2, #pointList do
    local distance = euclidean(pointList[p], point)
    if distance < near[1] then
      near[1] = distance
      near[2] = pointList[p]
    elseif distance == near[1] then near[2] = smallestCoord(near[2], pointList[p])
    end
  end

  return near[2]
end

------- EUCLIDEAN DISTANCE -------
-- Input: two points
-- Output: distance between them
function euclidean(p1, p2)
  local sum = 0
  for p = 1, #p1 do
    sum = sum + (p1[p] - p2[p])^2
  end
  return sum^0.5 -- similar to math.sqrt(sum)
end

------- GET CENTROID OF A GROUP -------
-- Input: list of points
-- Output: centroid
function getCentroid (pointList)
  local centroid = {}
  local dimensions = #pointList[1]
  for i = 1, dimensions do
    local sum = 0
    for p = 1, #pointList do sum = sum + pointList[p][i] end
    centroid[i] = sum/#pointList
  end
  return centroid
end

------- GET A POINT'S POSITION IN A LIST -------
-- Input: list of points and a point
-- Output: the point's position
function getPosition (pointList, point)
  for k, p in ipairs(pointList) do
    for i = 1, #p do
      if p[i] ~= point[i] then break end
      return k
    end
  end
end

------- COMPARE IF TWO LISTS ARE EQUAL -------
-- Input: two lists
-- Output: True of False
function isEqual (pointList1, pointList2)
  local len = #pointList1 -- length of list
  local dim = #pointList1[1] -- length/dimensions of a point
  for i = 1, len do
    for j = 1, dim do
      if pointList1[i][j] ~= pointList2[i][j] then return false end
    end
  end
  return true
end

------- PRINT POINTS -------
-- Input: list of points
-- Output: all points' line numbers printed on output stream defined by io.output
function printPoints (pointList)
  if isEmpty(pointList) then print("Empty list") end

  for i = 1, #pointList - 1 do
    io.write(pointList[i].l, ", ")
  end
  io.write(pointList[#pointList].l) -- different format for the last number
end

------- PRINT GROUPS -------
-- Input: list of groups (table of tables of integers/line numbers)
-- Output: all points' line numbers printed on output stream defined by io.output organized into groups
function printGroups (groupList)
  for k, t in ipairs(groupList) do
    printPoints(t)
    io.write("\n\n")
  end
end

------- DEFINE GROUPS -------
-- Input: list of (all) points and list of centroids (points)
-- Output: list of groups (table of tables of points)
function getGroups (pointList, centroidList)
  -- Table initialization (table.insert() can work then)
  local groups, nearCentroid, centroidPosition = {}, {}, {}
  for i = 1, #centroidList do
    groups[i] = {}
  end

  for k, p in ipairs(pointList) do
    nearCentroid = getNearest(centroidList, p) -- get the nearest centroid from a particular point
    centroidPosition = getPosition(centroidList, nearCentroid) -- get the centroid's "id" in the list
    table.insert(groups[centroidPosition], p) -- insert the point into a group (by the centroid's id)
  end
  return groups
end

------- GROUPS OF FIRST ITERATION -------
-- Input: number of groups (it), list of centroids and list of (all) points
-- Output: list of groups
function getFirstGroups (it, centroidList, pointList)
  local centroid, otherCentroid = {}, {}
  while (it > 0) do
    centroid = getCentroid(centroidList) -- considers only the previously selected centroids
    otherCentroid = getMostDistant(pointList, centroidList, centroid)
    table.insert(centroidList, otherCentroid)
    it = it - 1
  end

  return getGroups(pointList, centroidList)
end

------- FINAL GROUP -------
-- Input: max number of iterations, list of first groups and list of (all) points
-- Output: list of final groups
function getFinalGroup (n, groupList, pointList)
  local e = 0 -- counter of consecutive rounds where groups don't change
  local newCentroids, currentGroupList = {}, {}

  while n > 0 do
    for k, p in ipairs(groupList) do
      newCentroids[k] = getCentroid(p) -- recalculate centroids of each group
    end
    currentGroupList = getGroups(pointList, newCentroids) -- rearrange groups

    if isEqual(groupList, currentGroupList) then -- verify if the groups change
      e = e + 1
      if e == 2 then
        print("Iterations completed:", iter - n + 1)
        break
      end
    elseif e > 0 then
      e = e - 1
    end

    groupList = currentGroupList
    n = n - 1
  end

  return currentGroupList
end




--########## BEGIN ##########--
---- Open input file
io.input(assert(io.open("entrada.txt", 'r')))
print("Hello, world.\n> \"entrada.txt\" open.\n")

---- Get the number of groups and iterations from command line
groupsNum = tonumber(arg[1]); print("Number of groups:", groupsNum)
iter = tonumber(arg[2]); print("Number of iterations:", iter)

allPoints = pointsFromFile() -- Read all points from input file

---- First Iteration
selected = {getSmallest(allPoints)} -- "smallest" point
table.insert(selected, getMostDistant(allPoints, selected, selected[1])) -- most distant point
previousGroupList = getFirstGroups(groupsNum - 2, selected, allPoints) -- first set of groups

---- Other Iterations
finalGroup = getFinalGroup(iter - 1, previousGroupList, allPoints)

io.output(assert(io.open("saida.txt", 'w')))
print("\n> \"saida.txt\" open.")
printGroups(finalGroup)

------- End of execution -------
io.input():close(); io.output():close()
print("\n> Files closed\nBye world\n")
--########## END ##########--
