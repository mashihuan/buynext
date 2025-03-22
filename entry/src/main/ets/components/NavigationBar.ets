import { router } from '@kit.ArkUI'

@Styles function iconWrapperStyle() {
  .width(32)
  .height(32)
  .margin({ left: 2, right: 2 })
}

@Extend(Circle) function circleStyle() {
  .width('100%')
  .height('100%')
  .fill('#000')
  .fillOpacity(0.4)
}

@Extend(Image) function imageStyle() {
  .width(22)
  .height(22)
}

@Extend(Text) function textStyle(contentColor: ResourceStr) {
  .fontColor(contentColor || '#fff')
  .fontSize(14)
}

@Builder function defaultSlot() {

}

@Component
export struct NavigationBar {
  hiddenBack: boolean = false
  title: ResourceStr = ''
  bgColor: ResourceStr = ''
  contentColor: ResourceStr = ''
  bordered: boolean = false
  leftIcon: ResourceStr = ''
  leftText: ResourceStr = ''
  rightIcon: ResourceStr = ''
  rightText: ResourceStr = ''
  clickLeft: () => void = () => {}
  clickTitle: () => void = () => {}
  clickRight: () => void = () => {}
  @BuilderParam default: () => void = defaultSlot

  build() {
    Column() {
      Row() {
        Row() {
          if (!this.hiddenBack) {
            Button({ type: ButtonType.Circle }) {
              Image($r('app.media.arrow_left'))
                .width(27)
                .height(27)
            }
            .iconWrapperStyle()
            .backgroundColor('transparent')
            .onClick(() => router.back())
          }

          Stack() {
            if (this.leftIcon) {
              Stack() {
                Circle()
                  .circleStyle()
                Image(this.leftIcon)
                  .imageStyle()
              }
              .iconWrapperStyle()
            } else {
              if (this.leftText) {
                Text(this.leftText)
                  .iconWrapperStyle()
                  .textStyle(this.contentColor)
              }
            }
          }
          .onClick(() => this.clickLeft && this.clickLeft())
        }
        .width(70)

        if (this.title) {
          Text(this.title)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.contentColor || '#fff')
            .onClick(() => this.clickTitle && this.clickTitle())
        }else {
          this.default()
        }

        Row() {
          Stack() {
            if (this.rightIcon) {
              Stack() {
                Circle()
                  .circleStyle()
                Image(this.rightIcon)
                  .imageStyle()
              }
              .iconWrapperStyle()
            } else {
              if (this.rightText) {
                Text(this.rightText)
                  .iconWrapperStyle()
                  .textStyle(this.contentColor)
              }
            }
          }
          .onClick(() => this.clickRight && this.clickRight())
        }
        .width(70)
        .justifyContent(FlexAlign.End)
      }
      .width('100%')
      .height($r('app.float.navigation_bar_height'))
      .padding({ left: 3, right: 3 })
      .border({ width: { bottom: this.bordered ? 0.5 : 0 }, style: BorderStyle.Solid, color: '#eee' })
    }
    .width('100%')
    .backgroundColor(this.bgColor || $r('app.color.bg_primary'))
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}