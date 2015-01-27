//
//  PostTextView.m
//  AlienReader
//
//  Created by Richmond on 1/20/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "PostTextView.h"

@implementation PostTextView

-(instancetype)initWithParentView:(CGRect)parentViewRect andText:(NSString *)post withAnimation:(BOOL)animate andDirection:(enum animationDirections)direction{
    if (self = [super init]) {


        self.frame = CGRectMake(0, 0, parentViewRect.size.width * 0.8, parentViewRect.size.height * 0.8);

        if (animate) {
            switch (direction) {
                case UP:
                    [self setCenter:CGPointMake(parentViewRect.size.width / 2, parentViewRect.size.height + self.frame.size.height)];
                    break;
                case DOWN:
                    [self setCenter:CGPointMake(parentViewRect.size.width / 2, -parentViewRect.size.height + self.frame.size.height)];
                    
                    break;
                case RIGHT:
                    [self setCenter:CGPointMake(-(parentViewRect.size.width * 2), parentViewRect.size.height / 2)];

                    break;
                default:
                    break;
            }

        }else {
            
            [self setCenter:CGPointMake(parentViewRect.size.width / 2, parentViewRect.size.height / 2)];
        }


        self.text = post;
        self.textAlignment = NSTextAlignmentCenter;
        [self setFont:[UIFont systemFontOfSize:20]];
        self.editable = NO;

        self.backgroundColor = [UIColor orangeColor];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(checkFlickDirection:)];
        [self addGestureRecognizer:panGesture];

        [self addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];

    }

    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void)checkFlickDirection:(UIPanGestureRecognizer *)gesture {

    [self.customDelegate moveWithPanDirection:gesture];
}

- (void)animateToCenter:(CGRect)parentRect {
    [UIView animateWithDuration:0.2 animations:^{
        [self setCenter:CGPointMake(parentRect.size.width / 2, parentRect.size.height / 2)];
    } completion:^(BOOL finished) {
        //
    }];
}
@end
