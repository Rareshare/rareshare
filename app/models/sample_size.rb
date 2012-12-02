# encoding: UTF-8
class SampleSize
  include ActiveAttr::Model

  attribute :name, type: String
  attribute :symbol, type: String
  attribute :mult_factor, type: Float
  attribute :exponent, type: Integer

  SIZES = [
    SampleSize.new(name: "nano",  symbol: "n",  mult_factor: 0.000000001, exponent: -9),
    SampleSize.new(name: "micro", symbol: "µ",  mult_factor: 0.000001,    exponent: -6),
    SampleSize.new(name: "milli", symbol: "m",  mult_factor: 0.001,       exponent: -3),
    SampleSize.new(name: "centi", symbol: "c",  mult_factor: 0.01,        exponent: -2),
    SampleSize.new(name: "deci",  symbol: "d",  mult_factor: 0.1,         exponent: -1),
    SampleSize.new(name: "deka",  symbol: "da", mult_factor: 10,          exponent: 1),
    SampleSize.new(name: "hecto", symbol: "h",  mult_factor: 100,         exponent: 2),
    SampleSize.new(name: "kilo",  symbol: "k",  mult_factor: 1000,        exponent: 3),
  ]

  def self.all_sizes; SIZES; end

  def ==(other)
    self.exponent == other.exponent
  end

  def hash
    self.exponent.hash
  end
end