//
//  MGJPFIntroguideView.m
//  Animation
//
//  Created by Senmiao on 16/6/16.
//  Copyright © 2016年 juangua. All rights reserved.
//

#import "MGJPFIntroguideView.h"
#import <QuartzCore/QuartzCore.h>
static const CGFloat kAnimationDuration = 0.3f;
static const CGFloat kCutoutRadius = 2.0f;
static const CGFloat kMaxLblWidth = 230.0f;
static const CGFloat kLblSpacing = 35.0f;
static const BOOL kEnableContinueLabel = YES;
static const BOOL kEnableSkipButton = YES;

//根据frame获得偏移坐标
CG_INLINE CGPoint CGPointGetShiftPoint(CGRect frame){
    CGPoint p; p.x = frame.origin.x + (MAX(CGRectGetWidth(frame), CGRectGetHeight(frame)) - (CGRectGetHeight(frame)))/2;p.y = frame.origin.y + ( (MAX(CGRectGetWidth(frame), CGRectGetHeight(frame)) - CGRectGetWidth(frame)))/2;return p;
}
//根据缩放系数和偏移坐标进行变化
CG_INLINE CGPoint CGPointMakeScaleAndShift(CGPoint originPoint, CGFloat scale, CGPoint shiftPoint){
    CGPoint p; p.x = originPoint.x * scale + shiftPoint.x; p.y = originPoint.y * scale + shiftPoint.y; return p;
}


@implementation UIBezierPath (start)
//得到⭐️曲线
+ (instancetype)bezierPathWithStarInRect:(CGRect)frame {
    CGFloat edgeLength = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
    CGFloat scale = edgeLength/100;
    CGPoint shiftPoint = CGPointGetShiftPoint(frame);
    UIBezierPath *starPath = [UIBezierPath bezierPath];
    [starPath moveToPoint: CGPointMakeScaleAndShift(CGPointMake(50, 0),scale,shiftPoint)];
    [starPath addLineToPoint: CGPointMakeScaleAndShift(CGPointMake(67.64, 25.72),scale,shiftPoint)];
    [starPath addLineToPoint: CGPointMakeScaleAndShift(CGPointMake(97.55, 34.55),scale,shiftPoint)];
    [starPath addLineToPoint: CGPointMakeScaleAndShift(CGPointMake(78.54, 59.27),scale,shiftPoint)];
    [starPath addLineToPoint: CGPointMakeScaleAndShift(CGPointMake(79.39, 90.45),scale,shiftPoint)];
    [starPath addLineToPoint: CGPointMakeScaleAndShift(CGPointMake(50, 80.01),scale,shiftPoint)];
    [starPath addLineToPoint: CGPointMakeScaleAndShift(CGPointMake(20.61, 90.45),scale,shiftPoint)];
    [starPath addLineToPoint: CGPointMakeScaleAndShift(CGPointMake(21.46, 59.27),scale,shiftPoint)];
    [starPath addLineToPoint: CGPointMakeScaleAndShift(CGPointMake(2.45, 34.55),scale,shiftPoint)];
    [starPath addLineToPoint: CGPointMakeScaleAndShift(CGPointMake(32.36, 25.72),scale,shiftPoint)];
    [starPath closePath];
    return starPath;
}

@end

@interface MGJPFIntroguideView ()
/**  需要引导的view集合 */
@property (nonatomic, copy) NSArray <UIView *> *masksItems;
/**  需要表述的文字 */
@property (nonatomic, copy) NSArray <NSString *> *descptionItems;
/**  需要展示的字典集合 */
@property (nonatomic, copy) NSArray <NSDictionary *> *coachMarks;
/**
 *  需要展示的引导图片字典集合,其中字典key为imgae和point,分别表示要展示的引导图片和图片位置
 */
@property (nonatomic, copy) NSArray <NSDictionary *> *guideImageItems;
/**  遮盖层 */
@property (nonatomic, strong) CAShapeLayer *mask;

@end


@implementation MGJPFIntroguideView {
    NSUInteger markIndex;
    NSDictionary *shapeMap;
}

#pragma mark - init Methods

