def shared_update_behavior(item)
  item.quality = [item.quality, 0].max
  item.quality = [item.quality, 50].min
  item.sell_in -= 1
end

def update_normal_item(item, multiplier = 1, direction = :-)
  rate_of_change = item.sell_in > 0 ? 1 : 2
  rate_of_change *= multiplier
  item.quality = item.quality.send( direction, rate_of_change )
  shared_update_behavior(item)
end

def update_backstage_pass(item)
  case item.sell_in
  when ->(days) { days >= 11 }
    item.quality += 1
  when 6..10
    item.quality += 2
  when 1..5
    item.quality += 3
  else
    item.quality = 0
  end
  shared_update_behavior(item)
end

def update_quality(items)
  items.each do | item |
    if item.name == "NORMAL ITEM"
      update_normal_item(item)
    elsif item.name == "Aged Brie"
      update_normal_item(item, 1, :+)
    elsif item.name == "Backstage passes to a TAFKAL80ETC concert"
      update_backstage_pass(item)
    elsif item.name == "Conjured Mana Cake"
      update_normal_item(item, 2)
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

