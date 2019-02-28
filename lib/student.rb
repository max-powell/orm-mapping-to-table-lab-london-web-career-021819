class Student
  attr_reader :id
  attr_accessor :name, :grade

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    query = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    SQL
    DB[:conn].execute(query)
  end

  def self.drop_table
    query = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(query)
  end

  def self.create(hash)
    student = Student.new(hash[:name], hash[:grade])
    student.save
    student
  end

  def save
    query = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL
    DB[:conn].execute(query, @name, @grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
end
