#!/usr/bin/ruby -w

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

i = 1

@files = Dir.glob('./raw_text/*.txt').sort
@outputFolder = "./ProPresenter/";

@files.each do |fileFullPath|
	# fileBaseName = File.basename(fileFullPath, '.txt')
	# puts "full: " + fileFullPath + " - file: " + fileBaseName

	outFileName = File.open(fileFullPath, &:gets).gsub("\r\n", '') + ".txt"
	# puts outFileName
	File.open(fileFullPath, "r") do |file|

		# open file for write
		File.open(@outputFolder + outFileName, "w+") do |fileToWrite|

			lineNum = 0
			maxChars = 0
		  file.each_line do |line|
				# we need to look at first line for title but ignore second and third lines
				if lineNum.between?(0,2)
					if lineNum == 0
						# write out the hymn title and number on a slide
						tmp = line.split(' – ')
						fileToWrite.puts "Intro"		# this gets recognized by ProPresenter as a group, separating this slide from first verse
						fileToWrite.puts tmp[1]			# the hymn title
						fileToWrite.puts "Hymn #" + tmp[0].to_i.to_s
						fileToWrite.puts ""					# new line separates slide
					else
						# ignore
					end
				else

					# if it's a verse it'll start with a number
					match = /^([0-9])\r/.match(line)
					if (match)
						fileToWrite.puts "Verse " + match[1]
					else
						match = /^refrain\r/i.match(line)
						if (match)
							fileToWrite.puts "Chorus"
						else
							fileToWrite.puts line
						end
					end

				end

				lineNum = lineNum + 1
				if maxChars < line.length
					maxChars = line.length
				end

		  end # end file.each_line

			# puts outFileName[0...3].to_s + ": " + maxChars.to_s

		end # end open output file

	end

	# break if i == 5

	i=i+1
end

# puts "There are a total of " + i.to_s + " files that were read."
