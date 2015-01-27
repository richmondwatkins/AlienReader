//
//  AnimationView.m
//  AlienReader
//
//  Created by Richmond on 1/21/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "AnimationView.h"
#import "PostTextView.h"

@interface AnimationView  () <UIWebViewDelegate>
@property UIActivityIndicatorView *activityIndicator;
@end

@implementation AnimationView

-(instancetype)initWithParentViewFrame:(CGRect)parentFrame{

    if (self = [super init]) {

        self.frame = CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height);

        [self setCenter:CGPointMake(parentFrame.size.width / 2 + (parentFrame.size.width * 2), parentFrame.size.height / 2)];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleReturn:)];
        [self addGestureRecognizer:panGesture];

        self.backgroundColor = [UIColor redColor];

    }

    return self;
}

- (void)handleReturn:(UIPanGestureRecognizer *)pan {

    CGPoint velocity = [pan velocityInView:self];

    if (velocity.x > 0 && pan.state == UIGestureRecognizerStateEnded) {

        [UIView animateWithDuration:0.2 animations:^{
            
            [self setCenter:CGPointMake(self.frame.size.width * 2, self.frame.size.height / 2)];
        } completion:^(BOOL finished) {

            [self.delegate postViewHasLeftScreen];
        }];
    }
}

-(void)displayPostView:(RKLink *)post{
    UIView *postView;
    if (post.isSelfPost) {

        postView = (UITextView *)[[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.8, self.frame.size.height * 0.8)];
        ((UITextView *) postView).text = post.selfText.length ? post.selfText : post.title;
        ((UITextView *) postView).textAlignment = NSTextAlignmentCenter;
        [postView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        [postView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];

    }else{

        postView = (UIWebView *)[[UIWebView alloc] initWithFrame:self.frame];
        ((UIWebView *)postView).delegate = self;

        NSString *readabilityURLString = [NSString stringWithFormat:@"http://www.readability.com/m?url=%@", [post.URL absoluteString]];

        [((UIWebView *)postView) loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:readabilityURLString]]];
    }

    [self addSubview:postView];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(self.frame.size.width / 2, self.frame.size.height / 2, 20, 20);
    [self addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    [self.activityIndicator hidesWhenStopped];
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

@end
