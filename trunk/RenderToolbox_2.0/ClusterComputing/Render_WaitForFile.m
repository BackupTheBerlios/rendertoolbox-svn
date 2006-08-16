function Render_WaitForFile(fileNamePath)
%7/27/06 dpl wrote it

if ~exist(fileNamePath,'file');
	while true
		pause(.1);
		if exist(fileNamePath,'file')
			break;
		end
	end
end