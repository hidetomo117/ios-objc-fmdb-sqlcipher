//
//  CompanyMasterRepository.m
//  ios-objc-fmdb-sqlcipher
//
//  Created by YukiOkudera on 2018/07/07.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import "CompanyMasterRepository.h"
#import "EncryptedDAO.h"
#import "SelectResult.h"
#import "SQLiteRequest.h"

@implementation CompanyMasterRepository

#pragma mark - INSERT

+ (BOOL)insertWithCompanyMasterArray:(NSArray <CompanyMaster *> *)newDataArray {

    NSMutableArray <SQLiteRequest *> *insertRequests = [@[] mutableCopy];
    NSString *const sql = @"INSERT INTO company_master(company_name, company_employees_count) VALUES(?, ?);";

    for (CompanyMaster *companyMaster in newDataArray) {

        NSArray *parameters = @[companyMaster.companyName, @(companyMaster.companyEmployeesCount)];
        SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:sql parameters:parameters];
        [insertRequests addObject:request];
    }

    return [[EncryptedDAO shared] inTransaction:insertRequests.copy];
}

#pragma mark - UPDATE

+ (BOOL)updateWithCompanyMasterArray:(NSArray <CompanyMaster *> *)updateDataArray {

    NSMutableArray <SQLiteRequest *> *updateRequests = [@[] mutableCopy];
    NSString *const sql = @"UPDATE company_master SET company_name = ?, company_employees_count = ? WHERE company_no = ?;";

    for (CompanyMaster *companyMaster in updateDataArray) {

        NSArray *parameters = @[companyMaster.companyName, @(companyMaster.companyEmployeesCount), @(companyMaster.companyNo)];
        SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:sql parameters:parameters];
        [updateRequests addObject:request];
    }

    return [[EncryptedDAO shared] inTransaction:updateRequests];
}

+ (BOOL)updateWithCompanyNo:(NSUInteger)companyNo
                companyName:(NSString *)companyName
      companyEmployeesCount:(NSUInteger)companyEmployeesCount {

    NSString *const sql = @"UPDATE company_master SET company_name = ?, company_employees_count = ? WHERE company_no = ?;";
    NSArray *const parameters = @[companyName, @(companyEmployeesCount), @(companyNo)];
    SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:sql parameters:parameters];

    return [[EncryptedDAO shared] inTransaction:@[request]];
}

#pragma mark - DELETE

+ (BOOL)deleteWithCompanyNo:(NSUInteger)companyNo {

    NSString *const sql = @"DELETE FROM company_master WHERE company_no = ?;";
    NSArray *const parameter = @[@(companyNo)];
    SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:sql parameters:parameter];

    return [[EncryptedDAO shared] inTransaction:@[request]];
}

+ (BOOL)truncate {
    return [[EncryptedDAO shared] truncateWithTableName:@"company_master"];
}

#pragma mark - SELECT

+ (NSArray <CompanyMaster *> *)selectAll {

    NSString *const sql = @"SELECT company_no, company_name, company_employees_count FROM company_master;";
    SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:sql
                                                       parameters:nil
                                                       tableModel:TableModelCompanyMaster];
    SelectResult <CompanyMaster *>*result = [[SelectResult alloc] initWithTableModel:TableModelCompanyMaster resultType:CompanyMaster.new];

    [[EncryptedDAO shared] executeQuery:request result:result];

    return result.resultArray.copy;
}

+ (NSArray <CompanyMaster *> *)selectByCompanyNo:(NSUInteger)companyNo {

    NSString *const sql = @"SELECT company_no, company_name, company_employees_count FROM company_master WHERE company_no = ?;";
    NSArray *const parameter = @[@(companyNo)];
    SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:sql
                                                       parameters:parameter
                                                       tableModel:TableModelCompanyMaster];
    SelectResult <CompanyMaster *>*result = [[SelectResult alloc] initWithTableModel:TableModelCompanyMaster resultType:CompanyMaster.new];

    [[EncryptedDAO shared] executeQuery:request result:result];

    return result.resultArray.copy;
}

+ (NSArray <CompanyMaster *> *)selectByEmployeesCount:(NSInteger)threshold {

    NSString *const sql = @"SELECT company_no, company_name, company_employees_count FROM company_master WHERE company_employees_count >= ?;";
    NSArray *const parameter = @[@(threshold)];
    SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:sql
                                                       parameters:parameter
                                                       tableModel:TableModelCompanyMaster];
    SelectResult <CompanyMaster *>*result = [[SelectResult alloc] initWithTableModel:TableModelCompanyMaster resultType:CompanyMaster.new];

    [[EncryptedDAO shared] executeQuery:request result:result];

    return result.resultArray.copy;
}
@end
