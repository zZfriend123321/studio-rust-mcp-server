local Main = script:FindFirstAncestor("MCPStudioPlugin")
local Types = require(Main.Types)

local function serializeValue(value: any): string
	local valueType = typeof(value)
	if valueType == "string" then
		return '"' .. value .. '"'
	elseif valueType == "number" or valueType == "boolean" then
		return tostring(value)
	elseif valueType == "Vector3" then
		return string.format("Vector3(%g, %g, %g)", value.X, value.Y, value.Z)
	elseif valueType == "CFrame" then
		local pos = value.Position
		return string.format("CFrame(%g, %g, %g, ...)", pos.X, pos.Y, pos.Z)
	elseif valueType == "Color3" then
		return string.format("Color3(%g, %g, %g)", value.R, value.G, value.B)
	else
		return tostring(value)
	end
end

local function getProperties(instance: Instance, detailed: boolean): string
	if not detailed then return "" end
	
	local props = {}
	local importantProps = {
		"Name", "Position", "Size", "CFrame", "Color", "Material", 
		"Transparency", "CanCollide", "Anchored", "Text", "Value"
	}
	
	for _, propName in importantProps do
		local success, value = pcall(function()
			return instance[propName]
		end)
		if success and value ~= nil then
			table.insert(props, string.format("  %s: %s", propName, serializeValue(value)))
		end
	end
	
	return if #props > 0 then "\n" .. table.concat(props, "\n") else ""
end

local function getSourceCode(instance: Instance): string
	if instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
		local success, source = pcall(function()
			return instance.Source
		end)
		if success and source and source ~= "" then
			return "\n--- SOURCE CODE ---\n" .. source .. "\n--- END SOURCE ---"
		end
	end
	return ""
end

local function traverseInstance(instance: Instance, depth: number, maxDepth: number, detailed: boolean): string
	if depth > maxDepth then return "" end
	
	local indent = string.rep("  ", depth)
	local result = string.format("%s%s (%s)", indent, instance.Name, instance.ClassName)
	
	result = result .. getProperties(instance, detailed)
	
	if detailed then
		result = result .. getSourceCode(instance)
	end
	
	local children = instance:GetChildren()
	if #children > 0 then
		for _, child in children do
			result = result .. "\n" .. traverseInstance(child, depth + 1, maxDepth, detailed)
		end
	end
	
	return result
end

local function getProjectStructure(detail: string, maxDepth: number, rootPath: string?): string
	local detailed = detail == "detailed"
	local maxD = math.min(maxDepth or 10, 20)
	
	local root = workspace
	if rootPath and rootPath ~= "" then
		local parts = string.split(rootPath, ".")
		for _, part in parts do
			local child = root:FindFirstChild(part)
			if child then
				root = child
			else
				return "Path not found: " .. rootPath
			end
		end
	end
	
	local header = string.format("=== PROJECT STRUCTURE (%s) ===\nRoot: %s\nMax Depth: %d\n", 
		detail:upper(), root:GetFullName(), maxD)
	
	return header .. traverseInstance(root, 0, maxD, detailed)
end

local function handleGetProjectStructure(args: Types.ToolArgs): string?
	if not args["GetProjectStructure"] then
		return nil
	end
	
	local structureArgs: Types.GetProjectStructureArgs = args["GetProjectStructure"]
	
	local detail = structureArgs.detail or "minimal"
	if detail ~= "minimal" and detail ~= "detailed" then
		error("Detail must be 'minimal' or 'detailed'")
	end
	
	return getProjectStructure(detail, structureArgs.maxDepth or 5, structureArgs.rootPath)
end

return handleGetProjectStructure :: Types.ToolFunction
