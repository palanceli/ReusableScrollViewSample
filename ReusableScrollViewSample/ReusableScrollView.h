//
//  ReusableScrollView.h
//  SampleB
//
//  Created by palance on 15/10/7.
//  Copyright © 2015年 binglen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReusableScrollViewDelegate
// 需要delegate在view中填充第toPage的数据；如果传入的view为nil，需要delegate创建view
-(nonnull UIView*)setupView:(nullable UIView*)view toPage:(NSUInteger)toPage;
-(NSUInteger)numOfPages;
@end

@interface ReusableScrollView : UIScrollView
@property (nonatomic,assign, nonnull) id<ReusableScrollViewDelegate> delegateForReuseableScrollView;
// 完成bufferViews的初始化，并放入containerView，再把containerView放入scrollView
-(void)setupViews;
@end
