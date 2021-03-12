-- By jojos38

-- ============================ IMPORTS ============================ --
selfPath = debug.getinfo(1).source:sub(2):gsub("main.lua", ""):gsub("\\", "/")
utilPath = selfPath.."util/"
pluginPath = selfPath.."plugins/"
configManager = require(utilPath.."config")
yaml = require(utilPath.."yaml")
json = require(utilPath.."json") -- Not used but might have use
require(utilPath.."util")
require(utilPath.."logger")
-- ============================ IMPORTS ============================ --



-- ==================== VARIABLES ==================== --
config = {}
config.global = readYamlFile(selfPath.."config.yml")
local plugins = {
	"commands",
	"afk"
}
-- ==================== VARIABLES ==================== --



-- ==================== FUNCTIONS ==================== --
function onInit()
	log('i', "BeamMP Essentials initializing...")
	log('i', "Loading plugins...")
	for _, plugin in pairs(plugins) do
		config[plugin] = configManager.getConfig(plugin)
		local status, requiredPlugin = pcall(require, pluginPath..plugin)
		if not status then
			log('e', "Error loading "..plugin.." plugin")
			log('e', requiredPlugin)
		end
	end
	log('s', "BeamMP Essentials ready")
end
-- ==================== FUNCTIONS ==================== --