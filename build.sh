#!/bin/bash

# 打印提示信息。
# 例: PRINT "程序运行报错！" ERROR
PRINT(){
  RED='\033[1;31m'
  GREEN='\033[1;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[1;34m'
  PINK='\033[1;35m'
  NC='\033[0m'

  case "$2" in
    error|ERROR|red|RED)
      echo -e "${RED}$1${NC}" ;;
    warn|WARN|yellow|YELLOW)
      echo -e "${YELLOW}$1${NC}" ;;
    info|INFO|green|GREEN)
      echo -e "${GREEN}$1${NC}" ;;
    blue|BLUE)
      echo -e "${BLUE}$1${NC}" ;;
    pink|PINK)
      echo -e "${PINK}$1${NC}" ;;
    *)
      echo "$1"
  esac
}

PRINT_USAGE() {
  PRINT "Usage: ./build.sh [arguments] " WARN
  PRINT "  build: build TA mini program SDK"
  PRINT "  release: prepare release version of TA mini program SDK"
}

releaseMPMG()
{
  # 小程序 SDK 包名
  PACKAGE_MP="ta_mp_sdk"

  # 小游戏 SDK 包名
  PACKAGE_MG="ta_mg_sdk"

  if [ ! -d release/$PACKAGE_MP ]; then
    mkdir -p release/$PACKAGE_MP
    echo created folder release/$PACKAGE_MP
  fi

  cp assets/README.MP.md release/$PACKAGE_MP/README.md

  ################################
  PRINT "开始发布小程序 SDK" INFO
  ################################
  if [ ! -f build/tdanalytics.wx.js ]; then
    PRINT "警告: build/tdanalytics.wx.js 不存在, 跳过微信小程序..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.wx.js -c -m -o release/$PACKAGE_MP/tdanalytics.wx.min.js
    echo created release/$PACKAGE_MP/tdanalytics.wx.min.js
  fi

  if [ ! -f build/tdanalytics.swan.js ]; then
    PRINT "警告: build/tdanalytics.swan.js 不存在, 跳过百度小程序..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.swan.js -c -m -o release/$PACKAGE_MP/tdanalytics.swan.min.js
    echo created release/$PACKAGE_MP/tdanalytics.swan.min.js
  fi

  if [ ! -f build/tdanalytics.my.js ]; then
    PRINT "警告: build/tdanalytics.my.js 不存在, 跳过支付宝小程序..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.my.js -c -m -o release/$PACKAGE_MP/tdanalytics.my.min.js
    echo created release/$PACKAGE_MP/tdanalytics.my.min.js
  fi

  if [ ! -f build/tdanalytics.dd.js ]; then
    PRINT "警告: build/tdanalytics.dd.js 不存在, 跳过钉钉小程序..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.dd.js -c -m -o release/$PACKAGE_MP/tdanalytics.dd.min.js
    echo created release/$PACKAGE_MP/tdanalytics.dd.min.js
  fi

  if [ ! -f build/tdanalytics.tt.js ]; then
    PRINT "警告: build/tdanalytics.tt.js 不存在, 跳过字节跳动小程序..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.tt.js -c -m -o release/$PACKAGE_MP/tdanalytics.tt.min.js
    echo created release/$PACKAGE_MP/tdanalytics.tt.min.js
  fi

  if [ ! -f build/tdanalytics.ks.js ]; then
    PRINT "警告: build/tdanalytics.ks.js 不存在, 跳过快手小程序..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.ks.js -c -m -o release/$PACKAGE_MP/tdanalytics.ks.min.js
    echo created release/$PACKAGE_MP/tdanalytics.ks.min.js
  fi

  if [ ! -f build/tdanalytics.quick.js ]; then
    PRINT "警告: build/tdanalytics.quick.js 不存在, 跳过快应用..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.quick.js -c -m -o release/$PACKAGE_MP/tdanalytics.quick.min.js
    echo created release/$PACKAGE_MP/tdanalytics.quick.min.js
  fi

  if [ ! -f build/tdanalytics.qq.js ]; then
    PRINT "警告: build/tdanalytics.qq.js 不存在, 跳过QQ小程序..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.qq.js -c -m -o release/$PACKAGE_MP/tdanalytics.qq.min.js
    echo created release/$PACKAGE_MP/tdanalytics.qq.min.js
  fi

  if [ ! -f build/tdanalytics.jd.js ]; then
    PRINT "警告: build/tdanalytics.jd.js 不存在, 跳过京东小程序..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.jd.js -c -m -o release/$PACKAGE_MP/tdanalytics.jd.min.js
    echo created release/$PACKAGE_MP/tdanalytics.jd.min.js
  fi

  if [ ! -f build/tdanalytics.qh.js ]; then
    PRINT "警告: build/tdanalytics.qh.js 不存在, 跳过360小程序..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.qh.js -c -m -o release/$PACKAGE_MP/tdanalytics.qh.min.js
    echo created release/$PACKAGE_MP/tdanalytics.qh.min.js
  fi

  echo

  if [ ! -d release/$PACKAGE_MG ]; then
    mkdir -p release/$PACKAGE_MG
    echo created folder release/$PACKAGE_MG
  fi

  cp assets/README.MG.md release/$PACKAGE_MG/README.md

  ################################
  PRINT "开始发布小游戏 SDK" INFO
  ################################
  if [ ! -f build/tdanalytics.mg.wx.js ]; then
    PRINT "警告: build/tdanalytics.mg.wx.js 不存在, 跳过微信小游戏..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.mg.wx.js -c -m -o release/$PACKAGE_MG/tdanalytics.mg.wx.min.js
    echo created release/$PACKAGE_MG/tdanalytics.mg.wx.min.js
  fi

  if [ ! -f build/tdanalytics.mg.qq.js ]; then
    PRINT "警告: build/tdanalytics.mg.qq.js 不存在, 跳过 QQ 小游戏..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.mg.qq.js -c -m -o release/$PACKAGE_MG/tdanalytics.mg.qq.min.js
    echo created release/$PACKAGE_MG/tdanalytics.mg.qq.min.js
  fi

  if [ ! -f build/tdanalytics.mg.tt.js ]; then
    PRINT "警告: build/tdanalytics.mg.tt.js 不存在, 跳过字节跳动小游戏..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.mg.tt.js -c -m -o release/$PACKAGE_MG/tdanalytics.mg.tt.min.js
    echo created release/$PACKAGE_MG/tdanalytics.mg.tt.min.js
  fi

  if [ ! -f build/tdanalytics.mg.swan.js ]; then
    PRINT "警告: build/tdanalytics.mg.swan.js 不存在, 跳过百度小游戏..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.mg.swan.js -c -m -o release/$PACKAGE_MG/tdanalytics.mg.swan.min.js
    echo created release/$PACKAGE_MG/tdanalytics.mg.swan.min.js
  fi

  if [ ! -f build/tdanalytics.mg.bl.js ]; then
    PRINT "警告: build/tdanalytics.mg.bl.js 不存在, 跳过哔哩哔哩小游戏..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.mg.bl.js -c -m -o release/$PACKAGE_MG/tdanalytics.mg.bl.min.js
    echo created release/$PACKAGE_MG/tdanalytics.mg.bl.min.js
  fi
  echo

  ################################
  PRINT "开始发布快游戏 SDK" INFO
  ################################
  if [ ! -f build/tdanalytics.mg.oppo.js ]; then
    PRINT "警告: build/tdanalytics.mg.oppo.js 不存在, 跳过 OPPO 快游戏..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.mg.oppo.js -c -m -o release/$PACKAGE_MG/tdanalytics.mg.oppo.min.js
    echo created release/$PACKAGE_MG/tdanalytics.mg.qg.oppo.min.js
  fi

  if [ ! -f build/tdanalytics.mg.vivo.js ]; then
    PRINT "警告: build/tdanalytics.mg.vivo.js 不存在, 跳过 VIVO 快游戏..." WARN
  else
    ./node_modules/.bin/rollup -c --environment BUILD:COMPRESS,SRC:build/tdanalytics.mg.vivo.js,DST:release/$PACKAGE_MG/tdanalytics.mg.vivo.min.js
  fi

  if [ ! -f build/tdanalytics.mg.huawei.js ]; then
    PRINT "警告: build/tdanalytics.mg.huawei.js 不存在, 跳过华为快游戏..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.mg.huawei.js -c -m -o release/$PACKAGE_MG/tdanalytics.mg.huawei.min.js
    echo created release/$PACKAGE_MG/tdanalytics.mg.huawei.min.js
  fi

   if [ ! -f build/tdanalytics.mg.xiaomi.js ]; then
    PRINT "警告: build/tdanalytics.mg.xiaomi.js 不存在, 跳过小米快游戏..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.mg.xiaomi.js -c -m -o release/$PACKAGE_MG/tdanalytics.mg.xiaomi.min.js
    echo created release/$PACKAGE_MG/tdanalytics.mg.xiaomi.min.js
  fi



  if [ ! -f build/tdanalytics.mg.mz.js ]; then
    PRINT "警告: build/tdanalytics.mg.mz.js 不存在, 跳过魅族快游戏..." WARN
  else
    ./node_modules/.bin/uglifyjs build/tdanalytics.mg.mz.js -c -m -o release/$PACKAGE_MG/tdanalytics.mg.mz.min.js
    echo created release/$PACKAGE_MG/tdanalytics.mg.mz.min.js
  fi
  echo

  cd release
  pkgName="${PACKAGE_MP}_${npm_package_version}.zip"
  zip -q -r $PACKAGE_MP $PACKAGE_MP
  zip -q -r $pkgName $PACKAGE_MP
  echo created release/$pkgName

  if [ "$PACKAGE_MG" != "$PACKAGE_MP" ]; then
    pkgName="${PACKAGE_MG}_${npm_package_version}.zip"
    zip -q -r $PACKAGE_MG $PACKAGE_MG
    zip -q -r $pkgName $PACKAGE_MG
    echo created release/$pkgName
  fi
  cd ..
  echo
}

