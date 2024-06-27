//
//  ContentView.swift
//  Mybooks
//
//  Created by PEDRO PAULO DA SILVA on 25/06/24.
//

import SwiftUI
import SwiftData

struct BookListView: View {
    //cria uma consulta que busca todos os objetos Book no banco de dados e os ordena pelo título, armazenando-os na variável books
    @Environment(\.modelContext) private var context
    @Query(sort: \Book.title) private var books: [Book]
    @State private var createNewBook = false
    var body: some View {
        NavigationStack{
            Group{
                //caso nao tenha livros no banco exibe essa tela
                if books.isEmpty{
                    ContentUnavailableView("Enter your First Book.", systemImage: "book.fill")
                    //se nao exibe a tela com os livros
                    //MARK: exibe lista de livros caso o banco de dados tenha dados
                } else {
                    List{
                        ForEach(books) {book in // book e a variavel temporaria do foreach q acessa books
                            NavigationLink{ //MARK: qndo clicamos no livro ele apresenta a editBookView
                                EditBookView(book: book)
                            } label: {
                                HStack(spacing: 10){
                                    book.icon
                                    VStack(alignment: .leading){
                                        Text(book.title).font(.title2)
                                        Text(book.author).foregroundStyle(.secondary)
                                        if let rating = book.rating{
                                            HStack{
                                                ForEach(1..<rating, id: \.self){
                                                    _ in
                                                    Image(systemName: "star.fill")
                                                        .imageScale(.small)
                                                        .foregroundColor(.yellow)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //MARK: deleta um item da lista utilizando o index da list e associando com o do array de objs books
                        .onDelete{ indexSet in
                            indexSet.forEach{index in
                                let book = books[index]
                                context.delete(book)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My Books")
            .toolbar{
                Button{
                    createNewBook = true
                }label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.medium)
                }
                
            }
            //MARK: exibe a NewBookView qndo a variavel de estado createNewBook for igual a true
            .sheet(isPresented: $createNewBook){
                NewBookView()
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    BookListView()
        .modelContainer(for: Book.self, inMemory: true)
}
