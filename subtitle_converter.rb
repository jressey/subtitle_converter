require 'optparse'
require 'fileutils'

options = {}
OptionParser.new do |opts|
  opts.banner = "Bout ta retime some subs"

  opts.on("-o N", "--operation", "Operation to perform") do |operation|
    options[:operation] = operation
  end

  opts.on("-t", "--time x,y", Array,"--time", "Time to change") do |time|
    seconds = time[0].to_i
    milliseconds = time[1].to_i
    
    if options[:operation] == "sub" 
    	seconds = seconds * -1
    	milliseconds = milliseconds * -1
    end

    options[:seconds] = seconds
    options[:milliseconds] = milliseconds
  end
end.parse!

old_lines = IO.readlines(ARGV[0])
new_lines = Array.new
old_lines.map do |line|
	if line =~ /^[0-9][0-9]:[0-9][0-9]:[0-9][0-9],[0-9][0-9][0-9]/
		split_line = line.split(/ --> /)
		line_array = [split_line[0], split_line[1]]
		
		split_line.each_with_index do |time_segment, i|
			time_elements = time_segment.gsub(/:/, ",").split(",").map do |val|
				val.to_i
			end
			
			total_milliseconds = time_elements[3].to_i + options[:milliseconds]
			time_elements[3] = total_milliseconds % 1000
			time_elements[2] = time_elements[2].to_i + (total_milliseconds / 1000)
			total_seconds = time_elements[2].to_i + options[:seconds].to_i
			time_elements[2] = total_seconds % 60
			time_elements[1] = time_elements[1].to_i + (total_seconds / 60)
			time_elements[0] = time_elements[0].to_i + (time_elements[1] / 60)
			time_elements[1] = time_elements[1] % 60
			
			line_array[i] = "%02d" % "#{time_elements[0]}" + \
				":" + "%02d" % "#{time_elements[1]}" + \
				":" + "%02d" % "#{time_elements[2]}" + \
				"," + "%03d" % "#{time_elements[3]}"		
		end
		new_lines.push(line_array[0] + " --> " + line_array[1])
	else
		new_lines.push(line)
	end
end

unless File.file?(ARGV[1])
	new_file = FileUtils.touch(ARGV[1])
end

File.open(ARGV[1], "w+") do |f|
  new_lines.each { |line| f.puts(line) }
end

p "Success!"