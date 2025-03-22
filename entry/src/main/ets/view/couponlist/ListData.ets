import { Empty } from "../../components/Empty";
import { ICallback } from "../../utils/Types";
import {PullToRefresh, refreshConfigurator } from '../../utils/PullToRefreshUtil';
import { CouponItem } from "../../viewmodel/CouponModel";

@Component
export struct CouponListData {
  @Prop couponList: CouponItem[] = []
  getOrderList: (callback: ICallback) => void = () => {}
  private scroller: Scroller = new Scroller()

  @Builder getListView() {
    Scroll(this.scroller) {
      Column() {
        if(this.couponList.length) {
          Column() {
            ForEach(this.couponList, (coupon: CouponItem) => {
              Column({space: 10}) {
                Text(coupon.name)
              }
              .width('100%')
              .backgroundColor('#fff')
              .padding(15)
              .margin({top: 10})
            }, (coupon: CouponItem) => `${coupon.id}`)
          }
        }else {
          Empty({desc: '暂无此类优惠券...'})
        }
      }
    }
  }

  build() {
    Column() {
      PullToRefresh({
        // 必传项，列表组件所绑定的数据
        data: $couponList,
        // 必传项，需绑定传入主体布局内的列表或宫格组件
        scroller: this.scroller,
        // 必传项，自定义主体布局，内部有列表或宫格组件
        refreshConfigurator: refreshConfigurator,
        customList: () => {
          // 一个用@Builder修饰过的UI方法
          this.getListView();
        },
        // 可选项，下拉刷新回调
        onRefresh: () => {
          return new Promise<string>((resolve) => {
            // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
            console.log('下拉刷新')
            this.getOrderList(() => {})
            resolve('刷新成功');
          });
        },
        // 可选项，上拉加载更多回调
        onLoadMore: () => {
          return new Promise<string>((resolve) => {
            // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
            setTimeout(() => {
              console.log('上拉加载')
              resolve('上拉加载');
            }, 2000)
          });
        },
        customLoad: null,
        customRefresh: null,
      })
    }
    .width('100%')
    .height('100%')
    .padding({bottom: 44})
  }
}