import { NavigationBar } from '../components/NavigationBar'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct IntegralPage {
  @State integral: number = 0
  @State is_sign: boolean = false

  build() {
    Column() {
      NavigationBar({title: '积分'})
      Column() {
        Text('我的积分')
          .margin({top: 20})
          .fontSize($r('app.float.font_size'))
          .fontColor('#fff')
        Text(`${this.integral}`)
          .margin({top: 40})
          .fontSize(37)
          .fontColor('#fff')
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height(145)
      .padding({right: 15, left: 15})
      .alignItems(HorizontalAlign.Start)
      .backgroundColor($r('app.color.bg_primary'))
      Row() {
        Button(this.is_sign ? '已签到' : '签到', {type: ButtonType.Normal})
          .controlSize(ControlSize.SMALL)
          .width(62)
          .backgroundColor('transparent')
          .border({color: '#fff', width: 1})
          .borderRadius(5)
          .fontSize(14)
          .onClick(() => {
            if(this.is_sign) {
              return promptAction.showToast({message: '您今天已签到！'})
            }
            this.integral += 1
            this.is_sign = true
            AppStorage.setOrCreate('integral', this.integral)
            promptAction.showToast({message: '签到成功'})
          })
      }
      .width('100%')
      .height(40)
      .padding({right: 15, left: 15})
      .justifyContent(FlexAlign.End)
      .backgroundColor('#48b236')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.bg_color_page'))
  }
}