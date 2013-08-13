#! /usr/bin/env ruby

require 'rubygems'
require 'aws-sdk'
require 'mongo'
require 'pp'
require 'curb'
require 'yaml'

class Backup
	attr_accessor :instance_id, :volume_id, :infra, :device, :settings
	def initialize
		@settings = YAML.load_file "conf/settings.yml"
		AWS.config({
			:access_key_id => @settings[:access_key.to_s],
			:secret_access_key => @settings[:secret_key.to_s],
			:region => @settings[:region.to_s]
		})
		@device = @settings[:device.to_s]
		@infra = AWS.ec2
		
		url = "http://169.254.169.254/latest/meta-data/instance-id"
		response = Curl::Easy.perform(url)
		@instance_id = response.body_str
	end

	def mongo_fs_lock
	end

	def mongo_fs_unlock
	end

	def list_snapshots
	end

	def backup_vol
		@volume_id = ""
		@infra.instances[@instance_id].block_devices.each do |map|
			next if (map[:device_name] != @device)
			vol_attr = map[:ebs]
			puts "Device doesnot exist" if vol_attr == nil
			puts "A live Volume should be attached and recording" if (map[:ebs][:status] != "attached")
			@volume_id = map[:ebs][:volume_id]
			puts "Snapshotting Started on #{@volume_id}"
		end
	end
end
