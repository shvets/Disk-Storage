import Foundation

protocol Configuration {
  associatedtype Item: Codable

  var items: [String: Item] { get set }

  func exists() -> Bool
  
  func clear()
  
  func add(key: String, value: Item)

  func remove(_ key: String) -> Bool
  
  func read() async -> Result<[String: Item], StorageError>

  func write() async -> Result<[String: Item], StorageError>
}
