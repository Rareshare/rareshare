# encoding: UTF-8
class SampleSize
  include ActiveAttr::Model

  attribute :name,     type: String
  attribute :symbol,   type: String
  attribute :exponent, type: Integer

  SIZES = [
    SampleSize.new(name: "nano",  symbol: "n",  exponent: -9),
    SampleSize.new(name: "micro", symbol: "µ",  exponent: -6),
    SampleSize.new(name: "milli", symbol: "m",  exponent: -3),
    SampleSize.new(name: "centi", symbol: "c",  exponent: -2),
    SampleSize.new(name: "deci",  symbol: "d",  exponent: -1),
    SampleSize.new(name: "",      symbol: "",   exponent: 0),
    SampleSize.new(name: "deka",  symbol: "da", exponent: 1),
    SampleSize.new(name: "hecto", symbol: "h",  exponent: 2),
    SampleSize.new(name: "kilo",  symbol: "k",  exponent: 3),
    SampleSize.new(name: "mega",  symbol: "M",  exponent: 6),
    SampleSize.new(name: "giga",  symbol: "g",  exponent: 9)
  ]

  def self.all_sizes; SIZES; end

  def ==(other)
    self.exponent == other.exponent
  end

  def hash
    self.exponent.hash
  end

  def mult_factor
    10 ** self.exponent
  end

  def succ
    SIZES.find {|s| s.exponent > self.exponent}
  end

  def <=>(other)
    self.exponent <=> other.exponent
  end

  def as_json(options={})
    super options.merge(root: false)
  end
end
