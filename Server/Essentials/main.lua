-- By jojos38

-- ============================ IMPORTS ============================ --
selfPath = debug.getinfo(1).source:sub(2):gsub("main.lua", ""):gsub("\\", "/")
utilPath = selfPath.."util/"
pluginPath = selfPath.."plugins/"
json = require(utilPath.."json") -- Not used but might have use
require(utilPath.."util")
require(utilPath.."logger")
-- ============================ IMPORTS ============================ --



-- ==================== VARIABLES ==================== --
-- config = {}
-- config.global = readJsonFile(selfPath.."config.json")
-- ==================== VARIABLES ==================== --



-- ==================== FUNCTIONS ==================== --
function onInit()
	log('i', "BeamMP Essentials initializing...")
	RegisterEvent("log", "log")
	log('s', "BeamMP Essentials ready")
end
-- ==================== FUNCTIONS ==================== --