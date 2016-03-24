//
//  ViewController.m
//  RealmSample
//
//  Created by chenkai on 16/3/23.
//  Copyright © 2016年 chenkai. All rights reserved.
//

#import "ViewController.h"
#import <Realm/Realm.h>


//Define models
@interface Dog : RLMObject

@property NSString *name;
@property NSInteger age;

@end

RLM_ARRAY_TYPE(Dog)

@interface Person : RLMObject

@property NSString *name;
@property NSData *picture;
@property RLMArray<Dog> *dogs;

@end

@implementation Dog


@end



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self realmuserage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 概览用法

- (void)realmuserage{

    Dog *firstdog = [[Dog alloc] init];
    firstdog.name = @"franklin";
    firstdog.age = 3;
    NSLog(@"dog name:%@",firstdog.name);
    
    Dog *seconddog = [[Dog alloc] init];
    seconddog.name = @"lamer";
    seconddog.age = 2;
    
    //Save To Realm [1]
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:firstdog];
    }];

    //Save To Realm [2]
    [realm beginWriteTransaction];
    [realm addObject:seconddog];
    [realm commitWriteTransaction];
    
    RLMResults *result = [Dog objectsWhere:@"age < 5"];
    NSLog(@"Dog Count：%lu", (unsigned long)result.count);
    
    //Call anywhere
    dispatch_async(dispatch_queue_create("background", 0), ^{
        Dog *thedog = [[Dog objectsWhere:@"age < 10"] firstObject];
        RLMRealm *realm = [RLMRealm defaultRealm];
        if (thedog != nil) {
            [realm beginWriteTransaction];
            thedog.name = @"name changed";
            thedog.age = 100;
            [realm commitWriteTransaction];
        }
    });
    
    result = [Dog objectsWhere:@"age == 100"];
    NSLog(@"count:%lu",(unsigned long)result.count);
    Dog *changeddog = (Dog *)[result firstObject];
    NSLog(@"name:%@",changeddog.name);
    NSLog(@"age:%ld",(long)changeddog.age);
}

@end































