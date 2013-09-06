#Create a new book.
class Book
  
  #initialize variables 'author' and 'title' for each new book.
  def initialize(author, title)
    @author = author
    @title = title
    @status = "available"
  end

  #optionally add a description to a book that already exists.
  def add_description(desc)
    @description = desc
  end


  #Output the title, author, and status of each book.
  def get_info
    puts "#{@title} by #{@author} is #{@status}."
  end

end


class Library

end

class User

end

