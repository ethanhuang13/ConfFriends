//
//  FCNetworkImageLoader.h
//  Part of FCUtilities by Marco Arment. See included LICENSE file for BSD license.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface FCNetworkImageLoader : NSOperationQueue

+ (void)setCellularPolicyHandler:(BOOL (^)(void))returnIsCellularAllowed;
+ (void)setFetchedImageDataHandler:(NSData * (^)(NSData *imageData))block;

+ (void)loadImageAtURL:(NSURL *)url intoImageView:(UIImageView *)imageView placeholderImage:(UIImage *)placeholder;
+ (void)loadImageAtURL:(NSURL *)url intoImageView:(UIImageView *)imageView placeholderImage:(UIImage *)placeholder cachePolicy:(NSURLRequestCachePolicy)cachePolicy;

+ (void)cancelLoadForImageView:(UIImageView *)imageView;
+ (void)setCachedImageLimit:(NSUInteger)imageCount;

@end
