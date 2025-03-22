import { NavigationBar } from '../components/NavigationBar'

@Entry
@Component
struct HuaweiMapDemo {
  build() {
    Column() {
      NavigationBar({title: '地图服务'})
    }
    .width('100%')
    .height('100%')
  }
}