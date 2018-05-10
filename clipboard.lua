clipboard = {

	clear = function()
		spawn("clip clear all")
		out("All buffers cleared")
	end,

	seltocli = function()
		spawn("clip sel cli")
		out("Selection -> Clipboard")
	end,

	clitosel = function()
		spawn("clip cli sel")
		out("Clipboard -> Selection")
	end,

	savesel = function()
		spawn("clip sel sec")
		out("Selection saved")
	end,

	restsel = function()
		spawn("clip sec sel")
		out("Selection restored")
	end,

	dumpsel = function()
		async("clip sel", function(output)
			if string.len(sel) ~= 0 then
				out(sel, 0)
			else
				out("Selection empty")
			end
		end)
	end,

	dumpcli = function()
		async("clip cli", function (output)
			if string.len(cli) ~= 0 then
				out(cli, 0)
			else
				out("Clipboard empty")
			end
		end)
	end,
}

-- vim:ts=4:sw=4
