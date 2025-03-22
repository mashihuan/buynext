import { NavigationBar } from '../components/NavigationBar'

@Entry
@Component
struct SearchPage {
  build() {
    Column() {
      NavigationBar() {
        TextInput({placeholder: '请输入'})
          .layoutWeight(1)
          .height(30)
          .margin({left: -30, right: -30})
          .defaultFocus(true)
          .fontSize(14)
          .placeholderFont({size: 14})
          .backgroundColor('#fff')
      }
    }
    .height('100%')
    .width('100%')
  }
}