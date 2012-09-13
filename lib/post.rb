class Post
  attr_reader :id, :title, :body

  def initialize(options)
    @title = options[:title]
    @body = options[:body]
    @id = options[:title].downcase.gsub " ", "_"
  end

  def create(directory = 'data/')
    File.open("#{directory}#{@id}.post", 'w') { |f| Marshal.dump(self, f) }
  end

  def self.load_files(directory = 'data/')
    posts = []
    Dir.glob(directory + '*.post').each do |file|
      posts << load_file(File.basename(file, '.post'))
    end
    posts
  end

  def self.load_file(id, directory = 'data/')
    File.open("#{directory}#{id}.post", 'r') { |f| Marshal.load(f) }
  end
end
