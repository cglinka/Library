require 'date'

#Create a new book.
class Book
  attr_accessor :status, :description
  attr_reader :author, :title, :check_out_date, :due_date

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


# Library Class holds books and methods for updating the status of books.

class Library

  attr_reader :books

  # Initialize the three arrays that hold information about books.
  def initialize
    @books = []
    @checked_out = []
    @overdue = []
  end

  # Add a book to the library
  #
  # book - the Object to be added.
  #
  def add_book(book)
    if book.is_a?(Book)
      @books << book
    end
  end

  def list_books
    @books.each { |book| puts "#{book.title} - #{book.author} : #{book.status}"}
  end

  def list_checked_out
    @checked_out.each { |book| puts "#{book.title} - #{book.author}" }
  end

  def list_overdue
    @overdue.each { |book| puts "#{book.title} - #{book.author}" }
  end

  def check_out(book, user)
    if user.checked_out_books.length >= 2
      puts "You have too many books checked out. You must return at least one book before you can check out another book."      
    #elsif user.checked_out_books.each {}
    else 
      book.status == "available"
      book.status = "checked out"
      user.checked_out_books << book
      book.check_out_date = DateTime.now
      book.due_date = book.check_out_date + 7
      @checked_out << book
    end
  end

  def check_in(book, user)
    if book.status == "checked out"
      book.status = "available"
      user.checked_out_books.delete_if { |e| e == book }
      book.check_out_date = nil
      book.due_date = nil
      @checked_out.delete_if { |e| e == book }
      @overdue.delete_if { |e| e == book }
    else
      puts "This book is not checked out"
    end
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

