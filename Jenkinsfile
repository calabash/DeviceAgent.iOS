#!/usr/bin/env groovy

pipeline {
  agent { label 'master' }
  environment {
    DEVELOPER_DIR = '/Xcode/9.4.1/Xcode.app/Contents/Developer'
    XCPRETTY=0

    SLACK_COLOR_DANGER  = '#E01563'
    SLACK_COLOR_INFO    = '#6ECADC'
    SLACK_COLOR_WARNING = '#FFC300'
    SLACK_COLOR_GOOD    = '#3EB991'
    PROJECT_NAME = 'DeviceAgent.iOS'
  }
  options {
    disableConcurrentBuilds()
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timeout(time: 60, unit: 'MINUTES')
  }
  stages {
    stage('announce') {
      steps {
        slackSend(color: "${env.SLACK_COLOR_INFO}",
            message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Started* (<${env.BUILD_URL}|Open>)")
      }
    }
    stage('build') {
      parallel {
        stage('x86 agent') {
          steps {
            sh 'make app-agent'
          }
        }
        stage('arm agent') {
          steps {
            sh 'make ipa-agent'
          }
        }
        stage('test-ipa') {
          steps {
            sh 'make test-ipa'
          }
        }
        stage('test-app') {
          steps {
            sh 'make test-app'
          }
        }
      }
    }
    stage('prepare') {
      parallel {
        stage('bundle') {
          steps {
            sh 'bundle install'
          }
        }
        stage('appcenter-cli') {
          steps {
            sh 'npm install -g appcenter-cli'
          }
        }
        stage('cucumber; bundle install') {
          steps {
            sh 'cd cucumber; bundle install'
          }
        }
      }
    }
    stage('test') {
      parallel {
        stage('unit + cucumber') {
          steps {
            sh 'gtimeout --foreground --signal SIGKILL 60m make unit-tests'
            sh 'gtimeout --foreground --signal SIGKILL 60m bin/ci/cucumber.rb'
          }
        }
        stage('appcenter') {
          steps {
            sh 'bin/ci/appcenter.sh'
          }
        }
      }
    }
  }
  post {
    always {
      junit 'cucumber/reports/junit/*.xml'
    }

    aborted {
      echo "Sending 'aborted' message to Slack"
      slackSend (color: "${env.SLACK_COLOR_WARNING}",
               message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Aborted* after ${currentBuild.durationString.replace('and counting', '')}(<${env.BUILD_URL}|Open>)")
    }

    failure {
      echo "Sending 'failed' message to Slack"
      slackSend (color: "${env.SLACK_COLOR_DANGER}",
               message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Failed* after ${currentBuild.durationString.replace('and counting', '')}(<${env.BUILD_URL}|Open>)")
    }

    success {
      echo "Sending 'success' message to Slack"
      slackSend (color: "${env.SLACK_COLOR_GOOD}",
               message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Success* after ${currentBuild.durationString.replace('and counting', '')}(<${env.BUILD_URL}|Open>)")
    }
  }
}
