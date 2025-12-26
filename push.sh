#! /bin/bash
git add .

# 如果有参数，用所有参数作为提交信息；否则用'default'
if [ $# -gt 0 ]; then
	MESSAGE="$*"
else
	MESSAGE="default"
fi

git commit -m "$MESSAGE"
git push origin "hexo"
