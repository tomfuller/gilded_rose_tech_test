
class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      sort_all_items(item)
    end
  end

  private

  def item_special?(item)
    aged_brie?(item) || backstage_passes?(item) || item_conjured?(item)
  end

  def sort_all_items(item)
    item.sell_in -= 1 unless sulfuras?(item)
    sort_normal_quality(item) unless item_special?(item)
    sort_special_items(item) if item_special?(item)
  end

  def sort_special_items(item)
    sort_brie_passes_and_conjured(item)
    zero_sell_in(item) if item_sell_in_zero?(item)
  end

  def sort_brie_passes_and_conjured(item)
    sort_brie_quality(item) if aged_brie?(item)
    item.quality += backstage_passes_sell_in_to_quality(item) if backstage_passes?(item)
    sort_conjured_quality(item) if item_conjured?(item)
  end

  def sort_conjured_quality(item)
    item.quality -= 2 if item_sell_in_zero?(item)
    item.quality -= 2
  end

  def sort_normal_quality(item)
    subtract_1_quality(item) unless sulfuras?(item)
    subtract_1_quality(item) if item_sell_in_zero?(item)
  end

  def item_conjured?(item)
    item.name == 'Conjured'
  end

  def item_sell_in_zero?(item)
    item.sell_in <= 0
  end

  def zero_sell_in(item)
    backstage_pass_quality_to_0(item) if backstage_passes?(item)
    subtract_1_quality(item) unless sulfuras?(item) || item_conjured?(item)
  end

  def aged_brie?(item)
    item.name == 'Aged Brie'
  end

  def backstage_passes?(item)
    item.name == "Backstage passes to a TAFKAL80ETC concert"
  end

  def sulfuras?(item)
    item.name == "Sulfuras, Hand of Ragnaros"
  end

  def add_1_quality(item)
    item.quality += 1 if item.quality < 50
  end

  def subtract_1_quality(item)
    item.quality -= 1 if item.quality > 0
  end

  def sort_brie_quality(item)
    item.quality += 2 if item.quality < 50 && item_sell_in_zero?(item)
    item.quality += 1 if item.quality < 50
  end

  def backstage_pass_quality_to_0(item)
    item.quality = 0
  end

  def quality_greater_than_0(item)
    item.quality > 0
  end

  def backstage_passes_sell_in_to_quality(item)
    return 3 if item.sell_in < 6
    return 2 if item.sell_in < 11
    1
  end

end
