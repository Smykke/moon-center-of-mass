----------------------------------------------
-- UFES: Linguagens de Programação 2017/1 ----
-- Trabalho 2 ~ Agrupamento de dados em Lua --
-- Marcela Freitas Vieira --------------------
----------------------------------------------
local p = require("points")
local g = require("group")

--########## BEGIN ##########--
---- Open input file
io.input(assert(io.open("entrada.txt", 'r')))
print("Hello, world.\n> \"entrada.txt\" open.\n")

---- Get the number of groups and iterations from command line
local groupsNum = tonumber(arg[1]); print("Number of groups:", groupsNum)
local iter = tonumber(arg[2]); print("Max number of iterations:", iter)

local allPoints = p.pointsFromFile() -- Read all points from input file

---- First Iteration
local selected = {p.getSmallest(allPoints)} -- "smallest" point
table.insert(selected, p.getMostDistant(allPoints, selected, selected[1])) -- most distant point
local previousGroupList = g.getFirstGroups(groupsNum - 2, selected, allPoints) -- first set of groups
print("quantidade de grupos:", #previousGroupList)
for m, n in ipairs(previousGroupList) do
  print("grupo", m, ":", n[1])
end
---- Other Iterations
local finalGroup = g.getFinalGroup(iter, previousGroupList, allPoints)

io.output(assert(io.open("saida.txt", 'w')))
print("\n> \"saida.txt\" open.")
g.printGroups(finalGroup)

------- End of execution -------
io.input():close(); io.output():close()
print("\n> Files closed\nBye world\n")
--########## END ##########--
