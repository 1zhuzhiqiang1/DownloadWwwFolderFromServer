//
//  HCPFileDownloader.m
//
//  Created by Nikolay Demyankov on 11.08.15.
//

#import "ZQFileDownloader.h"

@interface ZQFileDownloader()<NSURLSessionDownloadDelegate>
{
    NSArray *_filesList;
    NSURL *_srcUrl;
    NSString* _toFolderPath;
    NSDictionary *_headers;
    NSString *_fileName;
    
    NSURLSession *_session;
    ZQFileDownloadCompletionBlock _complitionHandler;
    NSUInteger _downloadCounter;
}

@end

static NSUInteger const TIMEOUT = 300;

@implementation ZQFileDownloader

#pragma mark Public API

- (instancetype)initWithSrcUrl:(NSURL *)srcUrl toFolderPath:(NSString*)toFolderPath requestHeaders:(NSDictionary *)headers
{
    self = [super init];
    if (self) {
        _srcUrl = srcUrl;
        _toFolderPath = toFolderPath;
        _headers = headers;
    }
    return self;
}

- (NSURLSession *)sessionWithHeaders:(NSDictionary *)headers
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    configuration.timeoutIntervalForRequest = TIMEOUT;
    configuration.timeoutIntervalForResource = TIMEOUT;
    if (headers) {
        [configuration setHTTPAdditionalHeaders:headers];
    }
    
    return [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
}

- (void)startDownloadWithCompletionBlock:(ZQFileDownloadCompletionBlock)block
{
    _complitionHandler = block;
    _session = [self sessionWithHeaders:_headers];
    
    [[_session downloadTaskWithURL:_srcUrl] resume];
}

#pragma mark NSURLSessionDownloadDelegate delegate

/* 下载出错 */
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    if (error && _complitionHandler) {
        _complitionHandler(error);
        _session = nil;
        NSLog(@"URLSession：下载出错");
    }
}

/* 监听下载进度 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                                           didWriteData:(int64_t)bytesWritten
                                      totalBytesWritten:(int64_t)totalBytesWritten
                              totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"已经下载:%lld",bytesWritten);
}

/* 完成下载 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSError *error = nil;
    [self moveLoadedFileWithFromFolder:location.path toFolder:_toFolderPath fileName:@"www.zip" error:&error];
    _complitionHandler(error);
}

#pragma Private API

/**
 * 功能：将下载的文件从tmp文件夹移动到指定的目录
 */
- (BOOL)moveLoadedFileWithFromFolder:(NSString *)fromPath toFolder:(NSString *)toPath fileName:(NSString*)fileName error:(NSError **)error
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    toPath = [toPath stringByAppendingPathComponent:fileName];
    
    NSLog(@"FromPath=%@",fromPath);
    NSLog(@"toPath=%@",toPath);
    
    if ([fileManager fileExistsAtPath:toPath]) {
        [fileManager removeItemAtPath:toPath error:error];
    }
    
    BOOL result = [fileManager moveItemAtPath:fromPath toPath:toPath error:error];
    return result;
}


@end
