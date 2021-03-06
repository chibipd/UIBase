//
//  ViewController.m
//  UIBase
//
//  Created by Peng Dong on 16/6/23.
//  Copyright © 2016年 LucaPeng. All rights reserved.
//

#import "ViewController.h"
#import "Shop.h"
#import "shopView.h"

@interface ViewController ()

@property(nonatomic, strong)UIView *containView;
@property(nonatomic, strong)NSArray *shops;
@property(nonatomic, strong)UILabel *totastLabel;
@property(nonatomic, strong)UIButton *removeButton;
@property(nonatomic, strong)UIButton *addButton;

@end

@implementation ViewController

-(NSArray *)shops{
    if ( ! _shops ) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shops.plist" ofType:nil]];
        NSMutableArray *shopData = [NSMutableArray array];
        for (id dict in dictArray) {
            Shop *shop = [Shop shopWithDict:dict];
            [shopData addObject:shop];
        }
        _shops = shopData;
    }
    return _shops;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(50, 50, 30, 30);
    [addButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    self.addButton = addButton;
    [self.view addSubview:addButton];
    

    
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(280, 50, 30, 30);
    [removeBtn setBackgroundImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:removeBtn];
    self.removeButton = removeBtn;
    
    self.containView = [[UIView alloc]initWithFrame:CGRectMake(50, 150, 350, 300)];
//    _containView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_containView];
    
    
    UILabel *totastLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height/2, 150, 30)];
    totastLabel.hidden = YES;
    self.totastLabel = totastLabel;
    [self.view addSubview:totastLabel];
}


-(void)add{
  
    NSUInteger index = self.containView.subviews.count;
    NSUInteger cols = 3;
    CGFloat elementsW = 100;
    CGFloat elementsH = 100;
    CGFloat marginX = (self.containView.frame.size.width - cols * elementsW) / (cols - 1) ;
    CGFloat marginY = 20;
    NSInteger row = index / cols;
    NSInteger col = index % cols;

    shopView *elementView = [shopView shopView];
    elementView.frame = CGRectMake(col * (elementsW + marginX) , row * (elementsH + marginY), elementsW, elementsH);
    elementView.shopObj = self.shops[index];
    [self.containView addSubview:elementView];

    
    [self checkState];
}



-(void)remove{
    [[self.containView.subviews lastObject] removeFromSuperview];
    [self checkState];
}

-(void)checkState{
    
    self.removeButton.enabled = ([self.containView.subviews count] > 0);
    self.addButton.enabled = ([self.containView.subviews count] < _shops.count);
    
    NSString *text = nil;
    if (self.removeButton.enabled == NO) {
        text = @"没有东西可删除了";
    } else if(self.addButton.enabled == NO){
        text = @"不能添加了";
    }
    
    if (!text) {
        return;
    }
    self.totastLabel.hidden = NO;
    self.totastLabel.text = text;
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0f];
}



-(void)dismiss{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:3.0];
    self.totastLabel.hidden = YES;
//    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
