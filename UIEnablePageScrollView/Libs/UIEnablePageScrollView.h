//
//  tnAppDelegate.m
//  UIEnablePageScrollView
//
//  Created by Lee Aru on 13-5-8.
//  Copyright (c) 2013年 FourOnes http://www.xnwai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIEnablePageScrollViewKey  "UIEnablePageScrollViewKeyStr"
@protocol UIEnablePageScrollViewDelegate <NSObject>
@optional
//加载更多数据
-(void)UIEnablePageScrollViewLoadMore:(id)sender;
-(NSInteger)numberOfUIEnablePageScrollView:(id)sender;
-(UIView *)UIEnablePageScrollView:(id)sender withIndex:(NSInteger)index;
-(void)UIEnablePageScrollViewLoadMore:(id)sender didSelectedIndex:(NSInteger)index;
-(void)UIEnablePageScrollViewPageChanged:(NSMutableDictionary *)viewDictionary curPage:(NSInteger)page;
@end

@interface UIEnablePageScrollView : UIScrollView<UIScrollViewDelegate>{
    UIView *loadMoreView;
}
@property(nonatomic) NSInteger page;
@property(nonatomic,readonly) NSInteger pageCount;
@property(nonatomic,assign) id UIEnablePageScrollViewDelegate;
@property(nonatomic) BOOL isLoadCompeleted;
@property(nonatomic) BOOL loadingCompeleted;

-(void)reload;
@end
