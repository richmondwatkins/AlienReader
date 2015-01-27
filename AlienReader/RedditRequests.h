//
//  RedditRequests.h
//  AlienReader
//
//  Created by Richmond on 1/20/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RedditKit.h>

@interface RedditRequests : NSObject

+ (void)fetchPostsFromRedditWithPagination:(RKPagination *)pagination withCompletion:(void (^)(NSArray *results))complete;

@end
