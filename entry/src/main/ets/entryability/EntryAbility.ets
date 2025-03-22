import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { updateBreakpoint } from '../utils/UpdateBreakpoint';
import { dataPreferences } from '../utils/DataPreferences';
import { kvStore } from '../utils/KvStore';
import { rdbStore } from '../utils/RdbStore';
import { CartModel, GoodsModel, AddressModel, OrderModel, OrderGoodsModel } from '../viewmodel/Index'

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  listenWindowSizeChange(windowStage: window.WindowStage) {
    windowStage.getMainWindow().then((windowObj) => {
      // 获取应用启动时的窗口尺寸
      updateBreakpoint(windowObj, windowObj.getWindowProperties().windowRect.width)
      // 注册回调函数，监听窗口尺寸变化
      windowObj.on('windowSizeChange', (windowSize)=>{
        updateBreakpoint(windowObj, windowSize.width)
      })
    })
  }

  async initStore() {
    // 获取首选项实例
    dataPreferences.getPreferencesSync(this.context)
    // 获取键值数据库
    kvStore.createKVManager(this.context, this.context.abilityInfo.bundleName)
    // 获取关系型数据库
    await rdbStore.getRdbStore(this.context)
    await rdbStore.getTable(CartModel.sqlCreateTable)
    await rdbStore.getTable(GoodsModel.sqlCreateTable)
    await rdbStore.getTable(AddressModel.sqlCreateTable)
    await rdbStore.getTable(OrderModel.sqlCreateTable)
    await rdbStore.getTable(OrderGoodsModel.sqlCreateTable)
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    this.initStore()

    windowStage.getMainWindow().then((windowClass) => {
      // 获取应用启动时的窗口尺寸
      updateBreakpoint(windowClass, windowClass.getWindowProperties().windowRect.width)
      // 注册回调函数，监听窗口尺寸变化
      windowClass.on('windowSizeChange', (windowSize)=>{
        updateBreakpoint(windowClass, windowSize.width)
      })
      // 设置导航栏
      windowClass.setWindowSystemBarProperties({
        statusBarColor: '#45B934', // 状态栏背景颜色
        statusBarContentColor: '#ffffff', // 状态栏文字颜色
        navigationBarColor: '#ffffff' // 导航栏背景颜色
      })
      // 缓存window对象
      AppStorage.setOrCreate('windowClass', windowClass);
      // 缓存状态栏高度
      const avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      AppStorage.setOrCreate('statusBarHeight', avoidArea.topRect.height)
    })

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}