//
//  AnimationSegment.m
//  Segment Control
//
//  Created by Lowtrack on 25.08.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "AnimationSegment.h"

@implementation AnimationSegment

@synthesize segmentButton;
@synthesize segmentButtonTextColor;
@synthesize segmentButtonBGColor;
@synthesize Duration;



- (void) changeSegment {
    
    CATransition *transitionAnimation = [CATransition animation];
    //
    [transitionAnimation setType:kCATransitionFade];
    [transitionAnimation setDuration:Duration];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeBoth];
    
    [segmentButton.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
    segmentButton.titleLabel.textColor = segmentButtonTextColor;
    segmentButton.backgroundColor = segmentButtonBGColor;


}


@end