- (instancetype)initWithFrame:(CGRect)frame coachMarks:(NSArray *)marks {
    self = [super initWithFrame:frame];
    if (self) {
        self.coachMarks = marks;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame loadCoachMarks:(NSArray<__kindof UIView *>  *)markItems andDescriptionItems:( NSArray<__kindof NSString *> *)descriptionItems {
    self = [self initWithFrame:frame];
    if (self) {
        self.masksItems = markItems;
        self.descptionItems = descriptionItems;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame loadCoachMarks:( NSArray <__kindof UIView *> *)markItems andGuideImageItems:(NSArray<__kindof NSDictionary *>  * __nullable)guideImageItems {
    self = [self initWithFrame:frame];
    if (self) {
        self.masksItems = markItems;
        self.guideImageItems = guideImageItems;
    }
    return self;
}

- (void)setup {
    // Default
    self.animationDuration = kAnimationDuration;
    self.cutoutRadius = kCutoutRadius;
    self.maxLblWidth = kMaxLblWidth;
    self.lblSpacing = kLblSpacing;
    self.enableContinueLabel = kEnableContinueLabel;
    self.enableSkipButton = kEnableSkipButton;
    shapeMap = @{@"circle":@(MGJPFIntroguideShape_Circle),
                 @"square":@(MGJPFIntroguideShape_Square),
                 @"star":@(MGJPFIntroguideShape_Star)};
    // 设置遮盖层
    [self.layer addSublayer:self.mask];
    // 设置显示文字
    [self addSubview:self.lblCaption];
    // 设置显示图片
    [self addSubview:self.guideImageView];
    
    // 点击事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    // Hide until unvoked
    self.hidden = YES;
}
#pragma mark - public Method

- (void)loadMarks: (NSArray <__kindof UIView *> *)markItems {
    self.masksItems = markItems;
}

- (void)loadGuideImageItem:(NSArray <__kindof NSDictionary *> *)guideImageItems {
    self.guideImageItems = guideImageItems;
}

- (void)loadDescriptionItems:(NSArray<__kindof NSString *>  *)descriptionItems {
    self.descptionItems = descriptionItems;
}
#pragma mark - Navigation

- (void)start {
    NSAssert(self.superview, @"MGJPFIntroguideView should have a superView");
    // Fade in self
    self.alpha = 1.0f;
    self.hidden = NO;
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [self goToCoachMarkIndexed:0];
                     }];
}

#pragma mark - Cutout modify
- (void)animateGuideImgae:(UIImage *)guideImage withPoint:(CGPoint)point {
    self.guideImageView.image = guideImage;
    [self.guideImageView sizeToFit];
    self.guideImageView.frame = (CGRect){point,self.guideImageView.frame.size};
}
- (void)animateCutoutToRect:(CGRect)rect withShape:(MGJPFIntroguideShape)shape {
    // Define shape
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *cutoutPath;
    switch (shape) {
        case MGJPFIntroguideShape_Square: {
            cutoutPath = [UIBezierPath bezierPathWithRect:rect];
            break;
        }
        case MGJPFIntroguideShape_Circle: {
            cutoutPath = [UIBezierPath bezierPathWithOvalInRect:rect];
            break;
        }
        case MGJPFIntroguideShape_Star: {
            cutoutPath = [UIBezierPath bezierPathWithStarInRect:rect];
            break;
        }
        case MGJPFIntroguideShape_Other: {
            cutoutPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cutoutRadius];
            break;
        }
    }
    
    [maskPath appendPath:cutoutPath];
    
    // Animate it
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.delegate = self;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.duration = self.animationDuration;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.fromValue = (__bridge id)(self.mask.path);
    anim.toValue = (__bridge id)(maskPath.CGPath);
    [self.mask addAnimation:anim forKey:@"path"];
    self.mask.path = maskPath.CGPath;
}
- (void)animateCaptionLabelWith:(NSString *)description withRect:(CGRect)markRect {
    self.lblCaption.alpha = 0.0f;
    self.lblCaption.frame = (CGRect){{0.0f, 0.0f}, {self.maxLblWidth, 0.0f}};
    self.lblCaption.text = description;
    [self.lblCaption sizeToFit];
    CGFloat y = markRect.origin.y + markRect.size.height + self.lblSpacing;
    CGFloat bottomY = y + self.lblCaption.frame.size.height + self.lblSpacing;
    if (bottomY > self.bounds.size.height) {
        y = markRect.origin.y - self.lblSpacing - self.lblCaption.frame.size.height;
    }
    CGFloat x = floorf((self.bounds.size.width - self.lblCaption.frame.size.width) / 2.0f);
    
    // Animate the caption label
    self.lblCaption.frame = (CGRect){{x, y}, self.lblCaption.frame.size};
    
    [UIView animateWithDuration:0.3f animations:^{
        self.lblCaption.alpha = 1.0f;
    }];
}
#pragma mark - private Method
//进行展示的主要函数
- (void)goToCoachMarkIndexed:(NSUInteger)index {
    // Out of bounds
    if (index >= self.coachMarks.count && index >= self.masksItems.count) {
        [self cleanup];
        return;
    }
    markIndex = index;
    
    // Coach mark definition
    NSDictionary *markDef  = nil;
    NSString *markCaption = nil;
    CGRect markRect  = CGRectZero;
    MGJPFIntroguideShape shape = self.guideShape;
    if (self.coachMarks.count) {
        markDef = [self.coachMarks objectAtIndex:index];
        markCaption = [markDef objectForKey:@"caption"];
        markRect = [[markDef objectForKey:@"rect"] CGRectValue];
        if([[markDef allKeys] containsObject:@"shape"]) {
            NSString *currentShape = [markDef objectForKey:@"shape"];
            if ([[shapeMap allKeys] containsObject:currentShape]) {
                shape = shapeMap[currentShape];
            }
        }
    }else if (self.masksItems.count) {
        if (index < self.descptionItems.count) {
            markCaption = self.descptionItems[index];
        }
        markRect = ({
            UIView *view = self.masksItems[index];
            CGRect frame = [view.superview convertRect:view.frame toView:self.superview];
            CGRectInset(frame,self.insetSpacing,self.insetSpacing);
        });
    }else {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(coachMarksView:willNavigateToIndex:)]) {
        [self.delegate coachMarksView:self willNavigateToIndex:markIndex];
    }
    UIImage *guideImage = nil;
    CGPoint point = CGPointZero;
    if (index < self.guideImageItems.count) {
        guideImage = self.guideImageItems[index][@"image"];
        point = [self.guideImageItems[index][@"point"] CGPointValue];
    }
    [self animateGuideImgae:guideImage withPoint:point];
    // 运行标签动画
    [self animateCaptionLabelWith:markCaption withRect:markRect];
    // 运行展示动画
    [self animateCutoutToRect:markRect withShape:shape];
    if (self.enableContinueLabel) {
        //当第一次展现时出现
        if (markIndex == 0) {
            [self addSubview:self.lblContinue];
        } else if (markIndex > 0 && self.lblContinue != nil) {
            [self.lblContinue removeFromSuperview];
        }
    }
    if (self.enableSkipButton) {
        [self addSubview:self.btnSkipCoach];
    }
}


