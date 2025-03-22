import { NavigationBar } from '../components/NavigationBar'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct PaySuccess {
  title: string = '支付成功'

  build() {
    Column() {
      NavigationBar({title: this.title})
      Column() {
        Column({space: 10}) {
          Image($r('app.media.round_close'))
            .width(100)
            .height(100)
            .fillColor('#f00')
          Text(this.title)
            .fontSize($r('app.float.font_size_large'))
            .fontColor($r('app.color.text_color'))
        }
        .width('100%')
        Button('确定', {type: ButtonType.Normal})
          .width('100%')
          .margin({top: 100})
          .borderRadius(5)
          .backgroundColor($r('app.color.color_primary'))
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/OrderList',
              params: {
                index: 0
              }
            })
          })
      }
      .width('100%')
      .padding({ top: 75, right: 50, bottom: 0, left: 50 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}