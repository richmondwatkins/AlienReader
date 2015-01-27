//
//  AnimationView.h
//  AlienReader
//
//  Created by Richmond on 1/21/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RedditKit.h>
@protocol AnimationViewDelegate <NSObject>

- (void)postViewHasLeftScreen;

@end

@interface AnimationView : UIView

-(instancetype)initWithParentViewFrame:(CGRect)parentFrame;
-(void)displayPostView:(RKLink *)post;

@property id<AnimationViewDelegate> delegate;
@end
