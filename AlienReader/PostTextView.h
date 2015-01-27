//
//  PostTextView.h
//  AlienReader
//
//  Created by Richmond on 1/20/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RedditKit.h>
@protocol PostTextViewDelegate 

-(void)moveWithPanDirection:(UIPanGestureRecognizer *)gesture;

@end

@interface PostTextView : UITextView

typedef enum animationDirections
{
    UP,
    DOWN,
    RIGHT

} AnimationDirection;


-(instancetype)initWithParentView:(CGRect)parentViewRect andText:(NSString *)post withAnimation:(BOOL)animate andDirection:(enum animationDirections)direction;

-(void)animateToCenter:(CGRect)parentRect;

@property id<PostTextViewDelegate> customDelegate;

@end
