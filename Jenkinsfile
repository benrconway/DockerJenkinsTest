#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
      CI = 'true'
      DOCKER = tool('testDocker')
    }
    stages {
        stage('Build') {
            steps {

              // Use of tool allows for greater portability across platforms.
              sh "${DOCKER}/Contents/Resources/bin/docker build -q -t api ."
              sh "${DOCKER}/Contents/Resources/bin/docker create --name npm_script_test -p 3000:3000 api"
              sh "${DOCKER}/Contents/Resources/bin/docker start npm_script_test"
              sh "${DOCKER}/Contents/Resources/bin/docker ps -a"

               //Future proofing attempts to make it wait for the server to be running before continuing
               // sh "/Applications/Docker.app/Contents/Resources/bin/docker container ls -f status=running | grep -e $1 | wc -l"
               sh "${DOCKER}/Contents/Resources/bin/docker container ls -f status=running | grep -e npm_script_test | wc -l"

               // This one has yet to pass, theory is separate thread is starting up the
               // docker image, so server isn't there yet.
               sh 'curl -f http://0.0.0.0:3000/api || echo "Test 1 failed"'
            }
        }
        stage('Test') {
            steps {
                  echo 'Testing now.'

                  // Test to bring BDD test stored outside Docker in to run tests on
                  // container logic
                  dir('test'){
                    git url: 'https://github.com/benrconway/JenkinsTest2.git'
                    nodejs('testJS'){
                      sh 'npm install'
                      sh 'npm test'
                    }
                  }

            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying'
            }
        }
        stage('Cleanup'){
          steps{
              echo 'Cleaning up'
              //Here I will turn off all containers, remove containers, images etc
              // Clean up is a good word for it. This way all resources output no junk.

              //Stops the running container
              sh "${DOCKER}/Contents/Resources/bin/docker stop npm_script_test"
              // Remove the stopped container
              sh "${DOCKER}/Contents/Resources/bin/docker rm npm_script_test"
              // Remove image now that it is "dangling"
              sh "${DOCKER}/Contents/Resources/bin/docker rmi api"

              // Final check to be sure all images and containers are removed.
              sh "${DOCKER}/Contents/Resources/bin/docker container ls -a"
              sh "${DOCKER}/Contents/Resources/bin/docker images ls -a"
              sh "${DOCKER}/Contents/Resources/bin/docker ps -aq --no-trunc"
            }
          }
    }
}


    // Slacking is something I want to understand how to make work in general.
    // post {
    //      success {
    //          slackSend baseUrl: 'https://bemohq.slack.com/services/hooks/jenkins-ci/', channel: '', color: '#007F00', message: "Success ${env.JOB_NAME} ${env.BUILD_ID} (<${env.JENKINS_URL}/job/PwcCompliance/${env.BUILD_ID}|Open>)", tokenCredentialId: '$PWC_SLACK_TOKEN'
    //      }
    //
    //      failure {
    //          slackSend baseUrl: 'https://bemohq.slack.com/services/hooks/jenkins-ci/', channel: '#pwc', color: '#E63247', message: "******:fire:FAILURE:fire:****** ${env.JOB_NAME} ${env.BUILD_ID} (<${env.JENKINS_URL}/job/PwcCompliance/${env.BUILD_ID}|Open>)", tokenCredentialId: '$PWC_SLACK_TOKEN'
    //      }
    //  }