releaseLayaSDK()
{
  PACKAGE_LAYA="ta_laya_sdk"
  if [ ! -d release/$PACKAGE_LAYA ]; then
    mkdir -p release/$PACKAGE_LAYA
    echo created folder release/$PACKAGE_LAYA
  fi
  ./node_modules/.bin/rollup -c --environment BUILD:COMPRESS,SRC:build/tdanalytics.mg.laya.js,DST:release/$PACKAGE_LAYA/tdanalytics.mg.laya.min.js
  ./node_modules/.bin/rollup -c --environment BUILD:COMPRESS,SRC:build/tdanalytics.mg.layats.js,DST:release/$PACKAGE_LAYA/tdanalytics.mg.layats.min.js
  cp assets/ThinkingAnalyticsSDK.d.ts release/$PACKAGE_LAYA/
  cp assets/README.LAYA.md release/$PACKAGE_LAYA/README.md
  cp -rf src/native/laya/ios release/$PACKAGE_LAYA/
  cp -rf src/native/laya/android release/$PACKAGE_LAYA/
  cd release
  pkgName="${PACKAGE_LAYA}_${npm_package_version}.zip"
  zip -q -r $PACKAGE_LAYA $PACKAGE_LAYA
  zip -q -r $pkgName $PACKAGE_LAYA
  echo created release/$pkgName
  cd ..
}

