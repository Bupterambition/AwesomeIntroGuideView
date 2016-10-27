//
//  ViewController.h
//  AwesomeIntroGuideViewDemo
//
//  Created by Senmiao on 16/7/15.
//  Copyright © 2016年 Senmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, IntroGuideType) {
    IntroGuideType_0 = 0,
    IntroGuideType_1,
    IntroGuideType_2,
    IntroGuideType_3,
};
@interface ViewController : UIViewController
@property (nonatomic, assign) IntroGuideType type;
@end

