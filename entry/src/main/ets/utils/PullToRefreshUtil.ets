// https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fpulltorefresh  下拉刷新 文档
import {PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh'

const refreshConfigurator: PullToRefreshConfigurator = new PullToRefreshConfigurator()

refreshConfigurator
  .setRefreshTextSize(14)// 下拉文本的字体大小
  .setRefreshColor('#45B934')// 下拉动画颜色
  .setLoadTextSize(14)// 上拉文本的字体大小

export {
  PullToRefresh,
  refreshConfigurator
}