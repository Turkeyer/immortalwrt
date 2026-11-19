

# 本地编译器

https://github.com/VIKINGYFY/OWRT-Tools.git

# 自用修改版插件

https://github.com/VIKINGYFY/packages.git

# OpenWRT-CI

官方版：

https://github.com/immortalwrt/immortalwrt.git

自用版：

https://github.com/VIKINGYFY/immortalwrt.git

# U-BOOT


高通版-小猪：

https://github.com/1980490718/u-boot-2016.git

京东云 AX1800 Pro（re-ss-01 / 亚瑟）自用 U-BOOT — main/

- Release 页面：https://github.com/1980490718/u-boot-2016/releases/
- 机型文件（ipq6018_ax1800pro）：openwrt-ipq6018_ax1800pro-u-boot

- 用途：不死 U-BOOT，用于刷机与救砖；刷入前请确认分区布局（原厂 / 大分区）与机型匹配。


# 12M 大分区 U-BOOT + 2G GPT 分区表（京东云 AX1800 Pro 配套扩容方案）

两件配套使用，用于把 rootfs 扩到 2048MiB 并启用 12M 内核分区。作者可能发布新版，请从下列仓库/Release 页自行取最新版本，不写死直链。

12M 大分区 U-BOOT（HLOS 12MiB）：

- 仓库：https://github.com/chenxin527/uboot-qsdk12.5-build
- Release 列表：https://github.com/chenxin527/uboot-qsdk12.5-build/releases
- 机型文件关键字：jdcloud_re-ss-01 / ipq60xx（在最新 Release 中按机型挑选）

2G GPT 分区表（rootfs 2048M / HLOS 12M）：

- 仓库：https://github.com/natserver/istoreos
- 文件路径：docs/gpt-JDC_AX1800_Pro_dual-boot_rootfs2048M_HLOS12M_no-last-partition.bin（在仓库内查找，作者可能更新文件名）

刷机顺序（在旧 U-BOOT 的网页界面操作）：

1. http://192.168.1.1/uboot.html 刷 12M 大分区 U-BOOT；
2. http://192.168.1.1/img.html 刷 2G GPT 分区表；
3. http://192.168.1.1/ 刷固件 factory.bin；
4. 之后在系统内 Web 升级用 sysupgrade.bin。


# 固件简要说明


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
