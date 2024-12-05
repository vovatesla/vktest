// RepositoryObject.swift
import RealmSwift
import Foundation

class RepositoryObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var avatarUrl: String? = nil

    override static func primaryKey() -> String? {
        return "id"
    }
}
