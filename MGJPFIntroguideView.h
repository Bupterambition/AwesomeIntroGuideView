//
//  MGJPFIntroguideView.h
//  Animation
//
//  Created by Senmiao on 16/6/16.
//  Copyright © 2016年 Senmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol MGJPFIntroguideViewDelegate;

typedef NS_ENUM(NSUInteger, MGJPFIntroguideShape) {
    MGJPFIntroguideShape_Square,
    
    MGJPFIntroguideShape_Circle,
    
    MGJPFIntroguideShape_Star,
    
    MGJPFIntroguideShape_Other
};

@interface MGJPFIntroguideView : UIView

@property (nonatomic, weak)   id<MGJPFIntroguideViewDelegate> delegate;

/**  展示层文字标签 */
@property (nonatomic, strong) UILabel *lblCaption;
/**  引导图片 */
@property (nonatomic, strong) UIImageView *guideImageView;
/**  背景色 */
@property (nonatomic, strong) UIColor *maskColor;
/**  最初开始展示动画的时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/**  展示框圆角 */
@property (nonatomic, assign) CGFloat cutoutRadius;
/**  展示文字最大长度 */
@property (nonatomic, assign) CGFloat maxLblWidth;
/**  展示文字距离展示框的距离 */
@property (nonatomic, assign) CGFloat lblSpacing;
/**  引导框Inset 正值表示扩大 负值表示缩小 */
@property (nonatomic, assign) CGFloat insetSpacing;
/**  是否显示继续🔘 */
@property (nonatomic, assign, getter=isEnableContinueLabel) BOOL enableContinueLabel;
/**  是否显示跳过🔘 */
@property (nonatomic, assign, getter=isEnableSkipButton) BOOL enableSkipButton;
/**  跳过🔘 */
@property (nonatomic, strong) UIButton *btnSkipCoach;
/**  继续🔘 */
@property (nonatomic, strong) UILabel *lblContinue;
/**  展示的款图形状,目前有四种模式 ，默认是矩形展示*/
@property (nonatomic, assign) MGJPFIntroguideShape guideShape;
/**  自动计算引导页上面的展示图片的位置,主要用于适配不同屏幕*/
@property (nonatomic, assign) BOOL autoCalculateGuidePoint;
/**
 *  根据传入的复合字典数组创建引导页
 *
 *  @param frame 引导的frame
 *  @param marks 字典类型数组 格式参考：字典格式参考
 {@"rect": [NSValue valueWithCGRect:(CGRect){{0,0},{45,45}}],
 @"caption": @"Helpful navigation menu",
 @"shape": @"circle"//可以不加
 }
 *
 *  @return 引导页
 */
- (instancetype)initWithFrame:(CGRect)frame coachMarks:(NSArray <__kindof NSDictionary *> *)marks;
/**
 *  根据传入的View集合以及描述进行引导页布局
 *
 *  @param frame            引导页整体大小
 *  @param markItems        需要进行引导的view 集合
 *  @param descriptionItems 描述集合（应该与view集合一一对应，当没有时传入空）
 *
 *  @return 引导页
 */
- (instancetype)initWithFrame:(CGRect)frame loadCoachMarks:( NSArray <__kindof UIView *> *)markItems andDescriptionItems:(NSArray<__kindof NSString *>  * __nullable)descriptionItems;
/**
 *  根据传入的引导图片字典集合进行引导页布局 字典类型{@"image":UIImage,@"point":NSValue}
 *
 *  @param frame           引导页整体大小
 *  @param markItems       需要进行引导的view 集合
 *  @param guideImageItems 引导图片字典集合 （应该与view集合一一对应，当没有时传入空）
 *
 *  @return 引导页
 */
- (instancetype)initWithFrame:(CGRect)frame loadCoachMarks:( NSArray <__kindof UIView *> *)markItems andGuideImageItems:(NSArray<__kindof NSDictionary *>  * __nullable)guideImageItems;
/**
 *  导入需要进行引导的view 集合
 *
 *  @param markItems 需要进行引导的view 集合
 */
- (void)loadMarks:(NSArray <__kindof UIView *> *)markItems;
/**
 *  导入描述集合（应该与view集合一一对应，当没有时传入空）
 *
 *  @param descriptionItems 描述集合（应该与view集合一一对应，当没有时传入空）
 */
- (void)loadDescriptionItems:(NSArray<__kindof NSString *>  *)descriptionItems;
/**
 *  导入引导图片字典集合（应该与view集合一一对应，当没有时传入空）
 *
 *  @param guideImageItems 引导图片字典集合
 */
- (void)loadGuideImageItem:(NSArray <__kindof NSDictionary *> *)guideImageItems;

/**
 *  导入引导展示图片的url地址 展现的位置 点击后的连接 以及出现频率
 *
 *  @param imageURL    图片地址
 *  @param imagePoint  图片位置
 *  @param redirectURL 点击连接
 *  @param days        展示间隔
 */
- (void)loadGuideImageUrl:(NSString *)imageURL withPoint:(CGPoint)imagePoint redirectURL:(NSString *)redirectURL withFrequency:(NSInteger)days;
/**
 *  开启引导动画,可以通过设置animationDuration来控制动画展现出来的时间
 */
- (void)start;


@end

@protocol MGJPFIntroguideViewDelegate <NSObject>

@optional
/**
 *  即将进行下一个引导页展示
 *
 *  @param coachMarksView 引导页
 *  @param index          待引导的索引
 */
- (void)coachMarksView:(MGJPFIntroguideView*)coachMarksView willNavigateToIndex:(NSUInteger)index;
/**
 *  已经展示引导页
 *
 *  @param coachMarksView 引导页
 *  @param index          当前引导的索引
 */
- (void)coachMarksView:(MGJPFIntroguideView*)coachMarksView didNavigateToIndex:(NSUInteger)index;
/**
 *  即将清除引导页
 *
 *  @param coachMarksView 引导页
 */
- (void)coachMarksViewWillCleanup:(MGJPFIntroguideView*)coachMarksView;
/**
 *  已经清除引导页
 *
 *  @param coachMarksView 引导页
 */
- (void)coachMarksViewDidCleanup:(MGJPFIntroguideView*)coachMarksView;

@end
NS_ASSUME_NONNULL_END