ActiveRecord::Schema.define(:version => 1) do

  create_table "items", :force => true do |t|
    t.column "name", "string"
    t.column "name_soundex", "string"
  end

end
