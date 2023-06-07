#!/bin/bash
if [ $# -ne 2 ]; then
 echo "Usage: $0 chatname apikey"
 exit 1
fi
#新的文件名
newfolder=$1-wechat
#不存在则新建
if [ ! -d "$newfolder" ];then
 cp -r chatgpt-on-wechat $newfolder
fi
cd $newfolder
echo "Enter the new folder is $newfolder"
rm nohup.out
touch nohup.out
newfileName="app-$1.py"
#不存新文件则重命名
if [ ! -f "$newfileName"]; then
  mv app.py $newfileName
  echo  "Rename the new file name is $newfileName"
fi
#把参数加载到配置文件
sed -i 's/\("open_ai_api_key"\s*:\s*\)"[^"]*"/\1"'$2'"/' config.json
echo "New folder created with name $1 and apikey updated in config.json file."
cd ..
command="$newfolder/$newfileName"
echo  "The command is $command"
./script.sh restart $command
logfile="$newfolder/nohup.out"
#tail -f $logfile | grep --line-buffered '?url=https://login.weixin.qq.com/' | awk '{print $1}' | xargs -I{} echo "找到了：{}"
tail -f $logfile | while read line; do
  if echo "$line" | grep -q '?url=https://login.weixin.qq.com/'; then
    echo "'{\"QR\":\"$line\"}'"
    break
  fi
done
exit 0
