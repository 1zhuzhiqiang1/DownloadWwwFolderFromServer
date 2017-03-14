//
//  FileUtils.h
//  LoadWWWPage
//
//  Created by anyware on 17/2/8.
//
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

// 获取文件夹下所有的子目录
+ (NSMutableArray*)getAllChildDirWithSourceDir:(NSString*)sourceDir;
// 文件是否存在
+ (BOOL)isExistWithURL:(NSURL*)fileURL;
//移动文件
+ (void)moveFileFromURL:(NSURL *)fromURL toPath:(NSURL *)toURL;
//删除文件
+ (void)deleteFileWithURL:(NSURL *)fileURL;
//创建文件
+ (void)createFileWithURL:(NSURL *)fileURL;
//创建文件夹
+ (void)createDictionaryWithURL:(NSURL *)fileURL;


@end
