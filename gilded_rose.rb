require 'dumb_delegator'

class AbstractUpdater < DumbDelegator
  private
  
  def call
    self.quality = [quality, 0].max
    self.quality = [quality, 50].min
    self.sell_in -= 1
  end
end

class NormalUpdater < AbstractUpdater
  def initialize( item, multiplier = 1, direction = :- )
    super(item)
    @multiplier = multiplier
    @direction = direction
  end

  def call
    rate_of_change = sell_in > 0 ? 1 : 2
    rate_of_change *= @multiplier
    self.quality = quality.send( @direction, rate_of_change )
    super()
  end
end

class BackstageUpdater < AbstractUpdater
  def call
    case sell_in
    when ->(days) { days >= 11 }
      self.quality += 1
    when 6..10
      self.quality += 2
    when 1..5
      self.quality += 3
    else
      self.quality = 0
    end
    super()
  end
end

def update_quality(items)
  items.each do | item |
    case item.name
    when /^NORMAL/i
      NormalUpdater.new(item).call
    when "Aged Brie"
      NormalUpdater.new(item, 1, :+).call
    when "Backstage passes to a TAFKAL80ETC concert"
      BackstageUpdater.new(item).call
    when "Conjured Mana Cake"
      NormalUpdater.new(item, 2).call
    end
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

