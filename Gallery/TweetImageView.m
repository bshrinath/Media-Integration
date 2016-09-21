//
//  TweetDisplayView.m
//
//  Created by Shrinath on 7/5/16.
//  Copyright © 2016 cmu. All rights reserved.
//  Reference: Course Example & StackOverflow
//

#import <Foundation/Foundation.h>
#import "TweetImageView.h"

@interface TweetImageView()

@end

@implementation TweetImageView

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"URL --> %@", _imageURL);
    _displayTweetWebView.frame = self.view.bounds;
    _displayTweetWebView.scalesPageToFit = true;
    NSURLRequest* request = [NSURLRequest requestWithURL:self->_imageURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [self->_displayTweetWebView loadRequest:request];
    
}

@end
