import SwiftUI

struct EditMovieView: View {
    @Binding var movie: Movie
    var onSave: (Movie) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $movie.title)
                TextField("Overview", text: $movie.overview)
            }
            .navigationTitle("Edit Movie")
            .navigationBarItems(trailing: Button("Save") {
                onSave(movie)
            })
        }
    }
}
