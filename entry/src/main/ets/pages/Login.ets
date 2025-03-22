import { NavigationBar } from '../components/NavigationBar'
import { promptAction, router } from '@kit.ArkUI'

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
struct Login {
  @State phone: string = ''
  @State password: string = ''

  build() {
    Column() {
      NavigationBar({title: '登录', hiddenBack: true})
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
          Image($r('app.media.icon_lock'))
            .width(25)
            .height(25)
          TextInput({placeholder: '请输入密码', text: $$this.password})
            .type(InputType.Password)
            .inputStyle()
        }
        .rowStyles()

        Row() {
          Text('立即注册')
            .fontSize($r('app.float.font_size'))
            .fontColor($r('app.color.text_color_light'))
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Register'
              })
            })
          Text('忘记密码')
            .fontSize($r('app.float.font_size'))
            .fontColor($r('app.color.text_color_light'))
            .onClick(() => {
              router.pushUrl({
                url: 'pages/ForgetPassword'
              })
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .padding({top: 26, bottom: 26})

        Button('立即登录', {type: ButtonType.Normal})
          .margin({top: 126})
          .backgroundColor($r('app.color.bg_primary'))
          .width('100%')
          .borderRadius(5)
          .onClick(async () => {
            // await setToken(token)
            router.pushUrl({
              url: 'pages/Index'
            })
          })
      }
      .width('100%')
      .height('100%')
      .padding({ right: 16, left: 16 })

      Column() {
        Column({space: 10}) {
          Image($r('app.media.login_wechat'))
            .width(55)
            .height(55)
          Text('微信登录')
            .fontSize($r('app.float.font_size'))
            .fontColor($r('app.color.text_color_lighter'))
        }
        .onClick(() => {
          promptAction.showToast({message: '点击了微信登录'})
        })
      }
      .width('100%')
      .position({bottom: 55})
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#fff')
  }
}