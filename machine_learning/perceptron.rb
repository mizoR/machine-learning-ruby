#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# Reference
# * http://d.hatena.ne.jp/echizen_tm/20110606/1307378609
# * http://d.hatena.ne.jp/lettas0726/20111005/1317803286

module MachineLearning
  DEFAULT_BIAS = 1
  class Perceptron
    def initialize(w = {}, bias = DEFAULT_BIAS)
      @w = w.has_key?(:bias) ? w : w.merge({bias: bias})
    end

    def predict(vector)
      vector.inject(0) { |sum, (key, value)|
        @w.has_key?(key) ? (sum + @w[key] * value) : sum
      }
    end

    def train(vector, fact)
      vector[:bias] = DEFAULT_BIAS unless vector.has_key?(:bias)
      sum = predict(vector)
      return unless (sum * fact < 0)
      vector.each do |key, value|
        @w[key] = 0 unless @w.has_key?(key)
        @w[key] += fact * value
      end
    end
  end
end


if __FILE__ == $0
  train_data = [
    [{r: 255, g:   0, b:   0},  1],
    [{r:   0, g: 255, b: 255}, -1],
    [{r:   0, g: 255, b:   0}, -1],
    [{r: 255, g:   0, b: 255},  1],
    [{r:   0, g:   0, b: 255}, -1],
    [{r: 255, g: 255, b:   0},  1],
  ]

  machine = MachineLearning::Perceptron.new({r: 0, g: 0, b: 0})
  100.times do
    train_data.each do |vector, fact|
      machine.train(vector, fact)
    end
  end
  puts "Input color code. (ex) 102 204 255"
  begin
  while (print "> "; input = gets) do
    input = input.chomp.strip
    next unless input =~ /^\d{1,3} +\d{1,3} +\d{1,3}$/

    r, g, b = input.split(' ').map { |s| s.to_i }

    x = {r: r, g: g, b: b, bias: 1}
    t = machine.predict(x)
    if t >= 0
      puts ">> warm: #{t}"
    else
      puts ">> cold: #{t}"
    end
  end
  rescue Interrupt
    puts
    puts "Bye."
  end
end
