export type InsertModelArgs = {
	query: string,
}

export type RunCodeArgs = {
	command: string,
}

export type ToolFunction = (ToolArgs) -> string?

export type DeletePartArgs = {
    partName: string,
}

export type ToolArgs = { InsertModel: InsertModelArgs } | { RunCode: RunCodeArgs } | { DeletePart: DeletePartArgs }

return {}
