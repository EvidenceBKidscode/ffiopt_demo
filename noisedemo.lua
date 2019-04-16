--[[
	FFIopt Demo - A demo mod for FFIopt Minetest mod
	(c) Pierre-Yves Rollo

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published
	by the Free Software Foundation, either version 2.1 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

local log, profile = ffiopt_demo.log, ffiopt_demo.profile
local minp, maxp = ffiopt_demo.minp, ffiopt_demo.maxp

minetest.register_chatcommand("pn", {
	params = "",
	description = "PerlinNoise demo",
	func = function()
		log('Starting PerlinNoise demo')
		log(string.format('Volume : %s to %s', minetest.pos_to_string(minp), minetest.pos_to_string(maxp)))
		profile.init()
		profile.start("total")

		local params = {
			offset = 0,
			scale = 1,
			spread = {x=2048, y=2048, z=2048},
			seed = 1337,
			octaves = 6,
			persist = 0.6
		}
		local map_lengths_xyz = {x=maxp.x - minp.x + 1, y=maxp.y - minp.y + 1, z=maxp.z - minp.z + 1}

		profile.start("get_perlin_map")
		local perlin_map = minetest.get_perlin_map(params, map_lengths_xyz)
		profile.stop("get_perlin_map")
		profile.start("get3dMap_flat")
		local flatmap = perlin_map:get3dMap_flat(minp)
		profile.stop("get3dMap_flat")
		profile.start("lua processing")

		local perlin_index = 1
		local histogram = {}
		for z = minp.z, maxp.z do
			for y = minp.y, maxp.y do
				for x = minp.x, maxp.x do
					-- Compute an histogram for fun
					local histoix = math.floor(flatmap[perlin_index]*10)
					histogram[histoix] = 1 + (histogram[histoix] or 0)
					perlin_index = perlin_index + 1
				end
			end
		end

		profile.stop("lua processing")
		profile.stop("total")
		log('Ending VoxelManip demo')
		profile.show(log)
	end
})
