
//对象类型
class Person {
  name: string
  age: number
  gf: Person   //嵌套

  constructor(name: string, age: number, gf?: Person) {
    this.name = name
    this.age = age
    this.gf = gf
  }
}

@Entry
@Component
struct StatePage2 {
  idx: number = 1
  @State p: Person = new Person('Jack', 21, new Person('Rose', 23))    //@State对象类型可更新，但对象嵌套不可
  //@State数组可更新，但数组中的元素为对象时，对象内的元素变更不会触发重新渲染
  @State gfs: Person[] = [
    new Person('Rose', 18),
    new Person('Lucy', 19)
  ]

  build() {  //build()中写页面样式
    Row() {
      Column() {
        Text(`${this.p.name} : ${this.p.age}`)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#FFD')
          .onClick(() => {
            this.p.age ++
          })

        Text(`${this.p.gf.name} : ${this.p.gf.age}`)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.p.gf.age ++
          })

        Button('添加')
          .onClick(() => {
            this.gfs.push(new Person('女友' + this.idx++, 26))  //push为向数组中添加一个元素
          })

        Text('== gf list ==')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        ForEach(
          this.gfs,
          (p: Person, index?: number) => {
            Row() {
              Text(`${p.name} : ${p.age}`)  //数组中传进来的item p
                .fontSize(30)
                .onClick(() => {
                  // p.age ++   //数组中的元素为对象时，对象内的元素变更不会触发重新渲染
                  this.gfs[index] = new Person(p.name, p.age+1)  //但数组内对象重新赋值可以触发重新渲染
                })
              Button('删除')
                .onClick(() => {
                  this.gfs.splice(index, 1)  //splice为删除，index为从哪个下标开始删，count=1表示删除一个元素
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)
          }
        )
      }
      .width('100%')   //Column():列(纵向排列)占比100%，表示列全部填充父控件
    }
    // .height('100%')  //Row():行(横向排列)占比100%，表示表示行全部填充父控件
  }
}

// @Entry
@Component
struct StatePage {
  //声明式UI:状态驱动页面刷新
  //基本类型
  @State name: string = 'Jack'  //@State会同步修改的值渲染到页面
  @State age: number = 21


  build() {  //build()中写页面样式
    Row() {
      Column() {
        Text(`${this.name} : ${this.age}`)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.age ++
          })
      }
      .width('100%')   //Column():列(纵向排列)占比100%，表示列全部填充父控件
    }
    .height('100%')  //Row():行(横向排列)占比100%，表示表示行全部填充父控件
  }
}