#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 VIKINGYFY

#移除luci-app-attendedsysupgrade
find ./feeds/luci/collections/ -type f -name "Makefile" -exec sed -i "/attendedsysupgrade/d" {} +
#修改默认主题
find ./feeds/luci/collections/ -type f -name "Makefile" -exec sed -i "s/luci-theme-bootstrap/luci-theme-$WRT_THEME/g" {} +
#修改immortalwrt.lan关联IP
find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js" -exec sed -i "s/192\.168\.[0-9]*\.[0-9]*/$WRT_IP/g" {} +
#添加编译日期标识
find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js" -exec sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ $WRT_MARK-$WRT_DATE')/g" {} +

#修改默认WIFI账号密码
WIFI_UC="./package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc"
ROUTER_TOOL="./package/emortal/luci-app-router-tool/root/etc/config/router-tool"
for file in "$ROUTER_TOOL" "$WIFI_UC"; do
	[ -f "$file" ] && sed -i "s/ssid '.*'/ssid '$WRT_SSID'/g; s/key '.*'/key '$WRT_WORD'/g" "$file"
done

CFG_FILE="./package/base-files/files/bin/config_generate"
#修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$WRT_IP/g" $CFG_FILE
#修改默认主机名
sed -i "s/hostname='.*'/hostname='$WRT_NAME'/g" $CFG_FILE

#配置文件修改
echo "CONFIG_PACKAGE_luci=y" >> ./.config
echo "CONFIG_LUCI_LANG_zh_Hans=y" >> ./.config
echo "CONFIG_PACKAGE_luci-theme-$WRT_THEME=y" >> ./.config
echo "CONFIG_PACKAGE_luci-app-$WRT_THEME=y" >> ./.config
echo "CONFIG_PACKAGE_luci-app-$WRT_THEME-config=y" >> ./.config

#引入私有扩展配置
if [ -f "$GITHUB_WORKSPACE/Config/PRIVATE.txt" ]; then
	echo "Applying private configurations from PRIVATE.txt..."
	cat $GITHUB_WORKSPACE/Config/PRIVATE.txt >> ./.config
fi

#手动调整的插件
if [ -n "$WRT_PACKAGE" ]; then
	echo -e "$WRT_PACKAGE" >> ./.config
fi

#高通平台调整
DTS_PATH="./target/linux/qualcommax/dts/"
if [[ "${WRT_TARGET^^}" == *"QUALCOMMAX"* ]]; then
	#无WIFI配置调整Q6大小
	if [[ "$WRT_WIFI" == "WIFI-NO" ]]; then
		find $DTS_PATH -type f ! -iname '*nowifi*' -exec sed -i 's/ipq\(6018\|8074\).dtsi/ipq\1-nowifi.dtsi/g' {} +
		echo "qualcommax set up nowifi successfully!"
	fi
fi


# ==================== WorkBuddy 定制：固化刷机修复项 ====================
# 把用户现有的 4 项手动修复做成 uci-defaults，刷机首次开机自动应用
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/zz_workbuddy_fixes <<'WBEOF'
#!/bin/sh
# 京东云 re-ss-01 刷机后自动修复（首次开机执行一次，之后自动删除）

# 1) nlbwmon 宽带监控：加载 conntrack netlink 模块，修复默认不工作
if [ -f /etc/init.d/nlbwmon ]; then
    sed -i '/^start_service() {/a\	rmmod nf_conntrack_netlink 2>/dev/null\n\tmodprobe nf_conntrack_netlink 2>/dev/null' /etc/init.d/nlbwmon
    /etc/init.d/nlbwmon enable 2>/dev/null
fi

# 2) NSS ECM 前端选择：无需手动设置
# qca-nss-ecm 的 init 脚本会在每次启动时根据硬件自动计算并写入 front_end_selection，
# 手动写死反而可能与它冲突，故移除（2026-11-19 复查）。

# 3) eMMC 预读优化（提升 Samba 读吞吐）
grep -q 'read_ahead_kb' /etc/rc.local 2>/dev/null || sed -i '/^exit 0/i [ -e /sys/block/mmcblk0/queue/read_ahead_kb ] \&\& echo 4096 > /sys/block/mmcblk0/queue/read_ahead_kb' /etc/rc.local

# 4) APK 软件源：确保北大镜像源存在（去掉重复的 vsean 首行以防冲突）
if [ -d /etc/apk/repositories.d ]; then
    PKU="https://mirrors.pku.edu.cn/immortalwrt/snapshots/targets/qualcommax/ipq60xx/packages/packages.adb"
    grep -q 'mirrors.pku.edu.cn' /etc/apk/repositories.d/distfeeds.list 2>/dev/null || echo "$PKU" >> /etc/apk/repositories.d/distfeeds.list
fi

exit 0
WBEOF
chmod +x files/etc/uci-defaults/zz_workbuddy_fixes
echo "WorkBuddy: uci-defaults fix script injected"
# ==================== end WorkBuddy 定制 ====================
