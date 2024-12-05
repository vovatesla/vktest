import SwiftUI

struct MovieCell: View {
    let movie: Movie
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            if let posterURL = movie.posterURL {
                AsyncImage(url: posterURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 150)
                    case .success(let image):
                        image.resizable()
                             .scaledToFill()
                             .frame(width: 100, height: 150)
                             .clipped()
                    case .failure:
                        Color.gray
                             .frame(width: 100, height: 150)
                             .overlay(Text("No Image").foregroundColor(.white))
                    @unknown default:
                        EmptyView()
                    }
                }
                .onAppear {
                    print("Image URL: \(posterURL.absoluteString)")
                }
            } else {
                Color.gray
                    .frame(width: 100, height: 150)
                    .overlay(Text("No Image").foregroundColor(.white))
                    .onAppear {
                        print("No poster path available for movie: \(movie.title)")
                    }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(1)

                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.leading, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(colorScheme == .dark ? Color.black : Color.white)  
                .shadow(radius: 5)
        )
    }
}
