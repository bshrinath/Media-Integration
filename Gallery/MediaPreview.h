//
//  MediaPreview.h
//
//  Created by Shrinath on 7/5/16.
//  Copyright © 2016 cmu. All rights reserved.
//

#import  <UIKit/UIKit.h>

@class AVCaptureSession;

@interface MediaPreview : UIView

@property (nonatomic) AVCaptureSession *session;

@end

