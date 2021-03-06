group = {}

------- GROUPS OF FIRST ITERATION -------
-- Input: number of groups (it), list of centroids and list of (all) points
-- Output: list of groups
function group.getFirstGroups (it, centroidList, pointList)
  local centroid, otherCentroid = {}, {}
  while (it > 0) do
    centroid = points.getCentroid(centroidList) -- considers only the previously selected centroids
    otherCentroid = points.getMostDistant(pointList, centroidList, centroid)
    table.insert(centroidList, otherCentroid)
    it = it - 1
  end
  return group.getGroups(pointList, centroidList)
end

------- FINAL GROUP -------
-- Input: max number of iterations, list of first groups and list of (all) points
-- Output: list of final groups
function group.getFinalGroup (n, groupList, pointList)
  local e = 0 -- counter of consecutive rounds where groups don't change
  local i = n - 1
  local newCentroids, currentGroupList = {}, {}

  while i > 0 do
    for k, p in ipairs(groupList) do
      newCentroids[k] = points.getCentroid(p) -- recalculate centroids of each group
    end
    currentGroupList = group.getGroups(pointList, newCentroids) -- rearrange groups
    if group.isEqual(groupList, currentGroupList) then -- verify if the groups change
      e = e + 1
      if e == 2 then
         print("Iterations completed:", n - i + 1)
        break
      end
    elseif e > 0 then
      e = e - 1
    end

    groupList = currentGroupList
    i = i - 1
  end

  return currentGroupList
end

------- DEFINE GROUPS -------
-- Input: list of (all) points and list of centroids (points)
-- Output: list of groups (table of tables of points)
function group.getGroups (pointList, centroidList)
  -- Table initialization (table.insert() can work then)
  local groups, nearCentroid, centroidPosition = {}, {}, {}
  for i = 1, #centroidList do
    groups[i] = {}
  end
  for k, p in ipairs(pointList) do
    centroidPosition = points.getNearest(centroidList, p) -- get the nearest centroid from a particular point
    --centroidPosition = points.getPosition(centroidList, nearCentroid) -- get the centroid's "id" in the list
    table.insert(groups[centroidPosition], p) -- insert the point into a group (by the centroid's id)
  end
  return groups
end

------- COMPARE IF TWO LISTS ARE EQUAL -------
-- Input: two lists
-- Output: True of False
function group.isEqual (groupList1, groupList2)
  for i = 1, #groupList1 do
    if #groupList1[i] ~= #groupList2[i] then return false end
    for j = 1, #groupList1[i] do
      if groupList1[i][j].l ~= groupList2[i][j].l then return false end
    end
   end
   return true
end

------- PRINT GROUPS -------
-- Input: list of groups (table of tables of integers/line numbers)
-- Output: all points' line numbers printed on output stream defined by io.output organized into groups
function group.printGroups (groupList)
  for k, t in ipairs(groupList) do
    points.printPoints(t)
    io.write("\n\n")
  end
end

return group
