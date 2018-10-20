//
//  ATSQLManager.h
//  Sqlite3Demo
//
//  Created by 海修杰 on 17/1/10.
//  Copyright © 2017年 qizhiwenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATAtist.h"

@interface ATSQLManager : NSObject

//单例调用
+(instancetype)shareSQLManager;

//插入一条艺术家信息
-(void)insertArtistInfoWithArtist:(ATAtist *)artist;

//取出数据库所有数据数据
-(NSMutableArray *)getAllArtistsArrayFromDateBase;

//删除一条艺术家信息
-(void)deleteArtistInfoWithID:(NSString *)id;

//更新一条艺术家信息
-(void)updateArtistInfoWithArtist:(ATAtist *)artist;
@end