releaseEgretSDK()
{
  PACKAGE_EGRET="ta_egret_sdk"
  if [ ! -d release/$PACKAGE_EGRET ]; then
    mkdir -p release/$PACKAGE_EGRET
    echo created folder release/$PACKAGE_EGRET
  fi
  cp assets/ThinkingAnalyticsSDK.d.ts release/$PACKAGE_EGRET/
  cp build/tdanalytics.mg.egret.js release/$PACKAGE_EGRET/ThinkingAnalyticsSDK.js
  ./node_modules/.bin/uglifyjs build/tdanalytics.mg.egret.js -c -m -o release/$PACKAGE_EGRET/ThinkingAnalyticsSDK.min.js
  cp assets/README.EGRET.md release/$PACKAGE_EGRET/README.md
  cp -rf src/native/egret/ios release/$PACKAGE_EGRET/
  cp -rf src/native/egret/android release/$PACKAGE_EGRET/
  cd release
  pkgName="${PACKAGE_EGRET}_${npm_package_version}.zip"
  zip -q -r $PACKAGE_EGRET $PACKAGE_EGRET
  zip -q -r $pkgName $PACKAGE_EGRET
  echo created release/$pkgName
  cd ..
}

releaseCocosCreatorSDK()
{
  PACKAGE_COCOS="ta_cocoscreator_sdk"
  if [ ! -d release/$PACKAGE_COCOS ]; then
    mkdir -p release/$PACKAGE_COCOS
    echo created folder release/$PACKAGE_COCOS
  fi
  ./node_modules/.bin/uglifyjs build/tdanalytics.mg.cocoscreator.js -c -m -o release/$PACKAGE_COCOS/tdanalytics.mg.cocoscreator.min.js
  cp assets/ThinkingAnalyticsSDK.d.ts release/$PACKAGE_COCOS/
  cp assets/README.CC.md release/$PACKAGE_COCOS/README.md
  cp -rf src/native/cc/ios release/$PACKAGE_COCOS/
  cp -rf src/native/cc/android release/$PACKAGE_COCOS/
  cd release
  pkgName="${PACKAGE_COCOS}_${npm_package_version}.zip"
  zip -q -r $PACKAGE_COCOS $PACKAGE_COCOS
  zip -q -r $pkgName $PACKAGE_COCOS
  echo created release/$pkgName
  cd ..
}

