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

function getMostDistant (pointList, previouslySelected, point)
  print("pontos analisados:")
  printPoints(pointList)
  print("pontos selecionados:")
  printPoints(previouslySelected)

  distant = {0, point}
  for p = 1, #pointList do
    if not inList(previouslySelected, pointList[p]) then
      print("considerando o ponto", pointList[p]["l"])
      distance = euclidean(pointList[p], point)
      if (distance > distant[1]) then   -- Check if the number has already been selected
        distant[1] = distance
        distant[2] = pointList[p]
      elseif distance == distant[1] then distant[2] = smallestCoord(distant[2], pointList[p])
      end
    end
  end
  return distant[2]
end

function smallestCoord (point1, point2)
  c = 1
  while c <= #point1 do
    if point1[c] < point2[c] then return point1
    elseif point2[c] < point1[c] then return point2
    end
    c = c + 1
  end
  return point1
end

function inList(pointList, point)
  if isEmpty(pointList) then return false end
  for k, p in ipairs(pointList) do
    if p.l == point.l then
      print("o ponto", p.l, "esta na lista")
      return true
    end
  end
  -- print("não retornei")
  return false
end

function isEmpty(pointList)
  if not next(pointList) then return true end
  return false
end

function getNearest (centroidList, point)
  near = {0, centroidList[1]}
  for p = 1, #centroidList do
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
  print("ret centroid: ", centroid[1], centroid[2], centroid[3])
  return centroid
end




------- EXTRA FUNCTIONS -------
function printPoints (pointList)
  if isEmpty(pointList) then print("Empty list") end
  for n, p in ipairs(pointList) do
    print("Ponto ", p.l)
    --for i = 1, #p do
      --print(p[i])
    --end
  end
end

-- function getGroups (pointList, centroidList)



-------------- MAIN --------------


------- OPEN FILE -------
local inputFile = assert(io.open("entrada.txt", "r"))
io.input(inputFile)

print("\"entrada.txt\" file open.\n")

--print(#arg)
groups = tonumber(arg[1])
print("Quantidade de grupos:", groups)

------- READ POINTS -------
allPoints = pointsFromFile()  -- INSERT THE OPEN FILE PROCESSES INTO THIS FUNCTION?
--printPoints(allPoints)
selected = {}

------- FIRST ITERATION -------
smallest = getSmallest(allPoints)
print("The smallest sum is from point:", smallest.l)
table.insert(selected, smallest)

mostDistant = getMostDistant(allPoints, selected, smallest)
print("The mostDistant from point", smallest.l, "is point", mostDistant.l)

table.insert(selected, mostDistant)

k = groups - 2
while (k > 0) do
  fcentroid = getCentroid(selected)
  --print("f centroid", fcentroid[1])
  --table.insert(selected, fcentroid)
  new = getMostDistant(allPoints, selected, fcentroid)
  print("ULtimo centro: ", new.l)
  table.insert(selected, new)
  k = k - 1
end


print("The centroids are:")
printPoints(selected)

-- groups = getGroups(allPoints, centroids)

------- END OF EXECUTION -------
io.input():close()
print("\nFile closed\n")
