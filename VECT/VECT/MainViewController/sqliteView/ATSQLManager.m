//
//  ATSQLManager.m
//  Sqlite3Demo
//
//  Created by 海修杰 on 17/1/10.
//  Copyright © 2017年 qizhiwenhua. All rights reserved.
//

#import "ATSQLManager.h"
#import <sqlite3.h>


static ATSQLManager * SQLManager = nil;

@interface ATSQLManager ()
{
    sqlite3 *db;
}

@end

@implementation ATSQLManager

//增加艺术家信息
-(void)insertArtistInfoWithArtist:(ATAtist *)artist{
    
    if (sqlite3_open([[self path] UTF8String], &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }
    else{
        sqlite3_stmt *stmt ;
     NSString *  sql = [NSString stringWithFormat:@"insert or replace into artist (name,age) values ('%@','%@')",artist.name,artist.age];
        //第一个参数:数据库对象
        //第二个参数:SQL语句
        //第三个参数:执行语句的长度,-1代表全部执行
        //第四个参数:语句对象
        //第五个参数:没有执行的语句部分
        if( sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL)!=SQLITE_OK){
             NSLog(@"%s",sqlite3_errmsg(db));
        }
        else{
            if( sqlite3_step(stmt) != SQLITE_DONE){
                 sqlite3_close(db);
                NSAssert(NO, @"插入数据失败");
            }
            else{
                NSLog(@"插入数据库成功");
            }
            sqlite3_finalize(stmt);
            sqlite3_close(db);
        }
    }
}

//取出数据库所有数据数据
-(NSMutableArray *)getAllArtistsArrayFromDateBase{
    NSMutableArray *artists = [NSMutableArray array];
    if (sqlite3_open([[self path] UTF8String], &db)!=SQLITE_OK) {
        NSAssert(NO, @"数据库打开失败");
    }
    else{
        const char *sql = "select id ,name ,age from artist";
        sqlite3_stmt *stmt = NULL;
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL)!=SQLITE_OK){
            
        }
        else{
            //执行SQL语句
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                ATAtist *artist = [[ATAtist alloc]init];
                int id = sqlite3_column_int(stmt, 0);
                artist.id = [NSString stringWithFormat:@"%zd",id];
                const unsigned char * name =sqlite3_column_text(stmt, 1);
                artist.name = [[NSString alloc]initWithUTF8String:(char * )name];
                const unsigned char * age = sqlite3_column_text(stmt, 2);
                artist.age = [[NSString alloc]initWithUTF8String:(char * )age];
                [artists addObject:artist];
            }
            sqlite3_finalize(stmt);
        }
    }
    sqlite3_close(db);
    return artists;
}

//删除一条艺术家信息
-(void)deleteArtistInfoWithID:(NSString *)id{
    if (sqlite3_open([[self path] UTF8String], &db)!=SQLITE_OK) {
        NSAssert(NO, @"数据库打开失败");
    }
    else{
        //        sql语句格式: delete from 表名 where 列名 ＝ 参数     注：后面的 列名 ＝ 参数 用于判断删除哪条数据
        NSString *sql = [NSString stringWithFormat:@"delete from artist where id=%@",id];
        char *errorMeg = NULL;
        if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMeg)!=SQLITE_OK){
            NSLog(@"删除失败");
        }
        else{
             NSLog(@"删除成功");
        }
    }
    sqlite3_close(db);
}

//更新一条艺术家信息
-(void)updateArtistInfoWithArtist:(ATAtist *)artist{
    if (sqlite3_open([[self path] UTF8String], &db)!=SQLITE_OK) {
        NSAssert(NO, @"数据库打开失败");
    }
    else{
         // sql语句格式: update 表名 set  列名 = 新参数 where 列名 ＝ 参数   注：前面的 列名 ＝ 新参数 是修改的值, 后面的 列名 ＝ 参数 用于判断删除哪条数据
        NSString *sql = [NSString stringWithFormat:@"update artist set name='%@' , age='%@' where id = %@",artist.name,artist.age,artist.id];
        char * errmsg = NULL;
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errmsg)!=SQLITE_OK) {
            NSLog(@"更新数据失败");
        }
        else{
            NSLog(@"更新数据成功");
        }
    }
    sqlite3_close(db);
}

+(instancetype)shareSQLManager{
    if (!SQLManager) {
        SQLManager = [[self alloc]init];
    }
    return SQLManager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
     SQLManager = [super allocWithZone:zone];
        [SQLManager creatArtistDataBaseTableIfNeeded];
    });
    return SQLManager;
}


//创建艺术家表格
-(void)creatArtistDataBaseTableIfNeeded{
    NSLog(@"%@",[self path]);
    if (sqlite3_open([[self path] UTF8String], &db)!=SQLITE_OK) {
       //打开数据库失败
        sqlite3_close(db);
    }
    else{
        //打开数据库成功
        //编写sql语句
        const char * sql = "create table if not exists artist (id integer primary key autoincrement ,name text ,age text)";
        char *errMesg = NULL;
        if (sqlite3_exec(db, sql, NULL, NULL, &errMesg)!=SQLITE_OK) {
            //创建表失败
        }
    }
}

-(NSString *)path{
    
    NSArray *documentArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentPath = [documentArr firstObject];
    NSString *path = [NSString stringWithFormat:@"%@/artist.sqlite",documentPath];
    
    return path;
}
@end
