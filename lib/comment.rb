class Comment
  attr_reader :id, :comment, :name, :post_id

  def initialize(options)
    @comment = options[:comment]
    @name    = options[:name]
    @post_id = options[:post_id]
  end

  def create(directory = 'data/')
    File.open("#{directory}#{@post_id}.comments", 'a') do |f| 
      f.puts Marshal.dump(self)
      f.puts "\n"
    end
  end

  def self.load_file(id, directory = 'data/')
    file = "#{directory}#{id}.comments"
    array = []
    return array unless File.exists? file
    $/="\n\n"
    File.open("#{directory}#{id}.comments", 'r').each do |comment|
      array << Marshal.load(comment)
    end
    array
  end
end
