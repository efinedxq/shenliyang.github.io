#--------------------------------------------
#!/bin/bash
# author：shenliyang
# site：https://github.com/shenliyang
# slogan：梦想还是要有的，万一实现了呢。
#--------------------------------------------

#定义时间
time=`date +%Y-%m-%d\ %H:%M:%S`

#执行成功
function success(){
   echo "success"
}

#执行失败
function failure(){
   echo "failure"
}

#默认执行
function default(){

  git clone https://${GH_REF} .deploy_git
  cd .deploy_git

  git checkout master
  cd ../

  mv .deploy_git/.git/ ./public/
  cd ./public

  #判断部署结果
  if [$TRAVIS_TEST_RESULT eq 0]
  then 
	  TRAVIS_RESULT = "successful"
  else
	  TRAVIS_RESULT = "broken"
  fi

cat <<EOF >> README.md 
部署状态 | 集成结果 | 参考值
---|---|---
完成时间 | $time | yyyy-mm-dd hh:mm:ss
部署环境 | $TRAVIS_OS_NAME + $TRAVIS_NODE_VERSION | window \| linux + stable
部署类型 | $TRAVIS_EVENT_TYPE | push \| pull_request \| api \| cron
是否sudo | $TRAVIS_SUDO | false \| true
仓库地址 | $TRAVIS_REPO_SLUG | owner_name/repo_name
Job ID   | $TRAVIS_JOB_ID | number
Job NUM  | $TRAVIS_JOB_NUMBER | number.number
提交分支 | $TRAVIS_COMMIT | message
提交信息 | $TRAVIS_COMMIT_MESSAGE | hash 16位
部署结果 | $TRAVIS_RESULT | successful \| broken
EOF

  git init
  git config user.name "shenliyang"
  git config user.email ""
  git add .
  git commit -m "Build by Travis CI"
  git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:master
} 


case $1 in 
    "success")
	     success
       	 ;;
    "failure")
	     failure
	     ;;
	         *) 
         default	
esac

