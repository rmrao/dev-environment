local M = {}

function M.setup()
	local leap = require "leap"
	leap.setup{}
	leap.add_default_mappings()
end

return M

