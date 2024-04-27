class Book {
  String title;
  String author;

  Book({required this.title, required this.author});
}

class BookData {
  List<Book> books = [
    Book(title: "Contoh buku 1", author: "Author A"),
    Book(title: "Buku Flutter TI-A", author: "Author B"),
  ];

  void addBook(String title, String author) {
    books.add(Book(title: title, author: author));
  }

  void deleteBook(int index) {
    if (index >= 0 && index < books.length) {
      books.removeAt(index);
    }
  }

  void updateBook(int index, String title, String author) {
    if (index >= 0 && index < books.length) {
      books[index] = Book(title: title, author: author);
    }
  }
}