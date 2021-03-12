-- By jojos38

local function getConfig(pluginName)
	local configFile = readYamlFile(pluginPath..pluginName.."/config.yml")
	if configFile then
		log('i', "Loaded config file for plugin "..pluginName)
	else
		log('w', "No config file found for plugin "..pluginName)
	end
end

return {
	getConfig = getConfig
}