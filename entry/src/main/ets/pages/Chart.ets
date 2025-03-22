import { NavigationBar } from '../components/NavigationBar'

@Entry
@Component
struct Chart {
  build() {
    Column() {
      NavigationBar({title: '图表'})
    }
    .height('100%')
    .width('100%')
  }
}