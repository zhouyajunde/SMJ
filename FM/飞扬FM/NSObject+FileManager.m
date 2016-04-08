//
//  NSObject+FileManager.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/21.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "NSObject+FileManager.h"

@implementation NSObject (FileManager)

- (NSString *)cachePath
{
    return [NSObject cachePath];
}

+ (NSString *)cachePath
{
    // 获取cachePath文件路径
    return  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

- (void)getFileCacheSizeWithPath:(NSString *)path completion:(void (^)(NSInteger))completion
{
    [NSObject getFileCacheSizeWithPath:path completion:completion];
}

// 异步方法,不需要返回值
// 异步方法使用回调,block
// 获取文件尺寸
+ (void)getFileCacheSizeWithPath:(NSString *)path completion:(void(^)(NSInteger total))completion
{
    
    // 文件比较大,多
    // 文件操作比较耗时,开启子线程去计算,计算好了,在返回
    
    // 开启异步线程 2秒
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        // 1.创建文件管理者   获取文件尺寸 -> NSFileManager
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        // 1.1.判断下是否存在,而且是否是文件夹
        BOOL isDirectory;
        
        BOOL isFileExist = [mgr fileExistsAtPath:path isDirectory:&isDirectory];
        
        // 判断下当前是否是文件
        if (isFileExist){
            
            // 判断下是否是文件夹
            NSInteger total = 0;
            
            if (isDirectory) {
                // 2.遍历文件夹下所有文件,全部加上,就是文件夹尺寸
                NSArray *subPaths = [mgr subpathsAtPath:path];
                
                for (NSString *subPath in subPaths) {
                    // 3.拼接文件全路径
                    NSString *filePath = [path stringByAppendingPathComponent:subPath];
                    
                    BOOL isDirectory;
                    // 4.判断下当前是否是文件
                    BOOL isFileExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
                    
                    // 5.获取文件尺寸
                    if (isFileExist && !isDirectory && ![filePath containsString:@"DS"]) {
                        
                        NSDictionary *fileAttr = [mgr attributesOfItemAtPath:filePath error:nil];
                        NSInteger fileSize = [fileAttr[NSFileSize] integerValue];
                        
                        total += fileSize;
                    }
                    
                    
                }
                
            }else{
                
                // 当前传入是文件
                NSDictionary *fileAttr = [mgr attributesOfItemAtPath:path error:nil];
                
                total = [fileAttr[NSFileSize] integerValue];
                
                
                
            }
            
            // 计算完毕 -> 把计算的值传递出去
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if (completion) {
                    completion(total);
                }
                
            });
            
        }
    });
    
}

+ (void)removeCacheWithCompletion:(void (^)())completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 创建文件管理者
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        // 删除文件
        
        NSString *path = self.cachePath;
        
        BOOL isDirectory;
        
        BOOL isFileExist = [mgr fileExistsAtPath:path isDirectory:&isDirectory];
        
        if (!isFileExist) return;
        
        if (isDirectory) {
            NSArray *subPaths = [mgr subpathsAtPath:path];
            for (NSString *subPath in subPaths) {
                
                NSString *filePath = [path stringByAppendingPathComponent:subPath];
                [mgr removeItemAtPath:filePath error:nil];
            }
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
        
    });
    
   
}

- (void)removeCacheWithCompletion:(void (^)())completion
{
    [NSObject removeCacheWithCompletion:completion];
    
}

@end
