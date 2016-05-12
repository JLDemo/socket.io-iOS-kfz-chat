//
//  KFZNet.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/12.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZNet.h"

@implementation KFZNet


+ (void)GET:(NSString *)urlString params:(NSDictionary *)params success:(Success_B)success faile:(Faile_B)faile {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:params progress:nil success:success failure:faile];
}

+ (void)POST:(NSString *)urlString params:(NSDictionary *)params success:(Success_B)success faile:(Faile_B)faile {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString parameters:params progress:nil success:success failure:faile];
    
}

@end
