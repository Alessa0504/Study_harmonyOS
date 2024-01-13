/**
 * 自定义组件:标题
 */
@Component
export struct Header {  //export导出
  private title: ResourceStr   //相当于String
  build() {
    Row() {
      Image($r('app.media.ic_public_back'))
        .width(30)
      Text(this.title)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Blank()    //空白占位组件
      Image($r('app.media.ic_public_refresh'))
        .width(30)
    }
    .width('100%')
    .height(30)
  }
}