#pragma mark - event Response

- (void)userDidTap:(UITapGestureRecognizer *)recognizer {
    // Go to the next coach mark
    [self goToCoachMarkIndexed:(markIndex+1)];
}

- (void)skipCoach {
    [self goToCoachMarkIndexed:self.coachMarks.count];
}


#pragma mark - Cleanup

- (void)cleanup {
    // Delegate (coachMarksViewWillCleanup:)
    if ([self.delegate respondsToSelector:@selector(coachMarksViewWillCleanup:)]) {
        [self.delegate coachMarksViewWillCleanup:self];
    }
    
    // Fade out self
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         // Remove self
                         [self removeFromSuperview];
                         
                         // Delegate (coachMarksViewDidCleanup:)
                         if ([self.delegate respondsToSelector:@selector(coachMarksViewDidCleanup:)]) {
                             [self.delegate coachMarksViewDidCleanup:self];
                         }
                     }];
}

#pragma mark - Animation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // Delegate (coachMarksView:didNavigateTo:atIndex:)
    if ([self.delegate respondsToSelector:@selector(coachMarksView:didNavigateToIndex:)]) {
        [self.delegate coachMarksView:self didNavigateToIndex:markIndex];
    }
}
#pragma mark - Accessor 
- (UILabel *)lblCaption {
    if (!_lblCaption) {
        _lblCaption = [[UILabel alloc] initWithFrame:(CGRect){{0.0f, 0.0f}, {self.maxLblWidth, 0.0f}}];
        self.lblCaption.backgroundColor = [UIColor clearColor];
        self.lblCaption.textColor = [UIColor whiteColor];
        self.lblCaption.font = [UIFont systemFontOfSize:20.0f];
        self.lblCaption.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblCaption.numberOfLines = 0;
        self.lblCaption.textAlignment = NSTextAlignmentCenter;
        self.lblCaption.alpha = 0.0f;
    }
    return _lblCaption;
}

- (CAShapeLayer *)mask {
    if (!_mask) {
        _mask = [CAShapeLayer layer];
        [_mask setFillRule:kCAFillRuleEvenOdd];
        [_mask setFillColor:[[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.0f alpha:0.8f] CGColor]];
    }
    return _mask;
}

- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    [self.mask setFillColor:[maskColor CGColor]];
}

- (UIButton *)btnSkipCoach {
    if (!_btnSkipCoach) {
        CGFloat lblContinueWidth = self.enableSkipButton ? (70.0/100.0) * self.bounds.size.width : self.bounds.size.width;
        CGFloat btnSkipWidth = self.bounds.size.width - lblContinueWidth;
        _btnSkipCoach = [[UIButton alloc] initWithFrame:(CGRect){{lblContinueWidth, self.bounds.size.height - 30.0f}, {btnSkipWidth, 30.0f}}];
        [_btnSkipCoach addTarget:self action:@selector(skipCoach) forControlEvents:UIControlEventTouchUpInside];
        [_btnSkipCoach setTitle:@"跳过" forState:UIControlStateNormal];
        _btnSkipCoach.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _btnSkipCoach.tintColor = [UIColor whiteColor];
    }
    return _btnSkipCoach;
}

- (UILabel *)lblContinue {
    if (!_lblContinue) {
        CGFloat lblContinueWidth = self.enableSkipButton ? (70.0/100.0) * self.bounds.size.width : self.bounds.size.width;
        _lblContinue = [[UILabel alloc] initWithFrame:(CGRect){{0, self.bounds.size.height - 30.0f}, {lblContinueWidth, 30.0f}}];
        _lblContinue.font = [UIFont boldSystemFontOfSize:13.0f];
        _lblContinue.textAlignment = NSTextAlignmentCenter;
        _lblContinue.text = @"点击继续";
        _lblContinue.backgroundColor = [UIColor whiteColor];
    }
    return _lblContinue;
}

- (UIImageView *)guideImageView {
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc] init];
    }
    return _guideImageView;
}

@end


