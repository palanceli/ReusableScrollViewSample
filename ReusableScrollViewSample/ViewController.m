//
//  ViewController.m
//  ReusableScrollViewSample
//
//  Created by palance on 15/10/8.
//  Copyright © 2015年 binglen. All rights reserved.
//

#import "ViewController.h"
#import "ReusableScrollView.h"
#import "ContentView.h"

@interface ViewController ()<ReusableScrollViewDelegate>

@property (strong, nonatomic) IBOutlet ReusableScrollView *scrollView;

@property (nonatomic, strong) NSArray *contents;
@end

@implementation ViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _contents = @[@"A", @"B", @"C", @"D", @"E"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegateForReuseableScrollView = self;
    [self.scrollView setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)setupView:(UIView *)view toPage:(NSUInteger)toPage
{
    if (view == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
        view = vc.view;
    }
    ContentView *contentView = (ContentView*)view;
    contentView.contentLabel.text = self.contents[toPage];
    return view;
}

-(NSUInteger)numOfPages
{
    return [self.contents count];
}
@end
