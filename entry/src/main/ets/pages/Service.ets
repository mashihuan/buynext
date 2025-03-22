import { NavigationBar } from '../components/NavigationBar'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct Service {
  build() {
    Column() {
      NavigationBar({title: '联系客服'})
      Row() {
        Column({space: 16}) {
          Image($r('app.media.service_qq'))
            .width(93)
            .height(99)
          Text('客服QQ')
            .fontSize($r('app.float.font_size'))
            .fontColor($r('app.color.text_color'))
        }
        .width('50%')
        .onClick(() => {
          promptAction.showToast({message: '点击了客服QQ'})
        })

        Column({space: 16}) {
          Image($r('app.media.service_phone'))
            .width(93)
            .height(99)
          Text('客服电话')
            .fontSize($r('app.float.font_size'))
            .fontColor($r('app.color.text_color'))
        }
        .width('50%')
        .onClick(() => {
          promptAction.showToast({message: '点击了客服电话'})
        })
      }
      .width('100%')
      .margin({top: 80})
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}