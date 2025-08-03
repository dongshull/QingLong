/**
 * new Env('🔍 03.青龙环境探测');
 * cron: @once
 */

const { execSync } = require('child_process');
const fs = require('fs');

// ✅ 修正为你的实际脚本路径
const SH_SCRIPT_PATH = '/ql/data/repo/dongshull_QingLong/Docker/File_Tree.sh';

// 检查 .sh 脚本是否存在
if (!fs.existsSync(SH_SCRIPT_PATH)) {
    console.log(`❌【环境探测】脚本未找到：${SH_SCRIPT_PATH}`);
    console.log('💡 请检查：');
    console.log('   1. 仓库地址是否正确（dongshull/QingLong）');
    console.log('   2. 分支是否是 master 或 main');
    console.log('   3. 是否已成功拉取仓库');
    process.exit(1);
}

// 记录开始时间
const startTime = new Date();
console.log(`🚀【环境探测】开始执行：${SH_SCRIPT_PATH}`);
console.log(`⏰ 执行时间：${startTime.toLocaleString()}`);
console.log('────────────────────────────────');

// 执行 .sh 脚本
try {
    const output = execSync(`bash "${SH_SCRIPT_PATH}"`, {
        encoding: 'utf-8',
        stdio: 'pipe'
    });
    console.log(output); // 输出探测结果

    // ✅ 执行成功，发送通知
    try {
        const notify = require('./sendNotify');
        const duration = ((new Date() - startTime) / 1000).toFixed(1);
        notify.sendNotify(
            '🔍 青龙环境探测完成',
            `✅ 探测脚本执行成功，耗时 ${duration} 秒。\n请查看日志了解详细信息。`
        );
    } catch (e) {
        console.log('🔔 推送通知功能未启用（sendNotify 模块缺失）');
    }

} catch (error) {
    console.error('❌【环境探测】脚本执行失败：', error.message);

    // ❌ 发送失败通知
    try {
        const notify = require('./sendNotify');
        notify.sendNotify(
            '🔍 青龙环境探测失败',
            `❌ 脚本执行出错：\n${error.message}`
        );
    } catch {}
}