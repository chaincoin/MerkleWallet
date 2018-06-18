//
//  NSData+CHC.h
//  BreadWallet
//
//  Created by Sam Westrich on 1/31/17.
//  Copyright © 2018 Dash Core. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntTypes.h"

@interface NSData (Chaincoin)

-(UInt256)c11;
-(UInt512)blake512;
-(UInt512)bmw512;
-(UInt512)groestl512;
-(UInt512)skein512;
-(UInt512)jh512;
-(UInt512)keccak512;
-(UInt512)luffa512;
-(UInt512)cubehash512;
-(UInt512)shavite512;
-(UInt512)simd512;
-(UInt512)echo512;

+ (NSData *)dataFromHexString:(NSString *)string;

@end
