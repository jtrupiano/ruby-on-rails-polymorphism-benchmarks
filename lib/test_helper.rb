module TestHelper
  # Add more helper methods to be used by all tests here...
  def insert_count
    1000000
  end
  
  def find_count
    1000000
  end
  
  def type_count
    Math.log(insert_count).to_i
  end
  
  def int_types
    types = []
    for i in 1..type_count
      types.push(i)
    end
    types
  end
  
  def str_types
    types = []
    for i in 1..type_count
      types.push("Type "+i.to_s)
    end
    types
  end
  
  def build_items_list(types)
    items_to_insert = []
    for i in 1..(insert_count/types.size+types.size)
      types.each do |t|
        items_to_insert.push([i,t])
      end
    end
    items_to_insert
  end
end
