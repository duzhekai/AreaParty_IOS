// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: DeleteFileMsg.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "DeleteFileMsg.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - DeleteFileMsgRoot

@implementation DeleteFileMsgRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - DeleteFileMsgRoot_FileDescriptor

static GPBFileDescriptor *DeleteFileMsgRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"protocol"
                                                     syntax:GPBFileSyntaxProto2];
  }
  return descriptor;
}

#pragma mark - DeleteFileReq

@implementation DeleteFileReq

@dynamic hasUserId, userId;
@dynamic hasFileId, fileId;
@dynamic hasFileName, fileName;
@dynamic hasFileSize, fileSize;
@dynamic hasFileInfo, fileInfo;
@dynamic hasFileURL, fileURL;
@dynamic hasFilePwd, filePwd;

typedef struct DeleteFileReq__storage_ {
  uint32_t _has_storage_[1];
  int32_t fileId;
  NSString *userId;
  NSString *fileName;
  NSString *fileInfo;
  NSString *fileURL;
  NSString *filePwd;
  int64_t fileSize;
} DeleteFileReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = DeleteFileReq_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(DeleteFileReq__storage_, userId),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fileId",
        .dataTypeSpecific.className = NULL,
        .number = DeleteFileReq_FieldNumber_FileId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(DeleteFileReq__storage_, fileId),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "fileName",
        .dataTypeSpecific.className = NULL,
        .number = DeleteFileReq_FieldNumber_FileName,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(DeleteFileReq__storage_, fileName),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fileSize",
        .dataTypeSpecific.className = NULL,
        .number = DeleteFileReq_FieldNumber_FileSize,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(DeleteFileReq__storage_, fileSize),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "fileInfo",
        .dataTypeSpecific.className = NULL,
        .number = DeleteFileReq_FieldNumber_FileInfo,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(DeleteFileReq__storage_, fileInfo),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fileURL",
        .dataTypeSpecific.className = NULL,
        .number = DeleteFileReq_FieldNumber_FileURL,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(DeleteFileReq__storage_, fileURL),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "filePwd",
        .dataTypeSpecific.className = NULL,
        .number = DeleteFileReq_FieldNumber_FilePwd,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(DeleteFileReq__storage_, filePwd),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[DeleteFileReq class]
                                     rootClass:[DeleteFileMsgRoot class]
                                          file:DeleteFileMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(DeleteFileReq__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\007\001\006\000\002\006\000\003\010\000\004\010\000\005\010\000\006\005!!\000\007\007\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - DeleteFileRsp

@implementation DeleteFileRsp

@dynamic hasResultCode, resultCode;
@dynamic hasFileId, fileId;
@dynamic hasFileName, fileName;
@dynamic hasFileDate, fileDate;
@dynamic hasFileInfo, fileInfo;

typedef struct DeleteFileRsp__storage_ {
  uint32_t _has_storage_[1];
  DeleteFileRsp_ResultCode resultCode;
  int32_t fileId;
  NSString *fileName;
  NSString *fileDate;
  NSString *fileInfo;
} DeleteFileRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "resultCode",
        .dataTypeSpecific.enumDescFunc = DeleteFileRsp_ResultCode_EnumDescriptor,
        .number = DeleteFileRsp_FieldNumber_ResultCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(DeleteFileRsp__storage_, resultCode),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "fileId",
        .dataTypeSpecific.className = NULL,
        .number = DeleteFileRsp_FieldNumber_FileId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(DeleteFileRsp__storage_, fileId),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "fileName",
        .dataTypeSpecific.className = NULL,
        .number = DeleteFileRsp_FieldNumber_FileName,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(DeleteFileRsp__storage_, fileName),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fileDate",
        .dataTypeSpecific.className = NULL,
        .number = DeleteFileRsp_FieldNumber_FileDate,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(DeleteFileRsp__storage_, fileDate),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "fileInfo",
        .dataTypeSpecific.className = NULL,
        .number = DeleteFileRsp_FieldNumber_FileInfo,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(DeleteFileRsp__storage_, fileInfo),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[DeleteFileRsp class]
                                     rootClass:[DeleteFileMsgRoot class]
                                          file:DeleteFileMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(DeleteFileRsp__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\005\001\n\000\002\006\000\003\010\000\004\010\000\005\010\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Enum DeleteFileRsp_ResultCode

GPBEnumDescriptor *DeleteFileRsp_ResultCode_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Success\000Fail\000";
    static const int32_t values[] = {
        DeleteFileRsp_ResultCode_Success,
        DeleteFileRsp_ResultCode_Fail,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(DeleteFileRsp_ResultCode)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:DeleteFileRsp_ResultCode_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL DeleteFileRsp_ResultCode_IsValidValue(int32_t value__) {
  switch (value__) {
    case DeleteFileRsp_ResultCode_Success:
    case DeleteFileRsp_ResultCode_Fail:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
