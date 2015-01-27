//
//  RedditRequests.m
//  AlienReader
//
//  Created by Richmond on 1/20/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "RedditRequests.h"
@implementation RedditRequests

+ (void) fetchPostsFromRedditWithPagination:(RKPagination *)pagination withCompletion:(void (^)(NSArray *))response {

    if (pagination.after == nil) {
        pagination = nil;
    }

    [[RKClient sharedClient] frontPageLinksWithCategory:RKSubredditCategoryHot pagination:pagination completion:^(NSArray *collection, RKPagination *pagination, NSError *error) {
        response([RedditRequests filterResponseFromReddit:collection]);
    }];

}

+ (NSArray *)filterResponseFromReddit:(NSArray *)redditResponse {

    NSMutableArray *nonImageLinks = [NSMutableArray array];
    for (RKLink *link in redditResponse) {

        if (!link.isImageLink && [link.domain rangeOfString:@"imgur"].location == NSNotFound && [link.domain rangeOfString:@"youtu"].location == NSNotFound) {

            NSLog(@"DOMAIN %@",link.domain);
            [nonImageLinks addObject:link];
        }
    }

    return [NSArray arrayWithArray:nonImageLinks];
}

@end
