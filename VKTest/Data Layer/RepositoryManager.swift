// RepositoryManager.swift
import RealmSwift

class RepositoryManager {
    private var realm: Realm

    init() {
        realm = try! Realm()
    }

    func save(repository: Movie) {
        let repositoryObject = RepositoryObject()
        repositoryObject.id = repository.id
        repositoryObject.name = repository.title
        repositoryObject.descriptionText = repository.overview
        repositoryObject.avatarUrl = repository.posterPath
        
        try? realm.write {
            realm.add(repositoryObject)
        }
    }
    
    func delete(repository: Movie) {
        if let object = realm.object(ofType: RepositoryObject.self, forPrimaryKey: repository.id) {
            try? realm.write {
                realm.delete(object)
            }
        }
    }
    
    func update(repository: Movie) {
        if let object = realm.object(ofType: RepositoryObject.self, forPrimaryKey: repository.id) {
            try? realm.write {
                object.name = repository.title
                object.descriptionText = repository.overview
                object.avatarUrl = repository.posterPath
            }
        }
    }
    
    func getRepositories() -> [Movie] {
        let repositories = realm.objects(RepositoryObject.self)
        return repositories.map { Movie(id: $0.id, title: $0.name, overview: $0.descriptionText, posterPath: $0.avatarUrl, voteAverage: nil) }
    }
}

