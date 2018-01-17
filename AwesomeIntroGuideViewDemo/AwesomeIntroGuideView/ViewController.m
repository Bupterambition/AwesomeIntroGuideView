//
//  ViewController.m
//  AwesomeIntroGuideViewDemo
//
//  Created by Senmiao on 16/7/15.
//  Copyright © 2016年 Senmiao. All rights reserved.
//

#import "ViewController.h"
#import <AwesomeIntroGuideView/AwesomeIntroGuideView.h>
//主要iOS9下使用http请求需要先在info.list中设置App Transport Security Settings的Allow Arbitrary Loads为YES
static  NSString * const introGuideImgUrl = @"https://s10.mogucdn.com/p1/161027/idid_ifqtantemfstmzdemizdambqgyyde_483x337.png";

@interface CollectionViewCell : UICollectionViewCell

@end

@implementation CollectionViewCell

@end

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *introduceArray;
@property (nonatomic, strong) AwesomeIntroGuideView *coachMarksView;
@property (nonatomic, assign) BOOL coachMarksShown;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.coachMarksView.animationDuration = 0.3;
    [self.navigationController.view addSubview:self.coachMarksView];
    self.navigationItem.titleView =({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"AwesomeIntroGuide";
        [label sizeToFit];
        label;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collectionView.layoutMargins = UIEdgeInsetsMake(30, 10, 0, 10);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _displayCoachView];
    });
}

- (void)_displayCoachView {
    if (self.coachMarksShown == NO  && self.introduceArray.count) {
        // 展示引导层
        switch (self.type) {
            case IntroGuideType_0: {
                self.coachMarksView.guideShape = AwesomeIntroGuideShape_Square;
                break;
            }
            case IntroGuideType_1: {
                self.coachMarksView.guideShape = AwesomeIntroGuideShape_Circle;
                break;
            }
            case IntroGuideType_2: {
                self.coachMarksView.guideShape = AwesomeIntroGuideShape_Star;
                break;
            }
            case IntroGuideType_3: {
                self.coachMarksView.guideShape = AwesomeIntroGuideShape_Other;
                break;
            }
        }
        self.coachMarksShown = YES;
        [self.introduceArray addObject:self.navigationItem.titleView];
        [self.coachMarksView loadMarks:self.introduceArray];
        self.coachMarksView.animationDuration = 0.2;
        [self.coachMarksView loadGuideImageUrl:introGuideImgUrl withPoint:(CGPoint){70,100} redirectURL:@"http://www.mogujie.com/" withFrequency:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.23 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.coachMarksView start];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row %5 == 0 && self.introduceArray.count <=3 && indexPath.row != 0) {
        [self.introduceArray addObject:cell];
    }
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%100/100. green:arc4random()%100/100. blue:arc4random()%100/100. alpha:arc4random()%100/100.];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)/3 - 10;
    return (CGSize){width,width};
}

#pragma mark - getter Method
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSMutableArray *)introduceArray {
    if (_introduceArray == nil) {
        _introduceArray = [NSMutableArray array];
    }
    return _introduceArray;
}

- (AwesomeIntroGuideView *)coachMarksView {
    if (!_coachMarksView) {
        _coachMarksView = [[AwesomeIntroGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coachMarksView.completionBlock = ^(AwesomeIntroGuideView *guideView){
            NSLog(@"%@",guideView);
        };
        _coachMarksView.willCompletionBlock = ^(AwesomeIntroGuideView *guideView){
            NSLog(@"%@",guideView);
        };
        _coachMarksView.didNavgateBlock = ^(AwesomeIntroGuideView *guideView, NSUInteger indedx) {
            NSLog(@"%@",guideView);
        };
        _coachMarksView.willNavgateBlock = ^(AwesomeIntroGuideView *guideView, NSUInteger indedx) {
            NSLog(@"%@",guideView);
        };
        _coachMarksView.loadType = AwesomeIntroLoad_Sync;
    }
    return _coachMarksView;
}

@end

