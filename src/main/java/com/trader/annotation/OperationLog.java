package com.trader.annotation;

import java.lang.annotation.*;

/**
 * 操作日志注解
 * 标注在需要记录操作日志的方法上
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface OperationLog {
    /**
     * 功能模块
     */
    String module() default "";
    
    /**
     * 操作类型
     */
    OperationType type() default OperationType.OTHER;
    
    /**
     * 操作描述
     */
    String description() default "";
    
    /**
     * 操作类型枚举
     */
    enum OperationType {
        LOGIN("LOGIN", "登录"),
        LOGOUT("LOGOUT", "退出"),
        CREATE("CREATE", "新增"),
        UPDATE("UPDATE", "修改"),
        DELETE("DELETE", "删除"),
        IMPORT("IMPORT", "导入"),
        EXPORT("EXPORT", "导出"),
        OTHER("OTHER", "其他");
        
        private final String code;
        private final String name;
        
        OperationType(String code, String name) {
            this.code = code;
            this.name = name;
        }
        
        public String getCode() {
            return code;
        }
        
        public String getName() {
            return name;
        }
    }
}
