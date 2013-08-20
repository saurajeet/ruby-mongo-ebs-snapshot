namespace :recover do
	desc "Recover to a point in time state to single disk (can be only be done for single disk backups"
	task :single do
		puts "Recover to Single Disk"
	end

	desc "Recover to a point in time state of a RAID volume (can be done only for multidisk backups)"
	task :raid do
		puts "Recover to MultiDisk Raid Volumes"
	end
end
