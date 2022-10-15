protocol ReadableStorage {
  func read<T: Decodable>(_ type: T.Type, for key: String) async -> Result<T, StorageError>
}

protocol WritableStorage {
  @discardableResult func write<T: Encodable>(_ value: T, for key: String) async -> Result<T, StorageError>
}

typealias Storage = ReadableStorage & WritableStorage
