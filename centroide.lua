------- FUNÇÕES -------
function pointsFromFile()
  pointList = {}
  i = 1
  for line in io.lines() do
    point = {}
    for w in string.gmatch(line, "%d+%.?%d*") do   --or "%S+" (everything that is not a space)
      table.insert(point, tonumber(w))  -- Store the coordenates
    end
    point.l = i  -- Store the line number
    pointList[i] = point
    i = i + 1
    size = i
  end
  return pointList
end


function sumPoint (point)
  local sum = 0
  for r = 1, #point do   --change here
    sum = sum + point[r]
  end
  return sum
end

function getSmallest (pointList)
  small = {sumPoint(pointList[1]), pointList[1]}
  for p = 2, #pointList do
    sum = sumPoint(pointList[p])
    if sum < small[1] then
      small[1] = sum
      small[2] = pointList[p]
    elseif sum == small[1] then
      c = 1
      while pointList[p][c] == small[2][c] do c = c + 1 end
      if pointList[p][c] < small[2][c] then small = {sum, pointList[p]} end
    end
  end
  return small[2]
end

function getMostDistant (pointList, small)
  distant = {0, small}
  for p = 2, #pointList do
    distance = euclidean(pointList[p], small)
    if distance > distant[1] then
      distant[1] = distance
      distant[2] = pointList[p]
    elseif distance == distant[1] then
      c = 1
      while pointList[p][c] == distant[2][c] do c = c + 1 end
      if pointList[p][c] < distant[2][c] then distant = {distance, pointList[p]} end
    end
  end
  return distant[2]
end

function getNearest (centroidList, point)
  near = {0, centroidList[1]}
  for p = 2, #centroidList do
    distance = euclidean(centroidList[p], point)
    if distance < near[1] then
      near[1] = distance
      near[2] = pointList[p]
    elseif distance == distant[1] then
      c = 1
      while pointList[p][c] == distant[2][c] do c = c + 1 end
      if pointList[p][c] < distant[2][c] then distant = {distance, pointList[p]} end
    end
  end
  return distant[2]
end


function euclidean(p1, p2)
  sum = 0
  for p = 1, #p1 do
    sum = sum + (p1[p] - p2[p])^2
  end
  return sum^0.5 -- similar to math.sqrt(sum)
end

function getCentroid (pointList)
  centroid = {}
  dimensions = #pointList[1]
  for i = 1, dimensions do
    sum = 0
    for p = 1, #pointList do sum = sum + pointList[p][i] end
    centroid[i] = sum/#pointList
  end
  return centroid
end




------- EXTRA FUNCTIONS -------
function printPoints (pointList)
  --  print("Tam: ", len)
  for p = 1, #pointList do
    print("Ponto", p)
    for q = 1, 4 do
      print(allPoints[p][q])
    end
  end
end

function getGroups (pointList, centroidList)



-------------- MAIN --------------


------- OPEN FILE -------
local inputFile = assert(io.open("entrada.txt", "r"))
io.input(inputFile)

print("\"entrada.txt\" file open.\n")

------- READ POINTS -------
allPoints = pointsFromFile()
printPoints(allPoints, size)

------- GET THE SMALLEST -------
-- for p = 1, i-1 do
--   print("Soma: ", sumPoint(allPoints[p]))
-- end

smallest = getSmallest(allPoints)
print("The smallest sum is from point:", smallest.l)

mostDistant = getMostDistant(allPoints, smallest)
print("The mostDistant from point", smallest.l, "is point", mostDistant.l)

fcentroid = getCentroid({smallest, mostDistant})
print("The centroid is", fcentroid[1], fcentroid[2], fcentroid[3], fcentroid[4])

centroids = {smalles, mostDistant, fcentroid}
groups = getGroups(allPoints, centroids)

------- END OF EXECUTION -------
io.input():close()
print("\nFile closed\n")
