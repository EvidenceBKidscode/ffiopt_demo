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

ffiopt_demo = {}
ffiopt_demo.name = minetest.get_current_modname()
ffiopt_demo.path = minetest.get_modpath(ffiopt_demo.name)

ffiopt_demo.log = function(message)
	minetest.chat_send_all(message)
	minetest.log("action", "[ffiopt_demo] "..message)
end

-- A large area for voxelmanip demos
ffiopt_demo.minp = { x=-200, y=-200, z=-200 }
ffiopt_demo.maxp = { x=200, y=200, z=200 }

dofile(ffiopt_demo.path..'/emerge.lua')
dofile(ffiopt_demo.path..'/profile.lua')
dofile(ffiopt_demo.path..'/vmanipdemo.lua')
dofile(ffiopt_demo.path..'/noisedemo.lua')
