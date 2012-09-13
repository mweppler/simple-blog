module FlatFileProperties
  def properties(*attributes)
    @file_properties = attributes
  end

  def file_properties
    @file_properties
  end
end

module FlatFile
  def from_file(file_name)
    properties = []
    File.open(file_name, 'r') do |file|
      tmp_property = ""
      while line = file.gets
        if line.match /^--END_PROPERTY--$/
          properties << tmp_property
          tmp_property = ""
          next
        end
        tmp_property << line
      end
    end

    self.class.file_properties.each_with_index do |property, index|
      self.instance_variable_set("@#{property}", properties[index])
    end
  end

  def to_file(file_name)
    file = File.open(file_name, 'w')
    self.class.file_properties.each do |property|
      file.write "#{send(property)}\n--END_PROPERTY--\n"
    end
    file.close
  end

  def to_s
    self.class.file_properties.each do |property|
      puts "[#{property.to_s.upcase}] #{send(property)}"
    end
  end
end

#class MyClass
#  extend FlatFileProperties
#  include FlatFile
#  attr_accessor :id, :title, :body
#  properties :id, :title, :body
#end

#test = MyClass.new
#test.id = "third_post"
#test.title = "Third Post"
#test.body = "This is the content of the third post"
#test.to_file(File.expand_path('../', __FILE__) + "/new_file.txt")
#test.to_s

#test = MyClass.new
#test.from_file(File.expand_path('../', __FILE__) + "/new_file.txt")
#test.to_s

