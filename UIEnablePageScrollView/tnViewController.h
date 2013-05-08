//
//  tnViewController.h
//  UIEnablePageScrollView
//
//  Created by Lee Aru on 13-5-8.
//  Copyright (c) 2013年 FourOnes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIEnablePageScrollView.h"
#define ROWS 8

@interface tnViewController : UIViewController<UIEnablePageScrollViewDelegate>{
    NSInteger   m_nTotalDatas;
    NSInteger   m_nTotalPages;
    NSInteger   m_nCurPageindex;
}
@property(nonatomic,retain) UIEnablePageScrollView *pageScrollView;
@property(nonatomic,retain) NSMutableArray *sourceList;
@property(nonatomic,retain) NSMutableArray *list;

-(void)initSourceList;
-(void)loadDataHelper:(NSString *)i;
@end
