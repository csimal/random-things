require "turtle"
require "math"

iterations = 12 --the number of iterations to perform
branchLength = 15 --the length of each branch in pixels
root = {{x=0, y=0, source = nil, index = 1}}  --The root of the tree
lastBranch = 1 -- the index at which begins the next iteration

function drawBranch(node)
  line(node.source.x*branchLength, node.source.y*branchLength, node.x*branchLength, node.y*branchLength)
end

function addNode(tree, posx, posy, parent) --creates a new node in tree and draw it
  table.insert(tree, {x = posx, y = posy, source = parent, index = #tree +1})
  drawBranch(tree[#tree])
end

function removeNode(tree, node) --remove node from tree
  local index = node.index
  table.remove(tree, index)
  for i = index, #tree do
    local leaf = tree[i]
    leaf.index = leaf.index-1
  end
end

function getVec(node)
  local x = node.x - node.source.x
  local y = node.y -node.source.y
  return x, y
end

function branch(tree, node)--creates two branch nodes sourced at node and remove node from the tree
  local dx, dy = getVec(node)
  
  if dx == 0 then
    addNode(tree, node.x-1, node.y+dy, node)
    addNode(tree, node.x+1, node.y+dy, node)
  elseif dy == 0 then
    addNode(tree, node.x + dx, node.y - 1, node)
    addNode(tree, node.x + dx, node.y + 1, node)
  else
    addNode(tree, node.x + dx, node.y, node)
    addNode(tree, node.x, node.y + dy, node)
  end
end

function antibranch(tree, node1, node2)
  local x1, y1 = getVec(node1)
  local x2, y2 = getVec(node2)
  local x, y = x1+x2, y1+y2
  if x ~= 0 then x = x/math.abs(x) end
  if y ~= 0 then y = y/math.abs(y) end
  
  addNode(tree, node1.x+x, node1.y+y, node1)
end

function nodeComp(node1, node2)
  return (node1.x == node2.x and node1.y == node2.y and node1.source ~= node2.source)
end

function nodeMeet(tree, node) --check if node is meeting another node in the tree
  for i=1, #tree do
    leaf = tree[i]
    if nodeComp(leaf, node) then
      return leaf.index
    end
  end
  return nil
end

function nodeEquals(node1, node2)
  return (node1.x == node2.x) and (node1.y == node2.y) and (node1.source.x == node2.source.x) and (node1.source.y == node2.source.y) and (node1.index ~= node2.index)
end
function scalarProduct(node1, node2)
  local x1, y1 = getVec(node1)
  local x2, y2 = getVec(node2)
  return x1*x2 + y1*y2
end  
  
function clean(tree) --remove redundant nodes
  for i = 1, #tree do
    for j = i+1, #tree do
      if nodeEquals(tree[i], tree[j]) then
        removeNode(tree, tree[j])
      end
    end
  end
end

--[[ main ]]--
local rootNode = root[1]
addNode(root, 1, 0, rootNode)
addNode(root, 0, 1, rootNode)
addNode(root, -1, 0, rootNode)
addNode(root, 0, -1, rootNode)



for i = 1, iterations do
  --clean(root)
  max = #root
  for j = lastBranch+1, max do
    local k = nodeMeet(root, root[j])
    if not k then
        branch(root, root[j])
    elseif scalarProduct(root[j], root[k]) == 0 then antibranch(root, root[j], root[k]) else
    end
  end
  lastBranch = max
  wait(1)
end
wait() 