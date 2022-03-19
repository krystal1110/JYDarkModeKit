//
//  UITableView+JYDarkModeKit.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/19.
//

#import "UITableView+JYDarkModeKit.h"
#import "NSObject+JYTraitEnviroment.h"
#import "UIView+JYDatkModeKit.h"
@implementation UITableView (JYDarkModeKit)

- (void)jyTraitCollectionDidChange:(JYTraitCollection *)previousTraitCollection {
    
    if (@available(iOS 13, *)){return;}
    
    [self jy_updateDynamicColors];
    
    // 如果不刷新的话 cell不会自动刷新
    [self reloadData];
}

@end

 
