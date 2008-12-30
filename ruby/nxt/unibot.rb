#!/usr/bin/env ruby -w

require "nxt_comm"

@nxt = NXTComm.new('/dev/tty.NXT-DevB-1')

@u = Commands::UltrasonicSensor.new(@nxt)
@u.mode = :centimeters
 
@t = Commands::TouchSensor.new(@nxt)
@t.action = :pressed

@l = Commands::LightSensor.new(@nxt)
@s = Commands::SoundSensor.new(@nxt)
@t = Commands::TouchSensor.new(@nxt)

@m = Commands::Motor.new(@nxt)
@m.port = :c
@m.power = 100
@m.duration = :unlimited

def forward
  @m.direction = :forward
  @m.start
  @u.comparison = ">"
  @u.trigger_point = 25
  while @u.logic
  end
  @m.stop
  turn
end

def turn
  @m.direction = :backward
  @m.start
  @u.comparison = "<="
  @u.trigger_point = 25
  while @u.logic
  end
  @m.stop
  forward
end

def report
  puts "Sound Level: #{@s.sound_level}"
  puts "Distance (cm): #{@u.distance}"
  puts "Touch: #{@t.logic}"
  puts "Light: #{@l.intensity}"
end

forward