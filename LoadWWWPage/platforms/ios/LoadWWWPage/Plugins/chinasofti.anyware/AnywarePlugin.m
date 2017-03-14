/********* AnywarePlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

#import "ZQFileDownloader.h"

@interface AnywarePlugin : CDVPlugin {
  // Member variables go here.
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command;

- (void)downloadWwwFolder:(CDVInvokedUrlCommand*)command;

@end

@implementation AnywarePlugin

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:echo delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)downloadWwwFolder:(CDVInvokedUrlCommand*)command
{
    NSString* basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *wwwDataFolder = [basePath stringByAppendingPathComponent:@"wwwData"];
    if(![FileUtils isExistWithDir:wwwDataFolder]) {
        [FileUtils createDirWithDirName:@"wwwData" basePath:basePath];
    }
    
    NSString *zhuzhiqiangFolder = [wwwDataFolder stringByAppendingPathComponent:@"zhuzhiqiang"];
    if(![FileUtils isExistWithDir:zhuzhiqiangFolder]) {
        [FileUtils createDirWithDirName:@"zhuzhiqiang" basePath:wwwDataFolder];
    }
    
    NSString* srcString = @"http://172.16.1.216:8080/anyware/www.zip";
    srcString = [srcString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* srcUrl = [NSURL URLWithString:srcString];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ZQFileDownloader* downloadTask = [[ZQFileDownloader alloc] initWithSrcUrl:srcUrl toFolderPath:zhuzhiqiangFolder requestHeaders:nil];
        [downloadTask startDownloadWithCompletionBlock:^(NSError *error) {
            if(error) {
                NSLog(@"下载出错：%@",error);
            }else {
                NSLog(@"下载完成");
            }
        }];
    });
}

@end
