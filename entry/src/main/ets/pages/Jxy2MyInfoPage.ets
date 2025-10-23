import router from '@ohos.router'

@Entry
@Component
struct MyInfoPage {
  @State nickname: string = ''
  @State gender: string = '' // 存储选中的性别，'male'或'female'
  @State birthYear: number = 1991
  @State birthMonth: number = 4
  @State birthDay: number = 20

  build() {
    Column({ space: 20 }) {
      // 顶部导航栏
      Row() {
        // 返回按钮
        Row() {
          Image($r('app.media.return'))
            .width(20)
            .height(20)
            .objectFit(ImageFit.Contain)
        }
        .width(40)
        .height(40)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          router.back()
        })

        Blank()

        Text('我的信息')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)

        Blank()

        // 右侧占位，保持标题居中
        Text('')
          .width(40)
      }
      .width('100%')
      .height(56)
      .padding({ left: 10, right: 10 })
      .alignItems(VerticalAlign.Center)
      
      // 说明文字
      Text('精确的信息可以获取更准确的数据分析')
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: -10 })

      // 昵称输入
      Column({ space: 5 }) {
        Text('昵称')
          .fontSize(16)
          .width('100%')
          .padding({ left: 10 })
        TextInput({ placeholder: '输入昵称' })
          .width('100%')
          .height(40)
          .backgroundColor('#f5f5f5')
          .borderRadius(8)
          .padding({ left: 10 })
          .onChange((value: string) => {
            this.nickname = value
          })
      }
      .width('90%')

      // 性别选择（带图片）
      Column({ space: 5 }) {
        Text('性别')
          .fontSize(16)
          .width('100%')
          .padding({ left: 10 })
        Row({ space: 10 }) {
          // 男性按钮（带nan.png）
          Button({ type: ButtonType.Normal, stateEffect: true }) {
            Row({ space: 8 }) {
              Image($r('app.media.nan')) // 引用男性图片（确保nan.png在media目录）
                .width(20)
                .height(20)
                .objectFit(ImageFit.Contain)
              Text('男')
                .fontSize(16)
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
          }
          .width('45%')
          .height(40)
          .backgroundColor(this.gender === 'male' ? '#fff' : '#f5f5f5')
          .borderRadius(8)
          .border({ width: 1, color: this.gender === 'male' ? '#007AFF' : '#ddd' })
          .onClick(() => {
            this.gender = 'male'
          })

          // 女性按钮（带nv.png）
          Button({ type: ButtonType.Normal, stateEffect: true }) {
            Row({ space: 8 }) {
              Image($r('app.media.nv')) // 引用女性图片（确保nv.png在media目录）
                .width(20)
                .height(20)
                .objectFit(ImageFit.Contain)
              Text('女')
                .fontSize(16)
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
          }
          .width('45%')
          .height(40)
          .backgroundColor(this.gender === 'female' ? '#fff' : '#f5f5f5')
          .borderRadius(8)
          .border({ width: 1, color: this.gender === 'female' ? '#007AFF' : '#ddd' })
          .onClick(() => {
            this.gender = 'female'
          })
        }
        .width('100%')
      }
      .width('90%')

      // 年龄选择（日期选择器）
      Column({ space: 5 }) {
        Text('年龄')
          .fontSize(16)
          .width('100%')
          .padding({ left: 10 })
        DatePicker({
          start: new Date('1900-01-01'),
          end: new Date(),
          selected: new Date(`${this.birthYear}-${this.birthMonth}-${this.birthDay}`)
        })
          .width('100%')
          .onChange((value: DatePickerResult) => {
            this.birthYear = value.year || 1991
            this.birthMonth = value.month || 4
            this.birthDay = value.day || 20
          })
      }
      .width('90%')

      // 保存按钮
      Button('保存')
        .width('90%')
        .height(45)
        .backgroundColor('#007AFF')
        .fontColor('#fff')
        .borderRadius(8)
        .margin({ top: 40, bottom: 30 })
        .onClick(() => {
          // 保存并返回
          console.info(`保存信息：昵称=${this.nickname}，性别=${this.gender || '未选择'}，生日=${this.birthYear}-${this.birthMonth}-${this.birthDay}`)
          router.back()
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
    .padding({ left: 20, right: 20 })
  }
}