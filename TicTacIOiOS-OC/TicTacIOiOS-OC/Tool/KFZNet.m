//
//  KFZNet.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/12.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZNet.h"

@implementation KFZNet




/// 消息联系人接口
+ (void)getContactList:(NSString *)url param:(NSDictionary *)param success:(Success_B)success faile:(Faile_B)faile {
    [self POST:url params:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faile(task,error);
    }];
    
}
    


+ (void)GET:(NSString *)urlString params:(NSDictionary *)params success:(Success_B)success faile:(Faile_B)faile {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:params progress:nil success:success failure:faile];
}

+ (void)POST:(NSString *)urlString params:(NSDictionary *)params success:(Success_B)success faile:(Faile_B)faile {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString parameters:params progress:nil success:success failure:faile];
    
}



@end
