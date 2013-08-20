#! /usr/bin/env ruby

require 'rubygems'
require 'aws-sdk'
require 'mongo'
require 'pp'
require 'curb'
require 'yaml'
require 'logger'

include Mongo

class Backup
	attr_accessor :instance_id, :volume_id, :infra, :device, :settings, :mongo_client, :is_master
	def initialize
		@settings = YAML.load_file "conf/settings.yml"
		AWS.config({
			:access_key_id => @settings[:access_key.to_s],
			:secret_access_key => @settings[:secret_key.to_s],
			:region => @settings[:region.to_s]
		})
		@device = @settings[:device.to_s]
		@infra = AWS.ec2
	
		begin	
			@mongo_client = MongoClient.new 'localhost', @settings[:mongo_port.to_s].to_i
			@mongo_client.add_auth "admin", @settings[:admin_user.to_s], @settings[:admin_pass.to_s], nil
			@mongo_client.apply_saved_authentication
		rescue
			puts "Error in connectivity with Mongo, please set the mongo admin credentials in conf/settings.yml"
			@mongo_client = nil
		end
		seed = "mongodb://localhost:" + @settings[:mongo_port.to_s].to_s
		@is_primary = @mongo_client.check_is_master seed 
		
		url = "http://169.254.169.254/latest/meta-data/instance-id"
		response = Curl::Easy.perform(url)
		@instance_id = response.body_str
	end

	def mongo_fs_lock!
		return if (@mongo_client == nil)
		@mongo_client.lock!
	end

	def mongo_fs_unlock!
		return if (@mongo_client == nil)
		@mongo_client.unlock!
	end

	def list_snapshots
	end

	def backup_vol
		return if (@mongo_client == nil)
		@volume_id = ""
		@infra.instances[@instance_id].block_devices.each do |map|
			next if (map[:device_name] != @device)
			vol_attr = map[:ebs] 
			if (vol_attr == nil)
				puts "Device doesnot exist"
				return
			end
			if (map[:ebs][:status] != "attached")
				puts "A live Volume should be attached and recording"
				return
			end
			if (@settings[:run_if] == "not_master" && @is_primary!=nil)
				puts "You have specified to turn off backups at master nodes"
				return
			end
			@volume_id = map[:ebs][:volume_id]
			mongo_fs_lock!
		 	print "#{Time.now}: Snapshotting Started on #{@volume_id}"
			vol = @infra.volumes[@volume_id]
			snap = vol.create_snapshot "#{@settings[:desc.to_s]}"
			sleep 1 until [:completed, :error].include?(snap.status)
			print  " completed on #{Time.now} with " + snap.status.to_s
			mongo_fs_unlock!
		end
	end
end
