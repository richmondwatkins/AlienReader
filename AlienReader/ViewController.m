//
//  ViewController.m
//  AlienReader
//
//  Created by Richmond on 1/20/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ViewController.h"
#import "RedditRequests.h"
#import "PostTextView.h"
#import "AnimationView.h"

@import AVFoundation;

@interface ViewController () <PostTextViewDelegate, UIDynamicAnimatorDelegate, AVSpeechSynthesizerDelegate, AnimationViewDelegate>

@property NSInteger index;
@property NSArray *posts;
@property PostTextView *textView;
@property AVSpeechSynthesizer *speechSynthesizer;
@property CGPoint translation;
@end

@implementation ViewController {
    AnimationDirection theAnimationDirection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc]init];

    self.index = 1;

    [RedditRequests fetchPostsFromRedditWithPagination:nil withCompletion:^(NSArray *results) {
        if (results) {
            self.posts = results;

            self.textView = [[PostTextView alloc] initWithParentView:self.view.frame
                                                             andText:((RKLink *)self.posts[0]).title
                                                       withAnimation:NO andDirection:UP];

            self.textView.customDelegate = self;
            [self.view addSubview:self.textView];

        }
    }];

}


-(void)moveWithPanDirection:(UIPanGestureRecognizer *)gesture {
    CGPoint velocity = [gesture velocityInView:self.view];


    CGPoint translation = [gesture translationInView:gesture.view];

    if (velocity.x < 0 && gesture.view.center.y == self.view.frame.size.height / 2 ) {
        theAnimationDirection = RIGHT;

        gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y);
    }else if(gesture.view.center.x == self.view.frame.size.width / 2 && velocity.y < 0){
        theAnimationDirection = UP;

         gesture.view.center = CGPointMake(gesture.view.center.x, gesture.view.center.y+ translation.y);
    }else if(gesture.view.center.x == self.view.frame.size.width / 2 && velocity.y > 0){
        theAnimationDirection = DOWN;

         gesture.view.center = CGPointMake(gesture.view.center.x, gesture.view.center.y+ translation.y);
    }else if(velocity.x > 0 && gesture.view.center.x < self.view.frame.size.width / 2){
         gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y);
    }

    switch (gesture.state) {

        case UIGestureRecognizerStateBegan:

            break;
        case UIGestureRecognizerStateChanged:
            self.translation = translation;

            break;
        case UIGestureRecognizerStateCancelled:

            [self.textView animateToCenter:self.view.frame];

            break;
        case UIGestureRecognizerStateEnded:

            if(velocity.y < -30 && fabsf(self.translation.y ) > 3 && theAnimationDirection == UP){

                [self animateView:UP withVelocity:velocity];

            }else if (velocity.y > 30 && fabsf(self.translation.y) > 3 && theAnimationDirection == DOWN){

                [self animateView:DOWN withVelocity:velocity];

            }else if(velocity.x < - 30 && fabsf(self.translation.x) > 3 && theAnimationDirection == RIGHT){

                [self transitionToPostView];
            }else {
                [self.textView animateToCenter:self.view.frame];
            }

            break;
        default:
            break;
    }

    [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view];
}


- (void)animateView:(enum animationDirections)direction withVelocity:(CGPoint)velocity {

    if ([self.speechSynthesizer isSpeaking]) {
        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }

    [UIView animateWithDuration:0.2 animations:^{
        float animationY;

        if (direction == UP) {
            self.index += 1;
            animationY = -self.view.frame.size.height + self.textView.center.x;
        } else{
            self.index -= 1;
            animationY = self.view.frame.size.height + self.textView.frame.size.height;
        }

        self.textView.center = CGPointMake(self.textView.center.x, animationY);

    } completion:^(BOOL finished) {
        self.textView = [[PostTextView alloc] initWithParentView:self.view.frame
                                                         andText:((RKLink *)self.posts[self.index]).title
                                                   withAnimation:YES andDirection:direction];

        [UIView animateWithDuration:0.2 animations:^{

            [self.textView setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];

            self.textView.customDelegate = self;
            [self.view addSubview:self.textView];

        } completion:^(BOOL finished) {
            [self speakTest:self.textView.text];
        }];
    }];
}

- (void)transitionToPostView {

    if ([self.speechSynthesizer isSpeaking]) {
        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }

    [UIView animateWithDuration:0.2 animations:^{
        [self.textView setCenter:CGPointMake(-self.view.frame.size.width, self.view.frame.size.height / 2)];

    } completion:^(BOOL finished) {

        AnimationView *animationView = [[AnimationView alloc] initWithParentViewFrame:self.view.frame];
        animationView.delegate = self;
        [self.view addSubview:animationView];

        [UIView animateWithDuration:0.2 animations:^{
            [animationView setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];

        }completion:^(BOOL finished) {
            [animationView displayPostView:self.posts[self.index]];
        }];
    }];
}

-(void)postViewHasLeftScreen {
    self.textView = [[PostTextView alloc] initWithParentView:self.view.frame andText:((RKLink *)self.posts[self.index]).title withAnimation:YES andDirection:RIGHT];
    self.textView.customDelegate = self;
    [self.view addSubview:self.textView];

    [UIView animateWithDuration:0.2 animations:^{
        [self.textView setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    }];
}

- (void)speakTest:(NSString *)text {
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [utterance setRate:0.3f];
    [self.speechSynthesizer speakUtterance:utterance];
}


@end
