import { promptAction } from '@kit.ArkUI'
import { NavigationBar } from '../components/NavigationBar'

@Styles function rowStyles() {
  .width('100%')
  .padding({ top: 24, right: 16, bottom: 10, left: 16 })
  .border({color: $r('app.color.border_color'), width: {bottom: 1}})
}

@Extend(TextInput) function inputStyle() {
  .layoutWeight(1)
  .fontSize($r('app.float.font_size_large'))
  .fontColor($r('app.color.text_color'))
  .backgroundColor('transparent')
}

@Entry
@Component
struct ForgetPassword {
  @State phone: string = ''
  @State security: string = ''
  @State password: string = ''
  @State password2: string = ''
  @State counter: number = 0
  timer: number = -1

  aboutToDisappear(): void {
    if(this.timer > -1) {
      clearInterval(this.timer)
    }
  }

  async getSecurityCode() {
    if(!this.phone) {
      return promptAction.showToast({message: '请输入手机号'})
    }
    this.counter = 60
    clearInterval(this.timer)
    this.timer = setInterval(() => {
      if(this.counter < 1) {
        clearInterval(this.timer)
      }
      this.counter -= 1
    }, 1000)
  }

  build() {
    Column() {
      NavigationBar({title: '忘记密码'})
      Column() {
        Row() {
          Image($r('app.media.icon_mobile'))
            .width(25)
            .height(25)
          TextInput({placeholder: '请输入手机号', text: $$this.phone})
            .inputStyle()
        }
        .rowStyles()

        Row() {
          Image($r('app.media.icon_security'))
            .width(25)
            .height(25)
          TextInput({placeholder: '请输入验证码', text: $$this.security})
            .inputStyle()
          Button({stateEffect: false}) {
            Row() {
              Text(this.counter > 0 ? `重新获取(${this.counter}S)` : `获取验证码`)
                .fontSize(13)
                .fontColor($r('app.color.color_primary'))
            }
          }
          .enabled(this.counter <= 0)
          .controlSize(ControlSize.SMALL)
          .backgroundColor(Color.Transparent)
          .onClick(() => this.getSecurityCode())
        }
        .rowStyles()

        Row() {
          Image($r('app.media.icon_lock'))
            .width(25)
            .height(25)
          TextInput({placeholder: '请输新入密码', text: $$this.password})
            .type(InputType.Password)
            .inputStyle()
        }
        .rowStyles()

        Row() {
          Image($r('app.media.icon_lock'))
            .width(25)
            .height(25)
          TextInput({placeholder: '请确认新密码', text: $$this.password2})
            .type(InputType.Password)
            .inputStyle()
        }
        .rowStyles()

        Button('确定修改', {type: ButtonType.Normal})
          .margin({top: 126})
          .backgroundColor($r('app.color.bg_primary'))
          .width('100%')
          .borderRadius(5)
          .onClick(async () => {
            promptAction.showToast({message: '点击了确定修改'})
          })
      }
      .width('100%')
      .height('100%')
      .padding({ right: 16, left: 16 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#fff')
  }
}