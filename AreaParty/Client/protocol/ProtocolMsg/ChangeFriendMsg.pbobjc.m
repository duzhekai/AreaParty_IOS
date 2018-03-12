// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: ChangeFriendMsg.proto

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

 #import "ChangeFriendMsg.pbobjc.h"
 #import "UserData.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - ChangeFriendMsgRoot

@implementation ChangeFriendMsgRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - ChangeFriendMsgRoot_FileDescriptor

static GPBFileDescriptor *ChangeFriendMsgRoot_FileDescriptor(void) {
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

#pragma mark - ChangeFriendSync

@implementation ChangeFriendSync

@dynamic hasChangeType, changeType;
@dynamic hasUserItem, userItem;

typedef struct ChangeFriendSync__storage_ {
  uint32_t _has_storage_[1];
  ChangeFriendSync_ChangeType changeType;
  UserItem *userItem;
} ChangeFriendSync__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "changeType",
        .dataTypeSpecific.enumDescFunc = ChangeFriendSync_ChangeType_EnumDescriptor,
        .number = ChangeFriendSync_FieldNumber_ChangeType,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ChangeFriendSync__storage_, changeType),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "userItem",
        .dataTypeSpecific.className = GPBStringifySymbol(UserItem),
        .number = ChangeFriendSync_FieldNumber_UserItem,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ChangeFriendSync__storage_, userItem),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ChangeFriendSync class]
                                     rootClass:[ChangeFriendMsgRoot class]
                                          file:ChangeFriendMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ChangeFriendSync__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\001\n\000\002\010\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Enum ChangeFriendSync_ChangeType

GPBEnumDescriptor *ChangeFriendSync_ChangeType_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Add\000Delete\000Update\000";
    static const int32_t values[] = {
        ChangeFriendSync_ChangeType_Add,
        ChangeFriendSync_ChangeType_Delete,
        ChangeFriendSync_ChangeType_Update,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(ChangeFriendSync_ChangeType)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:ChangeFriendSync_ChangeType_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL ChangeFriendSync_ChangeType_IsValidValue(int32_t value__) {
  switch (value__) {
    case ChangeFriendSync_ChangeType_Add:
    case ChangeFriendSync_ChangeType_Delete:
    case ChangeFriendSync_ChangeType_Update:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
