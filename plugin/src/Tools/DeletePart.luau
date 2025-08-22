local Main = script:FindFirstAncestor("MCPStudioPlugin")
local Types = require(Main.Types)

local function handleDeletePart(args: Types.ToolArgs): string?
    if not args["DeletePart"] then
        return nil
    end
    
    local deletePartArgs: Types.DeletePartArgs = args["DeletePart"]
    local part = workspace:FindFirstChild(deletePartArgs.partName)
    
    if part then
        part:Destroy()
        return "Deleted " .. deletePartArgs.partName
    else
        return "Part not found: " .. deletePartArgs.partName
    end
end

return handleDeletePart :: Types.ToolFunction
