require 'rspec'
require './lib/gilded_rose'
require './lib/item'


describe GildedRose do

  describe "#update_quality" do

    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    context 'normal items' do

      it 'should lose 1 quality if normal item' do
        items = [Item.new("foo", 3, 3)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 2
      end

      it 'should lose 2 quality if sell by date is gone on normal item' do
        items = [Item.new("foo", 0, 3)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 1
      end

      it 'should not lose quality if quality is already 0' do
        items = [Item.new("foo", 0, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end

      it 'should have a decreasing sell_in value' do
        items = [Item.new("foo", 5, 4)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 4
      end

    end

    context 'sulfuras' do

      it 'should do nothing to values of sulfuras' do
        items = [Item.new("Sulfuras, Hand of Ragnaros", 2, 2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 2
        expect(items[0].sell_in).to eq 2
      end

    end

    context 'aged brie' do

      it 'should gain 1 quality if aged brie still in sell by' do
        items = [Item.new("Aged Brie", 3, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 1
      end

      it 'should gain 2 quality if aged brie out of sell by' do
        items = [Item.new("Aged Brie", 0, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 2
      end

      it 'should cap quality at 50 of aged brie' do
        items = [Item.new("Aged Brie", 2, 50)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 50
      end

    end

    context 'backstage passes' do

      it 'should cap quality at 50 of backstage passes' do
        items = [Item.new("Aged Brie", 2, 50)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 50
      end

      it 'should increase quality by 1 if sell in >10 of backstage passes' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 4)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 5
      end

      it 'should increase quality by 2 if sell in <10 of backstage passes' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 8, 4)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 6
      end

      it 'should increase quality by 3 if sell in <5 of backstage passes' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 4, 4)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 7
      end

      it 'should drop quality to 0 once sell in is 0 of backstage passes' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 4)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end

    end

    context 'conjured items' do

      it 'should lose 2 quality when conjured item sell_in is greater than 0' do
        items = [Item.new("Conjured", 7, 4)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 2
      end

      it 'should lose 4 quality when conjured item sell_in is less than 0' do
        items = [Item.new("Conjured", 0, 6)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 2
      end

    end

  end

end
