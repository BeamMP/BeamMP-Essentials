-- ============================ IMPORTS ============================ --
selfPath = debug.getinfo(1).source:sub(2):gsub("main.lua", ""):gsub("\\", "/")
utilpath = selfPath.."util/"
pluginPath = selfPath.."plugins/"
yaml = require(utilpath.."yaml")
require(utilpath.."util")
require(utilpath.."logger")
-- ============================ IMPORTS ============================ --



-- ==================== VARIABLES ==================== --
globalConfig = readYamlFile(selfPath.."config.yml")
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
		local status, requiredPlugin = pcall(require, pluginPath..plugin)
		if not status then
			log('e', "Error loading "..plugin.." plugin")
			log('e', requiredPlugin)
		end
	end
	log('s', "BeamMP Essentials ready")
end
-- ==================== FUNCTIONS ==================== --