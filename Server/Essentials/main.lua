-- ============================ IMPORTS ============================ --
local pluginPath = debug.getinfo(1).source:sub(2):gsub("main.lua", ""):gsub("\\", "/")
json = require(pluginPath.."util/json")
require(pluginPath.."util/util")
require(pluginPath.."util/logger")
-- ============================ IMPORTS ============================ --



-- ==================== VARIABLES ==================== --
config = readJsonFile(pluginPath.."config.json")
local plugins = {
	"afk"
}
-- ==================== VARIABLES ==================== --



-- ==================== FUNCTIONS ==================== --
function onInit()
	log('i', "BeamMP Essentials initializing...")
	log('i', "Loading plugins...")
	for _, plugin in pairs(plugins) do
		require(pluginPath.."plugins/"..plugin)
	end
	log('s', "BeamMP Essentials ready")
end
-- ==================== FUNCTIONS ==================== --