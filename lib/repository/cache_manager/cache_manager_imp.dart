import 'package:GM_Nav/repository/cache_manager/cache_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ICacheManager implements CacheManager {
  DefaultCacheManager _defaultCacheManager;

  ICacheManager() {
    _defaultCacheManager = new DefaultCacheManager();
  }

  @override
  Future<void> cacheData(String url) async {
    await _defaultCacheManager.downloadFile(url);
  }

  @override
  Future<dynamic> getCache(String url) async {
    return (await _defaultCacheManager.getSingleFile(url)).path;
  }

  @override
  Future<void> removeFileCache(String url) async {
    await _defaultCacheManager.removeFile(url);
  }

  @override
  Future<void> emptyCache() async {
    await _defaultCacheManager.emptyCache();
  }
}
