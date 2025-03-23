import { requestBannerList } from "../../api/Banner"
import { BASE_URL } from "../../common/Config"
import { BannerItem } from "../../viewmodel/BannerModel"
import { router } from "@kit.ArkUI"

@Component
export struct HomeBanner {
  @State bannerList: BannerItem[] = []

  aboutToAppear(): void {
    this.getBannerList()
  }

  async getBannerList() {
    const res = await requestBannerList<BannerItem[], null>()
    this.bannerList = res.data.banners || []
  }

  build() {
    Swiper() {
      ForEach(this.bannerList, (banner: BannerItem) => {
        Image(BASE_URL + banner.url)
          .width('100%')
          .height('100%')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/GoodsDetail',
              params: {goods_id: banner.goods_id}
            })
          })
      }, (banner: BannerItem) => banner.id+'')
    }
    .indicator(new DotIndicator().selectedColor($r('app.color.color_primary')))
    .width('100%')
    .height(165)
    .padding({right: 15, left: 15})
  }
}