--changes the color of the console.
local function color(fg, bg)
	if globalConfig.consoleColor then
		if bg then return string.char(27) .. '[' .. tostring(fg) .. ';' .. tostring(bg) .. 'm'
		else return string.char(27) .. '[' .. tostring(fg) .. 'm'
		end
	else return ""
	end
end



function log(header, message, indentSize)
	if not header and not message then
		logLine('i', "")
		return
	end
	if not message then message = "nil" end
	
	-- If it's a table, use the table printing
	if (type(message) == "table") then
		dump(header, message, indentSize)
		return
	end

	-- If it's not a table, print each row
	local s = message:split("\n")
	for _, line in pairs(s) do
		logLine(header, line)
	end

end

-- Indent size is only used for tables
function logLine(header, message)
	local out = ("["..os.date("%d/%m/%Y %X", os.time()).."] "):gsub("/0", "/"):gsub('%[0', '[')
	if header == "w" or header == "warn" then
		out = out .. "[" .. color(33) .. "WARN" .. color(0) .. "] "
	elseif header == "c" or header == "chat" then
		out = out .. "[" .. color(36) .. "CHAT" .. color(0) .. "] "
	elseif header == "d" or header == "debug" then
		out = out .. "[" .. color(35) .. "DBUG" .. color(0) .. "] "
	elseif header == "i" or header == "info"then
		out = out .. "[" .. color(94) .. "INFO" .. color(0) .. "] "
	elseif header == "e" or header == "error" then
		out = out .. "[" .. color(31) .. "ERRO" .. color(0) .. "] "
	elseif header == "s" or header == "success" then
		out = out .. "[" .. color(32) .. "INFO" .. color(0) .. "] "
	end
	print(out..color(0)..message)
end