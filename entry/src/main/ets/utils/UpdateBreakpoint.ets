import { window, display } from "@kit.ArkUI";
import { Constants } from "../common/Constants";

// 根据当前窗口尺寸更新断点
export function updateBreakpoint(windowObj: window.Window, windowWidth: number) {
  // 拿到当前窗口对象获取当前所在displayId
  let displayId = windowObj?.getWindowProperties().displayId
  try {
    // 将长度的单位由px换算为vp
    let windowWidthVp = windowWidth / display.getDisplayByIdSync(displayId).densityPixels
    let newBp: string = ''
    if (windowWidthVp < 320) {
      newBp = 'xs'
    } else if (windowWidthVp < 600) {
      newBp = 'sm'
    } else if (windowWidthVp < 840) {
      newBp = 'md'
    } else {
      newBp = 'lg'
    }

    const currentBreakpoint: string | undefined = AppStorage.get(Constants.CURRENT_BREAKPOINT)

    if (!currentBreakpoint || currentBreakpoint !== newBp) {
      // 使用状态变量记录当前断点值
      AppStorage.setOrCreate(Constants.CURRENT_BREAKPOINT, newBp)
    }
  } catch(err) {
    console.log("getDisplayByIdSync failed err"+err.code)
  }
}