public enum StorageError: Error {
  case genericError(error: Error)
  case notFound
  case cantWrite(Error)
}