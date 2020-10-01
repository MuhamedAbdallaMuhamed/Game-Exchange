abstract class CacheManager {
  Future<void> cacheData(String url);
  Future<dynamic> getCache(String url);
  Future<void> removeFileCache(String url);
  Future<void> emptyCache();
}
