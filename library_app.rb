#Create a new book.
class Book
  attr_accessor :status, :description
  attr_reader :author, :title

  #initialize variables 'author' and 'title' for each new book.
  def initialize(title, author)
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
  attr_reader :books

  def initialize
    @books = []
  end

  def add_book(book)
    @books << book    
  end

  def list_books
    
  end

  def check_out(book, user)
    book.status = "checked out"
    user.checked_out_books << book
  end

  def check_in(book, user)
    book.status = "available"
    user.checked_out_books.delete_if { |e| e == book }
  end

end

#Create user who can check out books.
class User
  attr_reader :name, :checked_out_books

  def initialize(name)
    @name = name
    @checked_out_books = []
  end

end

