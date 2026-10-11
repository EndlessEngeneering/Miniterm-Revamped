#!/usr/bin/env ruby
require 'tty-prompt'
require 'rbconfig'

terminal_input, terminal_output =
  if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/i
    ['CONIN$', 'CONOUT$']
  else
    ['/dev/tty', '/dev/tty']
  end

prompt = TTY::Prompt.new(
  input: File.open(terminal_input, 'r'),
  output: File.open(terminal_output, 'w'),
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

puts selected
