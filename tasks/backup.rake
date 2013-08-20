namespace :backup do

	desc "Take Mongo Backup"
	task :take do
		puts "Taking Backup"
	end


	desc "List Mongo Backups"
	task :list do
		puts "Listing Backups"
	end

	desc "Automatically Clean Mongo Backups"
	task :autoclean do
		puts "Autoclean Mongo Backups"
	end

	desc "Delete a Backup"
	task :delete do
		puts "Clearing  Backups"
	end
end
