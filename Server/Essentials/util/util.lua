-- By jojos38

-- https://gist.github.com/ripter/4270799
function dump(header, tbl, indentSize, indent)
	if not indent then indent = 0 end
	if not indentSize then indentSize = 1 end
	for k, v in pairs(tbl) do
		formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			logLine(header, formatting)
			dump(header, v, indentSize, indent + indentSize)
		elseif type(v) == 'boolean' then
			logLine(header, formatting .. tostring(v))		
		else
			logLine(header, formatting .. v)
		end
	end
end



-- https://gist.github.com/jaredallard/ddb152179831dd23b230
function string:split(delimiter)
	local result = {}
	local from  = 1
	local delim_from, delim_to = string.find(self, delimiter, from )
	while delim_from do
		table.insert( result, string.sub(self, from , delim_from-1 ))
		from  = delim_to + 1
		delim_from, delim_to = string.find(self, delimiter, from)
	end
	table.insert( result, string.sub(self, from))
	return result
end



function readYamlFile(filePath)
	local success, f = pcall(assert, io.open(filePath, "rb"))
	if success then
		if not f then
			log('e', "Error while loading file "..filePath)
			return
		end
		local content = f:read("*all")
		f:close()
		return yaml.eval(content)
	else
		return nil
	end
end