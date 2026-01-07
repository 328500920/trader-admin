#!/bin/bash

# 交易员成长计划后台服务启动脚本
# 用法: ./trader.sh start|stop|restart|status

# 配置
HOME_DIR="/home/subt"
APP_DIR="${HOME_DIR}/trader/trader_admin"
JAR_NAME="trader-admin-1.0.0.jar"
JAR_PATH="${APP_DIR}/${JAR_NAME}"
CONFIG_FILE="${APP_DIR}/application.yml"
PID_FILE="${APP_DIR}/trader.pid"
LOG_FILE="${APP_DIR}/trader.log"

# JVM参数
JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC"

# 检查JAR文件是否存在
check_jar() {
    if [ ! -f "${JAR_PATH}" ]; then
        echo "错误: JAR文件不存在: ${JAR_PATH}"
        exit 1
    fi
}

# 检查配置文件是否存在
check_config() {
    if [ ! -f "${CONFIG_FILE}" ]; then
        echo "错误: 配置文件不存在: ${CONFIG_FILE}"
        exit 1
    fi
}

# 获取进程PID
get_pid() {
    if [ -f "${PID_FILE}" ]; then
        cat "${PID_FILE}"
    else
        echo ""
    fi
}

# 检查进程是否运行
is_running() {
    local pid=$(get_pid)
    if [ -n "${pid}" ] && kill -0 "${pid}" 2>/dev/null; then
        return 0
    fi
    return 1
}

# 启动服务
start() {
    if is_running; then
        echo "服务已在运行中, PID: $(get_pid)"
        return 0
    fi

    check_jar
    check_config

    echo "正在启动服务..."
    cd "${APP_DIR}"
    nohup java ${JAVA_OPTS} -jar "${JAR_PATH}" --spring.config.location="${CONFIG_FILE}" > "${LOG_FILE}" 2>&1 &
    echo $! > "${PID_FILE}"
    
    sleep 2
    if is_running; then
        echo "服务启动成功, PID: $(get_pid)"
    else
        echo "服务启动失败, 请查看日志: ${LOG_FILE}"
        rm -f "${PID_FILE}"
        exit 1
    fi
}

# 停止服务
stop() {
    if ! is_running; then
        echo "服务未运行"
        rm -f "${PID_FILE}"
        return 0
    fi

    local pid=$(get_pid)
    echo "正在停止服务, PID: ${pid}..."
    kill "${pid}"
    
    # 等待进程结束，最多等待30秒
    local count=0
    while is_running && [ ${count} -lt 30 ]; do
        sleep 1
        count=$((count + 1))
    done

    if is_running; then
        echo "服务未能正常停止，强制终止..."
        kill -9 "${pid}"
    fi

    rm -f "${PID_FILE}"
    echo "服务已停止"
}

# 重启服务
restart() {
    stop
    sleep 2
    start
}

# 查看状态
status() {
    if is_running; then
        echo "服务运行中, PID: $(get_pid)"
    else
        echo "服务未运行"
    fi
}

# 主入口
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac

exit 0
