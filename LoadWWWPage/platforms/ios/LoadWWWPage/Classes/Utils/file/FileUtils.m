//
//  FileUtils.m
//  LoadWWWPage
//
//  Created by anyware on 17/2/8.
//
//

#import "FileUtils.h"

@implementation FileUtils


/**
 *  功能：获取指定目录下的所有的子目录
 */
+ (NSMutableArray*)getAllChildDirWithSourceDir:(NSString*)sourceDir
{
    NSMutableArray* subDirs = [NSMutableArray array];
    // 1.判断文件还是目录
    NSFileManager * fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:sourceDir isDirectory:&isDir];
    if (isExist) {
        // 2. 判断是不是目录
        if (isDir) {
            NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:sourceDir error:nil];
            NSString * subPath = nil;
            for (NSString * str in dirArray) {
                subPath  = [sourceDir stringByAppendingPathComponent:str];
                BOOL issubDir = NO;
                [fileManger fileExistsAtPath:subPath isDirectory:&issubDir];
                if(issubDir) {
                    [subDirs addObject:str];
                }
            }
        }
        else {
            NSLog(@"%@不是目录",sourceDir);
        }
    }else {
        NSLog(@"你打印的是目录或者不存在");
    }
    
    return subDirs;
}

/**
 *  功能：判断是否存在指定的目录
 */
+ (BOOL)isExistWithURL:(NSURL*)fileURL
{
    BOOL isOk = NO;
    NSFileManager* fm = [NSFileManager defaultManager];
    isOk = [fm fileExistsAtPath:fileURL.path];
    if(isOk) {
        NSLog(@"目录%@存在",fileURL.path);
    }else {
        NSLog(@"目录%@不存在",fileURL.path);
    }
    return isOk;
}

//移动文件
+ (void)moveFileFromURL:(NSURL *)fromURL toPath:(NSURL *)toURL {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([self isExistWithURL:fromURL] && [self isExistWithURL:toURL]) {
        [fileManager moveItemAtURL:fromURL toURL:toURL error:&error];
    }
    if(error) {
        NSLog(@"移动文件%@到%@出错",fromURL.path,toURL.path);
    }
}

//删除文件
+ (void)deleteFileWithURL:(NSURL *)fileURL {
    NSError *error = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    if([self isExistWithURL:fileURL]) {
        //删除
        [manager removeItemAtURL:fileURL error:&error];
        if(error) {
            NSLog(@"删除%@出错",fileURL.path);
        }
    }
}

//创建文件
+ (void)createFileWithURL:(NSURL *)fileURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([self isExistWithURL:fileURL]) {
        [fileManager removeItemAtURL:fileURL error:&error];
    }
    [fileManager createDirectoryAtURL:fileURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    if(error) {
        NSLog(@"创建文件%@出错",fileURL.path);
    }
}

//创建文件夹
+ (void)createDictionaryWithURL:(NSURL *)fileURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([self isExistWithURL:fileURL]) {
        [fileManager removeItemAtURL:fileURL error:&error];
    }
    [fileManager createDirectoryAtURL:fileURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    if(error) {
        NSLog(@"创建文件夹%@出错",fileURL.path);
    }
}

@end
