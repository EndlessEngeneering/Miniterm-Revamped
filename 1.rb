#!/usr/bin/env ruby
require 'tty-prompt'

prompt = TTY::Prompt.new(
  input: File.open('/dev/tty', 'r'),
  output: File.open('/dev/tty', 'w')
)

loop do
  choices = {
    'check LCL/ONL ip addr' => 'check_ip',
    'disk check'    => 'SYS_DISK',
    'ram check'      => 'SYS_MEM',
    '❌ Exit Menu'  => 'exit_menu' # Added to break the main loop cleanly
  }

  selected = prompt.select('Choose an option:', choices)

  if selected == 'check_ip'
    ipchoices = {
      'local'             => 'LCL',
      'online'            => 'ONL',
      '↩️ <- Back to Main' => 'sub_back' # Handled by Bash case to just refresh
    }
    
    selected = prompt.select('ip settings', ipchoices)
  end

  puts selected
  break
end

