subtitle_converter
==================

Script that changes the timing of an srt file

Run from command line with Ruby:

ruby subtitle_converter.rb -o {add|sub} -t {seconds, milliseconds} {source_file_name} {destination_file_name}

For example, to move the subtitles ahead 1.5 seconds from old_subs.srt to new_subs.srt:

ruby subtitle_converter.rb -o add -t 1,500 old_subs.srt new_subs.srt


There is a subs_old.srt included to test with
