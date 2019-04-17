--[[
	FFIopt Demo - A demo mod for FFIopt Minetest mod
	(c) Pierre-Yves Rollo

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

local state = {}

local function emerge_callback(blockpos, action, calls_remaining, id)
	if state[id].calls == nil then
		state[id].calls = calls_remaining
	end
	if calls_remaining == 0 then
		state[id] = nil
		minetest.chat_send_all("Emerging done")
		ffiopt_demo.emerged = true
	else
		if state[id].time ~= os.time() then
			state[id].time = os.time()
			minetest.chat_send_all(string.format("Emerging (%2d%%)", 100-100*calls_remaining / state[id].calls))
		end
	end
end


minetest.register_chatcommand("emerge", {
	params = "",
	description = "emerge map",
	func = function()
		local id = 1
		while state[id] do
			id = id + 1
		end
		state[id] = { time = os.time() - 1 }
		minetest.emerge_area(ffiopt_demo.minp, ffiopt_demo.maxp, emerge_callback, id)
	end
})
