require './gilded_rose.rb'
require "rspec"

def item(subject, name)
  subject.items.select { |i| i.name.include? name }.first
end

describe GildedRose do
  before do
    subject.items = []
    subject.items << Item.new("+5 Dexterity Vest", 10, 20)
    subject.items << Item.new("Aged Brie", 2, 0)
    subject.items << Item.new("Elixir of the Mongoose", 5, 7)
    subject.items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
    subject.items << Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
    subject.items << Item.new("Conjured Mana Cake", 3, 6)
  end

  it "at the end of each day our system lowers sellin by 1 for normal items" do
    # Vest or Mongoose
    prev_sell_by = item(subject, "Vest").sell_in
    subject.update_quality
    expect(prev_sell_by-1).to be item(subject, "Vest").sell_in
  end

  it "at the end of each day our system lowers quality by 1 for normal items" do
    # Vest or Mongoose
    prev_quality = item(subject, "Vest").quality
    subject.update_quality
    expect(prev_quality-1).to be item(subject, "Vest").quality
  end

  it "once the sell by date has passed on a normal item, quality degrades twice as fast" do
    item(subject, "Vest").sell_in.times do
      subject.update_quality
    end
    prev_quality = item(subject, "Vest").quality
    subject.update_quality
    expect(prev_quality-2).to be item(subject, "Vest").quality
  end

  it "never has a negative quality" do
    (item(subject, "Vest").quality+1).times do
      subject.update_quality
    end
    expect(item(subject, "Vest").quality).not_to be < 0
  end

  it "Aged Brie actually increases in Quality the older it gets" do
    prev_quality = item(subject, "Brie").quality
    subject.update_quality
    expect(prev_quality+1).to be item(subject, "Brie").quality
  end

  it "quality of an item is never more than 50" do
    51.times do
      subject.update_quality
    end
    expect(item(subject, "Brie").quality).to be <= 50
  end

  it "Sulfuras never has to be sold" do
    prev_sell_by = item(subject, "Sulfuras").sell_in
    subject.update_quality
    expect(item(subject, "Sulfuras").sell_in).to be prev_sell_by
  end

  it "Sulfuras never decreases in Quality" do
    prev_quality = item(subject, "Sulfuras").quality
    subject.update_quality
    expect(item(subject, "Sulfuras").quality).to be prev_quality
  end

  it "Backstage passes quality increases by 1 when sellin is greater than 10 while sellin approaches" do
    if item(subject, "Backstage").sell_in > 10
      prev_quality = item(subject, "Backstage").quality
      subject.update_quality
      expect(prev_quality+1).to be item(subject, "Backstage").quality
    end
  end

  it "Backstage passes quality increases by 2 when sellin is 10 or less while sellin approaches" do
    until item(subject, "Backstage").sell_in <= 10
      subject.update_quality
    end

    if item(subject, "Backstage").sell_in <= 10 && item(subject, "Backstage").sell_in > 5
      prev_quality = item(subject, "Backstage").quality
      subject.update_quality
      expect(prev_quality+2).to be item(subject, "Backstage").quality
    end
  end

  it "Backstage passes quality increases by 3 when sellin is 5 or less while sellin approaches" do
    until item(subject, "Backstage").sell_in <= 5
      subject.update_quality
    end

    if item(subject, "Backstage").sell_in <= 5 && item(subject, "Backstage").sell_in > 0
      prev_quality = item(subject, "Backstage").quality
      subject.update_quality
      expect(prev_quality+3).to be item(subject, "Backstage").quality
    end
  end

  it "Backstage passes quality drops to 0 after the sellin reaches 0" do
    (item(subject, "Backstage").sell_in+1).times do
      subject.update_quality
    end
    subject.update_quality

    expect(item(subject, "Backstage").quality).to be 0
  end

  it "Conjured items degrade in Quality twice as fast as normal items" do
    prev_quality = item(subject, "Conjured").quality
    subject.update_quality
    expect(prev_quality-2).to be item(subject, "Conjured").quality
  end
end
