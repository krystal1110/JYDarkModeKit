//
//  JYEnvironmentConfiguration.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/19.
//

#import "JYEnvironmentConfiguration.h"

@implementation JYEnvironmentConfiguration


- (instancetype)init {
  self = [super init];
  if (self) {
    _useImageAsset = NO;
    _themeChangeHandler = nil;
  }
  return self;
}


+ (instancetype)initWithThemeChangeHandler:(void(^)(void))themeChangeHandler{
    JYEnvironmentConfiguration * configuration = [[JYEnvironmentConfiguration alloc]init];
    configuration.themeChangeHandler = themeChangeHandler;
    return configuration;
}

@end
