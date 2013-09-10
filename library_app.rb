# Create a new book.
class Book
  attr_accessor :status, :description, :check_out_date, :due_date, :who_checked, :title
  attr_reader :author

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
    puts "#{@title} now has a description of: '#{@description}'"
  end

  # Output the title, author, and status of each book.
  def get_info
    puts "#{@title} by #{@author} is #{@status}."
    if @description
      puts "#{@title} description: #{@description}."
    end
  end

  # Update the status of a book to overdue if it is past it's due date.
  def is_overdue
    if @due_date
      if ( (Time.now - @due_date) > 0 )
        @status = "overdue"
        puts "#{@title} is overdue! Please return!"
      else
        days_left = @due_date.yday - Time.now.yday
        puts "You have #{days_left} days before you need to return #{@title}."
      end

    else
      puts "#{@title} has not been checked out."
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
    if book.is_a? Book # This test does not work as intended. I get a NameError undefined local variable.
      @books << book
      puts "#{book.title} by #{book.author} has been added to the library."
    else
      puts "That is not a book. Try again."
    end
  end

  # List all books in library. Displays Title - Author : Status.
  def list_books
    @books.each { |book| puts "#{book.title} - #{book.author} : #{book.status}"}
  end

  # List all books in the 'checked_out' array.
  def list_checked_out
    @checked_out.each { |book| puts "#{book.title} - #{book.author} : Due on #{book.due_date.ctime}" }
  end

  # List all books in the 'overdue' array.
  def list_overdue
    @checked_out.each do |book|
      book.is_overdue
    end
    
    puts "The following books are overdue:"
    @overdue.each { |book| puts "#{book.title} - #{book.author}" }
  end

  # Method for checking out books
  #
  # book - Book object
  # user - User object
  #
  def check_out(book, user)
    user.overdue_update

    # Check the number of books a user has checked out
    if user.checked_out_books.length >= 2
      puts "You have too many books checked out. You must return at least one book before you can check out another book."

    # Check if the user has overdue books
    elsif user.overdue_books.any? 
      puts "You have overdue books! No new books for you! Return your overdue books to be allowed to check out new books."
  
    # Check out the book
    elsif book.status == "available"
      book.status = "checked out"
      user.checked_out_books << book
      book.check_out_date = Time.now
      book.due_date = book.check_out_date + ((60*60*24)*7)
      @checked_out << book
      book.who_checked = user.name
      puts "#{book.title} has been checked out by #{book.who_checked}. Enjoy!"
    
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
      user.overdue_books.delete_if {|e| e == book }
      
      # Reset the check out and due dates to nothing
      book.check_out_date = nil
      book.due_date = nil
      
      # Remove from the library's checked out and overdue arrays.
      @checked_out.delete_if { |e| e == book }
      @overdue.delete_if { |e| e == book }

      # Remove the user who checked out the book
      book.who_checked = nil
    
    # Error message for book that is not checked out.
    elsif book.status == "available"
      puts "This book is not checked out"
    
    # Allows lost books to be returned.
    elsif book.status == "lost"
      book.status  = "available"
      puts "Thanks for bringing #{book.title} back!"
    
    # Malformed input or malfunctioning method error message.
    else
      puts "There is something wrong with the book you've tried to check out. This is an error message. Sorry."
    end
  end

end # End of Library class

#Create user who can check out books.
class User
  attr_accessor :name, :overdue_books
  attr_reader :checked_out_books

  def initialize(name)
    @name = name
    @checked_out_books = []
    @overdue_books = []
  end

  def get_name
    puts "User is named #{@name}"
  end

  def overdue_update
    @checked_out_books.each do |book|
      book.is_overdue
    end

    @checked_out_books.each do |book|
      if book.status == "overdue"
        @overdue_books << book
      end
    end
  end

  def print_checked_out
    puts "#{@name} has checked out the following books:"
    @checked_out_books.each do |book|
      puts "#{book.title}"
    end
  end

end # End of User class

# # TESTING

# # load 'library_app.rb'

# # Create a new library
# my_library = Library.new()

# # Create a new user
# user1 = User.new("Clare")
# user1.get_name # => User is named Clare


# # Create new books
# book1 = Book.new("Sabriel", "Garth Nix")
# book2 = Book.new("Jurassic Park", "That Guy")
# book3 = Book.new("Anne of Green Gables", "L M Montgomery")
# book4 = Book.new("The Phantom Tollbooth", "Norton Juster")

# # Books should be able to have information saved about them (author, title, description)
# book1.get_info # => Sabriel by Garth Nix is available.
# book2.get_info # => Jurassic Park by That Guy is available.
# book3.get_info # => Anne of Green Gables by L M Montgomery is available.
# book4.get_info # => The Phantom Tollbooth by Norton Juster is available.

# book1.add_description("Girl fights dead things with the help of magical bells and a cat.") # => Sabriel now has a description of: 'Girl fights dead things with the help of magical bells and a cat.'
# book1.get_info # => Sabriel by Garth Nix is available.
#                # => Sabriel description: Girl fights dead things with the help of magical bells and a cat.

# # Users should be able to add books to a library
# my_library.add_book(book1)   # => Sabriel by Garth Nix has been added to the library.
# my_library.add_book(book2)   # => Jurassic Park by That Guy has been added to the library.
# my_library.add_book(book3)   # => Anne of Green Gables by L M Montgomery has been added to the library.
# my_library.add_book("book")  # => That is not a book. Try again.
# # my_library.add_book(book5)  gives undefined local variable or method 'book' for main:Object (NameError)


# # A user should be able to check out books from the library for one week intervals
# my_library.check_out(book1, user1) # => Sabriel has been checked out by Clare. Enjoy!
# my_library.check_out(book2, user1) # => You have # days before you need to return Sabriel.
                                   # => Jurassic Park has been checked out by Clare. Enjoy!

# A user should not be able to check out more than two books at any given time
# my_library.check_out(book3, user1) # => You have 7 days before you need to return Sabriel.
#                                    # => You have 7 days before you need to return Jurassic Park.
#                                    # => You have too many books checked out. You must return at least one book before you can check out another book.

# # Checked-out books should be associated with a user
# # See the user who checked out an individual book.
# puts "#{book1.who_checked}"
# # See the boolist of books a user has checked out.
# user1.print_checked_out

# # Users with overdue books should not be able to request any new books until they turn all their overdue books in
# # Sets due_date of book1 to 8 days in the past. NOTE: comment out one of the checkouts above as necesary.
# book1.due_date = 250
# my_library.check_out(book3, user1)
# puts "#{book3.who_checked}"

# # Users should be able to check in books to the library when they're finished with them
# my_library.check_in(book1, user1)
# my_library.check_in(book2, user1)

# # Users should be able to check a book's status (e.g. available, checked out, overdue or lost)
# book1.status
# book2.status
# book3.status

# # Users should be able to see a list of who has checked out which book and when those books are due to be returned
# # Look at the array of checked out books
# my_library.checked_out
# # Nice list of checked out books with due dates
# my_library.list_checked_out

# # Users should be able to see a list of books that are overdue
# # Look at the array of overdue books
# my_library.overdue
# my_library.list_overdue


# # #check status of book
# # book1.status



