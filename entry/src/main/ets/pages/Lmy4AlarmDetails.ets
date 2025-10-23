import router from '@ohos.router'

@Entry
@Component
struct AddAlarm {
  @State selectedHour: number = 12;
  @State selectedMinute: number = 45;
  @State selectedDays: string[] = ['周一', '周三', '周五', '周六'];
  
  // 生成小时数组 (0-23)
  private hours: string[] = Array.from<number, string>({ length: 24 }, (_: number, i: number): string => i.toString().padStart(2, '0'));
  // 生成分钟数组 (0-59)
  private minutes: string[] = Array.from<number, string>({ length: 60 }, (_: number, i: number): string => i.toString().padStart(2, '0'));

  build() {
    Column() {
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
          // 返回到闹钟提醒页面
          router.back()
        })

        Blank()

        // 标题
        Text('新增闹钟')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .textAlign(TextAlign.Center)

        Blank()

        // 保存按钮
        Text('保存')
          .fontSize(16)
          .fontColor('#5B9EFF')
          .onClick(() => {
            // 保存闹钟并返回
            console.info(`保存闹钟: ${this.selectedHour}:${this.selectedMinute}`);
            router.back()
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          // 时间标签
          Row() {
            Text('时间')
              .fontSize(14)
              .fontColor('#999999')

            Blank()

            Text(`${this.selectedHour.toString().padStart(2, '0')}:${this.selectedMinute.toString().padStart(2, '0')}`)
              .fontSize(14)
              .fontColor('#5B9EFF')

            Image($r('sys.symbol.chevron_right'))
              .width(16)
              .height(16)
              .fillColor('#CCCCCC')
              .margin({ left: 5 })
          }
          .width('90%')
          .padding({ top: 20, bottom: 10 })
          .margin({ left: '5%' })

          // 时间选择器区域
          Column() {
            Row() {
              // 小时选择器
              Column() {
                TextPicker({
                  range: this.hours,
                  selected: this.selectedHour
                })
                  .onChange((value: string | string[], index: number | number[]) => {
                    this.selectedHour = index as number;
                    console.info(`选择小时: ${value}`);
                  })
                  .defaultPickerItemHeight(50)
              }
              .layoutWeight(1)

              // 分钟选择器
              Column() {
                TextPicker({
                  range: this.minutes,
                  selected: this.selectedMinute
                })
                  .onChange((value: string | string[], index: number | number[]) => {
                    this.selectedMinute = index as number;
                    console.info(`选择分钟: ${value}`);
                  })
                  .defaultPickerItemHeight(50)
              }
              .layoutWeight(1)
            }
            .width('100%')
            .height(200)
          }
          .width('100%')
          .padding({ top: 10, bottom: 20 })

          // 分隔线
          Divider()
            .width('90%')
            .height(1)
            .color('#F0F0F0')
            .margin({ left: '5%' })

          // 重复选项
          Row() {
            Text('重复')
              .fontSize(14)
              .fontColor('#999999')

            Blank()

            Text(this.selectedDays.join('、'))
              .fontSize(14)
              .fontColor('#5B9EFF')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)
              .textAlign(TextAlign.End)
              .margin({ right: 5 })

            Image($r('sys.symbol.chevron_right'))
              .width(16)
              .height(16)
              .fillColor('#CCCCCC')
          }
          .width('90%')
          .padding({ top: 20, bottom: 20 })
          .margin({ left: '5%' })
          .onClick(() => {
            // 打开重复设置页面
            console.info('打开重复设置');
          })

          // 分隔线
          Divider()
            .width('90%')
            .height(1)
            .color('#F0F0F0')
            .margin({ left: '5%' })
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

