#!/usr/bin/env ruby
require 'tty-prompt'

prompt = TTY::Prompt.new(
  input: File.open('/dev/tty', 'r'),
  output: File.open('/dev/tty', 'w'),
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
