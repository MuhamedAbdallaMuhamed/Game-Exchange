abstract class FileManager {
  Future<void> create();

  Future<void> write(String docID);

  Future<String> read();
}
