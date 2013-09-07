# Create a new book.
class Book
  attr_accessor :status, :description, :check_out_date, :due_date, :who_checked
  attr_reader :author, :title

  # Initialize instance variables 'author' and 'title' for each new book.
  #
  # title - String
  # author - String
  #
  def initialize(title, author)
    @author = author
    @title = title
    @status = "available"
    @check_out_date
    @due_date
    @who_checked
  end

  # Optionally add a description to a book that already exists.
  def add_description(desc)
    @description = desc
    puts "#{@title} now has a description of: '#{@description}'."
  end

  # Output the title, author, and status of each book.
  def get_info
    puts "#{@title} by #{@author} is #{@status}."
  end

  # Update the status of a book to overdue if it is past it's due date.
  def update_status
    if @due_date == nil
      puts "#{@title} has not been checked out."
    elsif ( (Time.now.yday - @due_date) > 0 )
      @status = "overdue"
      puts "#{@title} is overdue! Please return!"
      return true
    else
      days_left = @due_date - Time.now.yday
      puts "You have #{days_left} days before you need to return #{@title}."
      return false
    end    
  end

end # End of Book class


# Library Class holds books and methods for updating the status of books.
#
class Library

  attr_reader :books, :checked_out, :overdue

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

  # List all books in library. Displays Title - Author : Status.
  def list_books
    @books.each { |book| puts "#{book.title} - #{book.author} : #{book.status}"}
  end

  # List all books in the 'checked_out' array.
  def list_checked_out
    @checked_out.each { |book| puts "#{book.title} - #{book.author}" }
  end

  # List all books in the 'overdue' array.
  def list_overdue
    @overdue.each { |book| puts "#{book.title} - #{book.author}" }
  end

  # Check if a book is overdue
  # def overdue_check(book)
  #   today = Time.now.yday
  #   if book.due_date == nil
  #     puts "I think #{book.title} is not checked out!"
  #     return false 
  #   elsif ((today - book.due_date) > 7)
  #     book.status = "overdue"
  #     puts "#{book.title} is overdue! Please return it asap!"
  #     return true
  #   elsif book.status == "overdue"
  #     return true
  #     puts "This book is overdue!"
  #   else
  #     puts "#{book.title} is not overdue. Enjoy!"
  #     return false
  #   end 
  # end

  # Method for checking out books
  #
  # book - Book object
  # user - User object
  #
  def check_out(book, user)
    # Check the number of books a user has checked out
    if user.checked_out_books.length >= 2
      puts "You have too many books checked out. You must return at least one book before you can check out another book."

    # Check if the user has overdue books
    elsif book.update_status
      puts "You have overdue books! No new books for you! Return your overdue books to be allowed to check out new books."

    # Check out the book
    elsif book.status == "available"
      book.status = "checked out"
      user.checked_out_books << book
      book.check_out_date = Time.now.yday  # Note: does not work for multiple years / days at the turn of the new year. Needs better method for getting date.
      book.due_date = book.check_out_date + 7
      @checked_out << book
      book.who_checked = user.name
    
    else
      puts "You have discovered a problem with the check_out method! Sorry!"
    end
  end

  # Method for checking books back in to the library
  # 
  # book - Book object
  # user - User object
  #
  def check_in(book, user)
    # Check if book is already checked out
    if book.status == "checked out" || book.status == "overdue"
      book.status = "available"

      # Remove from user's checked out book array
      user.checked_out_books.delete_if { |e| e == book }
      
      # Reset the check out and due dates to nothing
      book.check_out_date = nil
      book.due_date = nil
      
      # Remove from the library's checked out and overdue arrays.
      @checked_out.delete_if { |e| e == book }
      @overdue.delete_if { |e| e == book }

      # Remove the user who checked out the book
      book.who_checked = nil
    elsif book.status == "available"
      # Error message for book that is not checked out.
      puts "This book is not checked out"
    elsif book.status == "lost"
      book.status  = "available"
      puts "Thanks for bringing #{book.title} back!"
    else
      puts "There is something wrong with the book you've tried to check out. This is an error message. Sorry."
    end
  end

end # End of Library class

#Create user who can check out books.
class User
  attr_accessor :name
  attr_reader :checked_out_books

  def initialize(name)
    @name = name
    @checked_out_books = []
    @overdue_books = []
  end

end # End of User class

