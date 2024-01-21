/**
 * 自定义组件:标题
 */
import router from '@ohos.router'
@Component
export struct Header {  //export导出
  private title: ResourceStr   //相当于String
  @State params: any = router.getParams()  //params对象类型不确定，只能用any接收
  build() {
    Row() {
      Image($r('app.media.ic_public_back'))  //返回按钮
        .width(30)
        .onClick(() => {
          //返回前弹窗警告
          router.showAlertBeforeBackPage({
            message: '确定要返回吗？'
          })
          router.back()  //返回上一页
        })
      if (this.params && this.title) {
        Text(this.params.id + '.' + this.title)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
      }
      Blank()    //空白占位组件
      Image($r('app.media.ic_public_refresh'))
        .width(30)
    }
    .width('100%')
    .height(30)
  }
}