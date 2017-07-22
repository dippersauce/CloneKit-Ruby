#!/bin/ruby
# CloneKit.rb

require 'date'

def clone_device(device_to_rescue, client_name)
	# Cast method arguments to strings
	device_to_rescue.to_s
	client_name.to_s
	# Concatenate client name with slashes to generate directory name that rescued image will be stored in.
	target_directory = "./" + client_name.downcase.tr(" ", "_") + "/" # Eventually replace with gsub that also removes slashes and backslashes
	# Device images are named after the current time.
	rescued_image_name = DateTime.now.strftime('%d-%m-%Y_%H:%M:%S').to_s
	clone_command = "ddrescue -f -n " + (device_to_rescue) + " " + (target_directory) + (rescued_image_name) + ".img" + " " + (target_directory) + (rescued_image_name) +".log"
	begin
		print(clone_command)
		system(clone_command)
	rescue
		print("Error cloning device. Manual cloning strongly suggested.") # In the future this will be more robust.
	end
end

def format_mb(size)
  conv = ['b', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb'];
  scale = 1024;

  ndx = 1
  if (size < 2 * (scale ** ndx)) then
    return "#{(size)} #{conv[ndx - 1]}"
  end
  size=size.to_f
  [2,3,4,5,6,7].each do |ndx|
    if (size < 2 * (scale ** ndx)) then
      return "#{'%.3f' % (size / (scale ** (ndx - 1)))} #{conv[ndx - 1]}"
    end
  end
  ndx = 7
  return "#{'%.3f' % (size / (scale ** (ndx - 1)))} #{conv[ndx - 1]}"
end

def list_device_clones(client_name)
	target_directory = "./" + client_name.downcase.tr(" ", "_") + "/"
	device_clones = Dir["", (target_directory), "/*.img"]
	device_clones_info = Hash.new
	device_clones.each do |file|
		# parse file name to unix stamp and pretty string date
		clone_file_size = format_mb(File.size(file))
		device_clones_info.store(file, clone_file_size)
	end
	device_clones_info.each do |hashpair|
		print(hashpair, "\n")
	end
end

def delete_device_clone(client_name, image_name)
	print("Deleting device clone ", (image_name), "from client directory ", (client_name), ".")
	target_file = "./" + client_name.downcase.tr(" ", "_") + "/" + (image_name)
	file_delete_command = "rm " + (target_file)
	print(file_delete_command)
	system(delete_command)
end

def delete_all_clones_by_client
	print("Deleting all clones of ",(client_name), "'s devices.")
	target_directory = "./" + client_name.downcase.tr(" ", "_") + "/"
	directory_delete_command
	print(directory_delete_command)
	system(directory_delete_command)
end

def restore_device_clone(target_device, image_name)
	print("Restoring device clone ", (image_name), " to ", (target_device), ".")
	restore_command = "dd if=" + (image_name) + " " + "of=" + (target_device)
	print(restore_command)
	system(restore_command) 
end




def main()
	system("clear")
	puts("Welcome to CloneKit 1.0, Copyright 2017 Austin Lasota.")
	puts("")
	puts("Please choose from the options below:")
	puts("(1) Rescue Device Data to Image")
	puts("(2) Restore Device Data from Image")
	puts("(3) Delete Single Device Image")
	puts("(4) Delete Device Images by Client Name")
	print(">> ")
	user_selection = gets.chomp.to_i
	case user_selection
	when 1
		puts("What is the full path of the device to be cloned?")
		puts("Which client name should this device image be stored under?")
	when 2
		puts("Which image should the device be restored from?")
		puts("Which device should be restored?")
	when 3
		puts("What client does the device image belong to?")
		puts("Here are all the images associated with ", (client_name), ".")
		puts("Which image would you like to delete?")
	when 4
		puts("Which client would you like to delete all device images for?")
		puts("Enter client name to confirm deletion.")		
	end
end
main()
