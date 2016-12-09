# AwesomeIntroGuideView

[![Version](https://img.shields.io/cocoapods/v/AwesomeIntroGuideView.svg?style=flat)](http://cocoapods.org/pods/AwesomeIntroGuideView)
[![License](https://img.shields.io/cocoapods/l/AwesomeIntroGuideView.svg?style=flat)](http://cocoapods.org/pods/AwesomeIntroGuideView)
[![Platform](https://img.shields.io/cocoapods/p/AwesomeIntroGuideView.svg?style=flat)](http://cocoapods.org/pods/AwesomeIntroGuideView)

AwesomeIntroGuideView is an iOS drop-in class that displays user coach marks with a rectangular or star or circular cutout over an existing UI. This approach leverages your actual UI as part of the onboarding process for your user. Simply defining an array of views or dictionary (Hard code ) or rectangles (CGRect) and their accompanying captions.What's more, you can also define an extro display image to intro your view with url or local resource ,even you can add a click link on the guiding image.For example, if you defined the url of image - https://www.google.com , the user would click the guiding image your app will open https://www.google.com. As you can image,you can even define a route url of your app.

![image](https://github.com/Bupterambition/AwesomeIntroguideView/blob/master/AwesomeIntroGuideViewDemo/AwesomeIntroGuideView/star.gif)
![image](https://github.com/Bupterambition/AwesomeIntroguideView/blob/master/AwesomeIntroGuideViewDemo/AwesomeIntroGuideView/Rect.gif)
![image](https://github.com/Bupterambition/AwesomeIntroguideView/blob/master/AwesomeIntroGuideViewDemo/AwesomeIntroGuideView/circular.gif)


## Installation

###CocoaPods

AwesomeIntroGuideView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AwesomeIntroGuideView'
```
### Source files

Alternatively, you can directly add the `AwesomeIntroGuideView.h` and `AwesomeIntroGuideView.m` source files to your project what's more you should add [MGJRouter](https://github.com/mogujie/MGJRouter) to your project.


## Example

Create a new AwesomeIntroGuideView instance in your viewDidLoad or viewDidLayoutSubviews method and pass in an array of views or dictionaries.

```objc

- (void)viewDidLayoutSubviews {
    if (self.coachMarksShown == NO  && self.introduceArray.count) {
        [self.coachMarksView loadMarks:self.introduceArray];
        [self.coachMarksView loadGuideImageUrl:introGuideImgUrl withPoint:(CGPoint){70,100} redirectURL:@"http://www.mogujie.com/" withFrequency:0];
        [self.coachMarksView start];
    }
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

#pragma mark - Accessor

- (AwesomeIntroGuideView *)coachMarksView {
    if (!_coachMarksView) {
        _coachMarksView = [[AwesomeIntroGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _coachMarksView;
}

```


if you want to control the frame of each coachMask,you can use the NSArray of NSDictionary below 

```objective-c
- (void)viewDidLoad {
	[super viewDidLoad];

	// ...

	// Setup coach marks
	NSArray *coachMarks = @[
		@{
			@"rect": [NSValue valueWithCGRect:(CGRect){{0,0},{45,45}}],
			@"caption": @"Helpful navigation menu"
			@"shape": @"circle"
		},
		@{
			@"rect": [NSValue valueWithCGRect:(CGRect){{10.0f,56.0f},{300.0f,56.0f}}],
			@"caption": @"Document your wedding by taking photos"
			@"shape": @"square"
		},
		@{
			@"rect": [NSValue valueWithCGRect:(CGRect){{10.0f,119.0f},{300.0f,56.0f}}],
			@"caption": @"Your wedding photo album"
		},
		@{
			@"rect": [NSValue valueWithCGRect:(CGRect){{10.0f,182.0f},{300.0f,56.0f}}],
			@"caption": @"View and manage your friends & family"
		},
		@{
			@"rect": [NSValue valueWithCGRect:(CGRect){{10.0f,245.0f},{300.0f,56.0f}}],
			@"caption": @"Invite friends to get more photos"
		},
		@{
			@"rect": [NSValue valueWithCGRect:(CGRect){{0.0f,410.0f},{320.0f,50.0f}}],
			@"caption": @"Keep your guests informed with your wedding details"
		}
	];
	AwesomeIntroGuide *coachMarksView = [[AwesomeIntroGuide alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
	[self.view addSubview:coachMarksView];
	[coachMarksView start];
}
```
If you'd like to take a certain action when a specific coach mark comes into view, you can define the callback Block of AwesomeIntroGuideView

```objc

- (void)setUpCoachMarksViewCallBack {
    self.coachMarksView = [[AwesomeIntroGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.coachMarksView.completionBlock = ^(AwesomeIntroGuideView *guideView){
        NSLog(@"%@",guideView);
    };
    self.coachMarksView.willCompletionBlock = ^(AwesomeIntroGuideView *guideView){
        NSLog(@"%@",guideView);
    };
    self.coachMarksView.didNavgateBlock = ^(AwesomeIntroGuideView *guideView, NSUInteger indedx) {
        NSLog(@"%@",guideView);
    };
    self.coachMarksView.willNavgateBlock = ^(AwesomeIntroGuideView *guideView, NSUInteger indedx) {
        NSLog(@"%@",guideView);
    };
}

#pragma mark - Accessor

- (AwesomeIntroGuideView *)coachMarksView {
    if (!_coachMarksView) {
        _coachMarksView = [[AwesomeIntroGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coachMarksView.loadType = AwesomeIntroLoad_Sync;
    }
    return _coachMarksView;
}

```

###More Detail

just clone the repo , check the my code

## Author

bupterAmbition，bupterambition@gmail.com

## License

AwesomeIntroGuideView is available under the MIT license. See the LICENSE file for more info.
