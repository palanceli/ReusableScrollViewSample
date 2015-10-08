//
//  ReusableScrollView.m
//  SampleB
//
//  Created by palance on 15/10/7.
//  Copyright © 2015年 binglen. All rights reserved.
//

#import "ReusableScrollView.h"

@interface ReusableScrollView()
@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) NSMutableArray* bufferViews;
@property int currentPage;
@property int toPage;
@end

static const int nBufferViews = 3;

@implementation ReusableScrollView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _currentPage = 0;
        _containerView = [[UIView alloc]init];
        _bufferViews = [[NSMutableArray alloc]init];
        _delegateForReuseableScrollView = nil;
    }
    return self;
}

-(void)setupViews
{
    CGRect rtContent = self.frame;
    rtContent.size.width = rtContent.size.width * nBufferViews;
    self.containerView.frame = rtContent;
    self.contentSize = rtContent.size;
    [self addSubview:self.containerView];
    self.pagingEnabled = YES;
    [self setShowsHorizontalScrollIndicator:NO];
    
    for (int i=0; i<nBufferViews; i++) {
        UIView *view = [self.delegateForReuseableScrollView setupView:nil toPage:i];
        CGRect rect = self.frame;
        rect.origin.x = rect.size.width * i;
        view.frame = rect;
        [self.bufferViews addObject:view];
        [self.containerView addSubview:view];
        
        if (i == 0) {
            view.backgroundColor = [UIColor redColor];
        }else if(i == 1){
            view.backgroundColor = [UIColor yellowColor];
        }else{
            view.backgroundColor = [UIColor blueColor];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.delegateForReuseableScrollView == nil) {
        NSLog(@"不执行reusable策略：self.delegateForReusableScrollView == nill");
        return;
    }
    // 如果总页数小于buffer页数，则没必要执行reusable策略
    if ([self.delegateForReuseableScrollView numOfPages] <= nBufferViews) {
        NSLog(@"不执行reusable策略：总页数小于buffer数");
        return;
    }
    UIView *currentView = nil;
    NSUInteger maxPage = [self.delegateForReuseableScrollView numOfPages] - 1;
    if (self.currentPage == 0) {
        currentView = self.bufferViews[0];
    }else if (self.currentPage == maxPage){
        currentView = self.bufferViews[2];
    }else{
        currentView = self.bufferViews[1];
    }
    
    CGFloat offsetDiff = self.contentOffset.x - currentView.frame.origin.x;
    // 如果滑动幅度没有达到翻页，则不执行reusable策略
    if (fabs(offsetDiff) < self.frame.size.width) {
//        NSLog(@"不执行reusable策略：未达到翻页X(%d - %d)", (int)self.contentOffset.x, (int)currentView.frame.origin.x);
        return;
    }
    
    int toPage = self.currentPage;
    if (offsetDiff > 0) {
        toPage++;
    }else{
        toPage--;
    }
    
    NSLog(@"Page %d => Page %d", self.currentPage, toPage);
    // 如果是 第0页<=>第1页 或者 最后一页<=>倒数第二页，则仅更新currentPage
    if (self.currentPage == 0 || toPage == 0 || self.currentPage == maxPage || toPage == maxPage) {
        self.currentPage = toPage;
    }else{
        if (toPage > self.currentPage) {
            UIView *view = self.bufferViews[0];
            self.bufferViews[0] = self.bufferViews[1];
            self.bufferViews[1] = self.bufferViews[2];
            self.bufferViews[2] = view;
            [self.delegateForReuseableScrollView setupView:self.bufferViews[2] toPage:toPage + 1];
        }else{
            UIView *view = self.bufferViews[2];
            self.bufferViews[2] = self.bufferViews[1];
            self.bufferViews[1] = self.bufferViews[0];
            self.bufferViews[0] = view;
            [self.delegateForReuseableScrollView setupView:self.bufferViews[0] toPage:toPage - 1];
        }
        self.currentPage = toPage;
        
        for (int i=0; i<nBufferViews; i++) {
            UIView *view = self.bufferViews[i];
            CGRect rect = self.frame;
            rect.origin.x = rect.size.width * i;
            view.frame = rect;
        }
        CGPoint contentOffset = ((UIView*)self.bufferViews[1]).frame.origin;
        self.contentOffset = contentOffset;
    }
}
@end
