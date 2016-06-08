# Refactored code (see below for original code)----------------------------------

require './item.rb'

class GildedRose

  attr_accessor :items

  def initialize
    @items = []
    @items << Item.new("+5 Dexterity Vest", 10, 20)
    @items << Item.new("Aged Brie", 2, 0)
    @items << Item.new("Elixir of the Mongoose", 5, 7)
    @items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
    @items << Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
    @items << Item.new("Conjured Mana Cake", 3, 6)
  end

  def aged_brie_update_quality(i)
    @items[i].sell_in = @items[i].sell_in - 1
    @items[i].quality = @items[i].quality + 1 if @items[i].quality < 50
  end

  def backstage_update_quality(i)
    @items[i].sell_in = @items[i].sell_in - 1
    @items[i].quality = @items[i].quality + 1
    @items[i].quality = @items[i].quality + 1 if @items[i].sell_in < 11
    @items[i].quality = @items[i].quality + 1 if @items[i].sell_in < 6
    @items[i].quality = 0 if @items[i].sell_in < 0
    @items[i].quality = 50 if @items[i].quality >= 50
  end

  def conjured_update_quality(i)
    @items[i].sell_in = @items[i].sell_in - 1
    @items[i].quality = @items[i].quality-2
  end

  def normal_item_update_quality(i)
    @items[i].sell_in = @items[i].sell_in - 1
    @items[i].quality = @items[i].quality - 1
    @items[i].quality = @items[i].quality - 1 if @items[i].sell_in <= 0
    @items[i].quality = 0 if @items[i].quality < 0
  end

  def update_quality
    for i in 0..(@items.size-1)
      case @items[i].name
      when "Aged Brie"
        aged_brie_update_quality(i)
      when "Backstage passes to a TAFKAL80ETC concert"
        backstage_update_quality(i)
      when "Conjured Mana Cake"
        conjured_update_quality(i)
      when "Sulfuras, Hand of Ragnaros"
        "nothing happens here"
      else
        normal_item_update_quality(i)
      end
    end
  end

end

# BEFORE REFACTOR------------------------------------------------------------------------------------
#
# require './item.rb'
#
# class GildedRose
#   attr_accessor :items
#
#   def initialize
#     @items = []
#     @items << Item.new("+5 Dexterity Vest", 10, 20)
#     @items << Item.new("Aged Brie", 2, 0)
#     @items << Item.new("Elixir of the Mongoose", 5, 7)
#     @items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
#     @items << Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
#     @items << Item.new("Conjured Mana Cake", 3, 6)
#   end
#
#   def update_quality
#
#     for i in 0..(@items.size-1)
#       if (@items[i].name != "Aged Brie" && @items[i].name != "Backstage passes to a TAFKAL80ETC concert")
#         if (@items[i].quality > 0)
#           if (@items[i].name != "Sulfuras, Hand of Ragnaros")
#             @items[i].quality = @items[i].quality - 1
#           end
#         end
#       else
#         if (@items[i].quality < 50)
#           @items[i].quality = @items[i].quality + 1
#           if (@items[i].name == "Backstage passes to a TAFKAL80ETC concert")
#             if (@items[i].sell_in < 11)
#               if (@items[i].quality < 50)
#                 @items[i].quality = @items[i].quality + 1
#               end
#             end
#             if (@items[i].sell_in < 6)
#               if (@items[i].quality < 50)
#                 @items[i].quality = @items[i].quality + 1
#               end
#             end
#           end
#         end
#       end
#       if (@items[i].name != "Sulfuras, Hand of Ragnaros")
#         @items[i].sell_in = @items[i].sell_in - 1;
#       end
#       if (@items[i].sell_in < 0)
#         if (@items[i].name != "Aged Brie")
#           if (@items[i].name != "Backstage passes to a TAFKAL80ETC concert")
#             if (@items[i].quality > 0)
#               if (@items[i].name != "Sulfuras, Hand of Ragnaros")
#                 @items[i].quality = @items[i].quality - 1
#               end
#             end
#           else
#             @items[i].quality = @items[i].quality - @items[i].quality
#           end
#         else
#           if (@items[i].quality < 50)
#             @items[i].quality = @items[i].quality + 1
#           end
#         end
#       end
#     end
#   end
#
# end
