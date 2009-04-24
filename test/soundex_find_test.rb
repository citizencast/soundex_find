
require File.dirname(__FILE__) + '/test_helper'

class SoundexFindTest < Test::Unit::TestCase

  context "A soundex model with default SoundexFind options" do

    setup do
      Item.delete_all
      Item.soundex_columns( :name )
      
      @items = []
      
      @items[0] = Item.new :name => "sue"
      @items[0].save!
      @items[1] = Item.new :name => "soup"
      @items[1].save!
      @items[2] = Item.new :name => "super"
      @items[2].save!
      @items[3] = Item.new :name => "supernatural"
      @items[3].save!
      
    end

    should "have a soundex value" do
      assert_not_nil @items[0].name_soundex
    end

    should "find all records" do
      @r = Item.find :all
      assert_equal(@r.length, 4, "with find :all")
    end
    
    should "have soundex length" do
      @r = Item.find :all
      assert_equal(@r[0].name_soundex.length, 1, "equals 1 " + @r[0].name_soundex)
      assert_equal(@r[1].name_soundex.length, 2, "equals 2 " + @r[1].name_soundex)
      assert_equal(@r[2].name_soundex.length, 3, "equals 3 " + @r[2].name_soundex)
      assert_equal(@r[3].name_soundex.length, 7, "equals 7 " + @r[3].name_soundex)
    end
    
    should "find records when using " do
      @r = Item.soundex_find :all, :soundex => ""
      assert_equal(@r.length, 4, "blank soundex string")

      @r = Item.soundex_find :all, :soundex => "zoo"
      assert_equal(@r.length, 4, "different first letter")

      @r = Item.soundex_find :all, :soundex => "per"
      assert_equal(@r.length, 2, "internal substring")

      @r = Item.soundex_find :all, :soundex => "su"
      assert_equal(@r.length, 4, "short string")

      @r = Item.soundex_find :all, :soundex => "sheuvir"
      assert_equal(@r.length, 2, "phonetic string")
    end
    
    should "not find records when using " do
      @r = Item.soundex_find :all, :soundex => "supernaturalsupernatural"
      assert_equal(@r.length, 0, "long soundex string")
    end
    
  end

  context "A soundex model with strict SoundexFind options" do

    setup do
      Item.delete_all
      Item.soundex_columns( :name, {:start => true, :end => true, :limit => 3, :strict => true} )
      
      @items = []
      
      @items[0] = Item.new :name => "sue"
      @items[0].save!
      @items[1] = Item.new :name => "soup"
      @items[1].save!
      @items[2] = Item.new :name => "super"
      @items[2].save!
      @items[3] = Item.new :name => "supernatural"
      @items[3].save!
      
    end

    should "have a soundex value" do
      assert_not_nil @items[0].name_soundex
    end

    should "find all records" do
      @r = Item.find :all
      assert_equal(@r.length, 4, "with find :all")
    end
    
    should "have soundex length" do
      @r = Item.find :all
      assert_equal(@r[0].name_soundex.length, 1, "equals 1")
      assert_equal(@r[1].name_soundex.length, 2, "equals 2")
      assert_equal(@r[2].name_soundex.length, 3, "equals 3")
      assert_equal(@r[3].name_soundex.length, 4, "equals 4")
    end
    
    should "find records when using " do
      @r = Item.soundex_find :all, :soundex => "supernaturalsupernatural"
      assert_equal(@r.length, 1, "long soundex string")

      @r = Item.soundex_find :all, :soundex => "su"
      assert_equal(@r.length, 1, "short string")

      @r = Item.soundex_find :all, :soundex => "sheuvir"
      assert_equal(@r.length, 1, "phonetic string")
    end
    
    should "not find records when using " do

      @r = Item.soundex_find :all, :soundex => ""
      assert_equal(@r.length, 0, "blank soundex string")

      @r = Item.soundex_find :all, :soundex => "zoo"
      assert_equal(@r.length, 0, "different first letter")

      @r = Item.soundex_find :all, :soundex => "per"
      assert_equal(@r.length, 0, "internal substring")
    end
   
  end

  context "A soundex model with auto-complete SoundexFind options" do

    setup do
      Item.delete_all
      Item.soundex_columns( :name, {:start => true, :strict => true} )
      
      @items = []
      
      @items[0] = Item.new :name => "sue"
      @items[0].save!
      @items[1] = Item.new :name => "soup"
      @items[1].save!
      @items[2] = Item.new :name => "super"
      @items[2].save!
      @items[3] = Item.new :name => "supernatural"
      @items[3].save!
      
    end

    should "have a soundex value" do
      assert_not_nil @items[0].name_soundex
    end

    should "find all records" do
      @r = Item.find :all
      assert_equal(@r.length, 4, "with find :all")
    end
    
    should "have soundex length" do
      @r = Item.find :all
      assert_equal(@r[0].name_soundex.length, 1, "equals 1")
      assert_equal(@r[1].name_soundex.length, 2, "equals 2")
      assert_equal(@r[2].name_soundex.length, 3, "equals 3")
      assert_equal(@r[3].name_soundex.length, 7, "equals 7")
    end
    
    
    should "find records when using " do
      @r = Item.soundex_find :all, :soundex => ""
      assert_equal(@r.length, 4, "blank soundex string")

      @r = Item.soundex_find :all, :soundex => "su"
      assert_equal(@r.length, 4, "short string")

      @r = Item.soundex_find :all, :soundex => "sheuvir"
      assert_equal(@r.length, 2, "phonetic string")
    end
    
    should "not find records when using " do

      @r = Item.soundex_find :all, :soundex => "supernaturalsupernatural"
      assert_equal(@r.length, 0, "long soundex string")
      
      @r = Item.soundex_find :all, :soundex => "zoo"
      assert_equal(@r.length, 0, "different first letter")

      @r = Item.soundex_find :all, :soundex => "per"
      assert_equal(@r.length, 0, "internal substring")
    end
    
  end
  
end