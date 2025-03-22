import { NavigationBar } from '../components/NavigationBar'
import { promptAction, router } from '@kit.ArkUI'

@Extend(Row) function rowStyle() {
  .width('100%')
  .height(66)
  .padding({right: 10, left: 10})
  .border({width: {bottom: 1}, color: $r('app.color.border_color_light')})
}

@Extend(Text) function textStyle() {
  .fontSize($r('app.float.font_size_large'))
  .fontColor($r('app.color.text_color'))
}

@Entry
@Component
struct Settings {
  build() {
    Column() {
      NavigationBar({title: '设置'})
      Column() {
        Row() {
          Text('检查更新')
            .textStyle()
        }
        .rowStyle()
        .onClick(() => {
          promptAction.showToast({message: '点击了检查更新'})
        })

        Row() {
          Text('退出登录')
            .textStyle()
        }
        .rowStyle()
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Login'
          })
        })
      }
      .width('100%')
      .padding({right: 16, left: 16})
      .backgroundColor('#fff')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}