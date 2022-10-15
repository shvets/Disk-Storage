import Foundation

class DiskStorage {
  private let queue: DispatchQueue
  private let fileManager: FileManager
  private let path: URL

  init(path: URL, queue: DispatchQueue = .init(label: "DiskCache.Queue"),
       fileManager: FileManager = FileManager.default) {
    self.path = path
    self.queue = queue
    self.fileManager = fileManager
  }

  private func createFolders(in url: URL) throws {
    let folderUrl = url.deletingLastPathComponent()

    if !fileManager.fileExists(atPath: folderUrl.path) {
      try fileManager.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
    }
  }

  public func getPath() -> String {
    String(path.pathComponents.joined(separator: "/").dropFirst())
  }
}

extension DiskStorage: ReadableStorage {
  func read<T: Decodable>(_ type: T.Type, for key: String) async -> Result<T, StorageError> {
    await withCheckedContinuation { continuation in
      let url = path.appendingPathComponent(key)

      if let data = fileManager.contents(atPath: url.path) {
        do {
          let value = try JSONDecoder().decode(type, from: data)

          continuation.resume(returning: .success(value))
        }
        catch {
          continuation.resume(returning: .failure(.genericError(error: error)))
        }
      }
      else {
        continuation.resume(returning: .failure(.notFound))
      }
    }
  }
}

extension DiskStorage: WritableStorage {
  @discardableResult func write<T: Encodable>(_ value: T, for key: String) async -> Result<T, StorageError> {
    await withCheckedContinuation { continuation in
      let url = path.appendingPathComponent(key)

      do {
        try createFolders(in: url)

        let data = try JSONEncoder().encode(value)

        try data.write(to: url, options: .atomic)

        continuation.resume(returning: .success(value))
      }
      catch {
        continuation.resume(returning: .failure(.genericError(error: error)))
      }
    }
  }
}
