#!/usr/bin/env ruby
require 'tty-prompt'
require 'rbconfig'

windows = RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/i
terminal_input = windows ? $stdin : File.open('/dev/tty', 'r')
terminal_output = windows ? $stdout : File.open('/dev/tty', 'w')

prompt = TTY::Prompt.new(
  input: terminal_input,
  output: terminal_output,
  active_color: :cyan,
  symbols: { marker: '❯' }
)

if ENV['MENU_LEVEL'] == 'network'
  choices = {
    'Local IP address' => 'LCL',
    'Public IP address' => 'ONL',
    'Back to main menu' => 'sub_back'
  }

  selected = prompt.select('NETWORK  ·  Choose an address', choices, cycle: true)
else
  choices = {
    'Network details' => 'check_ip',
    'Disk usage' => 'SYS_DISK',
    'Memory usage' => 'SYS_MEM',
    'Exit' => 'exit_menu'
  }

  selected = prompt.select('MAIN MENU  ·  Choose an action', choices, cycle: true)
end

if ENV['MENU_RESULT_FILE']
  File.write(ENV.fetch('MENU_RESULT_FILE'), selected.to_s)
else
  puts selected
end
