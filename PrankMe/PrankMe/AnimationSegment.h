//
//  AnimationSegment.h
//  Segment Control
//
//  Created by Lowtrack on 25.08.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationSegment : NSObject

@property (nonatomic, strong) UIButton * segmentButton;
@property (nonatomic, strong) UIColor * segmentButtonTextColor;
@property (nonatomic, strong) UIColor * segmentButtonBGColor;
@property (nonatomic, assign) float Duration;


- (void) changeSegment;

@end
