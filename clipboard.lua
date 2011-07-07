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
		local sel = pread("clip sel")
		if string.len(sel) ~= 0 then out(sel, 0)
		else out("Selection empty")
		end
	end,
	dumpcli = function()
		local cli = pread("clip cli")
		if string.len(cli) ~= 0 then out(cli, 0)
		else out("Clipboard empty")
		end
	end,
}
