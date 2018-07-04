//
//  DownloadManeger_torrent.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/9.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const TorrentDownloadCacheFolderName;
@class TorrentDownloadReceipt;
/** The download state */
typedef NS_ENUM(NSUInteger, TorrentDownloadState) {
    TorrentDownloadStateNone,           /** default */
    TorrentDownloadStateWillResume,     /** waiting */
    TorrentDownloadStateDownloading,    /** downloading */
    TorrentDownloadStateSuspened,       /** suspened */
    TorrentDownloadStateCompleted,      /** download completed */
    TorrentDownloadStateFailed          /** download failed */
};

/** The download prioritization */
typedef NS_ENUM(NSInteger, TorrentDownloadPrioritization) {
    TorrentDownloadPrioritizationFIFO,  /** first in first out */
    TorrentDownloadPrioritizationLIFO   /** last in first out */
};

typedef void (^TorrentSucessBlock)(NSURLRequest * _Nullable, NSHTTPURLResponse * _Nullable, NSURL * _Nonnull);
typedef void (^TorrentFailureBlock)(NSURLRequest * _Nullable, NSHTTPURLResponse * _Nullable,  NSError * _Nonnull);
typedef void (^TorrentProgressBlock)(NSProgress * _Nonnull,TorrentDownloadReceipt *);

/**
 *  The receipt of a downloader,we can get all the informationg by the receipt.
 */
@interface TorrentDownloadReceipt : NSObject <NSCoding>

/**
 * Download State
 */
@property (nonatomic, assign, readonly) TorrentDownloadState state;

@property (nonatomic, copy, readonly, nonnull) NSString *url;
@property (nonatomic, copy, readonly, nonnull) NSString *filePath;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *truename;
@property (nonatomic, copy, readonly) NSString *speed;  // KB/s

@property (assign, nonatomic, readonly) long long totalBytesWritten;
@property (assign, nonatomic, readonly) long long totalBytesExpectedToWrite;

@property (nonatomic, copy, readonly, nonnull) NSProgress *progress;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong, readonly, nullable) NSError *error;

@property (nonatomic,copy)TorrentSucessBlock successBlock;
@property (nonatomic,copy)TorrentFailureBlock failureBlock;
@property (nonatomic,copy)TorrentProgressBlock progressBlock;
@end


@protocol TorrentDownloadControlDelegate <NSObject>

- (void)suspendWithURL:(NSString * _Nonnull)url;
- (void)suspendWithDownloadReceipt:(TorrentDownloadReceipt * _Nonnull)receipt;

- (void)removeWithURL:(NSString * _Nonnull)url;
- (void)removeWithDownloadReceipt:(TorrentDownloadReceipt * _Nonnull)receipt;

@end


@interface DownloadManeger_torrent : NSObject <TorrentDownloadControlDelegate>

/**
 Defines the order prioritization of incoming download requests being inserted into the queue. `MCDownloadPrioritizationFIFO` by default.
 */
@property (nonatomic, assign) TorrentDownloadPrioritization downloadPrioritizaton;

/**
 The shared default instance of `MCDownloadManager` initialized with default values.
 */
+ (instancetype)defaultInstance;

/**
 Default initializer
 
 @return An instance of `MCDownloadManager` initialized with default values.
 */
- (instancetype)init;

/**
 Initializes the `MCDownloadManager` instance with the given session manager, download prioritization, maximum active download count.
 
 @param sessionManager The session manager to use to download file.
 @param downloadPrioritization The download prioritization of the download queue.
 @param maximumActiveDownloads  The maximum number of active downloads allowed at any given time. Recommend `4`.
 
 @return The new `MCDownloadManager` instance.
 */
- (instancetype)initWithSession:(NSURLSession *)session
         downloadPrioritization:(TorrentDownloadPrioritization)downloadPrioritization
         maximumActiveDownloads:(NSInteger)maximumActiveDownloads;

///-----------------------------
/// @name Running Download Tasks
///-----------------------------

/**
 Creates an `MCDownloadReceipt` with the specified request.
 
 @param url The URL  for the request.
 @param downloadProgressBlock A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 @param destination A block object to be executed in order to determine the destination of the downloaded file. This block takes two arguments, the target path & the server response, and returns the desired file URL of the resulting download. The temporary file used during the download will be automatically deleted after being moved to the returned URL.
 
 @warning If using a background `NSURLSessionConfiguration` on iOS, these blocks will be lost when the app is terminated. Background sessions may prefer to use `-setDownloadTaskDidFinishDownloadingBlock:` to specify the URL for saving the downloaded file, rather than the destination block of this method.
 */
- (TorrentDownloadReceipt *)downloadFileWithURL:(NSString * _Nullable)url
                                       FileName:(NSString*) name
                                  progress:(nullable void (^)(NSProgress *downloadProgress, TorrentDownloadReceipt *receipt))downloadProgressBlock
                               destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                   success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, NSURL *filePath))success
                                   failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure;


- (TorrentDownloadReceipt *)downloadReceiptForURL:(NSString *)url Name:(NSString*)name;
- (NSMutableDictionary *)allDownloadReceipts;
- (void)saveReceipts:(NSDictionary *)receipts;
@end

NS_ASSUME_NONNULL_END
