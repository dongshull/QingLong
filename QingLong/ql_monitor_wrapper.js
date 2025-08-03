/**
 * new Env('📊 02.青龙系统监控');
 * cron: @once
 */

const { execSync } = require('child_process');
const fs = require('fs');

// ✅ 你的 Monitor.sh 脚本真实路径
const SH_SCRIPT_PATH = '/ql/data/repo/dongshull_QingLong/Docker/Monitor.sh';

// 检查脚本文件是否存在
if (!fs.existsSync(SH_SCRIPT_PATH)) {
    console.log(`❌【系统监控】脚本未找到：${SH_SCRIPT_PATH}`);
    console.log('💡 请检查以下配置：');
    console.log('   1. 仓库地址是否正确：https://github.com/dongshull/QingLong.git');
    console.log('   2. 分支是否为 main 或 master');
    console.log('   3. 文件路径是否设置为 Docker');
    console.log('   4. 是否已成功拉取仓库');

    // ❌ 发送失败通知（可选）
    try {
        const notify = require('./sendNotify');
        notify.sendNotify('❌ 系统监控失败', `监控脚本未找到：${SH_SCRIPT_PATH}`);
    } catch (e) {
        console.log('🔔 推送通知功能未启用');
    }

    process.exit(1);
}

// 记录开始时间
const startTime = new Date();
console.log(`📊【青龙系统监控】开始执行：${SH_SCRIPT_PATH}`);
console.log(`⏰ 执行时间：${startTime.toLocaleString()}`);
console.log('────────────────────────────────');

// 执行 .sh 脚本
try {
    const output = execSync(`bash "${SH_SCRIPT_PATH}"`, {
        encoding: 'utf-8',
        stdio: 'pipe'  // 捕获输出，便于日志查看
    });

    console.log(output); // 输出 Monitor.sh 的完整日志

    // ✅ 执行成功，发送通知（可选：仅关键信息推送）
    try {
        const notify = require('./sendNotify');
        const duration = ((new Date() - startTime) / 1000).toFixed(1);
        notify.sendNotify(
            '📊 青龙系统监控完成',
            `✅ 监控脚本执行成功，耗时 ${duration} 秒。\n请查看日志了解 CPU、内存、磁盘等使用情况。`
        );
    } catch (e) {
        console.log('🔔 推送通知功能未启用（sendNotify 模块缺失）');
    }

} catch (error) {
    console.error('❌【系统监控】脚本执行失败：', error.message);

    // ❌ 发送失败通知
    try {
        const notify = require('./sendNotify');
        notify.sendNotify(
            '🚨 青龙系统监控失败',
            `❌ 脚本执行出错：\n${error.message.substring(0, 500)}`
        );
    } catch (e) {
        console.log('🔔 推送通知失败');
    }
}