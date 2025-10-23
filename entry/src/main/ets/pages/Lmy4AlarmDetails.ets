import router from '@ohos.router'
import http from '@ohos.net.http';

@Entry
@Component
struct AddAlarm {
  @State selectedHour: number = 7;
  @State selectedMinute: number = 0;
  @State selectedDays: boolean[] = [false, false, false, false, false, false, false]; // 周一到周日
  
  // 生成小时数组 (0-23)
  private hours: string[] = Array.from<number, string>({ length: 24 }, (_: number, i: number): string => i.toString().padStart(2, '0'));
  // 生成分钟数组 (0-59)
  private minutes: string[] = Array.from<number, string>({ length: 60 }, (_: number, i: number): string => i.toString().padStart(2, '0'));
  private dayNames: string[] = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

  // 获取选中的日期字符串
  getSelectedDaysString(): string {
    const selected: string[] = [];
    this.selectedDays.forEach((isSelected: boolean, index: number) => {
      if (isSelected) {
        selected.push(this.dayNames[index]);
      }
    });
    return selected.length > 0 ? selected.join('  ') : '不重复';
  }

  // 创建闹钟
  async createAlarm() {
    const time = `${this.selectedHour.toString().padStart(2, '0')}:${this.selectedMinute.toString().padStart(2, '0')}`;
    const days = this.getSelectedDaysString();

    let httpRequest = http.createHttp();
    try {
      let response = await httpRequest.request(
        'https://api.leancloud.cn/1.1/classes/alarm',
        {
          method: http.RequestMethod.POST,
          header: {
            'X-LC-Id': 'Lk7Ea17CoVWpjbDiMn2Ajc0t-gzGzoHsz',
            'X-LC-Key': 'VDfOAfC5exDYv5PUJWJTBKzS,master',
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify({
            time: time,
            days: days,
            enabled: true
          })
        }
      );

      if (response.responseCode !== 201 && response.responseCode !== 200) {
        console.error('创建闹钟失败:', response.result.toString());
      }
    } catch (err) {
      console.error('创建闹钟异常:', JSON.stringify(err));
    } finally {
      httpRequest.destroy();
    }
  }

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
            // 先保存数据
            this.createAlarm();
            // 延迟 300ms 后返回，确保数据已保存
            setTimeout(() => {
              router.replaceUrl({
                url: 'pages/Lmy3AlarmReminder'
              });
            }, 300);
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
          Column() {
            Row() {
              Text('重复')
                .fontSize(14)
                .fontColor('#999999')

              Blank()

              Text(this.getSelectedDaysString())
                .fontSize(14)
                .fontColor('#5B9EFF')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('90%')
            .padding({ top: 20, bottom: 10 })
            .margin({ left: '5%' })

            // 星期选择器
            Row() {
              ForEach(this.dayNames, (day: string, index: number) => {
                Text(day)
                  .fontSize(14)
                  .fontColor(this.selectedDays[index] ? '#FFFFFF' : '#666666')
                  .width(40)
                  .height(40)
                  .textAlign(TextAlign.Center)
                  .borderRadius(20)
                  .backgroundColor(this.selectedDays[index] ? '#5B9EFF' : '#F0F0F0')
                  .onClick(() => {
                    this.selectedDays[index] = !this.selectedDays[index];
                  })
              }, (day: string) => day)
            }
            .width('90%')
            .margin({ left: '5%', bottom: 20 })
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')

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
