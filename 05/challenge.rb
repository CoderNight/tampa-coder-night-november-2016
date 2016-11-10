#!/usr/bin/env ruby
require 'thread'
require 'etc'

class Levenstein
  def self.distance(a, b)
    self.recurse(a, a.length, b, b.length)
  end

  def self.recurse(a, a_length, b, b_length)
    return a_length if b_length == 0
    return b_length if a_length == 0

    if a[a_length-1] == b[b_length-1]
      cost = 0;
    else
      cost = 1;
    end

    [
      self.recurse(a, a_length - 1, b, b_length    ) + 1,   # delete char from a
      self.recurse(a, a_length    , b, b_length - 1) + 1,   # delete char from b
      self.recurse(a, a_length - 1, b, b_length - 1) + cost # delete char from both
    ].min
  end

end

class Neighbor
  attr_accessor :parent
  attr_accessor :word
  attr_accessor :distance

  def initialize p, w, d
    @word, @parent, @distance = p, w, d
  end
end

class Challenge
  attr_accessor :words

  def initialize args
    @count = 0
    args[:words].each do |word|
      @words = Hash.new
      walk(word, args[:file], 1)
    end
    puts "Total neighbors for #{word}: #{@count}"
  end

  def walk word, input, depth
    lines = IO.readlines( input ).each { |l| l.chomp! }
    #walk_at_depth(word, input, depth, lines)
    threaded_walk_at_depth(word, input, depth, lines)
    recurse_at_depth(word, input , depth, lines)
    print_at_depth(word, input , depth, lines)
  end

  def walk_at_depth word, input, depth, lines
    puts "walk_at_depth word = #{word}, depth = #{depth}"
    lines.each do |line|
      next if line == word
      if ! words[line]
        puts line #print "."
        distance = Levenstein.distance(word, line)
	if distance == 1
          words[line] = Neighbor.new(word, line, depth)
        end
      end
    end
  end

  def threaded_walk_at_depth word, input, depth, lines
    puts "threaded_walk_at_depth word = #{word}, depth = #{depth}"
    queue = Queue.new
    # Walk the tree at depth
    lines.each do |line|
      next if line == word
      if ! words[line]
        queue.push line
      end
    end
    per_percent = lines.count/100
    countdown = per_percent
    percentage = 0
    workers = (0 .. Etc.nprocessors).map do
      Thread.new do
        begin
          while line = queue.pop(true)
            countdown-=1
	    if countdown < 0
              countdown = per_percent
	      percentage+=1
	      print "Working: #{percentage.to_s}%   \r"
            end
            distance = Levenstein.distance(word, line)
       	    if distance == 1
              words[line] = Neighbor.new(word, line, depth)
            end
          end
        rescue ThreadError
        end
      end
    end
    workers.map(&:join)
  end

  def recurse_at_depth word, input, depth, lines
    puts "recurse_at_depth word = #{word}, depth = #{depth}"
    lines.each do |line|
      if words[line] && words[line].distance == depth
        walk(line, input, depth + 1)
      end
    end
  end

  def print_at_depth word, input, depth, lines
    puts "print_at_depth word = #{word}, depth = #{depth}"
    lines.each do |line|
      if words[line] && words[line].distance == depth
        puts words[line].inspect
	@count+=1
      end
    end
  end

end

Challenge.new( file: './input', words: ARGV )
