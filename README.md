

# U-BOOT


高通版-小猪：

https://github.com/1980490718/u-boot-2016.git

京东云 AX1800 Pro（re-ss-01 / 亚瑟）自用 U-BOOT — main/

- Release 页面：https://github.com/1980490718/u-boot-2016/releases/
- 机型文件（ipq6018_ax1800pro）：openwrt-ipq6018_ax1800pro-u-boot

- 用途：不死 U-BOOT，用于刷机与救砖；刷入前请确认分区布局（原厂 / 大分区）与机型匹配。


# 12M 大分区 U-BOOT + 2G GPT 分区表（京东云 AX1800 Pro 配套扩容方案）

两件配套使用，用于把 rootfs 扩到 2048MiB 并启用 12M 内核分区。U-BOOT 作者可能发布新版，可从下列 Release 页取最新；GPT 分区表已备份在本仓库（见下方直链）。

12M 大分区 U-BOOT（HLOS 12MiB）：

- 仓库：https://github.com/chenxin527/uboot-qsdk12.5-build
- Release 列表：https://github.com/chenxin527/uboot-qsdk12.5-build/releases
- 机型文件关键字：jdcloud_re-ss-01 / ipq60xx（在最新 Release 中按机型挑选）

2G GPT 分区表（rootfs 2048M / HLOS 12M）——本仓库备份，直接下载：

- 直链：https://raw.githubusercontent.com/Turkeyer/immortalwrt/main/Firmware/gpt-JDC_AX1800_Pro_rootfs2048M_HLOS12M.bin
- 仓库内路径：`Firmware/gpt-JDC_AX1800_Pro_rootfs2048M_HLOS12M.bin`
- MD5：`4e68b53b2646a4824aed74a4f5b656ea`（17408 字节，下载后可校验）

刷机顺序（在旧 U-BOOT 的网页界面操作）：

1. http://192.168.1.1/uboot.html 刷 12M 大分区 U-BOOT；
2. http://192.168.1.1/img.html 刷 2G GPT 分区表；
3. http://192.168.1.1/ 刷固件 factory.bin；
4. 之后在系统内 Web 升级用 sysupgrade.bin。


# 固件刷入方式（按当前状态选择）

本机当前状态：已是 12M HLOS + 2G rootfs 大分区，uboot 与 GPT 均已就位。日常升级无需再动 uboot。

| 当前情况 | 刷入方式 | 刷哪个文件 | 入口 |
|---|---|---|---|
| 系统正常、能进 LuCI（日常升级、本次新固件） | LuCI 后台网页升级，勾选"保留配置" | `*-squashfs-sysupgrade-*.bin` | 系统 → 备份/升级 → 刷写固件 |
| 系统进不去、但 uboot 还能进 | uboot 网页刷入 | `*-squashfs-factory-*.bin` | http://192.168.1.1/ |
| 首次扩容或彻底变砖 | 依次刷 uboot、GPT、固件 | uboot .bin → GPT .bin → factory.bin | /uboot.html → /img.html → /uboot 首页 |

说明：

- sysupgrade.bin：系统内升级用，带板子型号校验；勾选"保留配置"可保住 WiFi、拨号、WireGuard 及各插件设置。
- factory.bin：kernel + rootfs 拼接，供 uboot 网页刷入或首次刷机；会覆盖系统分区。
- uboot 后台默认 IP 为 192.168.1.1，可在 Web 内"系统 → 网络设置"修改。


# 固件简要说明

## 注意事项：DATA 分区会在首次开机格式化

- uboot 刷 factory（或 LuCI 升级不勾选保留配置）后首次开机，会自动格式化 DATA 分区（/dev/mmcblk0p27），清空原厂跑分缓存及分区内全部数据，再挂载到 /mnt/data。
- LuCI 升级若勾选"保留配置"，则不格式化，数据原样保留。
- DATA 分区有需要保留的文件时，请先备份，或改用保留配置方式升级。

# 目录简要说明

workflows——自定义CI配置

Scripts——自定义脚本

Config——自定义配置

## Star History

<a href="https://www.star-history.com/?repos=vikingyfy%2Fopenwrt-ci&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=vikingyfy/openwrt-ci&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=vikingyfy/openwrt-ci&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=vikingyfy/openwrt-ci&type=date&legend=top-left" />
 </picture>
</a>
