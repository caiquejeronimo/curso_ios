import Foundation

protocol Document {
    var id: UUID { get }
    
    func showDetails()
}

class Book: Document {
    let id: UUID
    
    private(set) var title: String
    private(set) var author: String
    private(set) var yearPublished: Int
    private(set) var isBorrowed: Bool
    
    init(id: UUID, title: String, author: String, yearPublished: Int, isBorrowed: Bool) {
        self.id = id
        self.title = title
        self.author = author
        self.yearPublished = yearPublished
        self.isBorrowed = isBorrowed
    }
    
    func borrow() {
        guard !isBorrowed else {
            print("Book already borrowed")
            return
        }
        isBorrowed = true
    }
    
    func returnBook() {
        guard isBorrowed else {
            print("Book available!")
            return
        }
        isBorrowed = false
    }
    
    func updateTitle(_ newTitle: String) {
        title = newTitle
    }
    
    func updateAuthor(_ newAuthor: String) {
        author = newAuthor
    }
    func updateYear(_ newYear: Int) {
        yearPublished = newYear
    }
    
    func showDetails() {
        print("ID: \(id) | title: \(title) | Author: \(author) | Year Published: \(yearPublished) | Is Borrowed: \(isBorrowed ? "Yes" : "No")")
    }
}

class eBook: Book {
    var fileSize: Double
    
    init(id: UUID, title: String, author: String, yearPublished: Int, isBorrowed: Bool,fileSize: Double) {
        self.fileSize = fileSize
        super.init(
            id: id,
            title: title,
            author: author,
            yearPublished: yearPublished,
            isBorrowed: isBorrowed
        )
    }
    
    override func showDetails() {
        super.showDetails()
        print("File Size: \(fileSize) MB")
    }
}

class Library {
    var bookList: [Book] = []
    
    func addBook(_ book: Book) {
        let bookExists = bookList.contains {
            $0.id == book.id
        }
        
        guard !bookExists else {
            print("This book is already added to the library")
            return
        }
        bookList.append(book)
        print("Book succesfully added!")
    }
    
    func showAllBooks() {
        let separator: String = "----------------"
        
        guard !bookList.isEmpty else {
            print("No books in the library")
            return
        }
        
        bookList.forEach {
            book in book.showDetails()
            print(separator)
        }
    }
    
    func searchBook(byId id: UUID) {
        if let book = bookList.first(where: { $0.id == id }) {
            book.showDetails()
        } else {
            print("Book not found!")
        }
    }
    
    func searchBook(byTitle title: String) {
        if let book = bookList.first(where: { $0.title.lowercased() == title.lowercased() }) {
            book.showDetails()
        } else {
            print("Book not found!")
        }
    }
    
    func remove(byId id: UUID) {
        guard let index = bookList.firstIndex(where: { $0.id == id }) else {
            print("Book not found!")
            return
        }
        
        bookList.remove(at: index)
        print("Book removed successfully")
    }
    
    func updateBook(id: UUID, newTitle: String?, newAuthor: String?, newYear: Int?) {
        guard let book = bookList.first(where: { $0.id == id }) else {
            print("Book not found!")
            return
        }
        
        if let title = newTitle {
            book.updateTitle(title)
        }
        if let author = newAuthor {
            book.updateAuthor(author)
        }
        if let year = newYear {
            book.updateYear(year)
        }
        
        print("Book updated")
    }
}

let library = Library()

// Menu

func showMenu() {
    print("""
    LIBRARY OPERATIONS

    1 - Add Book
    2 - List Books
    3 - Search Book by ID
    4 - Search Book by Title
    5 - Update Book
    6 - Remove Book
    7 - Borrow Book
    8 - Return Book
    0 - Exit

""")
}

while true {
    showMenu()
    
    guard let option = readLine() else { continue }
    
    switch option {
    case "1":
        print("Add book")
        
        print("Enter book title:")
        guard let title = readLine() else { break }
        
        print("Enter book author: ")
        guard let author = readLine() else { break }
        
        print("Year Published: ")
        guard let yearInput = readLine(), let year = Int(yearInput) else {
            print("Invalid Year")
            break
        }
        
        let book = Book(id: UUID(), title: title, author: author, yearPublished: year, isBorrowed: false)
        
       
        library.addBook(book)
        
        
    case "2":
        print("List books")
        
        library.showAllBooks()
    case "3":
        print("Search book by ID")
        print("Book ID:")
        guard let idInput = readLine(), let id = UUID(uuidString: idInput) else {
            print("Invalid ID")
            break
        }
        library.searchBook(byId: id)
    case "4":
        print("Search book by title")
        
        print("Title:")
        
        guard let title = readLine() else { break }
        
        library.searchBook(byTitle: title)
    case "5":
        print("Update book")
        
        print("Book ID: ")
        
        guard let idInput = readLine(), let id = UUID(uuidString: idInput) else {
            print("Invalid ID")
            break
        }
        print("New title:")
        let newTitle = readLine()
        
        print("New Author")
        let newAuthor = readLine()
        
        print("New Year:")
        
        let yearText = readLine()
        let newYear = Int(yearText ?? "")
        
        library.updateBook(id: id, newTitle: newTitle, newAuthor: newAuthor, newYear: newYear)
    case "6":
        print("Remove book")
        
        print("Book ID:")
        
        guard let idInput = readLine(), let id = UUID(uuidString: idInput) else {
            print("Invalid ID")
            break
        }
        
        library.remove(byId: id)
    case "7":
        print("Borrow book")
        
        print("Book ID: ")
        
        guard let idInput = readLine(), let id = UUID(uuidString: idInput) else {
            print("Invalid ID")
            break
        }
        
        if let book = library.bookList.first(where: { $0.id == id }) {
            book.borrow()
        } else {
            print("Book not found")
        }
    case "8":
        print("Return book")
        
        print("Book ID: ")
        
        guard let idInput = readLine(), let id = UUID(uuidString: idInput) else {
            print("Invalid ID")
            break
        }
        
        if let book = library.bookList.first(where: { $0.id == id }) {
            book.returnBook()
        } else {
            print("Book not found")
        }
    case "0":
        print("Exiting...")
        exit(0)
    default:
        print("Invalid option. Try again.")
    }

}


