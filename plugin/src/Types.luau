export type InsertModelArgs = {
	query: string,
}

export type RunCodeArgs = {
	command: string,
}

export type DeletePartArgs = {
	partName: string,
}

export type GetProjectStructureArgs = {
	detail: string, -- "minimal" or "detailed"
	maxDepth: number?,
	rootPath: string?,
}

export type ToolArgs = { 
	InsertModel: InsertModelArgs 
} | { 
	RunCode: RunCodeArgs 
} | { 
	DeletePart: DeletePartArgs 
} | { 
	GetProjectStructure: GetProjectStructureArgs 
}

export type ToolFunction = (ToolArgs) -> string?

return {}
