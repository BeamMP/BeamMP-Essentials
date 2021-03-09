--changes the color of the console.
local function color(fg, bg)
	if config.consoleColor then
		if bg then return string.char(27) .. '[' .. tostring(fg) .. ';' .. tostring(bg) .. 'm'
		else return string.char(27) .. '[' .. tostring(fg) .. 'm'
		end
	else return ""
	end
end



function log(header, message)
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