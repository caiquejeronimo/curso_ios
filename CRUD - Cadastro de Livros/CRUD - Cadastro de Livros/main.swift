import Foundation

/// Define o protocol base que será utilizado ao decorrer da aplicação

protocol Document {
    
    /// Identificador unico do documento
    var id: UUID { get }
    
    /// Exibe os detalhes do documento no console
    func showDetails()
}

/// Representa um livro de uma biblioteca
///
/// Implementa o protocol `Document` e contém as infos basicas de um livro

class Book: Document {
    /// Identificador unico do livro
    let id: UUID
    
    /// Infos basicas do livro, como titulo, autor, ano de publicação e se o livro está emprestado
    
    private(set) var title: String
    private(set) var author: String
    private(set) var yearPublished: Int
    private(set) var isBorrowed: Bool
    
    
    /// Cria uma nova instancia de livro, com parametos sendo:
    /// - Parameters:
    ///  - id: UUID unico do livro
    ///  - title: Titulo do livro
    ///  - author: Autor do livro
    ///  - yearPublished: Ano de publicação
    ///  - isBorrowed:  Se o livro está emprestado
    init(id: UUID, title: String, author: String, yearPublished: Int, isBorrowed: Bool) {
        self.id = id
        self.title = title
        self.author = author
        self.yearPublished = yearPublished
        self.isBorrowed = isBorrowed
    }
    
    /// Marca o livro como emprestado
    func borrow() {
        /// impede emprestimos duplicados
        guard !isBorrowed else {
            print("Book already borrowed")
            return
        }
        isBorrowed = true
    }
    /// Marca o livro como devolvido
    func returnBook() {
        /// Impede devoluções de livros já devolvidos
        guard isBorrowed else {
            print("Book available!")
            return
        }
        isBorrowed = false
    }
    
    /// Atualiza o título do livro.
    ///
    ///  - Parameter newTitle: Novo título
    func updateTitle(_ newTitle: String) {
        title = newTitle
    }
    
    /// Atualiza o autor do livro
    ///
    /// - Parameter newAuthor: Novo autor
    func updateAuthor(_ newAuthor: String) {
        author = newAuthor
    }
    /// Atualiza o ano de publicação do livro
    ///
    /// - Parameter newYear: Novo ano
    func updateYear(_ newYear: Int) {
        yearPublished = newYear
    }
    /// Exibe no console todas as informações do livro
    func showDetails() {
        print("ID: \(id) | title: \(title) | Author: \(author) | Year Published: \(yearPublished) | Is Borrowed: \(isBorrowed ? "Yes" : "No")")
    }
}

    /// Classe de livros digitals que herda a classe `Book` e adiciona fileSize nos paremtros
class EBook: Book {
    /// Tamanho do arquivo em MB
    var fileSize: Double
    
    /// Cria a instancia de um livro digital.
    ///
    /// - Parameters:
    ///  - id: UUID unico do livro
    ///  - title: Titulo do livro
    ///  - author: Autor do livro
    ///  - yearPublished: Ano de publicação
    ///  - isBorrowed: Se o livro está emprestado
    ///  - fileSize:ttamanho do arquivo em MB
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
    /// Exibe os detalhes do livro digital
    ///
    /// Sobrescreve a func `showDetails` da classe pai p/ incluir o tamanho do arquivo
    override func showDetails() {
        super.showDetails()
        print("File Size: \(fileSize) MB")
    }
}

/// Responsável por gerenciar a biblioteca
///
/// Implementa o CRUD
class Library {
    /// Lista de livros cadastrados
    var bookList: [Book] = []
    
    /// Adiciona um livro à biblioteca e impede duplicados
    /// - Parameter book: Livro a ser cadastrado
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
    
    /// Lista todos os livros cadastrados
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
    
    /// Busca um livro pelo ID.
    ///
    /// - Parameter id: UUID do livro.
    func searchBook(byId id: UUID) {
        if let book = bookList.first(where: { $0.id == id }) {
            book.showDetails()
        } else {
            print("Book not found!")
        }
    }
    
    
    /// Busca livros pelo título.
    ///
    /// A busca não diferencia letras maiúsculas de minúsculas.
    ///
    /// - Parameter title: Nome do titulo
    func searchBook(byTitle title: String) {
        if let book = bookList.first(where: { $0.title.lowercased() == title.lowercased() }) {
            book.showDetails()
        } else {
            print("Book not found!")
        }
    }
    
    /// Remove um livro da biblioteca.
    ///
    /// - Parameter id: ID do livro.
    
    func remove(byId id: UUID) {
        guard let index = bookList.firstIndex(where: { $0.id == id }) else {
            print("Book not found!")
            return
        }
        
        bookList.remove(at: index)
        print("Book removed successfully")
    }
    
    /// Atualiza as informações de um livro.
    ///
    /// - Parameters:
    ///  - id: UUID unico do livro
    ///  - newTitle: Novo titulo do livro
    ///  - newAuthor: Novo Autor do livro
    ///  - newYear: Novo ano de publicação
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


/// Menu principal que ficará no console
func showMenu() {
    print("""
    ===== LIBRARY OPERATIONS =====
---------------------------------------
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
/// Laço infinito que mostra o menu no terminal
///
/// Ao escolher 0, desliga o terminal
while true {
    showMenu()
    
    guard let option = readLine() else { continue }
    
    switch option {
    case "1":
        print("1 - Physical Book")
        print("2 - E-book")
        
        let type = readLine()
        
        print("Enter book title:")
        guard let title = readLine() else { break }
        
        print("Enter book author: ")
        guard let author = readLine() else { break }
        
        print("Year Published: ")
        guard let yearInput = readLine(), let year = Int(yearInput) else {
            print("Invalid Year")
            break
        }
    
        
        if type == "1" {
            let book = Book(id: UUID(), title: title, author: author, yearPublished: year, isBorrowed: false)
           
            library.addBook(book)
        } else if type == "2" {
            print("File Size (MB):")
            
            guard let sizeInput = readLine(), let fileSize = Double(sizeInput) else {
                print("Invalid size")
                break
            }
            
            let ebook = EBook(id: UUID(), title: title, author: author, yearPublished: year, isBorrowed: false, fileSize: fileSize)
            library.addBook(ebook)
        }
        
    case "2":
        print("Book list:")
        library.showAllBooks()
    case "3":
        print("Book ID:")
        guard let idInput = readLine(), let id = UUID(uuidString: idInput) else {
            print("Invalid ID")
            break
        }
        library.searchBook(byId: id)
    case "4":
        
        print("Title:")
        
        guard let title = readLine() else { break }
        
        library.searchBook(byTitle: title)
    case "5":
        
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
        
        print("Book ID:")
        
        guard let idInput = readLine(), let id = UUID(uuidString: idInput) else {
            print("Invalid ID")
            break
        }
        
        library.remove(byId: id)
    case "7":
        
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