runLint() {
  PRINT "开始检查源代码" INFO
  npm run lint;
  PRINT "源代码检查完毕" INFO
  echo
}

release() {
  PRINT "开始发布小程序、小游戏 SDK" INFO
  releaseMPMG
  PRINT "小程序、小游戏 SDK 发布完成" INFO
  echo

  PRINT "开始发布 LAYA SDK" INFO
  releaseLayaSDK
  PRINT "LAYA SDK 发布完成" INFO
  echo

  PRINT "开始发布 EGRET SDK" INFO
  releaseEgretSDK
  PRINT "EGRET SDK 发布完成" INFO
  echo

  PRINT "开始发布 COCOS CREATOR SDK" INFO
  releaseCocosCreatorSDK
  PRINT "COCOS CREATOR SDK 发布完成" INFO
  echo

  PRINT "发布完毕" INFO
  echo
}

if [ ! -d build ]; then
  mkdir build
fi

if [ -z "$1" ]; then
  runLint
  PRINT "开始打包全部平台" INFO
  ./node_modules/.bin/rollup -c

  release
elif [ "$1" == "build" ]; then
  runLint
  PRINT "TA SDK 目前支持以下目标平台选项:"
  echo

  PRINT "小程序" PINK
  echo "[P1] 微信小程序"
  echo "[P2] 百度小程序"
  echo "[P3] 支付宝小程序"
  echo "[P4] 钉钉小程序"
  echo "[P5] 字节跳动小程序"
  echo "[P6] 快手小程序"
  echo "[P9] 快应用"
  echo "[P10] QQ小程序"
  echo "[P11] 京东小程序"
  echo "[P12] 360小程序"
  echo

  PRINT "小游戏" PINK
  echo "[G1] 微信小游戏"
  echo "[G2] QQ 小游戏"
  echo "[G3] 字节跳动小游戏"
  echo "[G4] 百度小游戏"
  echo "[G5] 哔哩哔哩小游戏"
  echo

  PRINT "快游戏" PINK
  echo "[Q1] OPPO 快游戏"
  echo "[Q2] VIVO 快游戏"
  echo "[Q3] 华为快游戏"
  echo "[Q4] 小米快游戏"
  echo "[Q5] 魅族快游戏"
  echo

  PRINT "游戏引擎" PINK
  echo "[E1] Laya"
  echo "[E2] Egret"
  echo "[E3] CocosCreator"
  echo

  PRINT "WEB（用于功能测试）" PINK
  echo "[W] WEB（用于功能测试）"
  echo

  PRINT "输入您需要打包的平台编号(全部打包请按回车键):"

  read option

  echo
  case "$option" in
    P1)
      PRINT "开始打包微信小程序 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:WECHAT_MP
      ;;
    P2)
      PRINT "开始打包百度小程序 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:BAIDU_MP
      ;;
    P3)
      PRINT "开始打包支付宝小程序 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:ALIPAY_MP
      ;;
    P4)
      PRINT "开始打包钉钉小程序 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:DINGDING_MP
      ;;
    P5)
      PRINT "开始打包字节跳动小程序 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:TOUTIAO_MP
      ;;
    P6)
      PRINT "开始打包快手小程序 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:KUAISHOU_MP
      ;;
    P9)
      PRINT "开始打包快应用 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:QUICK_APP
      ;;
    P10)
      PRINT "开始打包QQ小程序 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:QQ_MP
      ;;
    P11)
      PRINT "开始打包京东小程序 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:JD_MP
      ;;
    P12)
      PRINT "开始打包360小程序 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:QH_MP
      ;;
    G1)
      PRINT "开始打包微信小游戏 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:WECHAT_MG
      ;;
    G2)
      PRINT "开始打包 QQ 小游戏 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:QQ_MG
      ;;
    G3)
      PRINT "开始打包字节跳动小游戏 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:TOUTIAO_MG
      ;;
    G4)
      PRINT "开始打包百度小游戏 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:BAIDU_MG
      ;;
    G5)
      PRINT "开始打包哔哩哔哩小游戏 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:BILIBILI_MG
      ;;
    Q1)
      PRINT "开始打包 OPPO 小游戏 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:OPPO_MG
      ;;
    Q2)
      PRINT "开始打包 VIVO 小游戏 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:VIVO_MG
      ;;
    Q3)
      PRINT "开始华为快游戏SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:HUAWEI_MG
      ;;
    Q4)
      PRINT "开始打包小米快游戏SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:XIAOMI_MG
      ;;
    Q5)
      PRINT "开始打包魅族快游戏SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:MZ_MG
      ;;
    E1)
      PRINT "开始打包 LAYA 小游戏 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:LAYA_MG
      ;;
    E2)
      PRINT "开始打包 EGRET 小游戏 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:EGRET_MG
      releaseEgretSDK
      ;;
    E3)
      PRINT "开始打包 Cocos Creator 小游戏 SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:COCOSCREATOR_MG
      ;;
    W)
      PRINT "开始打包 WEB SDK" INFO
      ./node_modules/.bin/rollup -c --environment BUILD:WEB
      ;;
    *)
      if [ -z "$option" ]; then
        PRINT "开始打包全部平台" INFO
        ./node_modules/.bin/rollup -c
        echo
        PRINT "打包任务完成! 如需发布最终版本可执行 npm run release" INFO
        echo
      else
        PRINT "错误: 未知平台选项: [$option] !!!" ERROR
      fi
      ;;
  esac
elif [ "$1" == "release" ]; then
  release
else
  PRINT_USAGE
fi

