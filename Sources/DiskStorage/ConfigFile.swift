import Foundation
import Files

open class ConfigFile<T: Codable> {
  private let fileManager = FileManager.default

  private var list: [String: T] = [:]

  public var items: [String: T] {
    get {
      list
    }

    set {
      list = newValue
    }
  }

  private var fileName: String = ""

  private let storage: DiskStorage!

  public init(path: URL, fileName: String) {
    storage = DiskStorage(path: path)

    self.fileName = fileName
  }
}

extension ConfigFile: Configuration {
  public func exists() -> Bool {
    fileManager.fileExists(atPath: "\(storage.getPath())/\(fileName)")
  }

  public func clear() {
    items.removeAll()
  }

  public func add(key: String, value: T) {
    items[key] = value
  }

  public func remove(_ key: String) -> Bool {
    items.removeValue(forKey: key) != nil
  }

  @discardableResult public func read() async -> Result<[String: T], StorageError> {
    clear()

    return await storage.read([String: T].self, for: fileName)
  }

  @discardableResult public func write() async -> Result<[String: T], StorageError> {
    await storage.write(items, for: fileName)
  }
}
