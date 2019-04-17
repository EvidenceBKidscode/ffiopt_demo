--[[
	FFIopt Demo - A demo mod for FFIopt Minetest mod
	(c) EvidenceBKidscode

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published
	by the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

local log, profile = ffiopt_demo.log, ffiopt_demo.profile
local minp, maxp = ffiopt_demo.minp, ffiopt_demo.maxp

local c_stone = minetest.get_content_id("default:stone")
local c_glass = minetest.get_content_id("default:glass")

minetest.register_chatcommand("vm", {
	params = "",
	description = "VoxelManip demo",
	func = function()
		if not ffiopt_demo.emerged then
			return false, "Map not emerged, please issue /emerge first"
		end

		local histogram = {}

		log('Starting VoxelManip demo')
		log(string.format('Volume : %s to %s', minetest.pos_to_string(minp), minetest.pos_to_string(maxp)))
		profile.init()
		profile.start("total")
		local vm = minetest.get_voxel_manip()
		profile.start("read_from_map")
		local emin, emax = vm:read_from_map(minp, maxp)
		profile.stop("read_from_map")
		local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
		profile.start("get_data")
		local data = vm:get_data()
		profile.stop("get_data")

		profile.start("lua processing")
		-- Make some data processing on vmanip
		for z = minp.z, maxp.z do
			for y = minp.y, maxp.y do
				local vmix = area:index(minp.x, y, z)
				for x = minp.x, maxp.x do
					-- Compute an histogram for fun
					histogram[data[vmix]] = 1 + (histogram[data[vmix]] or 0)
					vmix = vmix + 1

					-- Do something visual : replace stone with glass and inversely
					if data[vmix] == c_stone then
						data[vmix] = c_glass
					elseif data[vmix] == c_glass then
						data[vmix] = c_stone
					end
				end
			end
		end
		profile.stop("lua processing")

		profile.start("set_data")
		vm:set_data(data)
		profile.stop("set_data")
		profile.start("write_to_map")
		vm:write_to_map(false)
		profile.stop("write_to_map")

		profile.stop("total")
		log('Ending VoxelManip demo')
		profile.show(log)
	end
})
